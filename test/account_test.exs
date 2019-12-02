defmodule FishingSpot.AccountTest do
  @moduledoc """
  """
  use FishingSpot.DataCase
  alias FishingSpot.Account

  describe "" do
    test "changeset casts embedded values to proper type" do
      params = %{
        name: "some-name",
        identifier: "account_id",
        deposit: %{amount: 500}
      }

      {:ok, account} = Account.changeset(%Account{}, params) |> Repo.insert()
      assert account.deposit == 500
    end
  end
end
