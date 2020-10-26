class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings
    @ratings_hash = []
    @movies = Movie.all
    case1 = (params[:ratings] == nil)&&(session[:ratings] == nil)
    case2 = (params[:ratings] == nil)&&(session[:ratings] != nil)
    case3 = (params[:ratings] != nil)&&(session[:ratings] == nil)
    case4 = (params[:ratings] != nil)&&(session[:ratings] != nil)
    
    if case3
      ratings = params[:ratings].keys
      @ratings_to_show = ratings
      hash = Hash[ratings.collect { |item| [item, 1] } ]
      @ratings_hash = hash
      session[:ratings] = ratings
      @movies = Movie.with_ratings(ratings)
    elsif case1
      @ratings_to_show = []
    elsif case2&&(params[:commit] == "Refresh")
      session.delete(:ratings)
      @movies = Movie.all
      @ratings_to_show = []
    elsif case2
      ratings = session[:ratings]
      @ratings_to_show = ratings
      hash = Hash[ratings.collect { |item| [item, 1] } ]
      @ratings_hash = hash
      session[:ratings] = ratings
      @movies = Movie.with_ratings(ratings)
    elsif case4
      ratings = params[:ratings].keys
      @ratings_to_show = ratings
      hash = Hash[ratings.collect { |item| [item, 1] } ]
      @ratings_hash = hash
      session[:ratings] = ratings
      @movies = Movie.with_ratings(ratings)
    end
    if (params[:sort] != nil)
      @sort = params[:sort]
      if params[:sort] == "title"
        @sort_title = true
        @movies = @movies.order_by_title()
      elsif params[:sort] == "release"
        @sort_release = true
        @movies = @movies.order_by_release()
      end
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  
  
  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
