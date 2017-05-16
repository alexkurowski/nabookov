defmodule App.Web.ControllerHelper do
  @doc """
  Check if a string value `val` is not blank
  """
  def present(val) do
    not is_nil(val) and String.trim(val) != ""
  end
end
