require './queue'

describe Queue do
  let(:test_queue) { Queue.new('ER', 'Contains all patients presenting to the ER')}

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
    it 'can add an item' do
      pending 'waiting on queue_item class'
      fail
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
