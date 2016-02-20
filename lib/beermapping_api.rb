class BeermappingApi

	def self.place_by_id(id) 
		Rails.cache.fetch("place_with_id_#{id}", expires_in: 1.week) { fetch_place_by_id(id) }
	end

	def self.places_in(city)
		city = city.downcase
		Rails.cache.fetch("places_search_city_#{city}", expires_in: 1.week) { fetch_places_in(city) }
	end

	private

	def self.fetch_place_by_id(id)
		url = "http://beermapping.com/webservice/locquery/#{key}/"

		response = HTTParty.get "#{url}#{ERB::Util.url_encode(id)}"
		place = response.parsed_response["bmp_locations"]["location"]

		Place.new(place)
	end

	def self.fetch_places_in(city)
		url = "http://beermapping.com/webservice/loccity/#{key}/"

		response = HTTParty.get "#{url}#{ERB::Util.url_encode(city)}"
		places = response.parsed_response["bmp_locations"]["location"]

		return [] if places.is_a?(Hash) and places['id'].nil?

		places = [places] if places.is_a?(Hash)
		places.map do |place|
			Place.new(place)
		end
	end

	#fd9b62fec0e8fc51ba345b2ff1803091
	def self.key
		raise "APIKEY env variable not defined" if ENV['APIKEY'].nil?
		ENV['APIKEY']
	end

end