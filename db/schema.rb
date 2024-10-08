# frozen_string_literal: true

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

ActiveRecord::Schema[7.0].define(version: 20_240_719_134_504) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'pgcrypto'
  enable_extension 'plpgsql'

  create_table 'batches', id: :uuid, default: -> { 'gen_random_uuid()' }, force: :cascade do |t|
    t.string 'name', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.uuid 'user_id', null: false
    t.integer 'success_rate'
    t.boolean 'deleted', default: false
    t.index ['user_id'], name: 'index_batches_on_user_id'
  end

  create_table 'failed_urls', id: :uuid, default: -> { 'gen_random_uuid()' }, force: :cascade do |t|
    t.string 'long_url'
    t.uuid 'batch_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.uuid 'user_id', null: false
    t.index ['batch_id'], name: 'index_failed_urls_on_batch_id'
    t.index ['user_id'], name: 'index_failed_urls_on_user_id'
  end

  create_table 'tags', id: :uuid, default: -> { 'gen_random_uuid()' }, force: :cascade do |t|
    t.string 'name'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.string 'taggable_type', null: false
    t.uuid 'taggable_id', null: false
    t.index %w[name taggable_type taggable_id], name: 'index_tags_on_name_and_taggable_type_and_taggable_id', unique: true
    t.index %w[taggable_type taggable_id], name: 'index_tags_on_taggable'
  end

  create_table 'urls', id: :uuid, default: -> { 'gen_random_uuid()' }, force: :cascade do |t|
    t.string 'long_url'
    t.string 'short_url'
    t.integer 'click', default: 0
    t.uuid 'batch_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.uuid 'user_id', null: false
    t.boolean 'deleted', default: false
    t.integer 'visits_count', default: 0
    t.index ['batch_id'], name: 'index_urls_on_batch_id'
    t.index ['user_id'], name: 'index_urls_on_user_id'
  end

  create_table 'users', id: :uuid, default: -> { 'gen_random_uuid()' }, force: :cascade do |t|
    t.string 'email', default: '', null: false
    t.string 'encrypted_password', default: '', null: false
    t.string 'reset_password_token'
    t.datetime 'reset_password_sent_at'
    t.datetime 'remember_created_at'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['email'], name: 'index_users_on_email', unique: true
    t.index ['reset_password_token'], name: 'index_users_on_reset_password_token', unique: true
  end

  create_table 'visits', id: :uuid, default: -> { 'gen_random_uuid()' }, force: :cascade do |t|
    t.uuid 'url_id', null: false
    t.uuid 'user_id', null: false
    t.string 'ip_address'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['url_id'], name: 'index_visits_on_url_id'
    t.index ['user_id'], name: 'index_visits_on_user_id'
  end

  add_foreign_key 'batches', 'users'
  add_foreign_key 'failed_urls', 'batches'
  add_foreign_key 'failed_urls', 'users'
  add_foreign_key 'urls', 'batches'
  add_foreign_key 'urls', 'users'
  add_foreign_key 'visits', 'urls'
  add_foreign_key 'visits', 'users'
end
