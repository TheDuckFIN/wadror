class PlacesController < ApplicationController

	def index
	end

	def show
		@place = BeermappingApi.place_by_id(params[:id])
		@address = ERB::Util.url_encode("#{@place.street}, #{@place.zip} #{@place.city}")
	end

	def search
		@places = BeermappingApi.places_in(params[:city])

		if @places.empty?
			redirect_to places_path, notice: "No locations in #{params[:city]}"
		else
			render :index
		end
	end

end