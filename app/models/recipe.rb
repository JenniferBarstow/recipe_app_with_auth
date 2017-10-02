class Recipe < ActiveRecord::Base
  belongs_to :user
  
  validates :name, :ingredients, :instructions, presence: true
end
