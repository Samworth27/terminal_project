require './lib/triage/dynamic_queue'
require './lib/triage/symptoms'
require './lib/triage/flags'


# Testing for DynamicQueue
describe 'DynamicQueue' do
  let(:time) {Time.new.strftime("%H%M")}
  let(:database) {Symptoms.new(:user)}
  let(:test_queue) {DynamicQueue.new('test-name','test-desc',database)}

  context '#initilization' do
    it 'can be initilized' do
      expect(test_queue).to exist
    end
  end

  context '#add_item' do
    it 'can add items to its queue' do
      test_queue.add_item(3)
      expect(test_queue.size).to eq(1)
    end
    it 'can place items in the correct place in the queue' do
      # Can pass, just needs a test to prove
    end
  end

  context 'when information is requested' do
    it 'can return a formatted list of items in the queue' do
      test_queue.queue
    end
    it 'can return a list queue items' do
      test_queue.add_item(1)
      id = test_queue[0].id
      expect(test_queue.queue).to eq(["Position in DynamicQueue: 0\n ID: #{id}\n Priority: 1\n Time presented: #{time}\n"])
    end
    it 'can return a specific queue item' do
      test_queue.add_item(2)
      id = test_queue[0].id
      expect(test_queue.view_item(id)).to be_an(Item)
    end
  end

  context 'when the next queue item is requested' do
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
end