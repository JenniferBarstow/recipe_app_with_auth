require 'rails_helper'

RSpec.describe Recipe, type: :model do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:ingredients) }
  it { should validate_presence_of(:instructions) }
end
