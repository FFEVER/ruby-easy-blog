require 'rails_helper'

RSpec.describe Comment, type: :model do
  context 'validations' do
    it do
      should validate_presence_of(:commenter)
      should validate_presence_of(:body)
      should validate_length_of(:body).is_at_least(1).is_at_most(500).on(:create).on(:edit)
    end
  end

  context 'associations' do
    it do
     should belong_to(:user)
     should belong_to(:article)
    end
  end
end