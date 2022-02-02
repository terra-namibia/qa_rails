class ScoresController < ApplicationController
  before_action :set_score, only: %i[ show update destroy ]
  before_action :auth, except: %i[ hello ]

  def hello
    # ユーザごとのベストscore 30人まで

    render json: { "response": "ok"}
  end

  # GET /scores
  def index
    # ユーザごとのベストscore 30人まで
    @scores = Score.all

    render json: @scores
  end

  def user_scores
    # ユーザごとのベストscore 30人まで
    @scores = User.eager_load(:scores).where("scores.score > 0").order(score: :desc).map{ |user| { user_name: user.user_name, score: user.scores[0].try(:score), date: user.scores[0].try(:created_at).strftime("%Y-%m-%d %H:%M:%S") } }.first(30)

    render json: @scores
  end

  # GET /scores/1
  def show
    render json: @score
  end

  # POST /scores
  def create
    @user = User.find_by(user_params)
    render json: { "message": "user_not_found" }, status: :unauthorized and return unless @user

    @score = @user.scores.new(score_params)
    score_exist = Score.find_by(user_id: @score.user_id, score: @score.score)

    if score_exist
      render json: { "message": "score_exist" }, status: :no_content
    elsif @score.save
      render json: @score, status: :created, location: @score
    else
      render json: @score.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /scores/1
  def update
    if @score.update(score_params)
      render json: @score
    else
      render json: @score.errors, status: :unprocessable_entity
    end
  end

  # DELETE /scores/1
  def destroy
    @score.destroy
  end

  private
    def auth
      if params[:token] != ENV.fetch("API_TOKEN", "")
        render json: { "message": "token_error" }, status: :unauthorized and return
      end
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_score
      @score = Score.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def score_params
      params.require(:score).permit(:score, :user_id, :user_name)
    end

    def user_params
      params.require(:user).permit(:user_name, :auth_provider)
    end
end
