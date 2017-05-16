defmodule App.Web.Email do
  import Bamboo.Email
  use Bamboo.Phoenix, view: App.EmailView

  def signin(user) do
    # TODO: change the link in this email to lead to
    #       somewhere more personal, like user library
    #       or writer's dashboard
    base_email()
    |> to(user.email)
    |> subject("Sign in to koob|feed")
    |> render(:signin, email: user.email, token: user.signup_token)
  end

  defp base_email do
    new_email()
    |> from("noreply@koobfeed.com")
    |> put_layout({ App.LayoutView, :email })
  end
end
