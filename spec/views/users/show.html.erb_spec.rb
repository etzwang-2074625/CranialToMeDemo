require 'rails_helper'

RSpec.describe "users/show", type: :view do
  # before(:each) do
  #   @user = assign(:user, User.create!(
  #     user_firstname: "User Firstname"
  #   ))
  # end

  it "renders attributes in <p>" do
    pending "add some examples to (or delete) #{__FILE__}"
    render
    expect(rendered).to match(/User Firstname/)
  end
end
