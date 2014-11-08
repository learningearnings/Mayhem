class ReleaseNote < Post
  scope :featured, where(featured: true)
end
