require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

module ProfileSpecHelper
  
  def should_be_in_list(profile, attribute, collection)
    collection.each do |item|
      profile[attribute] = item
      profile.should be_valid
      profile.should have(:no).errors_on(attribute)
    end
  end
  
  def should_not_be_in_list(profile, attribute)
    profile[attribute] = "im not in the list"
    profile.should_not be_valid
    profile.should have(1).error_on(attribute)
  end
  
  def should_have_valid_length(profile, attribute)
    profile[attribute] = "a" * Profile::MAX_STRING_LENGTH
    profile.should be_valid
    profile.should have(:no).errors_on(attribute)
    
    profile[attribute] = "a"
    profile.should be_valid
    profile.should have(:no).errors_on(attribute)
    
    profile[attribute] = "a" * (Profile::MAX_STRING_LENGTH - 1)
    profile.should be_valid
    profile.should have(:no).errors_on(attribute)
    
    profile[attribute] = "a" * (Profile::MAX_STRING_LENGTH + 1)
    profile.should_not be_valid
    profile.should have(1).error_on(attribute)
  end
  
end

describe Profile do

  include ProfileSpecHelper
  
  before(:each) do
    @profile = Profile.new({
        :interested_in =>      "Women",
        :ethnicity =>          "African-American",
        :best_feature =>       "Smile",
        :body_type =>          "Athletic",
        :loves_when =>         "Girls pay",
        :hates_when =>         "Whiny girls suck",
        :turn_ons =>           "Nice face and a big butt",
        :turn_offs =>          "Bad breath and a stank attitude to match",
        :msg_me_if =>          "You got it going on",
        :completed =>          true
    })
  end

  it "should be valid" do
    @profile.should be_valid
  end
  
  it "should have a valid interest from interested_in list" do
    should_be_in_list(@profile, :interested_in, Profile::INTERESTED_IN)
  end
  
  it "should not be valid if interested_in is not in the interested_in list" do
    should_not_be_in_list(@profile, :interested_in)
  end

  it "should have a valid ethnicity from ethnicities list" do
    should_be_in_list(@profile, :ethnicity, Profile::ETHNICITIES)
  end
  
  it "should not be valid if ethnicity is not in the ethnicities list" do
    should_not_be_in_list(@profile, :ethnicity)
  end
  
  it "should have a valid best_feature from best_features list" do
    should_be_in_list(@profile, :best_feature, Profile::BEST_FEATURES)
  end

  it "should have a valid body_type from body_types list" do
    should_be_in_list(@profile, :body_type, Profile::BODY_TYPES)
  end
  
  it "should not be valid if body_type is not in the body_types list" do
    should_not_be_in_list(@profile, :body_type)
  end
  
  it "should have valid loves when length" do
    should_have_valid_length(@profile, :loves_when)
  end
  
  it "should have valid hates when length" do    
    should_have_valid_length(@profile, :hates_when)
  end
  
  it "should have valid turn ons length" do
    should_have_valid_length(@profile, :turn_ons)
  end
  
  it "should have valid turn offs length" do
    should_have_valid_length(@profile, :turn_offs)
  end
  
  it "should have valid msg me if length" do
    should_have_valid_length(@profile, :msg_me_if)
  end
  
  it "should not be complete after creation"
  
  it "should be completed when filled out"

end