shared_examples 'renders invalid message' do |sym|
  it do
    expect(json[:errors][sym]).to eq(['invalid'])
  end
end

