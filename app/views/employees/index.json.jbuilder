# TODO: Could be used to include the events
json.array!(@employees) do |employee|
  json.extract! employee, :id, :name
  json.url employee_url(employee, format: :json)
end
