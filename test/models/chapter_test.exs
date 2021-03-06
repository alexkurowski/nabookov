defmodule App.Web.ChapterTest do
  use App.Web.ModelCase

  alias App.Web.Chapter

  @valid_attrs %{locked: true, text: "some content", visible: true}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Chapter.changeset(%Chapter{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Chapter.changeset(%Chapter{}, @invalid_attrs)
    refute changeset.valid?
  end
end
