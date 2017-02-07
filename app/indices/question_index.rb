ThinkingSphinx::Index.define :question, with: :real_time do
  indexes title, sortable: :true
  indexes content

  has created_at, type: :timestamp
  has updated_at, type: :timestamp
end
