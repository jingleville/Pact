require 'rails_helper'

RSpec.describe User, type: :model do
  it 'returns the full name' do
    user = User.new(name: 'John', surname: 'Doe', patronymic: 'Smith')
    expect(user.full_name).to eq('Doe John Smith')
  end

  it 'has many interests' do
    t = User.reflect_on_association(:interests)
    expect(t.macro).to eq(:has_many)
  end

  it 'has many skills' do
    t = User.reflect_on_association(:skills)
    expect(t.macro).to eq(:has_many)
  end
end