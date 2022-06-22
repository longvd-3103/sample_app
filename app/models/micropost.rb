class Micropost < ApplicationRecord
  belongs_to :user

  scope :recent_posts, ->{order created_at: :desc}
  has_one_attached :image
  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: 140}
  validates :image, content_type:
                          {in: %w(image/jpeg image/gif image/png),
                           message: I18n.t(".microposts.format_invalid")},
                    size: {less_than: 5.megabytes,
                           message: I18n.t(".microposts.less_5mb")}
  scope :feed, ->(id){Micropost.where user_id: id}
  def display_image
    image.variant resize_to_limit: [Settings.image.width_size,
                                    Settings.image.width_size]
  end
end
