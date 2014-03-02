require 'spec_helper'

describe Realtime do
  let!(:obj) do
    double(:model,
      id: 888,
      serializable_hash: {test_case: true})
  end

  let(:expected_channel) { 'mock:test' }
  let(:expected_json) do
    {
      op: expected_op,
      path: '/test/path',
      value: { test_case: true }
    }.to_json
  end

  def notifies_redis_with_the_correct_data
    Redis.any_instance.should_receive(:publish) do |channel, message|
      channel.should eq expected_channel
      message.should be_json_eql expected_json
    end
    
    Realtime.send(method, expected_channel, obj, '/test/path')
  end

  describe :created do
    let(:expected_op) { 'add' }
    let(:method) { :created }
    it { notifies_redis_with_the_correct_data }
  end

  describe :destroyed do
    let(:expected_op) { 'remove' }
    let(:method) { :destroyed }
    it { notifies_redis_with_the_correct_data }
  end
end
