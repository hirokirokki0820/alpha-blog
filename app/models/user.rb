class User < ApplicationRecord
  before_save { self.email = email.downcase }
  has_many :articles, dependent: :destroy
  # dependent: :destroy → アカウントを削除したら、それに関連する記事も同時に削除する
  # 例） hiroki のアカウントを削除すると同時に、hirokiが投稿してきた記事も全て削除する

  validates :username, presence: true,
                      uniqueness: true,
                      length: { minimum: 3, maximum:25 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true,
                    uniqueness: { case_sensitive: false },
                    length: { maximum: 105 },
                    format: { with: VALID_EMAIL_REGEX }
  has_secure_password
end
