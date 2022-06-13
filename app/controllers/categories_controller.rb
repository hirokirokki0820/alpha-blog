class CategoriesController < ApplicationController

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
  end

  private

  def category_params
    params.require(:category).permit(:name)
  end
end
