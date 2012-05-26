module ApplicationHelper
  def title
    base_title = "Gravity Game"
    if @title.nil?
      base_title
    else
      "#{@title} | #{base_title}"
    end
  end
end