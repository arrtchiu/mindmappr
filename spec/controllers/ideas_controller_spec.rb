require 'spec_helper'

describe IdeasController do
  it { should route(:get, '/ideas').to(controller: :ideas, action: :index) }
  it { should route(:get, '/ideas/2').to(controller: :ideas, action: :show, id: '2') }
  it { should route(:post, '/ideas').to(controller: :ideas, action: :create) }
  it { should route(:delete, '/ideas/3').to(controller: :ideas, action: :destroy, id: '3') }

  describe :index do
    let!(:mock_rel) { double(:relation) }
    let!(:mock_ideas) { double(:ideas) } 

    before do
      Idea.should_receive(:top_level).and_return(mock_rel)
      mock_rel.should_receive(:order).with('created_at ASC').and_return(mock_ideas)
      get :index
    end

    it { should render_template :index }
    it { should respond_with :ok }
    it { assigns(:ideas).should be mock_ideas }
  end

  describe :show do
    let!(:mock_idea) { double(:idea) }

    before do
      Idea.should_receive(:find).with('2').and_return(mock_idea)
      get :show, id: '2'
    end

    it { should render_template :show }
    it { should respond_with :ok }
    it { assigns(:idea).should be mock_idea }
  end

  describe :create do
    let!(:mock_idea) { double(:idea) }
    let!(:model_params) { { 'content' => 'blah', 'parent_id' => '23' } }

    before do
      Idea.should_receive(:create).with(model_params).and_return(mock_idea)
      post :create, { 'idea' => model_params, 'top_level_id' => '1234' }
    end

    it { should redirect_to idea_path(1234) }
  end

  describe :destroy do
    before do
      Idea.should_receive(:destroy).with('5')
      post :destroy, { 'id' => '5', 'top_level_id' => '987654' }
    end

    it { should redirect_to idea_path(987654) }
  end
end
