module IdeasHelper
  def render_idea(idea)
    render('idea', locals: { idea: idea })
  end
end
