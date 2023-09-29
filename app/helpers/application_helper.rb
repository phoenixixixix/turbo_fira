module ApplicationHelper
  def routes_namespacing(*args, actual_model)
    %w( create new index ).include?(action_name) ? args << actual_model : [actual_model]
  end
end
