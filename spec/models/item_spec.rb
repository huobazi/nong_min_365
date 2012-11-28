require "spec_helper"

describe Item do
  context "model" do
    it {should validate_presence_of :title}
    it {should validate_presence_of :amount}
    it {should validate_presence_of :city_code}
    it {should validate_presence_of :county_code}
    it {should validate_presence_of :town_code}
    it {should validate_presence_of :village_code}
    it {should validate_presence_of :contact_name}
    it {should validate_presence_of :contact_phone}
    it {should validate_presence_of :contact_qq}
    it {should validate_presence_of :body}
    
    it {should belong_to :category}
    it {should belong_to :user}
    it {should belong_to :province}
    it {should belong_to :city}
    it {should belong_to :county}
    it {should belong_to :town}
    it {should belong_to :village}


  end
end
