require File.dirname(__FILE__) + '/spec_helper'
require File.expand_path("../../lib/pagem", __FILE__)

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
