defmodule Subscriber do
  defstruct name: nil, age: nil, document_number: nil, plan: nil

  @subscribers %{:prepaid => "prepaid.txt", :postpaid => "postpaid.txt"}

  def find_by_document_number(document_number, type \\ :all), do: find(document_number, type)

  defp find(document_number, :prepaid), do: filter(get_subscribers(:prepaid), document_number)
  defp find(document_number, :postpaid), do: filter(get_subscribers(:postpaid), document_number)
  defp find(document_number, :all), do: filter(get_subscribers(:all), document_number)

  defp get_subscribers(type) do
    case type do
      :all -> read_file(:prepaid) ++ read_file(:postpaid)
      _ -> read_file(type)
    end
  end

  defp filter(list, document_number), do: Enum.find(list, &(&1.document_number == document_number))

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

  def read_file(plan \\ :prepaid) do
    case File.read(@subscribers[plan]) do
      { :ok, content } -> content |> :erlang.binary_to_term()
      { :error, _reason} -> []
    end
  end

  defp write_file(content, plan) do
    File.write(@subscribers[plan], content)
  end
end
