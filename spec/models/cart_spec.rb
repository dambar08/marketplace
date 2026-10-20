require "rails_helper"

RSpec.describe Cart do
  it "prices an added line from the snapshotted unit price" do
    cart = create(:cart)

    cart.add_line(title: "Mug", unit_price: 10, quantity: 2)

    line = cart.line_items.sole
    expect(line.total).to eq(20)
    expect(cart.subtotal).to eq(20)
    expect(cart.total).to eq(20)
  end

  it "keeps the snapshotted unit price when quantity changes" do
    cart = create(:cart)
    cart.add_line(title: "Mug", unit_price: 10, quantity: 1)

    cart.change_line_quantity(cart.line_items.sole, 3)

    line = cart.line_items.sole
    expect(line.unit_price).to eq(10)
    expect(line.total).to eq(30)
    expect(cart.subtotal).to eq(30)
    expect(cart.total).to eq(30)
  end

  it "prices the cart from every line" do
    cart = create(:cart)
    cart.add_line(title: "Mug", unit_price: 10, quantity: 2)
    cart.add_line(title: "Cup", unit_price: 15, quantity: 1)

    expect(cart.line_items.map(&:total)).to contain_exactly(20, 15)
    expect(cart.subtotal).to eq(35)
    expect(cart.total).to eq(35)
  end

  it "drops a removed line from the money picture" do
    cart = create(:cart)
    cart.add_line(title: "Mug", unit_price: 10, quantity: 2)
    cart.add_line(title: "Cup", unit_price: 15, quantity: 1)
    cup = cart.line_items.find_by!(title: "Cup")

    cart.remove_line(cup)

    expect(cart.line_items.map(&:title)).to eq([ "Mug" ])
    expect(cart.subtotal).to eq(20)
    expect(cart.total).to eq(20)
  end

  it "refuses to change a line that is not on the cart" do
    cart = create(:cart)
    other = create(:cart)
    other.add_line(title: "Mug", unit_price: 10, quantity: 1)
    line = other.line_items.sole

    expect { cart.change_line_quantity(line, 4) }.to raise_error(ActiveRecord::RecordNotFound)
    expect(line.reload.quantity).to eq(1)
    expect(other.subtotal).to eq(10)
  end

  it "refuses to remove a line that is not on the cart" do
    cart = create(:cart)
    other = create(:cart)
    other.add_line(title: "Mug", unit_price: 10, quantity: 1)
    line = other.line_items.sole

    expect { cart.remove_line(line) }.to raise_error(ActiveRecord::RecordNotFound)
    expect(other.line_items.map(&:title)).to eq([ "Mug" ])
    expect(other.subtotal).to eq(10)
  end
end
