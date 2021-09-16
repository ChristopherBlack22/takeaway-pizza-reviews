class CreateTakeawayPizzas < ActiveRecord::Migration
    def change
        create_table :takeaway_pizzas do |t|
            t.string :name
            t.string :address
        end 
    end
end 