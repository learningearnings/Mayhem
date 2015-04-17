json.array! @awards do |award|
  json.(award, :id, :name)
end
