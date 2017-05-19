defmodule App.Web.Email do
  import Bamboo.Email
  use Bamboo.Phoenix, view: App.Web.EmailView

  alias App.Web.Endpoint

  def signin(user) do
    # TODO: change the link in this email to lead to
    #       somewhere more personal, like user library
    #       or writer's dashboard
    url = App.Web.Router.Helpers.page_url(Endpoint, :index, email: user.email, token: user.signup_token)

    base_email()
    |> to(user.email)
    |> subject("Sign in to Nabookov")
    |> render(:signin, url: url)
  end

  defp base_email do
    new_email()
    |> from("noreply@nabookov.com")
    |> put_layout({ App.Web.LayoutView, :email })
  end
end
