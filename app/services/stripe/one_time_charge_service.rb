module Stripe
  class OneTimeChargeService
    attr_reader :product_name, :value, :success_url, :policy_id

    def initialize(policy_id, product_name = nil, value = nil, success_url = nil)
      @policy_id = policy_id
      @product_name = product_name || 'Generic policy'
      @value = value || 1000
      @success_url = success_url || "#{ENV['APPWEB']}success_payment"
    end

    def self.create_checkout(policy_id, **kwargs)
      new(policy_id, **kwargs).create_checkout
    end

    def create_checkout
      checkout = generate_checkout

      return false unless checkout

      Payment.create!(
        policy_id: policy_id,
        external_id: checkout.id,
        link: checkout.url,
        price: checkout.amount_total
      )
    end

    private

    def selected_product
      products = Stripe::Product.search({
        query: "active:\'true\' AND name:\'#{product_name}\'",
      })

      products.first
    end

    def new_price
      if selected_product
        new_price = Stripe::Price.create(
          product: selected_product.id,
          unit_amount: value,
          currency: 'brl',
        )
      end
    end

    def generate_checkout
      if new_price
        Stripe::Checkout::Session.create({
          payment_method_types: ['card'],
          success_url: success_url,
          line_items: [{
            price: new_price,
            quantity: 1,
          }],
          mode: 'payment'
        })
      end
    end
  end
end
