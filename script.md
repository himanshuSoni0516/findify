# 📱 Findify : Lost & Found App (College Edition)

### Full-Stack Project Documentation

---

# 🧾 1. Project Overview

**Project Name:** Lost & Found App (College Edition)
**Goal:**
To build a mobile application where students can report lost or found items within their college and connect with each other to recover items.

**Objective:**

* Solve a real-world problem in college environments
* Demonstrate full-stack development skills
* Implement authentication, database, storage, and API integration using REST

---

# 🎯 2. Tech Stack

## Frontend:

* Flutter
* GetX (State Management, Routing, Dependency Injection)

## Backend:

* Supabase (via REST APIs only)

  * Authentication (JWT-based)
  * PostgreSQL Database
  * Storage (for images)

---

# 👥 3. User Roles

### 1. Student (Primary User)

* Can register/login
* Can post lost/found items
* Can browse posts
* Can contact other users
* Can mark items as resolved

---

# 🔄 4. App Flow (High-Level)

1. User installs and opens app
2. Registers or logs in
3. Lands on Home Feed
4. Can:

   * View lost/found items
   * Add new post
   * Filter/search posts
5. Opens post → views details
6. Contacts owner
7. Marks item as resolved

---

# 🧭 5. User Journey

## 🟢 First-Time User:

* Open app → Signup
* Login → Redirect to Home Feed
* Explore posts

## 🔵 Returning User:

* Login → Home Feed
* Scroll/search/filter posts
* Add new post if needed

## 🔴 Lost Item Scenario:

* Click “Add Post”
* Select type: LOST
* Fill details + upload image
* Submit → Post visible to all

## 🟡 Found Item Scenario:

* Add post → select FOUND
* Upload image + location
* Wait for owner to contact

## 🟣 Recovery Flow:

* User contacts post owner
* Item returned
* Owner marks post as “Resolved”

---

# 📌 6. Core Use Cases

## UC-1: User Authentication

* Register with email/password
* provide their basic details like - name, course , semester
* Login with email/password
* Logout

---

## UC-2: Create Post

* Input:

  * Title
  * Description
  * Location (text format)
  * Type (Lost/Found)
  * Image upload
* Save to database

---

## UC-3: View Posts

* Fetch all posts via REST API
* Display in list/grid

---

## UC-4: Filter Posts

* By:

  * Type (Lost / Found)
  * Date

---

## UC-5: Search

* Search by title or keyword

---

## UC-6: View Post Details

* Full information display
* Show contact option

---

## UC-7: Contact Owner

* Show:

  * Name, Email, phone number
    OR
  * In-app messaging (optional enhancement)

---

## UC-8: Mark as Resolved

* Update post status
* Hide or label resolved posts

---

## UC-9: Edit/Delete Post

* Only by post owner

---

# 🗄️ 7. Database Design

## Table: `posts`

| Field       | Type      | Description         |
| ----------- | --------- | ------------------- |
| id          | UUID      | Primary key         |
| user_id     | UUID      | Linked to auth user |
| title       | TEXT      | Item title          |
| description | TEXT      | Details             |
| type        | TEXT      | lost / found        |
| location    | TEXT      | Place               |
| image_url   | TEXT      | Stored image link   |
| is_resolved | BOOLEAN   | Status              |
| created_at  | TIMESTAMP | Created time        |

---

# 🔐 8. API Integration (REST Only)

## Authentication:

* Supabase Auth REST endpoints
* Store JWT token locally

## Database:

* CRUD via Supabase REST API
* Headers:

  * API Key
  * Authorization (Bearer token)

## Storage:

* Upload image → get public URL
* Save URL in DB

---

# 📱 9. App Screens

1. Splash Screen
2. Login / Signup
3. Home Feed
4. Add Post
5. Post Details
6. Profile Screen

---

# 🧠 10. State Management (GetX)

## Controllers:

* AuthController
* PostController
* ProfileController

## Responsibilities:

* API calls
* State updates
* UI binding

---

# ⚡ 11. Additional Features (To Stand Out)

## ⭐ Easy Enhancements:

* Dark Mode 🌙
* Pull-to-refresh
* Image preview before upload
* Loading & error states


---

# 🛡️ 12. Security Considerations

* Row-Level Security (RLS) in Supabase
* Users can:

  * Only edit/delete their posts
* Validate input on frontend

---

# 📈 13. Future Scope

* Multi-college support
* Admin panel
* Report spam posts
* Verification system

---

# 🎯 14. Conclusion

This project:

* Covers complete full-stack development
* Uses modern architecture (Flutter + REST APIs)
* Solves a real-world problem
* Is simple yet impactful

Perfect for:

* College submission
* Resume
* GitHub portfolio

---


**End of Document**
