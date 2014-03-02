class IdeasController < ApplicationController
  def index
    @ideas = Idea.top_level.order('created_at ASC')
  end

  def show
    @idea = Idea.find(params[:id])
  end

  def create
    @idea = Idea.create(idea_params)
    redirect_to_top_level
  end

  def destroy
    Idea.destroy(params[:id])
    redirect_to_top_level
  end

  private

  def idea_params
    params.require(:idea).permit(:parent_id, :content)
  end

  def redirect_to_top_level
    redirect_to idea_path(params.require(:top_level_id))
  end
end
