require_relative '../../../../apps/api/models/user'

describe API::User do
  it 'allows to set valid params' do
    p = API::User.new(base_params)

    expect(p.email).to eq(base_params[:email])
  end

  it 'coerce params to proper type' do
    p = API::User.new(email: :'example@example.com')

    expect(p.email).to eq('example@example.com')
  end

  it 'ignores non valid params' do
    p = API::User.new(base_params(foo: 'bar'))

    expect{ p.foo }.to raise_error(NoMethodError)
  end

  it 'encrypt password' do
    p = API::User.new(base_params(password: 'password'))

    expect(p.password).to_not be('password')
    expect(p.password).to eq('password')
  end

  it 'generate random token' do
    p = API::User.new(base_params)

    expect(p.token).to_not be_nil
  end

  private
  def base_params(params={})
    {
      email: 'example@example.com'
    }.merge(params)
  end
end
