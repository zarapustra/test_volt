require 'rails_helper'

describe 'Sessions', type: :api do
  let(:params) {
    {user:
       {
         email: 'zarapustra@volt.org',
         password: '12345678'
       }
    }
  }

  it 'POST /sessions/sign_up' do
    post '/api/v1/sessions/sign_up', params, format: :json

    res = Session::SignUp.(email: email, password: password)
    user = res['model']
    expect(user.persisted?).to be_truthy
    expect(user[:email]).to eq(email)
    expect(user[:password]).to be_nil
    expect(BCrypt::Password.new user[:encrypted_password]).to eq(password)
  end

  it 'POST /sessions/sign_in' do
    basic_authorize params[:email], params[:password]

    post '/api/v1/sessions/sign_in', format: :json

    expect(last_response.status).to eql(200)
  end
end
