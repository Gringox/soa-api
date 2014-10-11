class App < ActiveRecord::Base
	validates :name, presence: true, length: { maximum: 30 }, uniqueness: true
	validates :description, presence: true, length: { maximum: 50 }

	def to_json(options={})
     options[:except] ||= [:created_at, :updated_at]
     super(options)
   	end
end
