FactoryBot.define do
  factory :rppr do
    project_id { create(:project).id }
    year_start { 1 }
    year_end { 1 }
    abstract { "MyText" }
    data_repository_id { 1 }
    supplemental_info { "MyString" }
  end
end
