# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
ProjectType.create([{name: "private", description: "Private"},
					{name: "open", description: "Open"},
					{name: "current", description: "Current"}])
puts "Create ProjecTypes: private, open, current"

admin = User.find_by_name("admin")
unless admin 
	User.create([{name: "admin", role: "admin", password: "password"}])
	puts "Created User: admin"
end

