require 'rails_helper'

RSpec.describe ArticlesController, type: :controller do
  fixtures :articles
  fixtures :users

  let(:article) { articles(:article_1) }
  let(:article2) { articles(:article_2) }
  let(:user_1) { users(:user_1) }
  let(:user_2) { users(:user_2) }

  context 'Article controller request spec(non-user)' do
    render_views
    it 'GET #index' do
      get :index
      expect(response).to have_http_status(200)
      expect(response).to render_template('index')
    end

    it 'POST #create' do
      post :create, params: { article: { title: 'abcdefg', text: 'abcskdjfksflsdkf' }}
      expect(flash[:alert]).to eq('You need to sign in or sign up before continuing.')
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'GET #new' do
      get :new
      expect(flash[:alert]).to eq('You need to sign in or sign up before continuing.')
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'GET #edit' do
      get :edit, params: { id: article.id }
      expect(flash[:alert]).to eq('You need to sign in or sign up before continuing.')
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'GET #show' do
      get :show, params: { id: article.id }
      expect(response).to have_http_status(200)
      expect(response).to render_template('show')
    end

    it 'PUT #update' do
      put :update, params: { id: article.id, article: { title: 'edited_title', text: 'edited_text' }}
      expect(flash[:alert]).to eq('You need to sign in or sign up before continuing.')
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'DELETE #destroy' do
      delete :destroy, params: { id: article.id }
      expect(flash[:alert]).to eq('You need to sign in or sign up before continuing.')
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'get #my_articles' do
      get :my_articles
      expect(flash[:alert]).to eq('You need to sign in or sign up before continuing.')
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  context 'Articles controller request specs(with user)' do
    # login_user
    before { sign_in(user_1) }
    render_views

    # it "should have a current_user" do
    #   # note the fact that you should remove the "validate_session" parameter if this was a scaffold-generated controller
    #   expect(subject.current_user).to_not eq(nil)
    # end

    it 'GET #index' do
      get :index
      expect(response).to have_http_status(200)
      expect(response).to render_template('index')
    end

    context 'POST #create' do
      it 'case true #create' do
        post :create, params: { article: { title: 'title', text: 'text' } }
        # assigns(:article) ==> @article
        expect(assigns(:article)).to be_a(Article)
        expect(assigns(:article).title).to eq('title')
        expect(assigns(:article).text).to eq('text')
        expect(flash[:notice]).to eq('Article created.')
        expect(response).to redirect_to(article_path(assigns(:article)))
      end
      it 'case false' do
        allow_any_instance_of(Article).to receive(:save).and_return(false)
        post :create, params: { article: { title: 'title', text: 'text' } }
        expect(flash[:new_article_errors]).to eq(assigns(:article).errors.full_messages)
        expect(response).to redirect_to(new_article_path)
      end
    end

    it 'GET #new' do
      get :new
      expect(response).to have_http_status(200)
      expect(assigns(:article)).to be_a(Article)
      expect(response).to render_template('new')
    end

    context 'GET #edit' do
      it 'case true #edit' do
        get :edit, params: { id: article.id }
        expect(response).to have_http_status(200)
        expect(assigns(:article).id).to eq(article.id)
        expect(response).to render_template('edit')
      end

      it 'case false' do
        get :edit, params: { id: article2.id }
        # binding.pry
        expect(assigns(:article).user_id).not_to eq(subject.current_user.id)
        expect(flash[:alert]).to eq("Only author can edit this article.")
        expect(response).to redirect_to(article_path(assigns(:article)))
      end
    end

    it 'GET #show' do
      get :show, params: { id: article.id }
      expect(response).to have_http_status(200)
      expect(response).to render_template('show')
    end

    context 'PUT #update' do
      it 'case true #update' do
        put :update, params: { id: article.id, article: { title: 'edited_title', text: 'edited_text' }}
        expect(assigns(:article).id).to eq(article.id)
        expect(assigns(:article).title).to eq('edited_title')
        expect(assigns(:article).text).to eq('edited_text')
        expect(flash[:notice]).to eq('Article edited.')
        expect(response).to redirect_to(article_path(assigns(:article)))
      end
      it 'case false' do
        allow_any_instance_of(Article).to receive(:update).and_return(false)
        put :update, params: { id: article.id, article: { title: 'edited_title', text: 'edited_text' }}
        expect(response).to render_template('edit')
      end
    end



    it 'DELETE #destroy' do
      delete :destroy, params: { id: article.id }
      expect(assigns(:article).id).to eq(article.id)
      expect(flash[:notice]).to eq('Article deleted.')
      expect(response).to redirect_to(action: :index)
    end

    it 'get #my_articles' do
      get :my_articles
      expect(response).to have_http_status(200)
      expect(response).to render_template('my_articles')
    end
  end
end
