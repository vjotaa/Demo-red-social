# == Schema Information
#
# Table name: posts
#
#  id         :integer          not null, primary key
#  body       :text(65535)
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Post < ApplicationRecord
  belongs_to :user

  scope :news, ->{order("created_at desc")}

  after_create :send_to_action_cable


=begin

1.- Me tiene que mostrar mis propias publicaciones => user_id = user_id
2.- Las de mis amigos  => =
  *User_id => amista.friend_id

  *User_id => user.friend_id

  *Si y solo si la amistad ha sido aceptada.

end
=end

  def self.all_for_user(user)
      Post.where(user_id: user.id)
          .or( Post.where(user_id: user.friend_ids))
          .or( Post.where(user_id: user.user_ids))
  end

private
  def send_to_action_cable
    data = {message: to_html,action: "new_post"}

    self.user.friend_ids.each do |friend_id|
      ActionCable.server.broadcast "posts_#{friend_id}", data
    end

    self.user.user_ids.each do |friend_id|
      ActionCable.server.broadcast "posts_#{friend_id}", data
    end
  end

  def to_html
    ApplicationController.renderer.render(partial: "posts/post", locals: {post: self})
  end
end
