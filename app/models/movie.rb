class Movie < ActiveRecord::Base
   def self.with_ratings(ratings_list)
  # if ratings_list is an array such as ['G', 'PG', 'R'], retrieve all
  #  movies with those ratings
  # if ratings_list is nil, retrieve ALL movies
     where(ratings_list.contains("rating"))
  end
  def all_ratings
    ['G','PG','PG-13','R']
  end
end
