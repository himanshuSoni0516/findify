# Findify — Lost & Found App

> A Flutter mobile app for college students to report and recover lost items on campus.

Built with **Flutter + Supabase** (REST API only) as a BCA final year project.

---

## Features

- **Auth** — Email/password signup & login via Supabase Auth (JWT), persistent session
- **Feed** — Browse posts with real-time search and Lost / Found / Resolved filters
- **Create Posts** — Upload up to 5 item photos, add location and description
- **Post Detail** — View full item info and call the owner directly
- **Notifications** — Real-time in-app alerts when new posts are created
- **Mark Resolved** — Owner marks item as recovered; post updates to Resolved state
- **Profile** — View your posts, stats, and manage or delete them
- **Themes** — System / Light / Dark mode, persisted across sessions

---

## Screenshots

| Feed | Add Post | Post Detail | Profile |
|------|----------|-------------|---------|
| ![feed](https://raw.githubusercontent.com/himanshuSoni0516/findify/master/screenshots/feed.png) | ![add](https://raw.githubusercontent.com/himanshuSoni0516/findify/master/screenshots/add.png) | ![detail](https://raw.githubusercontent.com/himanshuSoni0516/findify/master/screenshots/detail.png) | ![profile](https://raw.githubusercontent.com/himanshuSoni0516/findify/master/screenshots/profile.png) |

---

## Tech Stack

| Layer | Technology |
|---|---|
| Frontend | Flutter (Dart) |
| State Management | GetX |
| Backend | Supabase (REST API only — no SDK) |
| Database | PostgreSQL via Supabase |
| Auth | Supabase Auth (JWT) |
| Storage | Supabase Storage (image upload) |
| Local Storage | shared_preferences |

---

## Project Structure

```
lib/
├── controllers/
│   ├── auth_controller.dart         # Signup, login, logout, session
│   ├── notification_controller.dart # Realtime notifications via Supabase
│   ├── post_controller.dart         # Fetch, create, filter, search, delete
│   └── theme_controller.dart        # Persists theme preference
├── core/
│   ├── api_client.dart              # HTTP wrapper (GET/POST/PATCH/DELETE + JWT)
│   ├── app_theme.dart               # Material 3 light & dark themes
│   ├── constants.dart               # Supabase URL, endpoints
│   └── storage_service.dart         # JWT token persistence
├── models/
│   ├── notification_model.dart
│   ├── post_image_model.dart
│   ├── post_model.dart
│   └── user_model.dart
└── screens/
    ├── widgets/
    │   ├── app_dialog.dart
    │   ├── app_snackbar.dart
    │   ├── app_text_field.dart
    │   ├── filter_bar.dart
    │   ├── glass_nav_bar.dart
    │   ├── gradient_button.dart
    │   ├── main_shell.dart
    │   ├── my_post_card.dart
    │   ├── post_card.dart
    │   └── skeleton_loader.dart
    ├── about_screen.dart
    ├── add_post_screen.dart
    ├── home_screen.dart
    ├── login_screen.dart
    ├── notifications_screen.dart
    ├── post_detail_screen.dart
    ├── profile_screen.dart
    ├── signup_screen.dart
    └── splash_screen.dart
```

---

## Database Schema

### `profiles`
| Column | Type | Notes |
|---|---|---|
| id | UUID | References auth.users |
| name | TEXT | |
| course | TEXT | |
| semester | TEXT | |
| phone | TEXT | |

### `posts`
| Column | Type | Notes |
|---|---|---|
| id | UUID | Primary key |
| user_id | UUID | References auth.users |
| title | TEXT | |
| description | TEXT | |
| type | TEXT | `lost`, `found`, or `resolved` |
| location | TEXT | |
| is_resolved | BOOLEAN | Default false |
| created_at | TIMESTAMP | |

### `post_images`
| Column | Type | Notes |
|---|---|---|
| id | UUID | Primary key |
| post_id | UUID | References posts |
| image_url | TEXT | Supabase Storage public URL |
| display_order | INT | 1–5, for carousel ordering |

### `notifications`
| Column | Type | Notes |
|---|---|---|
| id | UUID | Primary key |
| user_id | UUID | Recipient |
| post_id | UUID | Triggering post |
| is_read | BOOLEAN | Default false |
| created_at | TIMESTAMP | |

Row Level Security is enabled on all tables — users can only read/modify their own data.

---

## Getting Started

### Prerequisites
- Flutter SDK ≥ 3.0
- A free [Supabase](https://supabase.com) account

### Setup

1. Clone the repo
```bash
git clone https://github.com/himanshuSoni0516/findify.git
cd findify
```

2. Install dependencies
```bash
flutter pub get
```

3. Add your Supabase credentials in `lib/core/constants.dart`
```dart
static const String supabaseUrl = 'YOUR_SUPABASE_URL';
static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';
```

4. Run the SQL schema in your Supabase SQL Editor and enable RLS policies.

5. Run the app
```bash
flutter run
```

---

## Security

- RLS enforced in Supabase — users can only edit/delete their own posts and profile
- JWT stored locally via `shared_preferences`, sent as `Authorization: Bearer` on every request
- Input validated on the frontend before any API call

---

## Future Scope

- In-app messaging between users
- Multi-college support with email domain verification
- Admin panel for spam moderation
- Push notifications (FCM)
- Item category tags (Electronics, Books, ID Cards, etc.)

---

## Authors

**Himanshu Soni** & **Meet Swarnkar** — BCA 3rd Year, NIBM Nathdwara (2025–26)

- GitHub: [himanshusoni0516](https://github.com/himanshuSoni0516)
- LinkedIn: [Himanshu Soni](https://www.linkedin.com/in/himanshusoni0516/)

---

*Built as a BCA final year project to demonstrate full-stack Flutter development with Supabase.*