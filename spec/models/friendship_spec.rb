# == Schema Information
#
# Table name: friendships
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  friend_id  :integer
#  status     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#


require 'rails_helper'

RSpec.describe Friendship, type: :model do
  it { should belong_to :friend }
  it { should belong_to :user }
  
  it "should validate uniqueness of user with friend" do
  	user = FactoryGirl.create(:user)
  	friend = FactoryGirl.create(:user)

  	FactoryGirl.create(:friendship,user: user, friend: friend)

  	amistad_duplicada = FactoryGirl.build(:friendship,user: user, friend: friend)

  	expect(amistad_duplicada.valid?).to be_falsy

	end
end
