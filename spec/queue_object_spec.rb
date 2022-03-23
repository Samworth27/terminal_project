require './queue_object'
require './item'
describe QueueObject do
  let(:test_queue) { QueueObject.new('ER', 'Contains all patients presenting to the ER') }
  let(:john_smith) { Item.new({fname: 'John', lname: 'Smith' }) }
  let(:jane_doe) { Item.new({fname: 'Jane', lname: 'Doe' }) }

  it 'can be created' do
    expect(test_queue).to exist
  end

  describe '#initialize' do
    describe ' initialises correctly' do
      it 'sets queue name correctly' do
        expect(test_queue.name).to eq('ER')
      end
      it 'sets queue description correctly' do
        expect(test_queue.description).to eq('Contains all patients presenting to the ER')
      end
      it 'initialises an empty queue' do
        expect(test_queue.queue).to eq([])
      end
    end
  end

  describe '#add_item' do
    it 'accepts valid input' do
      test_queue.add_item(john_smith)
      expect(test_queue.queue.length).to eq(1)
      test_queue.add_item(jane_doe)
      expect(test_queue.queue.length).to eq(2)
    end
    it 'rejects invalid output' do
      expect { test_queue.add_item(1)}.to raise_error(InvalidInput)
    end
  end

  describe '#view_item' do
    it 'can view an item' do
      pending 'waiting on queue_item class'
      fail
    end
  end
  
  describe '#modify_item' do
    it 'can modify item' do
      pending 'waiting on queue_item class'
      fail
    end
  end

  describe '#delete_item' do
    it 'can delete item' do
      pending('waiting on queue_item class')
      fail
    end
  end

  describe '#next_item' do
    it 'returns the next item in the queue' do
      pending('waiting on queue_item class')
      fail
    end
  end
end
