class UsersController < ApplicationController
  before_action :set_user, only: %i[ show update destroy ]
  before_action :auth

  # GET /users
  def index
    @users = User.all

    render json: @users
  end

  # GET /users/1
  def show
    render json: @user
  end

  # POST /users
  def create
    @user = User.new(user_params)
    user_exist = User.find_by(user_name: @user.user_name, auth_provider: @user.auth_provider)

    if user_exist
      render json: { "message": "user_exist" }, status: :no_content
    elsif @user.save
      render json: @user, status: :created, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
  end

  private
    def auth
      if params[:token] != ( Rails.env.production? ? ENV.fetch("API_TOKEN") : "token_test" )
        render json: { "message": "token_error" }, status: :unauthorized and return
      end
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:user_name, :score, :auth_provider)
    end
end
