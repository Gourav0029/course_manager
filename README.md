📘 Course Manager – Flutter App

A simple and clean Flutter application to manage courses with category filtering, search functionality, offline storage, and a beginner-friendly clean architecture.
This project was built as part of a company mobile developer screening assignment.

🚀 Features

📚 Course Management:
Add a new course
Edit existing courses
View detailed course information
Delete courses
Auto-calculated score: score = title length × number of lessons

🏷 Category Management:
Fetch categories from MockAPI
Cache categories for offline usage
Category filtering using chips
Smooth UI updates using GetX

🔍 Search & Filtering:
Search by title or description
Filter courses by category
Smart sorting (highest score first)

📴 Offline Support:
Courses saved locally using SharedPreferences
Categories cached and reused when offline

🎨 UI/UX:
Clean and modern UI
Loading indicators
Empty states
Responsive layout for different screen sizes

🧱 Project Structure:
lib/
 ├── controllers/        # GetX controllers (business logic)
 ├── models/             # Data models
 ├── screens/            # UI screens
 ├── services/           # API + Local Storage
 ├── widgets/            # Reusable widgets
 └── utils/              # Constants, keys, API URLs

 🧰 Tech Stack
Flutter
Dart
GetX (state management + routing + DI)
SharedPreferences (local storage)
MockAPI (remote categories data)
Clean Architecture


🌐 API Details
GET Categories
Endpoint:
https://693ab3d49b80ba7262cb03d0.mockapi.io/api/v1/categories
Sample Response:
[
  {"id": "1", "name": "Programming"},
  {"id": "2", "name": "Design"},
  {"id": "3", "name": "Data Science"},
  {"id": "4", "name": "Machine Learning"},
  {"id": "5", "name": "Artificial Intelligence"}
]

🛠 Setup Instructions
Follow these steps to run the project locally:

1️⃣ Clone the repository
git clone https://github.com/Gourav0029/course_manager.git
cd course_manager

2️⃣ Install dependencies
flutter pub get

3️⃣ Run the project
flutter run

📱 Screens Included:
Home Screen
Search + category filter + list of courses

Add/Edit Screen
Form to create or update a course

Details Screen
Shows full course information

Empty / Loading States
Displayed when no data or during API calls

🧪 Testing Offline Mode:
Turn off WiFi / Data
App will load cached categories
Courses will still work because they are stored locally
Reconnect internet → pull to refresh to update categories.