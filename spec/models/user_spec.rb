require 'rails_helper'

RSpec.describe User, type: :model do
  context 'validations' do
    it do
      should validate_presence_of(:email)
      should validate_presence_of(:password)
    end
  end

  context 'associations' do
    it do
      should have_many(:articles).dependent(:destroy)
      should have_many(:comments).dependent(:destroy)
    end
  end
end