require './lib/triage/queue_object/item'

describe Item do
  let(:test_item) { Item.new({fname: 'John', lname: 'Smith'})}
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
      describe '@name' do
        it 'can init @fname correctly' do
          expect(test_item.fname).to eq('John')
        end
        it 'can init @lname correctly' do
          expect(test_item.lname).to eq('Smith')
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
        expect(test_item.priority).to eq(3)
      end
    end
  end

  describe '#modify' do
    it 'can modify item variable'
  end
end
