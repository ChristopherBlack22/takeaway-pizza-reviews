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
        if params["review"]["content"].empty?
            redirect "/reviews/new" #add error message, must have content
        elsif params["review"]["takeaway_pizza_id"] && params["takeaway_pizza"]["name"] != ""
            redirect "/reviews/new" #add error message, cant select old pizza and create new together
        elsif params["review"]["takeaway_pizza_id"]
            @review = Review.create(content: params["review"]["content"], takeaway_pizza_id: params["review"]["takeaway_pizza_id"], user_id: current_user.id)
            #add message review created
            redirect "/reviews/#{@review.id}"
        elsif params["takeaway_pizza"]["address"] == ""
            redirect "/reviews/new" #add error message, must have address
        else
            @takeaway_pizza = TakeawayPizza.create(params["takeaway_pizza"])
            @review = Review.create(content: params["review"]["content"], takeaway_pizza_id: @takeaway_pizza.id, user_id: current_user.id)
            #add message review created
            redirect "/reviews/#{@review.id}"
        end 
    end 

    get "/reviews/:id" do
        if logged_in?
            @review = Review.find(params[:id])
            erb :"reviews/show"
        else
            redirect "/"
        end 
    end 

    get "/reviews/:id/edit" do
        @review = Review.find(params[:id])
        erb :"reviews/edit"
    end 

end 