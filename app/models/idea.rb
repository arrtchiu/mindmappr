class Idea < ActiveRecord::Base
  belongs_to :parent, class_name: :Idea
  has_many :children, class_name: :Idea, foreign_key: :parent_id

  validates :content, presence: true

  default_scope -> { includes(:children) }
  scope :top_level, -> { where(parent_id: nil) }

  after_create do |idea|
    idea.notify_redis!('add')
  end

  def notify_redis!(op)
    $redis.with do |r|
      data = {
        op: op,
        value: serializable_hash
      }
      r.publish("idea:#{id}", data.to_json)
    end
  end
end
