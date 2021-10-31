defmodule Telephony do
  def create_subscriber(name, age, document_number, plan) do
    Subscriber.create(name, age, document_number, plan)
  end
end
