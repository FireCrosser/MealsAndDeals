require 'rails_helper'

describe ::User, type: :model do

  FactoryGirl.create_list(:role, 2)
  users = FactoryGirl.create_list(:user, 3)

  context '#user_role' do

    it 'should return role_id = 2 for first created user' do
      expect(users[0].role_id).to equal(2)
    end

    it 'should return role_id = 1 for other users' do
      expect(users[1].role_id).to equal(1)
      expect(users[2].role_id).to equal(1)
    end

  end
end
