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

  def illustration(icon) do
    raw "<div class='illustration'><i class='fa fa-#{icon}'></i></div>"
  end

  def title(content) do
    raw "<h4 class='modal-title'>#{content}</h4>"
  end

  def header(do: content),
    do: header "", do: content
  def header(add_class, do: content) do
    raw """
    <div class='modal-header #{add_class}'>
      #{content |> elem(1)}
    </div>
    """
  end

  def body(do: content),
    do: body "", do: content
  def body(add_class, do: content) do
    raw """
    <div class='modal-body #{add_class}'>
      #{content |> elem(1)}
    </div>
    """
  end

  def footer(do: content),
    do: footer "", do: content
  def footer(add_class, do: content) do
    raw """
    <div class='modal-footer #{add_class}'>
      #{content |> elem(1)}
    </div>
    """
  end
end
