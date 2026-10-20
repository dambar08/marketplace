require "rails_helper"

RSpec.describe ApplicationHelper do
  it "pluralizes through the helper seam" do
    expect(helper.pluralize(2, "product")).to eq("2 products")
  end
end
