module ApplicationHelper
  def format_money(amount, currency)
    formatted = number_with_precision(amount || 0, precision: 2, delimiter: ",")
    "#{currency} #{formatted}"
  end

  def products_without_variants_hint
    count = @dashboard.products_without_variants_count
    return if count.zero?

    "#{pluralize(count, "product")} without variants"
  end
end
