class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings=['G','PG','PG-13','R']
    @redirect=false
    if(@checked==nil)
      @movies=Movie.all
    end
    #get corresponding ratings data from database
    if(params[:ratings] != nil)
      session[:ratings]=params[:ratings]
      array_ratings = params[:ratings].keys
      @movies = Movie.where(rating: array_ratings)
    elsif(session.has_key?(:ratings))
      params[:ratings]=session[:ratings]
      @redirect=true
    end
    #sort the retrieved data by corresponding attribute
    if(params[:sort].to_s == 'title')
      session[:sort] = params[:sort]
      if(@movies==nil)
        @movies=Movie.order('title')
      elsif
        @movies = @movies.sort_by{|m| m.title}
      end
    elsif(params[:sort].to_s == 'release_date')
      session[:sort] = params[:sort]
      if(@movies==nil)
        @movies=Movie.order('release_date')
      elsif
        @movies = @movies.sort_by{|m| m.release_date}
      end
    elsif(session.has_key?(:sort))
      params[:sort]=session[:sort]
      @redirect=true
    end
    #redirect to index function with filled params
    if(@redirect)
      redirect_to movies_path(sort: params[:sort], ratings: params[:ratings])
    end
    # set the checked box
    @checked={}
    @all_ratings.each { |rating|
      if params[:ratings] == nil
        @checked[rating] = false
      else
        @checked[rating] = params[:ratings].has_key?(rating)
      end
    }
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

end
