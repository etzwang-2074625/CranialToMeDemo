class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :user_firstname
	    t.string :user_lastname
	    t.string :user_middlename
	    t.string :user_login
	    t.integer :user_type_id
	    t.string :user_title
	    t.string :token
	    t.boolean :approved
	    t.string :degree
	    t.string :avatar
	    t.string :signature
	    t.string :middle_name
	    t.string :status, default: "active"
	    t.string :password_digest
	    t.string :email
	    t.boolean :pediatric
	    t.integer :center_id
	    t.string :institution
	    t.integer :sequencing_center_id
	    t.index ["user_firstname", "user_lastname"], name: "index_users_on_user_firstname_and_user_lastname", unique: true
      t.timestamps
    end
  end
end
