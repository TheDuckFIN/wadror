class Beer < ActiveRecord::Base
	include RatingAverage

	belongs_to :brewery
	has_many :ratings, dependent: :destroy;

	def to_s
		"#{self.name} (#{Brewery.find(self.brewery_id).name})"
	end

end
