class TakeawayPizzasController < ApplicationController

    get "/takeaway_pizzas" do
        @takeaway_pizzas = TakeawayPizza.all
        erb :"takeaway_pizzas/index"
    end 
end 