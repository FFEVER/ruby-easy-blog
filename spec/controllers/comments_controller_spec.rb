require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  fixtures :articles
  fixtures :users
  fixtures :comments

  let(:article_1) { articles(:article_1) }
  let(:article_2) { articles(:article_2) }
  let(:user_1) { users(:user_1) }
  let(:user_2) { users(:user_2) }
  let(:comment_1) { comments(:comment_1) }
  let(:comment_2) { comments(:comment_2) }

  context 'Comment controller request spec(non-user)' do
    render_views

    context 'POST #create' do
      it 'case true #create' do
        post :create, params: {
          article_id: article_1.id,
          comment: { commenter: 'comment_commenter', body: 'comment_body' }}
        expect(assigns(:comment)).to be_a(Comment)
        expect(response).to redirect_to(article_path(article_1))
      end

      it 'case false' do
        allow_any_instance_of(Comment).to receive(:save).and_return(false)
        post :create, params: {
          article_id: article_1.id,
          comment: { commenter: '', body: '' }
        }
        expect(flash[:comment_errors]).to eq(assigns(:comment).errors.full_messages)
        expect(response).to redirect_to(article_path(article_1))
      end
    end

    it 'DELETE #destroy' do
      delete :destroy, params: { article_id: article_1.id, id: comment_1.id }
      expect(flash[:alert]).to eq('You need to sign in or sign up before continuing.')
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  context 'Comment controller request specs(with user)' do
    before { sign_in(user_1) }
    render_views

    context 'POST #create' do
      it 'case true #create' do
        post :create, params: {
          article_id: article_1.id,
          comment: { commenter: 'comment_commenter', body: 'comment_body' }}
        expect(assigns(:comment)).to be_a(Comment)
        expect(assigns(:comment).user_id).to eq(subject.current_user.id)
        expect(response).to redirect_to(article_path(article_1))
      end

      it 'case false' do
        allow_any_instance_of(Comment).to receive(:save).and_return(false)
        post :create, params: {
          article_id: article_1.id,
          comment: { commenter: '', body: '' }
        }
        expect(flash[:comment_errors]).to eq(assigns(:comment).errors.full_messages)
        expect(response).to redirect_to(article_path(article_1))
      end
    end

    context 'DELETE #destroy' do
      it 'case true' do
        delete :destroy, params: { article_id: article_1.id, id: comment_1.id }
        expect(flash[:notice]).to eq('Comment destroyed successfully.')
        expect(response).to redirect_to(article_path(article_1))
      end

      it 'case false' do
        delete :destroy, params: { article_id: article_1.id, id: comment_2.id }
        expect(subject.current_user.id).not_to eq(assigns(:comment).user_id)
        expect(flash[:alert]).to eq('Only author and owner can delete comments.')
        expect(response).to redirect_to(article_path(article_1))
      end
    end
  end
end
