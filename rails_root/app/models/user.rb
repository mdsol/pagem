class User < ActiveRecord::Base
  after_create :update_study
  acts_as_auditable 

  #Each model will be responsible for deciding when a reason for change is needed
  def audit_reason
  end

  def update_study
    if Study.first
      Study.first.name = "New Name"
    else
      Study.create( :name => "New Study" )
    end
  end
end

