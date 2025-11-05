require 'rails_helper'

RSpec.describe "users/new", type: :view do
  before(:each) do
    assign(:user, User.new(
      user_firstname: "MyString"
    ))
    allow_any_instance_of(ApplicationHelper).to receive(:current_user).and_return(create(:user))
  end

  it "renders new user form" do
    render

    assert_select "form[action=?][method=?]", users_path, "post" do

      assert_select "input[name=?]", "user[user_firstname]"
    end
  end
end
