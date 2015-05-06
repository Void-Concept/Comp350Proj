json.array!(@groups) do |group|
  json.extract! group, :id, :name, :admin
  json.url group_url(group, format: :json)
end
