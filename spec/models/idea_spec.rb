require 'spec_helper'

describe Idea do
  it { should have_many :children }
  it { should belong_to :parent }
  it { should validate_presence_of :content }

  describe :top_level do
    let!(:idea) { create :idea, parent: nil }
    let!(:child) { create :idea, parent: idea }

    subject { Idea.top_level }

    it { should include idea }
    it { should_not include child }
  end
end
