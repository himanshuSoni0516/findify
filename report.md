# Findify - Lost and Found App Project Report

## 1. Introduction
**Findify** is a mobile application designed specifically for college campuses to help students find lost items or return found belongings. The app provides a centralized platform for reporting lost and found items, browsing through a feed of reported items, and receiving notifications when potential matches are found.

## 2. Tech Stack
The project is built using modern cross-platform development tools:
- **Frontend Framework:** Flutter (Dart)
- **State Management:** GetX
- **Backend-as-a-Service:** Supabase
- **Architecture:** Controller-Model-View (CMV) with GetX bindings.
- **Networking:** `http` package for RESTful communication with Supabase.
- **Local Storage:** `shared_preferences` (via `StorageService`) for session management.

---

## 3. App Features and Functionality

### A. User Authentication & Profile
- **Secure Signup/Login:** Users can create accounts using their college email and password.
- **Profile Management:** Each user has a profile containing their name, course, semester, and contact information (stored in Supabase `profiles` table).
- **Session Persistence:** Uses JWT tokens and Refresh Tokens to keep users logged in across app restarts.
- **Auto-Login:** The splash screen automatically checks for valid sessions and refreshes them if necessary.

### B. Lost & Found Feed
- **Global Feed:** Displays all active lost and found reports in reverse chronological order.
- **Filtering:** Users can filter the feed by 'Lost' or 'Found' categories.
- **Search:** Real-time search functionality allows users to find items by title, description, or location.
- **Skeleton Loaders:** Provides a smooth user experience while data is being fetched from the backend.

### C. Post Management
- **Create Post:** Users can report a lost or found item by providing a title, description, location, and uploading an optional image.
- **Image Upload:** Integrated with Supabase Storage to store and serve item images.
- **My Posts:** Users can view and manage their own reports from the Profile screen.
- **Resolve Posts:** When an item is found or returned, the owner can mark it as 'Resolved' to inform others.
- **Delete Posts:** Users have full control over their posts and can remove them at any time.

### D. Notifications
- **Real-time Updates:** The app polls the backend every 15 seconds to check for new notifications.
- **Unread Count:** A notification badge on the home screen shows the count of unread alerts.
- **Mark as Read:** Users can mark individual notifications or all notifications as read.

### E. UI/UX Features
- **Glassmorphism Design:** Modern UI with translucent navigation bars and containers.
- **Dynamic Theming:** Supports Light, Dark, and System-based themes.
- **Splash Screen:** Branded entry point with smooth auth-state transitions.
- **Responsive Layouts:** Designed to work across various screen sizes.

---

## 4. Backend-Frontend Integrity

The app maintains a robust connection with the Supabase backend through several layers:

### I. API Client (`lib/core/api_client.dart`)
A centralized wrapper for all HTTP requests. It automatically injects authentication headers (JWT) for protected routes and handles common REST methods like `GET`, `POST`, `PATCH`, and `DELETE`.

### II. Supabase Integration
- **Auth:** Utilizes Supabase Auth for user management and secure login.
- **Database:** Uses Supabase's PostgreSQL-based REST API to interact with `posts`, `profiles`, and `notifications` tables.
- **Storage:** Uses Supabase Storage buckets to store images uploaded by users.

### III. Models (`lib/models/`)
Strongly typed Dart models (`UserModel`, `PostModel`, `NotificationModel`) ensure data consistency. They include `fromJson` and `toJson` methods for easy serialization.

### IV. Controllers (`lib/controllers/`)
Controllers act as the bridge between the UI and the Backend:
- `AuthController`: Manages user lifecycle and session tokens.
- `PostController`: Handles CRUD operations for posts and filtering logic.
- `NotificationController`: Manages notification state and polling.

---

## 5. Folder Structure and File Details

### `lib/core/`
- `api_client.dart`: Centralized HTTP request handler.
- `app_theme.dart`: Defines light/dark themes and gradients.
- `constants.dart`: Stores Supabase URLs, keys, and API endpoints.
- `storage_service.dart`: Handles local persistence of tokens and user IDs.

### `lib/models/`
- `user_model.dart`: Structure for user profile data.
- `post_model.dart`: Structure for lost/found item reports.
- `notification_model.dart`: Structure for user notifications.

### `lib/controllers/`
- `auth_controller.dart`: Business logic for login, signup, and session refresh.
- `post_controller.dart`: Logic for fetching, creating, and filtering posts.
- `notification_controller.dart`: Logic for notification management and polling.
- `theme_controller.dart`: Manages app-wide theme switching.

### `lib/screens/`
- `splash_screen.dart`: Initial loading and auth check screen.
- `login_screen.dart` / `signup_screen.dart`: User onboarding and authentication.
- `home_screen.dart`: Main feed with search and filtering.
- `profile_screen.dart`: User's own posts and profile details.
- `add_post_screen.dart`: Form to create a new lost/found report.
- `post_detail_screen.dart`: Detailed view of a specific item report.
- `notifications_screen.dart`: List of all user notifications.
- `about_screen.dart`: App version and developer information.

### `lib/screens/widgets/`
Contains reusable UI components like `PostCard`, `GlassNavBar`, `FilterBar`, and `SkeletonLoader`.

---

## 6. Conclusion
Findify is a comprehensive solution for campus-based lost and found management. By leveraging Flutter and Supabase, it provides a fast, secure, and visually appealing experience for students. The modular architecture ensures that the app is scalable and easy to maintain for future enhancements like real-time chat between users.
