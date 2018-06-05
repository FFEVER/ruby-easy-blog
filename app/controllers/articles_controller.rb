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
      # redirect to previous page
      render('new')
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
    @article = Article.find(params[:id])
    @article.destroy

    redirect_to(articles_path)
  end

  private
    def article_params
      params.require(:article).permit(:title,:text)
    end
end
