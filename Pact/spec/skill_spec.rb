require 'rails_helper'

RSpec.describe Skill, type: :model do
  it 'has many user_interests' do
    t = Skill.reflect_on_association(:user_skills)
    expect(t.macro).to eq(:has_many)
  end

  it 'has many users through user_interests' do
    t = Skill.reflect_on_association(:users)
    expect(t.macro).to eq(:has_many)
  end
end