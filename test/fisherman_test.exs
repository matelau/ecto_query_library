defmodule FishingSpot.FishermanTest do
  @moduledoc """
    Fishermen Tests
  """

  use FishingSpot.DataCase
  import EctoQueryLibray.Factory
  alias FishingSpot.Context.Fish
  alias FishingSpot.Fisherman

  describe "FishermanEctoChangesetsTests" do
    test "Casts values to proper type" do
      params = %{name: "some-name", date_of_birth: "2017-10-10"}
      {:ok, fisherman} = Fisherman.changeset(%Fisherman{}, params) |> Repo.insert()
      assert fisherman.date_of_birth == ~D[2017-10-10]
    end

    test "requires date of birth" do
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

    test "Select Unique Fishermen Names" do
      insert(:fisherman, name: "test")
      insert(:fisherman, name: "test")
      insert(:fisherman, name: "test")
      insert(:fisherman, name: "test")
      insert(:fisherman, name: "something_unique")
      # Update context to return proper result
      results = Fish.get_unique_fishermen_names()
      # assert Enum.count(results) == 1
      result = List.first(results)
      assert result == "something_unique"
    end

    test "select fisherman name and date of birth tuple" do
      fisherman = insert(:fisherman, name: "name", date_of_birth: "2000-10-01")
      # Update context to return proper result
      result = Fish.get_fisherman_name_and_date_of_birth(fisherman.id, :tuple)
      assert result == {"name", ~D[2000-10-01]}
    end

    test "select fisherman name and date of birth map" do
      fisherman = insert(:fisherman, name: "name", date_of_birth: "2000-10-01")
      # Update context to return proper result
      result = Fish.get_fisherman_name_and_date_of_birth(fisherman.id, :map)
      assert result == %{dob: ~D[2000-10-01], name: "name"}
    end

    test "select fisherman name and date of birth list" do
      fisherman = insert(:fisherman, name: "name", date_of_birth: "2000-10-01")
      # Update context to return proper result
      result = Fish.get_fisherman_name_and_date_of_birth(fisherman.id, :list)
      assert result == ["name", ~D[2000-10-01]]
    end
  end
end
