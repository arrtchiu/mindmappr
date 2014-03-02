class IdeasController < ApplicationController
  before_action :find_idea, only: [:show, :destroy]
  before_action :find_top_level_idea, only: [:create, :destroy]

  def index
    @ideas = Idea.top_level.order('created_at ASC')
  end

  def show
  end

  def create
    @idea = Idea.new(idea_params)

    Realtime.created(idea_context, @idea, idea_path(@idea)) if @idea.save

    redirect_to_top_level
  end

  def destroy
    @idea.destroy

    Realtime.destroyed(idea_context, @idea, idea_path(@idea))

    redirect_to_top_level
  end

  private

  def find_idea
    @idea = Idea.find(params[:id])
  end

  def find_top_level_idea
    @top_level_idea = Idea.find(params[:top_level_id])
  end

  def idea_params
    params.require(:idea).permit(:parent_id, :content)
  end

  def redirect_to_top_level
    redirect_to idea_path(params[:top_level_id])
  end

  def idea_context
    'idea:' + @top_level_idea.to_param
  end
end
