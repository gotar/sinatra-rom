require_relative '../../../../apps/api/models/product'

describe API::Product do
  it 'allows to set valid params' do
    p = API::Product.new(base_params)

    expect(p.name).to eq(base_params[:name])
  end

  it 'coerce params to proper type' do
    p = API::Product.new(name: :foo)

    expect(p.name).to eq('foo')
  end

  it 'ignores non valid params' do
    p = API::Product.new(base_params(foo: 'bar'))

    expect{ p.foo }.to raise_error(NoMethodError)
  end

  private
  def base_params(params={})
    {
      name: 'NAME'
    }.merge(params)
  end
end
