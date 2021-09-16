class CreateReviews < ActiveRecord::Migration[4.2]
    def change
        create_table :reviews do |t|
            t.string :content
            t.integer :user_id
            t.integer :takeaway_pizza_id
            t.timestamps
        end 
    end
end 