module Auth
  class AuthenticateUser < Rectify::Command
    def initialize(params = {})
      @params = params
    end

    def call
      return broadcast(:error, form.errors) unless user || form.valid?
      if token
        broadcast(:ok, token)
      else
        broadcast(:error, 'Problem with encrypting token')
      end
    end

    private

    attr_reader :params

    def user
      @_user ||= User.find_by(email: params[:email])
    end

    def form
      @_form ||= User::AuthForm.from_params(params).with_context(user: user)
    end

    def token
      @_token ||= JsonWebToken.encode(user_id: user.id)
    end
  end
end
