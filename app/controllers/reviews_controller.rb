class ReviewsController < ApplicationController

    get "/reviews/index" do
        @reviews = Review.all
        erb :"reviews/index"
    end 

end 