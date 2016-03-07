class RatingsController < ApplicationController
  def index
    #Tosiaan tällä tapaa nyt tulee 1 raskas lataus per viis minuuttia, mutta ei nyt tähän hätään oo aikaa tehdä paremmin!

    @ratings = Rails.cache.fetch("ratings_page_ratings", expires_in: 5.minutes) { Rating.all }
    @topbeers = Rails.cache.fetch("ratings_page_topbeers", expires_in: 5.minutes) { Beer.top 3 }
    @topbreweries = Rails.cache.fetch("ratings_page_topbreweries", expires_in: 5.minutes) { Brewery.top 3 }
    @topstyles = Rails.cache.fetch("ratings_page_topstyles", expires_in: 5.minutes) { Style.top 3 }
    @topraters = Rails.cache.fetch("ratings_page_topraters", expires_in: 5.minutes) { User.top_raters 3 }
  end

  def new
    @rating = Rating.new
    @beers = Beer.all
  end

  def destroy
    rating = Rating.find params[:id]
    rating.delete if current_user == rating.user
    redirect_to :back
  end

  def create
    @rating = Rating.new params.require(:rating).permit(:score, :beer_id)

    if current_user.nil?
      redirect_to signin_path, notice:'you should be signed in'
    elsif @rating.save
      current_user.ratings << @rating
      redirect_to user_path current_user
    else 
      @beers = Beer.all
      render :new
    end
  end
end