require 'spec_helper'

describe Idea do
  it { should have_many :children }
  it { should belong_to :parent }
  it { should validate_presence_of :content }
end
