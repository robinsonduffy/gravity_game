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

class PositiveNumberValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors[attribute] << "must be greater than zero" if !value.nil? && value <= 0
  end
end