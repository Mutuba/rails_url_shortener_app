module Taggable
  extend ActiveSupport::Concern

  included do
    has_many :tags, as: :taggable, dependent: :destroy
  end
end


# # app/jobs/process_payment_job.rb
# class ProcessPaymentJob
#   include Sidekiq::Worker

#   def perform(order_id, user_id, gateway)
#     # Use Redis for locking to ensure only one job processes the payment at a time
#     lock_key = "payment_lock_#{order_id}"

#     # Attempt to acquire a lock, and proceed only if the lock is obtained
#     if Redis.current.setnx(lock_key, 'locked')
#       begin
#         # Set an expiration for the lock (e.g., 5 minutes)
#         # Redis.current.expire(lock_key, 5 * 60)

#         # Call the PaymentProcessor to process the payment
#         idempotency_key = "idempotency_#{order_id}" # Generate or fetch idempotency key as needed
#         payment_result = PaymentProcessor.process(order_id, user_id, gateway, idempotency_key: idempotency_key)

#         # Log or handle the payment result as needed
#         Rails.logger.info(payment_result)
#       ensure
#         # Release the lock when the job completes (either successfully or with an error)
#         Redis.current.del(lock_key)
#       end
#     else
#       # Log that the job is skipped because another job is already processing the payment
#       Rails.logger.info("Payment processing for order #{order_id} is already in progress.")
#     end
#   end
# end

# # app/payment_processor.rb
# class PaymentProcessor
#   def self.process(order_id, user_id, gateway)
#     # Use the appropriate payment gateway based on the user's choice
#     gateway_instance = gateway_class(gateway).new(order_id, user_id)

#     # Perform the payment processing logic using the selected gateway
#     payment_result = gateway_instance.process_payment

#     # Return the payment result
#     payment_result
#   end

#   private

#   def self.gateway_class(gateway)
#     case gateway
#     when 'stripe'
#       StripeGateway
#     when 'paypal'
#       PaypalGateway
#     # Add more gateways as needed
#     else
#       raise ArgumentError, "Invalid gateway: #{gateway}"
#     end
#   end
# end


# # Define a common interface for payment gateways
# class BaseGateway
#   def initialize(order_id, user_id)
#     @order_id = order_id
#     @user_id = user_id
#   end

#   def process_payment
#     raise NotImplementedError, 'Subclasses must implement this method'
#   end
# end

# # Example implementation for the Stripe gateway
# class StripeGateway < BaseGateway
#   def process_payment
#     # Implement Stripe-specific payment logic here
#     # ...

#     # Return the payment result
#     { success: payment_successful?, message: 'Stripe payment processed successfully' }
#   end

#   private

#   def payment_successful?
#     # Implement Stripe-specific success logic here
#     # For demonstration purposes, always return true
#     true
#   end
# end

# # Example implementation for the Paypal gateway
# class PaypalGateway < BaseGateway
#   def process_payment
#     # Implement Paypal-specific payment logic here
#     # ...

#     # Return the payment result
#     { success: payment_successful?, message: 'Paypal payment processed successfully' }
#   end

#   private

#   def payment_successful?
#     # Implement Paypal-specific success logic here
#     # For demonstration purposes, always return true
#     true
#   end
# end