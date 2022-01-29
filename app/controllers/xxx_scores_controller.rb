class ScoresController < ApplicationController

  # GET /scores
  def index
    @scores = Score.all

    render json: @scores
  end

  # POST /scores
  def create
    @score = Score.new(score_params)

    if @score.save
      render json: @score, status: :created, location: @score
    else
      render json: @score.errors, status: :unprocessable_entity
    end
  end


  private

    # Only allow a list of trusted parameters through.
    def score_params
      binding.pry
      params.require(:score).permit(:user_id, :score)
    end
end
