defmodule App.Web.ViewHelper do
  def username(user) do
    user.name
  end

  def username_or_email(user) do
    if no_username?(user) do
      user.email
    else
      "@" <> user.name
    end
  end

  def no_username?(user) do
    is_nil(user.name) or String.trim(user.name) == ""
  end
end
