class User::Request::FindByEmail < Rectify::Query
  def initialize(email)
    @email = email
  end

  def query
    User.where(
      'lower(email) = lower(:email)', email: @email
    ).first
  end
end
