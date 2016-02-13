require 'rails_helper'

include Helpers

describe "User" do
  describe "who has signed up" do
    let!(:user) { FactoryGirl.create :user }

    it "can signin with right credentials" do
      sign_in(username:"Pekka", password:"Foobar1")

      expect(page).to have_content 'Welcome back!'
      expect(page).to have_content 'Pekka'
    end
  
    it "is redirected back to signin form if wrong credentials given" do
      sign_in(username:"Pekka", password:"wrong")

      expect(current_path).to eq(signin_path)
      expect(page).to have_content 'Username and/or password mismatch'
    end

    it "when signed up with good credentials, is added to the system" do
      visit signup_path
      fill_in('user_username', with:'Brian')
      fill_in('user_password', with:'Secret55')
      fill_in('user_password_confirmation', with:'Secret55')

      expect{
        click_button('Create User')
      }.to change{User.count}.by(1)
    end

    it "has favourite style listed on the page" do
      create_stuff

      visit user_path(user)

      expect(page).to have_content "Favourite beer style: IPA"
    end

    it "has favourite brewery listed on the page" do
      create_stuff

      visit user_path(user)

      expect(page).to have_content "Favourite brewery: fav"
    end
  end
end

def create_stuff
  brewery1 = FactoryGirl.create :brewery
  brewery2 = FactoryGirl.create :brewery, name:"fav"
  beer1 = FactoryGirl.create :beer, brewery:brewery1
  beer2 = FactoryGirl.create :beer, style:"IPA", brewery:brewery2
  FactoryGirl.create :rating, user:user, beer:beer1, score:15
  FactoryGirl.create :rating, user:user, beer:beer2, score:20
end