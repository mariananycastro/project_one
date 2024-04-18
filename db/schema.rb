# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2024_04_17_153752) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "insured_people", force: :cascade do |t|
    t.string "name"
    t.string "document"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email"
    t.index ["document"], name: "index_insured_people_on_document", unique: true
  end

  create_table "policies", force: :cascade do |t|
    t.date "effective_from"
    t.date "effective_until"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "insured_person_id", null: false
    t.bigint "vehicle_id", null: false
    t.index ["insured_person_id"], name: "index_policies_on_insured_person_id"
    t.index ["vehicle_id"], name: "index_policies_on_vehicle_id"
  end

  create_table "vehicles", force: :cascade do |t|
    t.string "brand"
    t.string "vehicle_model"
    t.integer "year"
    t.string "license_plate"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["license_plate"], name: "index_vehicles_on_license_plate", unique: true
  end

  add_foreign_key "policies", "insured_people"
  add_foreign_key "policies", "vehicles"
end
