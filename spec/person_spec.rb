require './lib/triage/queue_object/item/person'

describe Person do
  it 'is defined' do
    expect(Person.exists?).to eq(true)
  end
  # All collect methods inputs are validated on the fly. Currently there
  # no way for these methods to fail.
  # All information collected is purely for read only
end