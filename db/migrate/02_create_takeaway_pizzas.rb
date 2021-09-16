class CreateTakeawayPizzas < ActiveRecord::Migration[4.2]
    def change
        create_table :takeaway_pizzas do |t|
            t.string :name
            t.string :address
        end 
    end
end 