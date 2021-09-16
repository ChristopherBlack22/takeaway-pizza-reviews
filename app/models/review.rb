class Review < ActiveRecord::Base
    belongs_to :user
    belongs_to :takeaway_pizza
end 