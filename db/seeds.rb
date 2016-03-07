# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

users = 200           # jos koneesi on hidas, riittää esim 100
breweries = 100       # jos koneesi on hidas, riittää esim 50
beers_in_brewery = 40
ratings_per_user = 30

(1..users).each do |i|
  User.create! username:"user_#{i}", password:"Passwd1", password_confirmation:"Passwd1"
end

(1..breweries).each do |i|
  Brewery.create! name:"Brewery_#{i}", year:1900, active:true
end

bulk = Style.create! name:"Bulk", description:"cheap, not much taste"

Brewery.all.each do |b|
  n = rand(beers_in_brewery)
  (1..n).each do |i|
    beer = Beer.create! name:"Beer #{b.id} -- #{i}", style:bulk
    b.beers << beer
  end
end

User.all.each do |u|
  n = rand(ratings_per_user)
  beers = Beer.all.shuffle
  (1..n).each do |i|
    r = Rating.new score:(1+rand(50))
    beers[i].ratings << r
    u.ratings << r
  end
end

=begin
b1 = Brewery.create name:"Koff", year:1897
b2 = Brewery.create name:"Malmgard", year:2001
b3 = Brewery.create name:"Weihenstephaner", year:1042

s1 = Style.create name:"Lager", description:"Laageri on ok"
s2 = Style.create name:"Porter", description:"dasjdsfsa"
s3 = Style.create name:"Pale Ale", description:"fsdafadsfds"
s4 = Style.create name:"Weizen", description:"fdsfadsfdasf"

be1 = b1.beers.create name:"Iso 3", style:s1
be2 = b1.beers.create name:"Karhu", style:s1
be3 = b1.beers.create name:"Tuplahumala", style:s1
be4 = b2.beers.create name:"Huvila Pale Ale", style:s3
be5 = b2.beers.create name:"X Porter", style:s2
be6 = b3.beers.create name:"Hefeweizen", style:s4
be7 = b3.beers.create name:"Helles", style:s1

u1 = User.create username:"vlakanie", password:"Lollero1", password_confirmation: "Lollero1", admin: true
u2 = User.create username:"mluukkai", password:"Lollero1", password_confirmation: "Lollero1"

be1.ratings.create user:u1, score:15
be1.ratings.create user:u1, score:10
be2.ratings.create user:u1, score:2
be4.ratings.create user:u1, score:43
be5.ratings.create user:u1, score:21
be5.ratings.create user:u1, score:4

be2.ratings.create user:u1, score:22
be3.ratings.create user:u1, score:10
be5.ratings.create user:u1, score:12
=end
