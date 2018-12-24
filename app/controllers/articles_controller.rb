require "twitter"

class ArticlesController < ApplicationController
  before_action :set_article, only: [:show, :edit, :update, :destroy]
  before_action :twitter_client, except: :new
  def twitter_client
    @client = Twitter::REST::Client.new do |config|
      config.consumer_key = ENV['CONSUMER_KEY']
      config.consumer_secret = ENV['CONSUMER_SECRET']
      config.access_token = ENV['ACCESS_TOKEN']
      config.access_token_secret = ENV['ACCESS_TOKEN_SECRET']
    end
  end

  # GET /articles
  # GET /articles.json
  def index
    @articles = Article.all
  end

  # GET /articles/1
  # GET /articles/1.json
  def show
  end

  # GET /articles/new
  def new
    @article = Article.new
  end

  # GET /articles/1/edit
  def edit
  end

  # POST /articles
  # POST /articles.json
  def create
    @article = Article.new(article_params)

    respond_to do |format|
      if @article.save
        format.html { redirect_to @article, notice: 'Article was successfully created.' }
        format.json { render :show, status: :created, location: @article }
      else
        format.html { render :new }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /articles/1
  # PATCH/PUT /articles/1.json
  def update
    tweet_delete
    respond_to do |format|
      if @article.update(article_params)
        format.html { redirect_to @article, notice: 'Article was successfully updated.' }
        format.json { render :show, status: :ok, location: @article }
      else
        format.html { render :edit }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  def post
    tweet_options = Article.where(url: nil)
    if tweet_options.size != 0
      tweet = tweet_options.shuffle.first
      status = tweet.content
      @client.update(status)
      tw = @client.user_timeline(screen_name: "shikai_shosetsu", count: 1)
      tweet.url = tw[0].id.to_s
    else
      tweet = Article.where( 'id >= ?', rand(Article.first.id..Article.last.id) ).first
      if tweet.rtid.present?
        @client.unretweet(tweet.rtid.to_i)
        @client.retweet(tweet.url.to_i)
        tw = @client.user_timeline(screen_name: "shikai_shosetsu", count: 1)
        tweet.rtid = tw[0].id.to_s
      else
        @client.retweet(tweet.url.to_i)
        tw = @client.user_timeline(screen_name: "shikai_shosetsu", count: 1)
        tweet.rtid = tw[0].id.to_s
      end
    end
    tweet.save
    redirect_to :root
  end

  # DELETE /articles/1
  # DELETE /articles/1.json
  def destroy
    @article = Article.find(params[:id])
    tweet_delete
    @article.destroy
    respond_to do |format|
      format.html { redirect_to articles_url, notice: 'Article was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_article
      @article = Article.find(params[:id])
    end
    def tweet_delete
      if @article.url.present?
        @client.destroy_status(@article.url.to_i)
        @article.url = nil
        @article.rtid = nil
        @article.save
      end
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def article_params
      params.require(:article).permit(:content, :url, :rtid)
    end
end
