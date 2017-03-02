# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  username               :string           default(""), not null
#  name                   :string
#  last_name              :string
#  bio                    :text
#  uid                    :string
#  provider               :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  cover_file_name        :string
#  cover_content_type     :string
#  cover_file_size        :integer
#  cover_updated_at       :datetime
#  avatar_file_name       :string
#  avatar_content_type    :string
#  avatar_file_size       :integer
#  avatar_updated_at      :datetime
#

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :omniauth_providers => [:facebook]
  validates :username, presence: true,uniqueness: true,length: {in: 3..12}
  validate :validate_username_regex

  has_many :posts
  has_many :friendships
  has_many :followers,class_name: "Friendship",foreign_key: "friend_id"

  has_many :friends_added, through: :friendships, source: :friend
  has_many :friends_who_added,through: :friendships, source: :user

  has_attached_file :avatar, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.jpeg"
  has_attached_file :cover, styles: { medium: "900x600>", thumb: "400x300>" }, default_url: "/images/:style/missing_cover.jpg"
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\z/
  validates_attachment_content_type :cover, content_type: /\Aimage\/.*\z/

  def my_friend?(friend)
    Friendship.friends?(self,friend)
  end


  def unviewed_notifications_count
    Notification.for_user(self.id)
  end
  def friend_ids
    # [12,123,12,3123] => friend_id
    #Yo soy el user => friend_id
    Friendship.active.where(user:self).pluck(:friend_id)
  end

  def user_ids
    #Yo soy el friend => user_id
    Friendship.active.where(friend:self).pluck(:user_id)
  end

  private
    def validate_username_regex
      unless username =~ /\A[a-zA-Z]*[a-zA-Z][a-zA-Z0-9_]*\z/
        errors.add(:username,'the username may contain letters, underscores and numbers')
        errors.add(:username, 'The username must be star with a letter.s')
      end
    end
end
