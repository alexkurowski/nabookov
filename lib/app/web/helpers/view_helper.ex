defmodule App.Web.ViewHelper do
  def t(val) do
    Gettext.gettext App.Web.Gettext, val
  end

  def plural(str, val) do
    if val == 1,
      do: str,
      else: str <> "s"
  end

  def username(user) do
    user.name
  end

  def username_or_email(user) do
    if no_username?(user),
      do: user.email,
      else: "@" <> user.name
  end

  def no_username?(user) do
    is_nil(user.name) or String.trim(user.name) == ""
  end
end
