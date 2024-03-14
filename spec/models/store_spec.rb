require 'rails_helper'

RSpec.describe Store, type: :model do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_length_of(:name).is_at_least(3) }
  end

  let(:valid_attributes) {
    {name: "Great Restaurant"}
  }

  let(:invalid_attributes) {
    {name: nil}
  }

  describe "GET /index" do
    it "renders a successful response" do
      Store.create! valid_attributes
      get stores_url
      expect(response).to be_successful
    end
  end

end
