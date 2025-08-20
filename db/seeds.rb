guest_user = User.guest

user = User.create!(
  email: "user@example.com",
  username: "一般ユーザー",
  password: "password"
)

Event.create!([
  {
    title: "散歩",
    date: "2025-08-09",
    start_time: "2025-08-09 5:00",
    end_time: "2025-08-09 7:00",
    category: "プライベート",
    user: user
  },
  {
    title: "打ち合わせ",
    date: "2025-08-11",
    start_time: "2025-08-11 10:00",
    end_time: "2025-08-11 16:00",
    category: "重要",
    user: user
  },
  {
    title: "副業の仕事",
    date: "2025-08-13",
    start_time: "2025-08-13 19:00",
    end_time: "2025-08-13 22:00",
    category: "仕事",
    user: user
  },
  {
    title: "出張",
    date: "2025-08-12",
    start_time: "2025-08-12 8:00",
    end_time: "2025-08-12 22:00",
    category: "その他",
    user: user
  },
  {
    title: "会議",
    date: "2025-07-25",
    start_time: "2025-07-25 10:00",
    end_time: "2025-07-25 12:00",
    category: "仕事",
    user: user
  },
  {
    title: "副業の仕事",
    date: "2025-07-25",
    start_time: "2025-07-25 20:00",
    end_time: "2025-07-25 23:00",
    category: "仕事",
    user: guest_user
  },
  {
    title: "クライアントとのすり合わせ",
    date: "2025-08-10",
    start_time: "2025-08-10 20:00",
    end_time: "2025-08-10 22:00",
    category: "重要",
    user: guest_user
  },
  {
    title: "散歩",
    date: "2025-08-15",
    start_time: "2025-08-15 6:00",
    end_time: "2025-08-15 7:30",
    category: "プライベート",
    user: guest_user
  }
])

Booking.create!([
  {
    owner: user,
    name: "ゲスト1",
    email: "guest1@example.com",
    start_time: Time.zone.parse("2025-08-21 10:00"),
    end_time: Time.zone.parse("2025-08-21 10:30")
  },
  {
    owner: user,
    name: "ゲスト2",
    email: "guest2@example.com",
    start_time: Time.zone.parse("2025-08-30 10:00"),
    end_time: Time.zone.parse("2025-08-30 10:30")
  },
  {
    owner: guest_user,
    name: "ゲスト太郎",
    email: "guestarou@example.com",
    start_time: Time.zone.parse("2025-08-30 12:00"),
    end_time: Time.zone.parse("2025-08-30 12:30")
  }
])
