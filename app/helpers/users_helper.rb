module UsersHelper
	def get_roles(user)
		result = "<ul>"
		user.roles.each do |r|
			result = result + "<li>#{r.name}</li>"
		end
		result = result + "</ul>"
	end
end
