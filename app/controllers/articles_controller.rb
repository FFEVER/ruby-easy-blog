class ArticlesController < ApplicationController
  before_action :authenticate_user!, except: [:index,:show]

  def index
    @articles = Article.all
  end

  def my_articles
    @my_articles = current_user.articles.all
  end

  def show
    @article = Article.find(params[:id])
    @writer = User.find(@article.user_id)
    # binding.pry
  end

  def new
    # @article = Article.new(article_params)
    @article = current_user.articles.new
  end

  def edit
    @article = Article.find(params[:id])
    if current_user.id != @article.user_id
      redirect_to(article_path(@article), :flash => {:alert => "Only author can edit this article."})
    end
  end

  def create
    # Show the params value
    # render plain: params[:article].inspect

    # @article = Article.new(article_params)
    @article = current_user.articles.new(article_params)
    if @article.save
      # redirect to show action
      # redirect_to(@article) is equal to redirect_to(article_path(@article))
      redirect_to(@article, notice: 'Article created')
    else
      redirect_to(new_article_path, flash: { new_article_errors: @article.errors.full_messages })
    end
  end

  def update
    @article = Article.find(params[:id])
    if @article.update(article_params)
      redirect_to(@article)
    else
      render('edit')
    end
  end

  def destroy
    binding.pry
    @article = current_user.articles.find(params[:id])
      # redirect_to(articles_path, flash: { delete_article_errors: @article.errors.full_messages })
    @article.destroy
    redirect_to(articles_path)
    else
  end

  def render_404
    render json: {meta: meta_response(404, "Record not found")}
  end

  private
    def article_params
      params.require(:article).permit(:title,:text)
    end
end
