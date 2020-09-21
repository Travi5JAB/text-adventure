class PagesController < ApplicationController
  skip_before_action :verify_authenticity_token

  # playhistory.html.erb
  def playhistory
    @my_games = Game.where('creator' => current_user.username)
    @play_history = [1]
  end

  # profile.html.erb profile pages
  def profile
    @user = User.find(params[:id])
    @my_games = Game.where('creator' => @user.username)
    @use = @my_games.includes(:reports, :ratings)

    # all reports for the user
    @total_reports = []
    Report.find_each do |report|
      Game.find_each do |game|
        if report.game_id == game.id && game.user_id == @user.id
          @total_reports << report
        end
      end
    end

    # all ratings for the user
    @total_ratings = []
    Rating.find_each do |rating|
      if rating.user_id == @user.id
        @total_ratings << rating.score
      end
    end
    @all_game_avg = @total_ratings.sum.to_f/@total_ratings.length

    # rating each game
    # @game_ratings = []
    # Rating.find_each do |rating|
    #   Game.find_each do |game|
    #     if rating.game_id == game.id && @my_games.any?{ |v| v[:user_id] == game.user_id }
    #       @game_ratings << rating
    #     end
    #   end
    # end
    # @avg = @game_ratings.sum/@game_ratings.length
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
    @avg = @total_ratings.sum/@total_ratings.length
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
    elsif @rating.valid?
      redirect_to "/pages/#{@rating.game_id}", alert: "Can't Rate a Game More then Once"
    else
      redirect_to "/pages/#{@rating.game_id}", alert: "Error has occued. Please try again"
    end
    # render "show"
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
