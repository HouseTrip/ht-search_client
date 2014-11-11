shared_examples_for 'error handling' do
  it 'notifies EXCEPTION_HANDLER' do
    response_expectation = response ? an_instance_of(Faraday::Response) : nil

    expect(Ht::SearchClient.exception_handler).to receive(:notify).
      with(an_instance_of(error_class), an_instance_of(Hash), response_expectation)

    perform
  end

  it 'notifies MONITOR' do
    expect(monitor).to receive(:notify).with('attempts').ordered
    expect(monitor).to receive(:notify).with('errors').ordered

    expect { perform }.to raise_error(error_class)
  end
end
