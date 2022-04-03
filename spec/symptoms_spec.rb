require './lib/triage/symptoms'

describe 'Symptoms Class' do
  let(:symptoms){Symtpoms.new(:user)}
  describe 'what it can do' do
    it 'can call build method' do
      defined?(symptoms.build)
    end
    it 'can call browse method' do
      defined?(symptoms.browse)
    end
    it 'can call search method' do
      defined?(symptoms.search)
    end
  end
end