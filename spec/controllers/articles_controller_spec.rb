require 'rails_helper'

RSpec.describe ArticlesController, type: :controller do
  fixtures :articles
  fixtures :users

  let(:article) { articles(:article_1) }
  let(:user) { users(:user_1) }

  context "Article controller request spec(non-user)" do
    render_views
    it 'GET #index' do
      get :index
      should respond_with(200)
      should render_template('index')
    end

    it 'GET #show' do
      get :show, params: {id: article.id}
      should respond_with(200)
      should render_template('show')
    end

    it 'GET #edit' do
      get :edit, params: {id: article.id}
      should respond_wtih()
    end
  end

  context 'Articles controller request specs(with user)' do
    login_user
    render_views

    it "should have a current_user" do
      # note the fact that you should remove the "validate_session" parameter if this was a scaffold-generated controller
      expect(subject.current_user).to_not eq(nil)
    end

    it 'GET #index' do
      get :index
      should respond_with(200)
      should render_template('index')
    end

    it 'GET #show' do
      get :show, params: { id: article.id }
      should respond_with(200)
      should render_template('show')
    end
  end


end
