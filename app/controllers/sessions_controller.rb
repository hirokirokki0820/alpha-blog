class SessionsController < ApplicationController

  def new

  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      session[:user_id] = user.id
      flash[:notice] = "ログインに成功しました。"
      redirect_to user
    else
      flash.now[:alert] = "メールアドレス、またはパスワードに間違いがあります。"
      render 'new', status: :unprocessable_entity
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:notice] = "ログアウトしました。"
    redirect_to root_path, status: :see_other
  end

end
