require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Profile do
  fixtures :profiles
  
  before(:each) do
    @valid_attributes = {
    }
  end

  it "should create a new instance given valid attributes" do
    Profile.create!(@valid_attributes)
  end
end
