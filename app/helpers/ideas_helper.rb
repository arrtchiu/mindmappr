module IdeasHelper
  def render_idea(idea)
    render('idea', locals: { idea: idea })
  end

  def render_idea_children(idea)
    render('idea_children', locals: { idea: idea })
  end
end
