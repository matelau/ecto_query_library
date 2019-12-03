defmodule FishingSpot.FishermanTest do
  @moduledoc """
    Fishermen Tests
  """

  use FishingSpot.DataCase
  import EctoQueryLibray.Factory
  alias FishingSpot.Context.Fish
  alias FishingSpot.Fisherman

  describe "FishermanEctoChangesetsTests" do
    test "changeset casts values to proper type" do
      params = %{name: "some-name", date_of_birth: "2017-10-10"}
      {:ok, fisherman} = Fisherman.changeset(%Fisherman{}, params) |> Repo.insert()
      assert fisherman.date_of_birth == ~D[2017-10-10]
    end

    test "changeset requires date of birth" do
      params = %{name: "some-name"}
      {:error, changeset} = Fisherman.changeset(%Fisherman{}, params) |> Repo.insert()
      assert changeset.errors == [date_of_birth: {"can't be blank", [validation: :required]}]
    end

    test "changeset casts associations values to proper type" do
      params = %{
        name: "some-name",
        date_of_birth: "2017-10-10",
        fish_landed: [%{date_and_time: "2019-12-02T17:42:18+00:00", weight: 20, length: 10}]
      }

      {:ok, fisherman} = Fisherman.changeset(%Fisherman{}, params) |> Repo.insert()
      fish_landed = fisherman.fish_landed
      assert Enum.count(fish_landed) == 1
      assert List.first(fish_landed).weight == Decimal.cast(20)
    end

    test "changeset error includes constraints" do
      params = %{
        name: "some-name",
        date_of_birth: "2017-10-10",
        fish_landed: [%{date_and_time: "2019-12-02T17:42:18+00:00", weight: 20, length: 10}]
      }

      {:ok, _fisherman} = Fisherman.changeset(%Fisherman{}, params) |> Repo.insert()
      {:error, results} = Fisherman.changeset(%Fisherman{}, params) |> Repo.insert()

      assert results.errors == [
               name:
                 {"has already been taken",
                  [constraint: :unique, constraint_name: "fishermen_name"]}
             ]
    end
  end

  describe "FishermanEctoQueryTests" do
    test "Get Fisherman" do
      fisherman = insert(:fisherman)
      # Update context to return proper result
      result = Fish.get_fisherman(fisherman.id)
      assert result.name == "Fisherman"
    end

    test "Select Fisherman Name" do
      fisherman = insert(:fisherman)
      # Update context to return proper result
      result = Fish.get_fisherman_name(fisherman.id)
      assert result == "Fisherman"
    end

    test "Select unique fishermen date_of_birth" do
      insert(:fisherman, name: "test_1", date_of_birth: "2017-10-11")
      insert(:fisherman, name: "test_2", date_of_birth: "2017-10-11")
      insert(:fisherman, name: "test_3", date_of_birth: "2017-10-11")
      insert(:fisherman, name: "test_4", date_of_birth: "2017-10-11")
      insert(:fisherman, name: "something_unique", date_of_birth: "2017-10-02")
      results = Fish.get_unique_fishermen_dob()
      assert Enum.count(results) == 2
      # These should be in order
      assert List.first(results) == ~D[2017-10-02]
      assert List.last(results) == ~D[2017-10-11]
    end

    test "select fisherman name and date of birth tuple" do
      fisherman = insert(:fisherman, name: "name", date_of_birth: "2000-10-01")
      result = Fish.get_fisherman_name_and_date_of_birth(fisherman.id, :tuple)
      assert result == {"name", ~D[2000-10-01]}
    end

    test "select fisherman name and date of birth map" do
      fisherman = insert(:fisherman, name: "name", date_of_birth: "2000-10-01")
      result = Fish.get_fisherman_name_and_date_of_birth(fisherman.id, :map)
      assert result == %{dob: ~D[2000-10-01], name: "name"}
    end

    test "select fisherman name and date of birth list" do
      fisherman = insert(:fisherman, name: "name", date_of_birth: "2000-10-01")
      result = Fish.get_fisherman_name_and_date_of_birth(fisherman.id, :list)
      assert result == ["name", ~D[2000-10-01]]
    end

    test "Get each Fishermans longest fish" do
      Enum.each(0..9, fn _ ->
        random_number = :rand.uniform(100)
        insert(:fish_landed, length: random_number)
      end)

      insert(:fish_landed, length: 200, fisherman: %{name: "Johnny"})

      result = Fish.get_longest_fish_by_fisherman_sorted()
      assert List.first(result) == %{fisherman_name: "Johnny", max_fish_length: Decimal.cast(200)}
    end

    test "Get fisherman that have caught more than x fish" do
      fisherman = insert(:fisherman)

      Enum.each(0..9, fn _ ->
        insert(:fish_landed, fisherman: fisherman)
      end)

      insert(:fish_landed, length: 200, fisherman: %{name: "Johnny"})

      result = Fish.get_fishermen_whom_caught_more_than_x_fish(5)
      assert Enum.count(result) == 1
      assert List.first(result) == %{fisherman_name: "Fisherman", count: 10}
    end

    test "Get the fisherman with the biggest fish in one query" do
      Enum.each(0..9, fn _ ->
        random_number = :rand.uniform(100)
        insert(:fish_landed, length: random_number)
      end)

      insert(:fish_landed, length: 200, fisherman: %{name: "Johnny"})

      result = Fish.get_fisherman_with_biggest_fish()
      assert result == %{length: Decimal.cast(200), name: "Johnny"}
    end

    test "Get only the last 10 fish landed by fisherman" do
      fisherman = insert(:fisherman)

      Enum.each(0..99, fn _ ->
        insert(:fish_landed, fisherman: fisherman)
      end)

      result = Fish.get_the_last_ten_fish_landed_by_fisherman(fisherman.id)
      assert Enum.count(result) == 10

      result
      |> Enum.with_index()
      |> Enum.each(fn {val, ind} ->
        if(ind > 0) do
          assert val < Enum.at(result, ind - 1)
        end
      end)
    end

    test "" do
      Enum.each(0..2, fn x ->
        fisherman = insert(:fisherman, name: "fisherman_#{x}")

        Enum.each(0..9, fn _ ->
          random_number = :rand.uniform(100)
          insert(:fish_landed, length: random_number, fisherman: fisherman)
        end)
      end)

      result = Fish.favorite_lure_by_species_and_lure_with_longest_fish("Trout", "Yummy")
      assert length(result) == 3

      Enum.each(result, fn %{length: l} ->
        assert l > 0
      end)
    end
  end
end
