# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Role.create([
              {name: "System Administrator", privilege_string: '["EDIT_PI_DELEGATE","EDIT_PI","EDIT_PROGRESS_REPORT","EDIT_DATA","EDIT_DMS","VIEW_PROJECT","VALIDATE_DATA","VIEW_DMS","EDIT_COMMENTS","APPROVE_DMS"]'},
              {name: "Project PI", privilege_string: '["EDIT_PI_DELEGATE","EDIT_PROGRESS_REPORT","EDIT_DATA","EDIT_DMS","VIEW_PROJECT","VIEW_DMS"]'},
              {name: "PI Delegate", privilege_string: '["EDIT_PROGRESS_REPORT","EDIT_DATA","EDIT_DMS","VIEW_PROJECT","VIEW_DMS"]'},
              {name: "SPA", privilege_string: '["VIEW_PROJECT","VIEW_DMS","APPROVE_DMS"]'},
              {name: "Data Librarian", privilege_string: '["EDIT_PI","VIEW_PROJECT","VALIDATE_DATA","VIEW_DMS","EDIT_COMMENTS"]'}
            ])
if User.all.empty?
	u = User.create(user_firstname: 'DEPUT', user_lastname: 'Developer', email: 'shiqiang.tao@uth.tmc.edu', password: 'password', password_confirmation: 'password')
	u.roles << Role.find_by_name('System Administrator')
	u.save
end