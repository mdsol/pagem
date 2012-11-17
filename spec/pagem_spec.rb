require File.dirname(__FILE__) + '/spec_helper'
require 'lib/pagem'

describe Pagem do
  before(:each) do
    @scope = mock("Scope", :respond_to? => true)
    @scope.stub(:count).and_return(101)
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
  
  context "given a scopable collection" do
    it "should return the paged scope" do
      @scope.should_receive(:scoped).with({:limit => 10, :offset => 0}).and_return(@scope)
      @scope.should_receive(:all).and_return(@scope)
      @pager.paged_scope.should == @scope
    end

    it "should return the paged scope for the 2nd page" do
      @pager = Pagem.new(@scope, {:page => 2})
      @scope.should_receive(:scoped).with({:limit => 10, :offset => 10}).and_return(@scope)
      @scope.should_receive(:all).and_return(@scope)
      @pager.paged_scope.should == @scope
    end
  end

  context "given a non-scopable collection" do
    before :each do
      @scope.stub(:respond_to?).with(:scoped).and_return(false)
      @values = [*1..30]
    end

    it "should slice the collection" do
      @scope.should_receive(:slice).with(0, 10).and_return(@values.slice(0,10))
      @pager.paged_scope.should == [*1..10]
    end

    it "should slice the collection correctly to return the paged scope for the 2nd page" do
      @pager = Pagem.new(@scope, {:page => 2})
      @scope.should_receive(:slice).with(10, 10).and_return(@values.slice(10, 10))
      @pager.paged_scope.should == [*11..20]
    end
  end
  
  it "should return an empty array if there are no results" do
    @scope = mock("Scope")
    @scope.stub(:count).and_return(0)
    @pager = Pagem.new(@scope, {:page => 1})
    @pager.paged_scope.should == []
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
    @scope = mock("Scope")
    @scope.stub(:count).and_return(0)
    @pager = Pagem.new(@scope, {:page => 1})
    @pager.render.should == ""
  end
  
  it "should render empty if there is one page" do
    @scope = mock("Scope")
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
