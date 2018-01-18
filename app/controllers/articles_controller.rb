class ArticlesController < ApplicationController
  
	def index
		@articles = Article.all
	end

  def show
    respond_to do |format|
      begin
        @article = Article.find(params[:id])
        format.json { render json: {article: @article}, status: :ok }
        format.html { @article = Article.find(params[:id])}
      rescue => e
        format.json { render json: {error: e.message}, status: :unprocessable_entity }
        format.html { render html: {error: e.message}, status: :unprocessable_entity }
      end
    end
  end

	def new
		@article = Article.new
	end

	def edit
    respond_to do |format|
      begin @article = Article.find(params[:id])
        format.html { @article = Article.find(params[:id]) }
        format.json { render json: {article: @article}, status: :ok }
      rescue => e
        format.json { render json: {error: e.message}, status: :unprocessable_entity }
        format.html { render html: {error: e.message}, status: :unprocessable_entity }
      end
    end 
  end

	def create
		@article = Article.new(article_params)
		if @article.save
      respond_to do |format|
        format.json { render json: {article: @article}, status: :ok }
        format.html { redirect_to @article }
      end
    else
      respond_to do |format|
        format.json { render json: {article: @article.errors}, status: :unprocessable_entity }
        format.html { render 'new' }
      end
    end
	end

	def update
    respond_to do |format|
      begin
        @article = Article.find(params[:id])
        @article.update(article_params)
        format.json { render json: {article: @article}, status: :ok }
        format.html { redirect_to @article }
      rescue => e
        format.json { render json: {error: e.message}, status: :unprocessable_entity }
        format.html { render html: {error: e.message}, status: :unprocessable_entity }
      end
    end
  end

	def destroy
		respond_to do |format|
    	begin @article = Article.find(params[:id])
     		@article.destroy
        format.json { render json: {message: "Deleted"}, status: :ok }
       	format.html { redirect_to articles_path }
      rescue => e
        format.json { render json: {error: e.message}, status: :unprocessable_entity }
        format.html { render html: {error: e.message}, status: :unprocessable_entity }
    	end
  	end
	end

	private
	  def article_params
	    params.require(:article).permit(:title, :text)
	  end
end
