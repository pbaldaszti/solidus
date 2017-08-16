json.cache! [I18n.locale, shipment] do
  json.(shipment, *shipment_attributes)
  if shipment.selected_shipping_rate
    json.selected_shipping_rate do
      json.partial!("spree/api/shipping_rates/shipping_rate", shipping_rate: shipment.selected_shipping_rate)
    end
  end
  json.inventory_units(shipment.inventory_units) do |inventory_unit|
    json.(inventory_unit, *inventory_unit_attributes)
    json.variant do
      json.partial!("spree/api/variants/small", variant: inventory_unit.variant)
      json.(inventory_unit.variant, :product_id)
      json.images(inventory_unit.variant.images) do |image|
        json.partial!("spree/api/images/image", image: image)
      end
    end
    json.line_item do
      json.(inventory_unit.line_item, *line_item_attributes)
      json.single_display_amount(inventory_unit.line_item.single_display_amount.to_s)
      json.display_amount(inventory_unit.line_item.display_amount.to_s)
      json.total(inventory_unit.line_item.total)
    end
  end
  json.order do
    json.partial!("spree/api/orders/order", order: shipment.order)
    json.bill_address do
      json.partial!("spree/api/addresses/address", address: shipment.order.billing_address)
    end
    json.ship_address do
      json.partial!("spree/api/addresses/address", address: shipment.order.shipping_address)
    end
    json.adjustments(shipment.order.adjustments) do |adjustment|
      json.partial!("spree/api/adjustments/adjustment", adjustment: adjustment)
    end
    json.payments(shipment.order.payments) do |payment|
      json.(payment, :id, :amount, :display_amount, :state)
      json.source do
        attrs = [:id]
        (attrs << :cc_type) if payment.source.respond_to?(:cc_type)
        json.(payment.source, *attrs)
      end
      json.payment_method { json.(payment.payment_method, :id, :name) }
    end
  end
end
