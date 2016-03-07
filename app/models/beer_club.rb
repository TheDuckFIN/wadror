class BeerClub < ActiveRecord::Base
	has_many :memberships, dependent: :destroy

    has_many :confirmed_memberships, -> { where confirmed: true }, class_name: "Membership"
    has_many :unconfirmed_memberships, -> { where confirmed: [nil, false] }, class_name: "Membership"

	has_many :members, through: :memberships, source: :user

	validates :name, presence: true
	validates :city, presence: true
	validates :founded, numericality: { only_integer: true }

    def is_member(user)
        !(self.confirmed_memberships.where user_id:user.id).empty? 
    end

	def to_s
		"#{self.name} (#{self.city}, since #{self.founded})"
	end
end