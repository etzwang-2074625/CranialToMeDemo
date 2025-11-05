require 'rails_helper'

RSpec.describe "users/edit", type: :view do
  # before(:each) do
  #   @user = assign(:user, User.create!(
  #     user_firstname: "MyString"
  #   ))
  # end

  it "renders the edit user form" do
    pending "add some examples to (or delete) #{__FILE__}"
    render

    assert_select "form[action=?][method=?]", user_path(@user), "post" do

      assert_select "input[name=?]", "user[user_firstname]"
    end
  end
end
