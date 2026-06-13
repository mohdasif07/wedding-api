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

ActiveRecord::Schema[8.1].define(version: 2026_06_14_111200) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "albums", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id", "title"], name: "index_albums_on_user_id_and_title"
    t.index ["user_id"], name: "index_albums_on_user_id"
  end

  create_table "attendances", force: :cascade do |t|
    t.datetime "checked_in_at", null: false
    t.datetime "created_at", null: false
    t.bigint "event_id", null: false
    t.bigint "guest_id", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_attendances_on_event_id"
    t.index ["guest_id", "event_id"], name: "index_attendances_on_guest_id_and_event_id", unique: true
    t.index ["guest_id"], name: "index_attendances_on_guest_id"
  end

  create_table "device_tokens", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "platform", null: false
    t.string "token", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["token"], name: "index_device_tokens_on_token", unique: true
    t.index ["user_id"], name: "index_device_tokens_on_user_id"
  end

  create_table "events", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.time "end_time"
    t.date "event_date", null: false
    t.time "start_time"
    t.integer "status", default: 0, null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.string "venue"
    t.index ["event_date"], name: "index_events_on_event_date"
    t.index ["status"], name: "index_events_on_status"
    t.index ["user_id", "title"], name: "index_events_on_user_id_and_title"
    t.index ["user_id"], name: "index_events_on_user_id"
  end

  create_table "expenses", force: :cascade do |t|
    t.decimal "actual_amount", precision: 12, scale: 2, default: "0.0"
    t.integer "category", default: 0, null: false
    t.datetime "created_at", null: false
    t.decimal "estimated_amount", precision: 12, scale: 2, default: "0.0"
    t.integer "payment_status", default: 0, null: false
    t.text "remarks"
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["category"], name: "index_expenses_on_category"
    t.index ["created_at"], name: "index_expenses_on_created_at"
    t.index ["payment_status"], name: "index_expenses_on_payment_status"
    t.index ["user_id"], name: "index_expenses_on_user_id"
  end

  create_table "guests", force: :cascade do |t|
    t.text "address"
    t.datetime "created_at", null: false
    t.string "email"
    t.bigint "event_id", null: false
    t.string "family_name"
    t.string "first_name", null: false
    t.integer "invite_count", default: 0, null: false
    t.datetime "invited_at"
    t.string "last_name", null: false
    t.string "phone"
    t.string "qr_code_token", null: false
    t.integer "rsvp_status", default: 0, null: false
    t.integer "side", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["event_id", "email"], name: "index_guests_on_event_id_and_email"
    t.index ["event_id"], name: "index_guests_on_event_id"
    t.index ["qr_code_token"], name: "index_guests_on_qr_code_token", unique: true
    t.index ["rsvp_status"], name: "index_guests_on_rsvp_status"
    t.index ["side"], name: "index_guests_on_side"
  end

  create_table "message_recipients", force: :cascade do |t|
    t.integer "channel", default: 0, null: false
    t.datetime "created_at", null: false
    t.text "error_message"
    t.bigint "guest_id", null: false
    t.bigint "message_id", null: false
    t.datetime "sent_at"
    t.integer "status", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["guest_id"], name: "index_message_recipients_on_guest_id"
    t.index ["message_id", "guest_id"], name: "index_message_recipients_on_message_id_and_guest_id", unique: true
    t.index ["message_id"], name: "index_message_recipients_on_message_id"
    t.index ["status"], name: "index_message_recipients_on_status"
  end

  create_table "messages", force: :cascade do |t|
    t.text "body", null: false
    t.datetime "created_at", null: false
    t.bigint "event_id"
    t.integer "message_type", default: 0, null: false
    t.string "subject", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["created_at"], name: "index_messages_on_created_at"
    t.index ["event_id"], name: "index_messages_on_event_id"
    t.index ["message_type"], name: "index_messages_on_message_type"
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "password_reset_tokens", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "expires_at", null: false
    t.string "token_digest", null: false
    t.datetime "updated_at", null: false
    t.datetime "used_at"
    t.bigint "user_id", null: false
    t.index ["token_digest"], name: "index_password_reset_tokens_on_token_digest", unique: true
    t.index ["user_id"], name: "index_password_reset_tokens_on_user_id"
  end

  create_table "photos", force: :cascade do |t|
    t.bigint "album_id"
    t.string "caption"
    t.datetime "created_at", null: false
    t.bigint "event_id"
    t.datetime "updated_at", null: false
    t.index ["album_id"], name: "index_photos_on_album_id"
    t.index ["created_at"], name: "index_photos_on_created_at"
    t.index ["event_id"], name: "index_photos_on_event_id"
  end

  create_table "refresh_tokens", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "expires_at", null: false
    t.datetime "revoked_at"
    t.string "token_digest", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["expires_at"], name: "index_refresh_tokens_on_expires_at"
    t.index ["token_digest"], name: "index_refresh_tokens_on_token_digest", unique: true
    t.index ["user_id"], name: "index_refresh_tokens_on_user_id"
  end

  create_table "rsvps", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "event_id", null: false
    t.bigint "guest_id", null: false
    t.integer "status", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_rsvps_on_event_id"
    t.index ["guest_id", "event_id"], name: "index_rsvps_on_guest_id_and_event_id", unique: true
    t.index ["guest_id"], name: "index_rsvps_on_guest_id"
    t.index ["status"], name: "index_rsvps_on_status"
  end

  create_table "tasks", force: :cascade do |t|
    t.string "category", default: "general", null: false
    t.datetime "created_at", null: false
    t.text "description"
    t.date "due_date"
    t.integer "position", default: 0, null: false
    t.integer "status", default: 0, null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id", "category"], name: "index_tasks_on_user_id_and_category"
    t.index ["user_id", "status"], name: "index_tasks_on_user_id_and_status"
    t.index ["user_id"], name: "index_tasks_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "password_digest", null: false
    t.string "phone"
    t.integer "role", default: 1, null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["role"], name: "index_users_on_role"
  end

  create_table "vendors", force: :cascade do |t|
    t.string "contact_person"
    t.decimal "contract_amount", precision: 12, scale: 2, default: "0.0"
    t.datetime "created_at", null: false
    t.string "email"
    t.text "notes"
    t.decimal "paid_amount", precision: 12, scale: 2, default: "0.0"
    t.string "phone"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.string "vendor_name", null: false
    t.integer "vendor_type", default: 0, null: false
    t.index ["user_id", "vendor_name"], name: "index_vendors_on_user_id_and_vendor_name"
    t.index ["user_id"], name: "index_vendors_on_user_id"
    t.index ["vendor_type"], name: "index_vendors_on_vendor_type"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "albums", "users"
  add_foreign_key "attendances", "events"
  add_foreign_key "attendances", "guests"
  add_foreign_key "device_tokens", "users"
  add_foreign_key "events", "users"
  add_foreign_key "expenses", "users"
  add_foreign_key "guests", "events"
  add_foreign_key "message_recipients", "guests"
  add_foreign_key "message_recipients", "messages"
  add_foreign_key "messages", "events"
  add_foreign_key "messages", "users"
  add_foreign_key "password_reset_tokens", "users"
  add_foreign_key "photos", "albums"
  add_foreign_key "photos", "events"
  add_foreign_key "refresh_tokens", "users"
  add_foreign_key "rsvps", "events"
  add_foreign_key "rsvps", "guests"
  add_foreign_key "tasks", "users"
  add_foreign_key "vendors", "users"
end
