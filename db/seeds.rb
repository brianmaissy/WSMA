# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Emanuel', :city => cities.first)

houses = House.create([{:name => 'Griffindor'}, {:name => 'Hufflepuff'}, {:name => 'Ravenclaw'}, {:name => 'Slytherin'}])
harry = User.create(:house => houses[0], :name => 'Harry Potter', :access_level => 1, :email => 'a', :password => 'seeker')
ron = User.create(:house => houses[0], :name => 'Ron Weasley', :access_level => 1, :email => 'b', :password => 'hermione')
malfoy = User.create(:house => houses[3], :name => 'Draco Malfoy', :access_level => 1, :email => 'c', :password => 'voldemort')
admin = User.create(:house => houses[2], :name => 'admin', :access_level => 3, :email => 'admin', :password => 'admin')
dumbledore = User.create(:house => houses[0], :name => 'Dumbledore', :access_level => 3, :email => 'dumble', :password => 'dore')
chore1 = Chore.create(:house_id => 1, :name => 'clean dishes', :hours => 1, :sign_out_by_hours_before => 0, :due_hours_after => 1)
chore2 = Chore.create(:house_id => 1, :name => 'cook dinner', :hours => 1, :sign_out_by_hours_before => 0, :due_hours_after => 1)
shift1 = Shift.create(:chore_id => 1, :user_id => 1, :day_of_week => 1, :time => DateTime.current, :temporary => 0)
shift2 = Shift.create(:chore_id => 1, :user_id => 2, :day_of_week => 3, :time => DateTime.current, :temporary => 0)
assign1 = Assignment.create(:user_id => 1, :shift_id => 1, :week => 1, :status => 2)
assign2 = Assignment.create(:user_id => 2, :shift_id => 2, :week => 1, :status => 1)

