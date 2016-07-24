defmodule FunLand.Mixfile do
  use Mix.Project

  def project do
    [app: :fun_land,
     version: "0.6.1",
     elixir: "~> 1.3",
     description: description,
     package: package,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:currying, "~> 1.0"},

      {:dialyxir, "~> 0.3", only: :dev},
      {:ex_doc, ">= 0.0.0", only: :dev} 
    ]
  end

  defp description do
    """
    FunLand adds Behaviours to define Algebraic Data Types ('Container' data types) to Elixir, 
    including many helpful operations with them.
    
    FunLand attempts to use understandable names for the different behaviours and functions, 
    to make ADTs as approachable to newcomers as possible.

    Some examples of Algebraic Data Types are Mappables (Functors), Applicatives and Monads.

    """
  end

  defp package do
    [# These are the default files included in the package
     name: :fun_land,
     files: ["lib", "mix.exs", "README*", "LICENSE*"],
     maintainers: ["Wiebe-Marten/Qqwy"],
     licenses: ["MIT"],
     links: %{"GitHub" => "https://github.com/qqwy/elixir_fun_land",
              }]
  end
end
