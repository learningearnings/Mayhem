# Spree Checkout Fakery
We want to use spree to manage inventory/products, but our app uses funny money and needs to override checkout.

Ordering a product is a one-step process.  Click a button, order fulfilled.  My plan is as follows:

On button click:
- Create a cart.
- Add the product to the cart.
- Specify my own address bits to handle fulfilment.
- Push the order through all of its state machine, step by step.  I won't skip any, I'll just do them all in one action. (this will be in a plain ol' ruby object that handles all of this)
- Redirect the user to my own 'hey guy good job!' success page.

I will make this happen by decorating the OrdersController#populate method.

Now by default, Spree requires payment for an order (surprisingly).  To get around this, we will decorate the Order#payment_required? method to return false.

GeekOnCoffee has suggested that we might want to actually build a fake PaymentGateway for LE Bucks, as this will make order cancellation awesome among other things.  Here's a bogus gateway example: https://github.com/spree/spree/blob/master/core/app/models/spree/gateway/bogus.rb

I've made one at Spree::Gateways::LearningEarnings that just succeeds all the time for now.  We add that in seeds.
