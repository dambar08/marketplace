require "rails_helper"

RSpec.describe AdminPolicy do
  it "allows admins" do
    expect(described_class.new(User.new(admin: true), :admin).access?).to be(true)
  end

  it "denies everyone else" do
    expect(described_class.new(User.new(admin: false), :admin).access?).to be(false)
    expect(described_class.new(nil, :admin).access?).to be(false)
  end
end
