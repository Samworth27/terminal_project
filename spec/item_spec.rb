require './lib/triage/queue_object/item'
require './lib/triage/common'
require './lib/triage/symptoms'


describe Item do
  before (:each) do
    stub_const("Person", Class.new)
  end
  let(:test_item) { Item.new(Symptoms.new(:user),1)}

  it 'can be created' do
    expect(test_item).to exist
  end

  describe '#initialize' do
    describe 'initialises correctly' do
      describe '@id' do
        (1..9).each do |i|
          it "Can init @id correctly attempt #{i}" do
            item_id = Item.count
            expect(test_item.id).to eq(item_id)
          end
        end
      end
      it 'can init @time_presented correctly' do
        current_time = Time.new
        expect(test_item.time_presented-current_time).to be < 10
      end

      it 'can init @symptom_flags correctly' do
        expect(test_item.flags).to eq(0)
      end

      it 'can init @notes correctly' do
        expect(test_item.notes).to eq([])
      end

      it 'can init @priority correctly' do
        expect(test_item.priority).to eq(1)
      end
    end
  end

  describe '#modify' do
    it 'can modify item variable'
  end

  describe '#archive' do
    it 'can archive item'
  end
end
