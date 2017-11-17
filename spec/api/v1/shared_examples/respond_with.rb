shared_examples 'respond with' do |code|
  it "code #{code}" do
    expect(last_response.status).to eq(code)
  end
end
