# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Emanuel', :city => cities.first)

houses = House.create([{:name => 'Griffindor'}, {:name => 'Hufflepuff'}, {:name => 'Ravenclaw'}, {:name => 'Slytherin'}])
harry = User.create(:house => houses[0], :name => 'Harry Potter', :access_level => 1, :email => 'a', :hashed_password => 'a', :salt => 'a')
ron = User.create(:house => houses[0], :name => 'Ron Weasley', :access_level => 1, :email => 'b', :hashed_password => 'b', :salt => 'b')
malfoy = User.create(:house => houses[3], :name => 'Draco Malfoy', :access_level => 1, :email => 'c', :hashed_password => 'c', :salt => 'c')
