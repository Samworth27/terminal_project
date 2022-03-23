require './queue'

describe Queue do
  it 'can be created' do
    test_queue = Queue.new
    expect(test_queue).to exist
  end
end
