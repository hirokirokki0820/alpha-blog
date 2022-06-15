class CategoriesController < ApplicationController
  before_action :require_admin, except: [:index, :show]

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      flash[:notice] = "新規カテゴリーが作成されました。"
      redirect_to @category
    else
      render 'new', status: :unprocessable_entity
    end
  end

  def index
    @categories = Category.all.page(params[:page]).per(5).order(created_at: :desc)
  end

  def show
    @category = Category.find(params[:id])
    @articles = @category.articles.page(params[:page]).per(5).order(created_at: :desc)
  end

  private

  def category_params
    params.require(:category).permit(:name)
  end

  def require_admin
    if !(logged_in? && current_user.admin?)
      flash[:alert] = "許可されていない操作です。"
      redirect_to categories_path
    end
  end
end
