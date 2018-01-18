class CommentsController < ApplicationController

  def index
    @comments = Comment.all
    respond_to do |format|
      format.json { render json: {comments: @comments}, status: :ok }
      format.html { render html: {comments: @comments}, status: :ok }
    end
  end

  def show
    @comment = Comment.find(params[:id])
    @comment.destroy
      respond_to do |format|
        format.json { render json: {comment: @comment}, status: :ok }
        format.html { redirect_to article_path(@article) }
      end
    rescue ActiveRecord::RecordNotFound
      respond_to do |format|
        format.json { render json: {article: "Comment ID invalid"}}
        format.html { render html: {comment: "error in id"}, status: :unprocessable_entity }
      end
  end
  
 def create
    begin 
      @comment = Comment.create(comment_params)
      @article = Article.find(@comment.article_id)
        if @comment.save
          respond_to do |format|
            format.json { render json: { comment: @comment }, status: :ok }
            format.html { redirect_to article_path(@article) }
          end
        else
          respond_to do |format| 
            format.json { render json: { message: @comment.errors}, status: :unprocessable_entity }
            format.html { render html: {message: @comment.errors}, status: :unprocessable_entity}
          end
        end
    rescue ActiveRecord::RecordNotFound
      respond_to do |format|
        format.json { render json: {article: "Article ID invalid"},status: :unprocessable_entity}
      end  
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
      respond_to do |format|
        format.json { render json: {message: "Deleted"}, status: :ok }
        format.html { redirect_to  request.referrer}
      end
    rescue ActiveRecord::RecordNotFound
      respond_to do |format|
        format.json { render json: {comment: "Comment ID invalid"}}
        format.html { render html: {comment: "error in id"}, status: :unprocessable_entity }
      end
  end
  
  private
    def comment_params
      params.require(:comment).permit(:commenter, :body, :article_id)
    end
end