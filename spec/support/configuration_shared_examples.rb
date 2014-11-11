shared_examples_for 'a configuration setting' do |setting_name, default_value|
  describe "##{setting_name}" do
    it "default value is #{default_value}" do
      expect(subject.send(setting_name)).to eql default_value
    end
  end

  describe "##{setting_name}=" do
    it 'can set value' do
      subject.send("#{setting_name}=", 'something')

      expect(subject.send(setting_name)).to eql 'something'
    end
  end
end

shared_examples_for 'a required configuration setting' do |setting_name|
  describe "##{setting_name}" do
    context 'when the config is set' do
      before { subject.send("#{setting_name}=", 'something') }

      it 'should return the config value' do
        expect(subject.send(setting_name)).to eql 'something'
      end
    end

    context 'when the config is not set' do
      it 'should raise MissingConfigurationError' do
        expect{ subject.send(setting_name) }.
          to raise_error(Ht::SearchClient::Configuration::MissingConfigurationError)
      end
    end
  end
end
