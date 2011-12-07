# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Emanuel', :city => cities.first)


testHouse = House.create(:name => 'Test House', :sign_off_verification_mode => 1)
admin = User.create(:house => testHouse, :name => 'admin', :access_level => 3, :email => 'admin', :password => 'password')
wsm = User.create(:house => testHouse, :name => 'wsm', :access_level => 2, :email => 'wsm', :password => 'password')
user = User.create(:house => testHouse, :name => 'user', :access_level => 1, :email => 'user', :password => 'password')
