require 'rails_helper'

RSpec.describe Article, type: :model do
  context 'validations' do
    it do
      should validate_presence_of(:title)
      should validate_presence_of(:text)
      should validate_length_of(:title).is_at_most(50)
      should validate_length_of(:text).is_at_most(3000)
    end
  end

  context 'associations' do
    it do
      should belong_to(:user)
      should have_many(:comments).dependent(:destroy)
    end
  end
end