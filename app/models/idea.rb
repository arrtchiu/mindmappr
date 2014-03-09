class Idea < ActiveRecord::Base
  belongs_to :parent, class_name: :Idea
  has_many :children, class_name: :Idea, foreign_key: :parent_id

  validates :content, presence: true

  default_scope -> { includes(:children) }
  scope :top_level, -> { where(parent_id: nil) }
end
