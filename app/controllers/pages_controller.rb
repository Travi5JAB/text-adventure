class PagesController < ApplicationController
  skip_before_action :verify_authenticity_token

  # playhistory.html.erb
  def playhistory
    @my_games = Game.where('creator' => current_user.username)
    @play_history = [1]
  end

  # profile.html.erb profile pages
  def profile
    # find profile based on user
    @user = User.find(params[:id])

    # all games belonging to user
    @my_games = Game.where('creator' => @user.username)
    # my_games with reports and ratings
    @use = @my_games.includes(:reports, :ratings)

    # my reports
    @my_game_ids = @my_games.map{|game| game.id}
    @my_reports = Report.where(game_id: @my_game_ids)
    # my ratings
    @my_ratings = Rating.where(game_id: @my_game_ids)

    # list of scores
    @ratings_scores = @my_ratings.map{|rating| rating.score }

    # avg for all games
    @all_game_avg = @ratings_scores.sum.to_f/@ratings_scores.length

  end

  # show.html.erb/ single game page
  def show
    @game = Game.find(params[:id])
    @webpage = @game.webpage

    # all ratings for game
    @total_ratings = []
    Rating.find_each do |rating|
      if rating.game_id == @game.id && @game.user_id == @game.user_id
        @total_ratings << rating.score.to_f
      end
    end
    if @total_ratings.length > 0
      @avg = @total_ratings.sum/@total_ratings.length
    else
      @avg = 0
    end

    # Rating.find_each do |rating|
    #   Game.find_each do |game|
    #     if rating.game_id == game.id && game.user_id == @game.user_id
    #       @total_ratings << rating.score
    #     end
    #   end
    # end
    # @avg = @total_ratings.sum/@total_ratings.length
  end

  # index.html.erb/ home/ all_games page
  def index
    @all_games = Game.all
  end

  # report.html.erb page
  def report
    @game = Game.find(params[:id])
  end

  # reportinfo.htm.erb
  def reportinfo
    @game = Game.find(params[:id])
    @report = Report.where('game_id' => @game.id)
    @rating = Rating.where('game_id' => @game.id)
  end

  # create a new game (function on newgame.html.erb)
  def add_game
    params[:games][:name].capitalize!
    @newgame = Game.new(game_params)
    @newgame.save
    redirect_to "/profile/#{current_user.id}"
  end

  # create a new report (function on report.html.erb)
  def add_report
    @newreport = Report.new(report_params)
    if @newreport.valid? && Report.where('user_id = ? and game_id = ?',@newreport.user_id , @newreport.game_id).blank?
      @newreport.save
      redirect_to "/profile/#{current_user.id}"
    elsif @newreport.valid?
      redirect_to "/report/#{@newreport.game_id}", alert: "Can't report a game more then once. #{view_context.link_to("View Reports?", "/reportinfo/#{@newreport.game_id}")}"
    else
      redirect_to "/report/#{@newreport.game_id}", alert: "An error occured please try again"
    end
  end

  # create a new rating (function)
  def add_rating
    @rating = Rating.new(rating_params)
    if @rating.valid? && Rating.where('user_id = ? and game_id = ?',@rating.user_id, @rating.game_id).blank?
      @rating.save
      redirect_to "/pages/#{@rating.game_id}"
    elsif @rating.valid? && @rating.score == nil
      redirect_to "/pages/#{@rating.game_id}", notice: "Cannot Rate 0. Try again."
    elsif @rating.valid?
      @updated_rating = Rating.where('user_id = ? and game_id = ?',@rating.user_id, @rating.game_id)
      @updated_rating.update(rating_params)
      redirect_to "/pages/#{@rating.game_id}", notice: "Updated Rating. #{view_context.link_to("View Rating?", "/reportinfo/#{@rating.game_id}#ratings_table")}"
    else
      redirect_to "/pages/#{@rating.game_id}", alert: "Error has occued. Please try again"
    end
  end


  # all params
  def game_params
    params.require(:games).permit(:name, :webpage, :category, :creator, :user_id)
  end

  def report_params
    params.require(:report).permit(:reason, :notes, :user_id, :game_id)
  end

  def rating_params
    params.require(:rating).permit(:score, :comment, :user_id, :game_id)
  end
end
