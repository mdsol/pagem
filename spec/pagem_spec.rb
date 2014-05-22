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
