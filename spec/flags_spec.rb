require './src/flags'

describe 'Flag' do
  let (:test_flags) do
    temp = {}
    0.upto(7) {|i| temp["flag_#{i+1}".to_sym]=2**i}
    temp
  end
  

  it 'can be instansitated' do
    expect(Flags.new('testing')).to exist
  end

  describe '#Class' do
    describe 'initilises correctly' do
      it 'stores flag values once in a class instance variable' do
        test = Flags.new
        expect(test.class.flags).to eq(test_flags)
      end
      it 'will not overwrite class instance variable `flags' do
        test = Flags.new([:bad_1, :bad_2, :bad_3])
        expect(test.class.flags).to eq(test_flags)
      end
    end
    describe 'self.flags' do
      it 'can return flags value' do
        test = Flags.new
        expect(test.class.flags).to eq(test_flags)
      end
      it 'can update flags value' do
        test = Flags.new
        test.class.flags = {nothing: 0}
        expect(test.class.flags).to eq({nothing: 0})
        # Need to rest flags or other tests will fail
        test.class.flags = test_flags
      end
    end
  end


  describe '#initilize' do
    it 'can create method calls for each flag' do
      test_flags.each do |flag, _value|
        expect(Flags.new.public_send(flag)).to eq(false)
      end
    end
  end
end