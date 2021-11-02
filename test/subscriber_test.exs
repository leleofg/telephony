defmodule SubscriberTest do
  use ExUnit.Case
  doctest Subscriber

  setup do
    File.write("prepaid.txt", :erlang.term_to_binary([]))
    File.write("postpaid.txt", :erlang.term_to_binary([]))

    on_exit(fn ->
      File.rm("prepaid.txt")
      File.rm("postpaid.txt")
    end)
  end

  test "should return a struct of subscriber" do
    assert %Subscriber{name: "Leo", age: 27, document_number: "123", plan: :prepaid}.name == "Leo"
  end

  test "should create an account prepaid with default param" do
    assert Subscriber.create("Leonardo", 27, "12345678912") == {:ok, "Subscriber Leonardo created successfully!"}
  end

  test "should create an account prepaid" do
    assert Subscriber.create("Leonardo", 27, "12345678912", :prepaid) == {:ok, "Subscriber Leonardo created successfully!"}
  end

  test "should create an account postpaid" do
    assert Subscriber.create("Leonardo", 27, "12345678912", :postpaid) == {:ok, "Subscriber Leonardo created successfully!"}
  end

  test "should return an error when a subscriber is already registered" do
    Subscriber.create("Leonardo", 27, "12345678912")
    assert Subscriber.create("Leonardo", 27, "12345678912") == {:error, "Subscriber already exists!"}
  end

  test "should return a subscriber when create with plan postpaid" do
    Subscriber.create("Leonardo", 27, "12345678912", :postpaid)
    assert Subscriber.find_by_document_number("12345678912", :postpaid).name == "Leonardo"
  end

  test "should return a subscriber when create with plan prepaid" do
    Subscriber.create("Leonardo", 27, "12345678912", :prepaid)
    assert Subscriber.find_by_document_number("12345678912", :prepaid).name == "Leonardo"
  end
end
