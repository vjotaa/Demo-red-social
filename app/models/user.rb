# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  username               :string(255)      default(""), not null
#  name                   :string(255)
#  last_name              :string(255)
#  bio                    :text(65535)
#  uid                    :string(255)
#  provider               :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  cover_file_name        :string(255)
#  cover_content_type     :string(255)
#  cover_file_size        :integer
#  cover_updated_at       :datetime
#  avatar_file_name       :string(255)
#  avatar_content_type    :string(255)
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
  has_many :friendship
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
