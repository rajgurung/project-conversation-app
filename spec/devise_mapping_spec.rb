require 'rails_helper'

RSpec.describe 'Devise mapping', type: :request do
  it "has the user mapping loaded" do
    expect(Devise.mappings[:user]).to be_present
  end
end
