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
    let!(:mock_idea) { double(:idea, id: 555888) }
    let!(:mock_top_level_idea) { double(:idea, to_param: '1234') }
    let!(:model_params) { { 'content' => 'blah', 'parent_id' => '23' } }

    before do
      Idea.should_receive(:find).with('1234').and_return(mock_top_level_idea)
      Idea.should_receive(:new).with(model_params).and_return(mock_idea)
    end

    subject do
      post :create, { 'idea' => model_params, 'top_level_id' => '1234' }
    end

    describe :success do
      before do
        mock_idea.stub(:save).and_return(true)
        Realtime.should_receive(:created)
          .with('idea:1234', mock_idea, idea_path(mock_idea))
      end

      it { should redirect_to idea_path(1234) }
    end

    describe :failure do
      before do
        mock_idea.stub(:save).and_return(false)
        Realtime.should_not_receive(:created)
      end

      it { should redirect_to idea_path(1234) }
    end
  end

  describe :destroy do
    let!(:mock_idea) { double(:idea) }
    let!(:mock_top_level_idea) { double(:idea, to_param: '987654') }

    before do
      # Find handles case of not found by raising ActiveRecord::RecordNotFound
      Idea.should_receive(:find).with('5').and_return(mock_idea)
      Idea.should_receive(:find).with('987654').and_return(mock_top_level_idea)
      mock_idea.should_receive(:destroy)
      Realtime.should_receive(:destroyed)
        .with('idea:987654', mock_idea, idea_path(mock_idea))
    end

    subject do
      post :destroy, { 'id' => '5', 'top_level_id' => '987654' }
    end

    it { should redirect_to idea_path(987654) }
  end
end
