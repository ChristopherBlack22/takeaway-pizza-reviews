require "rack-flash"
class ReviewsController < ApplicationController
    use Rack::Flash

    get "/reviews" do
        if logged_in?
            @takeaway_pizzas = TakeawayPizza.all
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
            flash[:message] = "Error - Reviews must have content!"
            redirect "/reviews/new" 
        elsif params["review"]["takeaway_pizza_id"] && (params["takeaway_pizza"]["name"] != "" || params["takeaway_pizza"]["address"] != "")
            flash[:message] = "Error - Only provide details for new Takeway Pizza if not selecting an existing one!"
            redirect "/reviews/new"
        elsif params["review"]["takeaway_pizza_id"]
            @review = Review.create(content: params["review"]["content"], takeaway_pizza_id: params["review"]["takeaway_pizza_id"], user_id: current_user.id)
            flash[:message] = "New Review created!"
            redirect "/reviews/#{@review.id}"
        elsif params["takeaway_pizza"]["name"] == "" || params["takeaway_pizza"]["address"] == ""
            flash[:message] = "Error - New Takeaway Pizzas must have a name and address!"
            redirect "/reviews/new"
        else
            @takeaway_pizza = TakeawayPizza.find_or_create_by(params["takeaway_pizza"])
            @review = Review.create(content: params["review"]["content"], takeaway_pizza_id: @takeaway_pizza.id, user_id: current_user.id)
            flash[:message] = "New Review created!"
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
        if params["review"]["content"] == ""
            flash[:message] = "Error - Reviews must have content!"
            redirect "/reviews/#{@review.id}/edit"
        else
            @review.content = params["review"]["content"]
            @review.save
        end 
        if params["takeaway_pizza"] && (params["takeaway_pizza"]["name"] == "" || params["takeaway_pizza"]["address"] == "")
            flash[:message] = "Error - Takeway Pizzas must have a name and address!"
            redirect "/reviews/#{@review.id}/edit"
        else
            @takeaway_pizza = @review.takeaway_pizza
            @takeaway_pizza.name = params["takeaway_pizza"]["name"]
            @takeaway_pizza.address = params["takeaway_pizza"]["address"]
            @takeaway_pizza.save
        end 
        flash[:message] = "Review updated!"
        redirect "/reviews/#{@review.id}"
    end 

    delete "/reviews/:id" do
        @review = Review.find_by_id(params[:id])
        if @review.takeaway_pizza.reviews.count == 1
            @review.takeaway_pizza.delete
        end 
        @review.delete
        flash[:message] = "Review deleted!"
        redirect "/reviews"  
    end 

end 