defmodule App.Web.ModalView do
  use App.Web, :view

  def modal(id, do: content) do
    raw """
    <div id='#{id}' class='modal'>
      <div class='modal-dialog'>
        <div class='modal-content'>
          #{content |> elem(1)}
        </div>
      </div>
    </div>
    """
  end

  def modal_title(content) do
    raw "<h4 class='modal-title'>#{content}</h4>"
  end
end
