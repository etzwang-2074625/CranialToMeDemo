require 'rails_helper'

RSpec.describe "users/index", type: :view do
  # before(:each) do
  #   assign(:users, [
  #     User.create!(
  #       user_firstname: "User Firstname"
  #     ),
  #     User.create!(
  #       user_firstname: "User Firstname"
  #     )
  #   ])
  # end

  it "renders a list of users" do
    pending "add some examples to (or delete) #{__FILE__}"
    render
    assert_select "tr>td", text: "User Firstname".to_s, count: 2
  end
end
