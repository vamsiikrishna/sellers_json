defmodule Sellersjson do
  @moduledoc """
  Sellersjson is an Elixir Module used to validate sellers.json on a given advertising system.
  More info available at https://iabtechlab.com/wp-content/uploads/2019/07/Sellers.json_Final.pdf
  """
  defp validate_json(json) do
    schema = %{
      "type" => "object",
      "definitions" => %{
        "seller" => %{
        "type" => "object",
        "required" => ["seller_id", "seller_type"],
        "properties" => %{
          "seller_id" => %{
            "type" => "string"
          },
          "is_confidential" => %{
            "enum" => ["0", "1"]
          },
          "name" => %{
            "type" => "string"
          },
          "seller_type" => %{
            "type" => "string",
            "enum" => ["PUBLISHER", "INTERMEDIARY", "BOTH"]
          },
          "is_passthrough" => %{
            "enum" => ["0", "1"]
          },
          "domain" => %{
            "type" => "string"
          },
          "comment" => %{
            "type" => "string"
          },
          "ext" => %{
            "type" => "object"
          }
        }
      }
      },
      "required" => ["version", "sellers"],
      "properties" => %{
        "contact_email" => %{
          "type" => "string"
        },
        "contact_address" => %{
          "type" => "string"
        },
        "version" => %{
          "type" => "string"
        },
        "sellers" => %{
          "type" => "array",
          "items" => %{
            "$ref" => "#/definitions/seller"
          }
        }
      }
    } |> ExJsonSchema.Schema.resolve()

    ExJsonSchema.Validator.validate(schema, json)
  end

  defp get_host_name(url) do
    case URI.parse(url).scheme do
      "https" ->
        URI.parse(url).host

      "http" ->
        URI.parse(url).host

      nil ->
        ("http://" <> url) |> URI.parse() |> Map.get(:host)

      _ ->
        {:error, "Protocol not supported"}
    end
  end

  defp append_sellers_json(url) do
    url <> "/sellers.json"
  end

  def get_sellers_json(url) do
    HTTPoison.start()
    url
    |> get_host_name
    |> append_sellers_json
    |> HTTPoison.get([], ssl: [{:versions, [:'tlsv1.2']}], follow_redirect: true)
    |> case do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, body } = Poison.decode(body)
        validate_json(body)

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        {:error, "sellers.json not implemented"}
      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end

end
