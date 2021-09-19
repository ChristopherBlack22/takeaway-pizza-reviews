class TakeawayPizza < ActiveRecord::Base
    has_many :reviews
    has_many :users, through: :reviews

    def self.find_or_create_by(attributes_hash)
        if self.find_by(attributes_hash)
            takeaway_pizza = self.find_by(attributes_hash)
        else
            takeaway_pizza = self.create(attributes_hash)
        end 
    end 

end 