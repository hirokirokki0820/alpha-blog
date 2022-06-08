class ArticlesController < ApplicationController
  before_action :set_article, only: [:show, :edit, :update, :destroy]

  def show
    # ↑before_action で :set_article メソッドを定義
    # @article のインスタンス変数が使える
  end

  def index
    @articles = Article.all
  end

  def new
    @article = Article.new
  end

  def edit
  end

  def create
    #@article = Article.new(params[:article]) と同じ処理
    @article = Article.new(article_params)
    @article.user = User.first
    if @article.save
      flash[:notice] = "新規投稿が完了しました。"
      redirect_to @article
    else
      render 'new', status: :unprocessable_entity
      # rails7.0.3 から status: :unprocessable_entity が必須に！！
    end
  end

  def update
    if @article.update(article_params)
      flash[:notice] ="記事を更新しました。"
      redirect_to @article
    else
      # p @article.errors
      render 'edit', status: :unprocessable_entity
    end
  end

  def destroy
    @article.destroy
    redirect_to articles_path, status: :see_other
  end


  private

    # to find an article
    def set_article
      @article = Article.find(params[:id])
    end
    # Strong Parameters
    def article_params
      params.require(:article).permit(:title, :description)
    end

end
