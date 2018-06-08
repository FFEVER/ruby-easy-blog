class CommentsController < ApplicationController
  before_action :authenticate_user!, only: [:destroy]

  def create
    @article = Article.find(params[:article_id])
    @comment = @article.comments.new(comment_params)
    if @comment.save
      redirect_to(article_path(@article))
    else
      redirect_to(article_path(@article), flash: { comment_errors: @comment.errors.full_messages})
    end
  end

  def destroy
    @article = current_user.articles.find(params[:article_id])
    # @article = Article.find(params[:article_id])
    @comment = @article.comments.find(params[:id])
    if current_user.id == @comment.user_id
      @comment.destroy
      redirect_to(article_path(@article), flash: { notice: 'Comment destroyed successfully.'})
    else
      redirect_to(article_path(@article), flash: { alert: 'Only author and owner can delete comments.'})
    end
  end

  private

    def comment_params
      params.require(:comment).permit(:commenter, :body).merge!(user_id: current_user&.id)
    end
end
