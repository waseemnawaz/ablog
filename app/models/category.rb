class Category < ApplicationRecord
	has_many :comments
	has_many :posts
end