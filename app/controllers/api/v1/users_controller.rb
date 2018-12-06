class Api::V1::UsersController < Api::V1::BaseController
  skip_before_action :authenticate_user_from_token!, only: :signin

  api! "认证"
  param :email, String, desc: "邮箱"
  param :password, String, desc: "密码"
  example <<-JSON
{
    "id": 1,
    "museum_id": 1,
    "email": "admin@microwise-system.com",
    "authentication_token": "zmSt4WHAFFsAecsLXQDG",
    "created_at": "2017-06-20T13:42:41.000+08:00",
    "updated_at": "2017-07-24T09:19:56.000+08:00",
    "museum": {
        "id": 1,
        "name": "兵马俑博物馆"
    }

    // 注意： museum 可能为 null
}
  JSON
  def signin
    unless params[:email].present? && params[:password].present?
      render json: { error: '邮箱和密码必须填写' }, status: 401 and return
    end

    @user = User.where(email: params[:email]).first

    render json: { error: '邮箱或密码错误' }, status: 401 and return unless @user
    render json: { error: '邮箱或密码错误' }, status: 401 and return unless @user.valid_password?(params[:password])

    if @user.authentication_token.blank?
      @user.ensure_authentication_token
      @user.save!
    end

  end
end