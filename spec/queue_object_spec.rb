require './lib/triage/queue_object'
require './lib/triage/symptoms'
require './lib/triage/flags'


# Testing for QueueObject
describe QueueObject do
  let(:time) {Time.new.strftime("%H%M")}
  let(:database) {Symptoms.new(:user)}
  let(:test_queue) {QueueObject.new('test-name','test-desc',database)}

  it 'can be created' do
    expect(test_queue).to exist
  end

  it 'can return a formatted list of items in the queue' do
    test_queue.queue
  end

  it 'can add items to its queue' do
    test_queue.add_item(3)
    expect(test_queue.size).to eq(1)
  end

  it 'can return a list queue items' do
    test_queue.add_item(1)
    id = test_queue[0].id
    expect(test_queue.queue).to eq(["Position in Queue: 0\n ID: #{id}\n Priority: 1\n Time presented: #{time}\n"])
  end

  it 'can return a queue item' do
    test_queue.add_item(2)
    id = test_queue[0].id
    expect(test_queue.view_item(id)).to be_an(Item)
  end

  it 'can return next queue item' do
    test_queue.add_item(3)
    test_queue.add_item(2)
    test_queue.add_item(1)
    test_pri = 1
    while(test_queue.size > 0) do
      item = test_queue.next_item
      # expect(item).to eq('')
      expect(item).to be_an(Item)
      expect(item.priority).to eq(test_pri)
      test_pri += 1
    end
  end
end