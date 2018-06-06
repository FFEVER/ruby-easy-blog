class CommentsController < ApplicationController
  before_action :authenticate_user!, only: [:destroy]
  def create
    @article = Article.find(params[:article_id])
    @comment = @article.comments.new(comment_params)
    # binding.pry
    if @comment.save
      redirect_to(article_path(@article))
    elsif comment_params[:commenter] && comment_params[:body] && @comment.save(validate: false)
      redirect_to(article_path(@article))
    else
      redirect_to(article_path(@article), :flash => {:comment_errors => @comment.errors.full_messages})
    end

  end

  def destroy
    @article = current_user.articles.find(params[:article_id])
    # @article = Article.find(params[:article_id])
    @comment = @article.comments.find(params[:id])
    if current_user.id == @comment.user_id
      @comment.destroy
      redirect_to(article_path(@article))
    else
      redirect_to(article_path(@article), :flash => {:alert => 'Only author and owner can delete comments.'})
    end

  end

  private
    def comment_params
      if current_user
        params.require(:comment).permit(:commenter,:body).merge!(user_id: current_user&.id)
      else
        params.require(:comment).permit(:commenter,:body)
        end
    end
end
