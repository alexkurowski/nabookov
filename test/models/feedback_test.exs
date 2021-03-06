defmodule App.Web.FeedbackTest do
  use App.Web.ModelCase

  alias App.Web.Feedback

  @valid_attrs %{comment: "some content", status: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Feedback.changeset(%Feedback{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Feedback.changeset(%Feedback{}, @invalid_attrs)
    refute changeset.valid?
  end
end
