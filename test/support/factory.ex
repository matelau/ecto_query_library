defmodule EctoQueryLibray.Factory do
  @moduledoc """
  Factory for EctoQueryLibrary
  """
  use ExMachina.Ecto, repo: FishingSpot.Repo

  alias FishingSpot.{Fisherman}

  def fisherman_factory do
    %Fisherman{
      name: "Fisherman",
      date_of_birth: DateTime.utc_now()
    }
  end
end
