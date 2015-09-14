class Pagem
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::AssetTagHelper
  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::FormTagHelper

  ITEMS_PER_PAGE = 10

  attr_reader :scope, :items_per_page, :count

  def initialize(scope, params, opt = {})
    @page_variable = opt[:page_variable] || :page
    @count = opt[:count_number] || scope.count
    @scope = scope
    @params = params
    @items_per_page = opt[:items_per_page] || ITEMS_PER_PAGE
    # This param should be an array of column names
    @order = opt[:order]
  end

  def icon_link(icon, text, url, options = {})
    options = options.merge(
      class: "#{options[:class] if options[:class]} iconlink",
      style: "background-image:url(#{options[:global_url] ? icon.to_s : "/images/medidata_buttons/#{icon}.gif"})",
      global_url: nil
     )
    link_to text, url, options
  end

  # Returns a scope for the currently selected page, or an empty scope if current_page is not valid.
  def paged_scope
    (current_page > 0) ? scope.limit(items_per_page).offset((current_page - 1) * items_per_page) : scope.where('0=1')
  end

  # Returns an array of hashes containing the requested records. Used when pulling records from multiple tables.
  def paged_union_results
    sql_statements = scope.map { |s| s.select("#{s.primary_key} AS id, #{s.klass} AS model_type").to_sql }
    pagination_clause = "LIMIT #{items_per_page} OFFSET #{(current_page - 1) * items_per_page}"
    order_clause = @order ? " ORDER BY #{@order.map(&:to_s).join(', ')}" : ''
    query = "#{sql_statements.join(' UNION ')}#{order_clause} #{pagination_clause}"
    query_results = ActiveRecord::Base.connection.select_all(query)

    query_results.map { |record_hash| record_hash['model_type'].constantize.find(record_hash['id']) }
  end

  def pages
    (count.to_f / items_per_page).ceil
  end

  def current_page
    page = (@params[@page_variable] || 1).to_i rescue 1
    return 1 if page < 1
    [page, pages].min
  end

  def render(opt = {})
    @is_remote = opt[:is_remote] || false
    p = current_page
    tp = pages

    if(tp > 1)
      href = "##{@page_variable}"

      content_tag('div',
        (icon_link('/images/pagem/arrow_leftend.gif', I18n.t('application.pagination.first', :default => "First"), href, link_options(1, p > 1)) +
      icon_link('/images/pagem/arrow_left.gif', I18n.t('application.pagination.previous', :default => "Previous"), href, link_options(p - 1, p > 1)) +
      pager_section(p, tp) +
      icon_link('/images/pagem/arrow_right.gif', I18n.t('application.pagination.next', :default => "Next"), href, link_options(p + 1, p < tp, true)) +
      icon_link('/images/pagem/arrow_rightend.gif', I18n.t('application.pagination.last', :default => "Last"), href, link_options(tp, p < tp, true))) +
      hidden_field_tag(@page_variable, ""),
       {:class => 'pagination', :name => @page_variable})
    else
      ""
    end
  end

  def to_s
    render
  end

  private
  def link_options(page_number, enabled, right_side = false)
    if(enabled)
      options = {:onclick => onclick_script(page_number)}
    else
      options = {:class => 'disabled', :disabled => 'true'}
    end
    options[:class] = (options[:class] ? "iconlink_right #{options[:class]}" : "iconlink_right") if(right_side)
    options[:global_url] = true
    return options
  end

  def pager_section(page_number, total_pages)
    content_tag('span', text_field_tag(nil, page_number, :maxlength => '5', :style => "width:30px; margin:0;", :onkeypress => onkeypress_script) + " #{I18n.t('application.pagination.of', :default => "of")} #{total_pages} ", {:class => 'page_picker'})
  end

  def onclick_script(page_number)
    "Pager.setPage(this, '#{@page_variable}', #{page_number}, #{@is_remote});"
  end

  def onkeypress_script
    "if(event.keyCode == 13) Pager.setPage(this, '#{@page_variable}', this.value, #{@is_remote});"
  end
end
