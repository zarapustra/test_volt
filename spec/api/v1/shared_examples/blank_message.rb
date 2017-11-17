shared_examples 'renders blank message' do |sym|
  it do
    expect(json[:errors][sym]).to eq(['can\'t be blank'])
  end
end

