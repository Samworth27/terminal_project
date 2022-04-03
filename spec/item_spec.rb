require './lib/triage/dynamic_queue/item'
require './lib/triage/common'
require './lib/triage/symptoms'


describe 'Item Class' do
  before (:each) do
    stub_const("Person", Class.new)
  end
  let(:test_item) { Item.new(Symptoms.new(:user),1)}

  context 'when it is created' do
    it 'can be instantiated without error' do
      expect(test_item).to exist
    end

    it 'can store the time it was created' do
      current_time = Time.new
      expect(test_item.time_presented-current_time).to be < 10
    end

    describe 'multiple instances can be instantiated' do
      (1..9).each do |i|
        it "can assign a unique ID to itself. Attempt #{i}" do
          item_id = Item.count
          expect(test_item.id).to eq(item_id)
        end
      end
    end
  end

  context 'when it needs to be modified' do
    it 'can modify item variable'
  end

  describe 'when it needs to be archived' do
    it 'can archive item'
  end
end
