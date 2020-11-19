# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'faker'
require 'csv'

puts 'Cleaning database now...'
Booking.destroy_all
Truck.destroy_all
User.destroy_all
puts 'Database clean ✅'

# Users:

owner_array = []

user = User.new
user.email = 'admin@gmail.com' # admin user
user.password = '123456'
user.name = "Administator"
user.admin = true
user.save!

user_rentee = User.new
user_rentee.email = 'joe@gmail.com' # user_rentee to rent a truck
user_rentee.password = '123456'
user_rentee.name = "Joe Rentee"
user_rentee.save!

user_owner1 = User.new
user_owner1.email = 'owner1@gmail.com' # user_owner1 to offer trucks
user_owner1.name = "Anne Owner"
user_owner1.password = '123456'
user_owner1.save!
owner_array << user_owner1

user_owner2 = User.new
user_owner2.email = 'owner2@gmail.com' # user_owner2 to offer trucks
user_owner2.name = "Anne Other Owner"
user_owner2.password = '123456'
user_owner2.save!
owner_array << user_owner2

# Trucks:

# truck_array = []

# 10.times do 
#   truck = Truck.new(
#     title: Faker::Vehicle.make_and_model,
#     location: ['Berlin - Mitte', 'Berlin - Kreuzberg', 'Berlin - Tiergarten'].sample,
#     size: ['Large SUV', 'Pick-Up Truck', 'Small Van', 'Large Van'].sample,
#     price_per_day: rand(2500..10000),
#     description: Faker::Lorem.paragraph(sentence_count: 2),
#   )
#   truck.user = user
#   truck.save
#   truck_array << truck
# end


truck_array = []

csv_text = File.read(Rails.root.join('lib', 'seeds_db', 'our_trucks_seeds.csv'))
csv = CSV.parse(csv_text, :headers => true, :header_converters => :symbol)
csv.each do |row|
  # p row
  t = Truck.new
  t.title = row[:title]
  # p row[:title]
  t.location = row[:location]
  t.size = row[:size]
  t.price_per_day = row[:price_per_day]
  t.description = row[:description]
  t.photo = row[:photo_url]
  t.user = owner_array.sample
  t.save
  truck_array << t
end


# Bookings:

3.times do
  random_day = rand(19..30)
  booking = Booking.new(
    start_date:  DateTime.new(2020, 11, 18), # Date.parse("18/11/2020")
    end_date: DateTime.new(2020, 11, random_day),
    status: ['pending', 'confirmed', 'pending'].sample,
  )
  booking.user = user_rentee
  booking.truck = truck_array.sample
  booking.save
end

puts "Done!"
puts "Created #{User.count} users."
puts "Created #{Truck.count} trucks."
puts "Created #{Booking.count} bookings."



