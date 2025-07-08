User.guest

user = User.create!(
  email: "user@example.com",
  username: "一般ユーザー",
  password: "password"
)

Event.create!([
  {
    title: "会議",
    date: "2025-08-09",
    start_time: "2025-08-09 10:00",
    end_time: "2025-08-09 11:00",
    category: "仕事",
    user: user
  },
  {
    title: "おでかけ",
    date: "2025-08-11",
    start_time: "2025-08-11 10:00",
    end_time: "2025-08-11 16:00",
    category: "プライベート",
    user: user
  },
  {
    title: "お祭り",
    date: "2025-08-13",
    start_time: "2025-08-13 18:00",
    end_time: "2025-08-13 22:00",
    category: "重要",
    user: user
  },
  {
    title: "散歩",
    date: "2025-08-12",
    start_time: "2025-08-12 9:00",
    end_time: "2025-08-12 10:00",
    category: "その他",
    user: user
  },
  {
    title: "会議"
    date: "2025-07-25"
    start_time: "2025-07-25 10:00"
    end_time: "2025-07-25 12:00"
    category: "仕事"
    user: user
  }
])
