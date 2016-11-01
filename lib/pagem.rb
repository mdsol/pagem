class Pagem
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::AssetTagHelper
  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::FormTagHelper
  include ActionView::Helpers::OutputSafetyHelper

  ITEMS_PER_PAGE = 10

  def initialize(scope, params, opt = {})
    @page_variable = opt[:page_variable] || :page
    @count = opt[:count_number] || scope.count
    @scope = scope
    @params = params
    @items_per_page = opt[:items_per_page] || ITEMS_PER_PAGE
  end

  def icon_link(icon, text, url, options = {})
    options = options.merge(
      class: "#{options[:class] if options[:class]}",
      global_url: nil
     )
    content = safe_join([content_tag(:span, '', class: "fa fa-#{icon.to_s}"),
                        content_tag(:span, text, class: 'sr-only')])
    content_tag(:li, link_to(content, url, options))
  end

  def scope
    @scope
  end

  # Returns a scope for the currently selected page, or an empty scope if current_page is not valid.
  def paged_scope
    (current_page > 0) ? scope.limit(items_per_page).offset((current_page - 1) * items_per_page) : scope.where('0=1')
  end

  def items_per_page
    @items_per_page
  end

  def count
    @count
  end

  def pages
    (count.to_f / items_per_page).ceil
  end

  def current_page
    page = (@params[@page_variable] || 1).to_i rescue 1
    page = page < 1 ? 1 : page > pages ? pages : page
  end

  def render(opt = {})
    @is_remote = opt[:is_remote] || false
    p = current_page
    tp = pages

    if(tp > 1)
      href = "##{@page_variable}"

      content_tag(:div,
        content_tag(:ul,
          safe_join([icon_link('angle-double-left', I18n.t('application.pagination.first', :default => "First"), href, link_options(1, p > 1)),
                    icon_link('angle-left', I18n.t('application.pagination.previous', :default => "Previous"), href, link_options(p - 1, p > 1)),
                    pager_section(p, tp),
                    icon_link('angle-right', I18n.t('application.pagination.next', :default => "Next"), href, link_options(p + 1, p < tp)),
                    icon_link('angle-double-right', I18n.t('application.pagination.last', :default => "Last"), href, link_options(tp, p < tp)),
                    hidden_field_tag(@page_variable, "")]),
          class: 'controls'),
       {:class => 'paginate clearfix', :name => @page_variable})
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
    options[:global_url] = true
    return options
  end

  def pager_section(page_number, total_pages)
    input = text_field_tag(nil, page_number, maxlength: '5', class: 'current-page', onkeypress: onkeypress_script)
    content_tag(:li,  safe_join([input, " #{I18n.t('application.pagination.of', default: 'of')} #{total_pages} "]), {:class => 'counter'})
  end

  def onclick_script(page_number)
    "Pager.setPage(this, '#{@page_variable}', #{page_number}, #{@is_remote});"
  end

  def onkeypress_script
    "if(event.keyCode == 13) Pager.setPage(this, '#{@page_variable}', this.value, #{@is_remote});"
  end
end

# PagemMultiscope class inherits from Pagem and allows pagination of 2 scopes, returning either the paginated
# set of the first scope with limit and offset, the paginated set of the second scope with limit and offset,
# or results of a combined scope proc combining both scopes if the page is rendering a combination
# of both table records on the same page
# TODO Move this back to the Pagem class and extend it to allow more than 2 scopes
class PagemMultiscope < Pagem
  def initialize(first_scope, second_scope, params, opt = {})
    super(first_scope, params, opt)
    @first_scope, @second_scope = first_scope, second_scope
    @first_scope_count = opt[:first_scope_count] || first_scope.size
    @second_scope_count = opt[:second_scope_count] || second_scope.size
    if opt[:count_number].blank?
      # Add the scope counts together only if count is a number since if otherwise count should be provided
      # via the count_number optional arg in the inherited class
      @count = @first_scope_count + @second_scope_count if @count.is_a?(Integer)
    elsif @first_scope_count + @second_scope_count != @count
      # Get the scope sizes if they were not passed in as options
      @first_scope_count = first_scope.size
      @second_scope_count = second_scope.size
      @count = @first_scope_count + @second_scope_count
    end
  end

  # Return the paginated scope result of some combination of the 2 scopes using the current page and per page
  # as limit and offset, or empty scope
  def paged_scope(&combine_method)
    if current_page > 0
      start_offset = (current_page - 1) * items_per_page
      end_offset = current_page * items_per_page
      # If end offset of the current page is less than or equal to the first scope count, return only first scope results
      if end_offset <= @first_scope_count
        @first_scope.limit(items_per_page).offset(start_offset)
      # If starting offset of current page is greater than the first scope count,
      # return only second scope results
      elsif start_offset + 1 > @first_scope_count
        @second_scope.limit(items_per_page).offset(start_offset - @first_scope_count)
      # Otherwise return a combined scope of both scopes using the combined scope proc
      else
        # TODO Implement a better default behavior here if no combine_method instead of just raising
        raise ArgumentError, 'Multiscope paged scope call must have a method for combining scopes passed in args' unless combine_method
        first_scope = @first_scope.offset(start_offset)
        second_scope = @second_scope.limit(end_offset - @first_scope_count)
        combine_scopes = combine_method.call(first_scope, second_scope)
      end
    else
      @first_scope.where('0=1')
    end
  end

  # Return nil for inherited scope method because it's ambiguous for multiple scopes
  def scope
    nil
  end
end
