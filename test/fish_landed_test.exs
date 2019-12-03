defmodule FishingSpot.FishLandedTest do
  @moduledoc """
    Fishermen Tests
  """

  use FishingSpot.DataCase
  import EctoQueryLibray.Factory
  alias FishingSpot.FishLanded
  alias FishingSpot.Repo

  describe "FishLandedEctoTests" do
    test "Get the heaviest FishLanded" do
      insert(:fish_landed, weight: 0.05)
      insert(:fish_landed, weight: 0.5)
      insert(:fish_landed, weight: 1.0)
      insert(:fish_landed, weight: 1.5)
      insert(:fish_landed, weight: 2.5)
      insert(:fish_landed, weight: 3.0)
      heaviest_fish = FishLanded |> FishLanded.largest_fish() |> Repo.one()
      assert heaviest_fish == Decimal.cast(3.0)
    end

    test "Get the FishLanded of a specific length" do
      insert(:fish_landed, length: 10.0)
      insert(:fish_landed, length: 11.5)
      insert(:fish_landed, length: 22.5)
      insert(:fish_landed, length: 33.0)
      fish_landed = FishLanded |> FishLanded.by_length(33.0) |> Repo.one()
      assert fish_landed.length == Decimal.cast(33.0)
    end

    test "Get the count of FishLanded" do
      Enum.each(0..9, fn _ ->
        random_number = :rand.uniform(100)
        insert(:fish_landed, length: random_number)
      end)

      count = FishLanded |> FishLanded.count() |> Repo.one()
      assert count == 10
    end

    test "Get the count of FishLanded where length is greater than 100" do
      Enum.each(0..9, fn _ ->
        random_number = :rand.uniform(100)
        insert(:fish_landed, length: random_number)
      end)

      insert(:fish_landed, length: 200)

      count = FishLanded |> FishLanded.count_long_fish() |> Repo.one()
      assert count == 1
    end
  end
end
