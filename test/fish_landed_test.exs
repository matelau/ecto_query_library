defmodule FishingSpot.FishLandedTest do
  @moduledoc """
    Fishermen Tests
  """

  use FishingSpot.DataCase
  import EctoQueryLibray.Factory
  alias FishingSpot.Context.Fish

  describe "FishLandedEctoTests" do
    test "Get FishLanded" do
        fish_landed = insert(:fish_landed)
        assert fish_landed == ""
    end
end
end