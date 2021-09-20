class ReviewsController < ApplicationController

    get "/reviews" do
        
        if logged_in?
            @takeaway_pizzas = TakeawayPizza.all
            #@reviews = Review.all
            erb :"reviews/index"
        else
            redirect "/"
        end 
    end 

    get "/reviews/new" do
        if logged_in?
            @takeaway_pizzas = TakeawayPizza.all
            erb :"reviews/new"
        else
            redirect "/"
        end 
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
            #@takeaway_pizza = TakeawayPizza.create(params["takeaway_pizza"])
            @takeaway_pizza = TakeawayPizza.find_or_create_by(params["takeway_pizza"])
            @review = Review.create(content: params["review"]["content"], takeaway_pizza_id: @takeaway_pizza.id, user_id: current_user.id)
            #add message review created
            redirect "/reviews/#{@review.id}"
        end 
    end 

    get "/reviews/:id" do
        if logged_in?
            @review = Review.find_by_id(params[:id])
            erb :"reviews/show"
        else
            redirect "/"
        end 
    end 

    get "/reviews/:id/edit" do
        @review = Review.find_by_id(params[:id])
        if logged_in? && @review.user == current_user
            erb :"reviews/edit"
        elsif logged_in?
            redirect "/reviews/#{@review.id}"
        else
            redirect "/"
        end 
    end 

    patch "/reviews/:id" do
        @review = Review.find_by_id(params[:id])
        @review.content = params["review"]["content"]
        @review.save
        if params["takeaway_pizza"]
            @takeaway_pizza = @review.takeaway_pizza
            @takeaway_pizza.name = params["takeaway_pizza"]["name"]
            @takeaway_pizza.address = params["takeaway_pizza"]["address"]
            @takeaway_pizza.save
        end 
        redirect "/reviews/#{@review.id}"
    end 

    delete "/reviews/:id" do
        @review = Review.find_by_id(params[:id])
        if @review.takeaway_pizza.reviews.count == 1
            @review.takeaway_pizza.delete
        end 
        @review.delete
        redirect "/reviews"  
    end 

end 