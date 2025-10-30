# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

puts "Importing Common Data Elements"
count1 = CommonDataElement.import(Rails.root.join("db/seeds/common_data_elements.xlsx").to_s)
puts "Rows count #{count1}"

puts "Importing Demographics"
count2 = Demographic.import(Rails.root.join("db/seeds/Patient_Database_mock.xlsx").to_s) 
puts "Rows count #{count2}"

puts "Importing Patient Tasks"
count3 = PatientTask.import(Rails.root.join("db/seeds/patient_tasks.xlsx").to_s)
puts "Rows count #{count3}"

puts "Importing Epilepsy"
count4 = Epilepsy.import(Rails.root.join("db/seeds/Epilepsy_mock.xlsx").to_s) 
puts "Rows count #{count4}"

puts "Importing CCEPs"
count5 = Ccep.import(Rails.root.join("db/seeds/CCEP_Database.xlsx").to_s) 
puts "Rows count #{count5}"