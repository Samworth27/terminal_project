require './queue_object'
require './item'

# Testing for QueueObject
describe QueueObject do
  let(:empty_queue) { QueueObject.new('empty queue', 'Contains an empty queue object') }
  let(:john_smith) { Item.new({fname: 'John', lname: 'Smith' }) }
  let(:jane_doe) { Item.new({fname: 'Jane', lname: 'Doe' }) }
  let!(:test_queue) do
    temp = QueueObject.new('test_queue', 'contains two members; John Smith and Jane Doe')
    temp.add_item(john_smith)
    temp.add_item(jane_doe)
    temp
  end

  it 'can be created' do
    expect(empty_queue).to exist
  end

  describe '#initialize' do
    describe ' initialises correctly' do
      it 'sets queue name correctly' do
        expect(empty_queue.name).to eq('empty queue')
      end
      it 'sets queue description correctly' do
        expect(empty_queue.description).to eq('Contains an empty queue object')
      end
      it 'initialises an empty queue' do
        expect(empty_queue.queue).to eq({})
      end
    end
  end

  describe '#add_item' do
    it 'accepts valid input' do
      empty_queue.add_item(john_smith)
      expect(empty_queue.queue.length).to eq(1)
      empty_queue.add_item(jane_doe)
      expect(empty_queue.queue.length).to eq(2)
    end
    it 'rejects invalid output' do
      expect { empty_queue.add_item(1)}.to raise_error(InvalidInput)
    end
  end

  describe '#view_item' do
    it 'can view an item' do
      p test_queue.queue[28].fname
    end
  end

  describe '#modify_item' do
    it 'can modify item'
  end

  describe '#delete_item' do
    it 'can delete item'
  end

  describe '#next_item' do
    it 'returns the next item in the queue'
  end
end