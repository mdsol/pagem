require File.dirname(__FILE__) + '/spec_helper'
require File.expand_path("../../lib/pagem", __FILE__)

describe Pagem do
  before(:each) do
    @scope = double("Scope")
    @scope.stub(:count).and_return(101)
    @scope.stub(:where => @scope, :limit => @scope, :offset => @scope)
    @pager = Pagem.new(@scope, {:page => 1})
    @pager.stub('medidata_icon_link').and_return('')
  end

  it "should default the page_variable to 'page'" do
    @pager.instance_eval { @page_variable }.should == :page
  end

  it "should properly set the page_variable" do
    @pager = Pagem.new(@scope, {:page => 1}, {:page_variable => :foo})
    @pager.instance_eval { @page_variable}.should == :foo
  end

  it "should return the original scope" do
    @pager.scope.should == @scope
  end

  describe "#paged_scope" do
    it "limits to items_per_page" do
      @scope.should_receive(:limit).with(@pager.items_per_page)
      @pager.paged_scope
    end

    it "applies an offset for the current page" do
      @scope.should_receive(:offset).with(0)
      @pager.paged_scope
    end


    it "returns the paged scope" do
      @scope.stub(:offset => @scope)
      @pager.paged_scope.should == @scope
    end

    it "builds the offset for the 2nd page" do
      @pager = Pagem.new(@scope, {:page => 2})
      @scope.should_receive(:offset).with(10)
      @pager.paged_scope
    end

    it "returns an empty array if there are no results" do
      @scope = double("Scope")
      @scope.stub(:count => 0, :where => [])
      @pager = Pagem.new(@scope, {:page => 1})
      @pager.paged_scope.should == []
    end
  end

  it "should return the default items per page" do
    @pager.items_per_page.should == 10
  end

  it "should return the proper items per page" do
    @pager = Pagem.new(@scope, {:page => 1}, {:items_per_page => 20})
    @pager.items_per_page.should == 20
  end

  it "should return the count" do
    @pager.count.should == 101
  end

  it "should return the total page count" do
    @pager.pages.should == 11
  end

  it "should return the current page" do
    @pager.current_page.should == 1
  end

  it "should return the first page if the page is less than 1" do
    @pager = Pagem.new(@scope, {:page => 0})
    @pager.current_page.should == 1
  end

  it "should return the first page if the page is invalid" do
    @pager = Pagem.new(@scope, {:page => 'a'})
    @pager.current_page.should == 1
  end

  it "should return the first page if the page is not given" do
    @pager = Pagem.new(@scope, {})
    @pager.current_page.should == 1
  end

  it "should return the last page if the page is greater than the total pages" do
    @pager = Pagem.new(@scope, {:page => 100})
    @pager.current_page.should == 11
  end

  it "should render" do
    @pager.render
  end

  it "should render empty if there are no pages" do
    @scope = double("Scope")
    @scope.stub(:count).and_return(0)
    @pager = Pagem.new(@scope, {:page => 1})
    @pager.render.should == ""
  end

  it "should render empty if there is one page" do
    @scope = double("Scope")
    @scope.stub(:count).and_return(10)
    @pager = Pagem.new(@scope, {:page => 1})
    @pager.render.should == ""
  end

  it "should render for remote forms (ajax) if given an is_remote option parameter" do
    @pager.render :is_remote => true
  end

  it "should convert to string" do
    @pager.to_s.should == @pager.render
  end
end


describe PagemMultiscope do
  before(:each) do
    @scope = double("Scope")
    @second_scope = double("Scope")
    @scope.stub(:size).and_return(101)
    @second_scope.stub(:size).and_return(202)
    @scope.stub(:where => @scope, :limit => @scope, :offset => @scope)
    @second_scope.stub(:where => @second_scope, :limit => @second_scope, :offset => @second_scope)
  end

  it 'inherits from Pagem' do
    expect(PagemMultiscope).to be < Pagem
  end

  it 'gets the sizes of the scopes if they are not passed in' do
    @scope.should_receive(:count).and_return(101)
    # @scope.stub(:size).and_return(101)
    # @second_scope.stub(:size).and_return(202)
    @multipager = PagemMultiscope.new(@scope, @second_scope, {:page => 1})
    @multipager.instance_eval { @count}.should == 303
  end

  it 'assigns of the scopes if they are passed in' do
    @multipager = PagemMultiscope.new(@scope, @second_scope, {page: 1}, {
      count_number: 303,
      first_scope_count: 101,
      second_scope_count: 202
    })
    @multipager.instance_eval { @count}.should == 303
  end

  describe "#paged_scope" do
    before(:each) do
      @scope.should_receive(:count).and_return(101)
      @scope_count = 101
    end

    context 'current page > 0' do

      context 'end_offset <= first scope count' do
        it "returns only the first scope" do
          @multipager = PagemMultiscope.new(@scope, @second_scope, {page: 1})
          @start_offset = (@multipager.current_page - 1) * @multipager.items_per_page
          @end_offset = @multipager.current_page * @multipager.items_per_page
          @scope.should_receive(:limit).with(@multipager.items_per_page)
          @scope.should_receive(:offset).with(@start_offset)
          @multipager.paged_scope
        end
      end

      context 'start_offset +1 > first scope count' do
        it "returns only the first scope" do
          @multipager = PagemMultiscope.new(@scope, @second_scope, {page: 200})
          @start_offset = (@multipager.current_page - 1) * @multipager.items_per_page
          @end_offset = @multipager.current_page * @multipager.items_per_page
          @second_scope.should_receive(:limit).with(@multipager.items_per_page)
          @second_scope.should_receive(:offset).with(@start_offset - @scope_count)
          @multipager.paged_scope
        end
      end

      it "uses a combine method" do
        @multipager = PagemMultiscope.new(@scope, @second_scope, {page: 11})
        @start_offset = (@multipager.current_page - 1) * @multipager.items_per_page
        @end_offset = @multipager.current_page * @multipager.items_per_page
        @scope.should_receive(:offset).with(@start_offset)
        @second_scope.should_receive(:limit).with(@end_offset - @scope_count)
        combine_method = Proc.new{}
        @multipager.paged_scope(&combine_method)
      end
    end
  end
end
