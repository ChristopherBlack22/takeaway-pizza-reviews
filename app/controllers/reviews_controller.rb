class ReviewsController < ApplicationController

    get "/reviews/index" do
        @reviews = Review.all
        erb :"reviews/index"
    end 

    get "/reviews/new" do
        @takeaway_pizzas = TakeawayPizza.all
        erb :"reviews/new"
    end 

    post "/reviews" do 
        puts params
    end 

end 