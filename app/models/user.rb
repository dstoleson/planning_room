class User < ActiveRecord::Base
	has_secure_password

	def admin?
		return role == 'admin'
	end

end
