defmodule App.Web.LayoutView do
  use App.Web, :view

  def years do
    startYear   = 2017
    currentYear = DateTime.utc_now.year
    if currentYear == startYear do
      "#{currentYear}"
    else
      "#{startYear} - #{currentYear}"
    end
  end
end
