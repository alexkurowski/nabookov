defmodule App.Web.Email do
  import Bamboo.Email
  use Bamboo.Phoenix, view: App.Web.EmailView

  def signin(user) do
    # TODO: change the link in this email to lead to
    #       somewhere more personal, like user library
    #       or writer's dashboard
    base_email()
    |> to(user.email)
    |> subject("Sign in to Nabookov")
    |> render(:signin, email: user.email, token: user.signup_token)
  end

  defp base_email do
    new_email()
    |> from("noreply@nabookov.com")
    |> put_layout({ App.Web.LayoutView, :email })
  end
end
