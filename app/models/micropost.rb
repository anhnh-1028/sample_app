class Micropost < ApplicationRecord
  FORMAT_IMG = Settings.format_img.freeze
  MICROPOST_PARAMS = Settings.micropost_params.freeze

  belongs_to :user
  has_one_attached :image

  validates :user_id, :content, presence: true,
    length: {maximum: Settings.content_post_length}
  validates :image, content_type: {in: FORMAT_IMG, message: I18n.t("micropost_mess1")},
    size: {less_than: Settings.mega_size.megabytes, message: I18n.t("micropost_mess2")}

  scope :recent_posts,->{order created_at: :desc}
  scope :feed_user,-> following_ids{where user_id: following_ids}
end
