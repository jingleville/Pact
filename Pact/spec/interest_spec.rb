require 'rails_helper'

RSpec.describe Interest, type: :model do
  it 'has many user_interests' do
    t = Interest.reflect_on_association(:user_interests)
    expect(t.macro).to eq(:has_many)
  end

  it 'has many users through user_interests' do
    t = Interest.reflect_on_association(:users)
    expect(t.macro).to eq(:has_many)
  end
end