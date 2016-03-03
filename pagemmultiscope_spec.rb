describe PagemMultiscope do
  let(:scope) { double('Scope') }
  let(:second_scope) { double('Scope') }

  before(:each) do
    scope.stub(where: scope, limit: scope, offset: scope)
    second_scope.stub(where: second_scope, limit: second_scope, offset: second_scope)
  end

  after(:each) do
    @multipager.instance_eval { @count }.should == 303
    @multipager.instance_eval { @first_scope_count }.should == 101
    @multipager.instance_eval { @second_scope_count }.should == 202
  end

  it 'inherits from Pagem' do
    expect(PagemMultiscope).to be < Pagem
  end

  it 'gets the sizes of the scopes if they are not passed in' do
    scope.should_receive(:count).and_return(101)
    scope.stub(:size).and_return(101)
    second_scope.stub(:size).and_return(202)
    @multipager = PagemMultiscope.new(scope, second_scope, { page: 1 })
  end

  it 'assigns the scopes if they are passed in' do
    @multipager = PagemMultiscope.new(scope, second_scope, { page: 1 },
    {
      count_number: 303,
      first_scope_count: 101,
      second_scope_count: 202
    })
  end

  it 'calculates the scopes if count number is inaccurate' do
    scope.should_receive(:size).and_return(101)
    second_scope.should_receive(:size).and_return(202)
    @multipager = PagemMultiscope.new(scope, second_scope, { page: 1 },
    {
      count_number: 603,
      first_scope_count: 101,
      second_scope_count: 202
    })
  end

  it 'calculates the scopes if either or both scope counts are inaccurate' do
    scope.should_receive(:size).and_return(101)
    second_scope.should_receive(:size).and_return(202)
    @multipager = PagemMultiscope.new(scope, second_scope, { page: 1 },
    {
      count_number: 603,
      first_scope_count: 201,
      second_scope_count: 302
    })
  end

  describe "#paged_scope" do
    before(:each) do
      scope.should_receive(:count).and_return(101)
      scope_count = 101
    end

    context 'current page > 0' do
      context 'end_offset <= first scope count' do
        it "returns only the first scope" do
          @multipager = PagemMultiscope.new(scope, second_scope, { page: 1 })
          scope.should_receive(:limit)
          scope.should_receive(:offset)
          @multipager.paged_scope
        end
      end

      context 'start_offset +1 > first scope count' do
        it "returns only the first scope" do
          @multipager = PagemMultiscope.new(scope, second_scope, { page: 200 })
          second_scope.should_receive(:limit)
          second_scope.should_receive(:offset)
          @multipager.paged_scope
        end
      end

      it "uses a combine method" do
        @multipager = PagemMultiscope.new(scope, second_scope, { page: 11 })
        scope.should_receive(:offset)
        second_scope.should_receive(:limit)
        combine_method = Proc.new{ }
        @multipager.paged_scope(&combine_method)
      end
    end
  end
end
