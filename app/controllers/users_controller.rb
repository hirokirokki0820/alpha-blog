class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :require_user, only: [:edit, :update]
  before_action :require_same_user, only: [:edit, :update, :destroy]

  def show
    @articles = @user.articles.page(params[:page]).per(5).order(created_at: :desc)
  end

  def index
    @users = User.all.page(params[:page]).per(5).order(created_at: :desc)
  end

  def new
    @user = User.new
  end

  def edit
  end

  def update
    if @user.update(user_params)
      flash[:notice] = "プロフィールの編集に成功しました。"
      redirect_to @user
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      flash[:notice] = "ようこそ、#{@user.username}さん。ログインに成功しました。"
      redirect_to @user
    else
      render 'new', status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
    if !current_user.admin?
      session[:user_id] = nil
      # if @user == current_user でもOK
    end
    flash[:notice] = "アカウント、および関連する全ての投稿が削除されました。"
    redirect_to articles_path
  end

  private
  def user_params
    params.require(:user).permit(:username, :email, :password)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def require_same_user
    if current_user != @user && !current_user.admin?
      flash[:alert] = "許可されていない操作です。プロフィールの編集、削除は作成者ご自身のみ可能です。"
      redirect_to @user
    end
  end

end
