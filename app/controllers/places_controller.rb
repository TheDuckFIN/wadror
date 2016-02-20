class PlacesController < ApplicationController

	#fd9b62fec0e8fc51ba345b2ff1803091

	def index
		
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