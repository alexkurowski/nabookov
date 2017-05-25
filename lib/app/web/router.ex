defmodule App.Web.Router do
  use App.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  if Mix.env == :dev do
    forward "/emails", Bamboo.EmailPreviewPlug
  end

  scope "/", App.Web do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index

    post "/signin",   UserController, :signin
    post "/signout",  UserController, :signout
    post "/username", UserController, :username

    get "/write",       WriterController, :dashboard
    get "/write/:slug", WriterController, :write
    post "/write/new",  WriterController, :new_book
    post "/write/chp",  WriterController, :new_chapter
    post "/write/rch",  WriterController, :remove_chapter

    get "/:slug",     ReaderController, :find
  end

  # Other scopes may use custom stacks.
  # scope "/api", App do
  #   pipe_through :api
  # end
end
