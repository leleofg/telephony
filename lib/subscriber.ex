defmodule Subscriber do
  @moduledoc """
    Subscriber module to create subscriber with plan, like `prepaid` and `postpaid`

    The most used function is `create/4`
  """

  defstruct name: nil, age: nil, document_number: nil, plan: nil

  @subscribers %{:prepaid => "prepaid.txt", :postpaid => "postpaid.txt"}

  @doc """
    Function to create a subscriber, using a plan with `prepaid` and `postpaid`

  ## Parameters

    - name: subscriber name
    - age: subscriber age
    - document_number: subscriber document_number
    - plan: optional - default: `prepaid`

  ## Example

      iex> Subscriber.create("Leo", 27, "123")
      {:ok, "Subscriber Leo created successfully!"}

  """
  def create(name, age, document_number, plan \\ :prepaid) do

    case find_by_document_number(document_number) do
      nil ->
        read_file(plan) ++ [%__MODULE__{name: name, age: age, document_number: document_number, plan: plan}]
        |> :erlang.term_to_binary()
        |> write_file(plan)
        {:ok, "Subscriber #{name} created successfully!"}
      _sub -> {:error, "Subscriber already exists!"}
    end
  end

  @doc """
    Function to get a subscriber by document_number

  ## Parameters

    - document_number: subscriber document_number
    - plan: optional - default: `all`

  """
  def find_by_document_number(document_number, plan \\ :all), do: find(document_number, plan)

  defp find(document_number, :prepaid), do: filter(get_subscribers(:prepaid), document_number)
  defp find(document_number, :postpaid), do: filter(get_subscribers(:postpaid), document_number)
  defp find(document_number, :all), do: filter(get_subscribers(:all), document_number)

  defp get_subscribers(plan) do
    case plan do
      :all -> read_file(:prepaid) ++ read_file(:postpaid)
      _ -> read_file(plan)
    end
  end

  defp filter(list, document_number), do: Enum.find(list, &(&1.document_number == document_number))

  defp read_file(plan) do
    case File.read(@subscribers[plan]) do
      { :ok, content } -> content |> :erlang.binary_to_term()
      { :error, _reason} -> []
    end
  end

  defp write_file(content, plan) do
    File.write(@subscribers[plan], content)
  end
end
