require 'rails_helper'

RSpec.describe WelcomeController, type: :controller do
  context 'GET #index' do
    before {get :index}
    it 'should success and render to index page' do
      should respond_with(200)
      should render_template('index')
    end
  end
end