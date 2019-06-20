# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_06_19_162247) do

  create_table "achievements", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "group_id"
    t.string "prize"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_achievements_on_group_id"
  end

  create_table "colleges", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "competitions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.integer "version"
    t.date "deadline"
    t.date "endtime"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "groups", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.string "mema"
    t.string "memb"
    t.string "memc"
    t.string "memd"
    t.integer "isteam"
    t.bigint "student_id"
    t.bigint "competition_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["competition_id"], name: "index_groups_on_competition_id"
    t.index ["student_id"], name: "index_groups_on_student_id"
  end

  create_table "guide_teachers", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "group_id"
    t.bigint "teacher_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_guide_teachers_on_group_id"
    t.index ["teacher_id"], name: "index_guide_teachers_on_teacher_id"
  end

  create_table "students", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "student_id"
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.bigint "college_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["college_id"], name: "index_students_on_college_id"
    t.index ["student_id"], name: "index_students_on_student_id"
  end

  create_table "teachers", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "teacher_id"
    t.string "name"
    t.bigint "college_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["college_id"], name: "index_teachers_on_college_id"
    t.index ["teacher_id"], name: "index_teachers_on_teacher_id"
  end

  add_foreign_key "achievements", "groups"
  add_foreign_key "groups", "competitions"
  add_foreign_key "groups", "students"
  add_foreign_key "guide_teachers", "groups"
  add_foreign_key "guide_teachers", "teachers"
  add_foreign_key "students", "colleges"
  add_foreign_key "teachers", "colleges"
end
