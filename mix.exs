defmodule Sellersjson.MixProject do
  use Mix.Project

  def project do
    [
      app: :sellersjson,
      name: "sellers_json",
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      description: description(),
      docs: [
        main: "Sellersjson",
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:poison, "~> 3.1"},
      {:httpoison, "~> 1.6"},
      {:ex_json_schema, "~> 0.6.1"},
      {:ex_doc, "~> 0.18", only: :dev},
    ]
  end

  defp package do
    [
      maintainers: ["Vamsi Krishna B"],
      licenses: ["MIT"],
      links: %{
        GitHub: "https://github.com/vamsiikrishna/sellers_json"
      }
    ]
  end

  defp description do
    "sellers.json validator"
  end
end
