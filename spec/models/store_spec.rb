require 'rails_helper'

RSpec.describe Store, type: :model do

  let(:user) {
    user = User.new(
      email: "user@example.com",
      password: "123456",
      password_confirmation: "123456",
      role: "seller"
    )
    user.save!
    user
  }

  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_length_of(:name).is_at_least(3) }
  end

  let(:valid_attributes) {
    {name: "Great Restaurant", user: user}
  }

  let(:invalid_attributes) {
    {name: nil}
  }

  describe "GET /index" do
    it "renders a successful response" do
      store = Store.create! valid_attributes
      expect(store.name).to_not be_empty
    end
  end

end
