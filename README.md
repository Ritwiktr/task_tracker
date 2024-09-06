A Flutter-based mobile application that allows users to track and manage tasks using an SQLite database for persistent storage. The app focuses on providing essential task management features with a clean and functional UI.

Features
Add Tasks: Users can add tasks with the following attributes:

Task name
Description
Due date
View Tasks: A list of all tasks is displayed, sorted by the due date.

Edit Tasks: Users can edit an existing task by clicking on it.

Delete Tasks: Tasks can be removed from the list.

Search Functionality: A search bar is provided to filter tasks based on their name.

Completion Status: Users can mark tasks as complete or incomplete.

Persistent Storage: Task data is saved using SQLite to ensure persistence across app sessions.

Bonus Features (Optional)
Due Today Notification: Users receive local notifications when a task is due today.
Task Categorization: Users can categorize tasks (e.g., Work, Personal, etc.) and filter by category.
Technology Stack
Flutter: For building the mobile app for both iOS and Android.
SQLite: Used for persistent storage of tasks.
Provider: State management is handled using the Provider package.

Requirements
The UI is clean and intuitive, focusing more on functionality and the use of SQLite for data persistence.
The app runs smoothly on both Android and iOS simulators or devices.
Notifications and task categorization are optional features but enhance the user experience.
Getting Started
To run this project locally:

Clone the repository:

git clone <repository-link>

Navigate to the project directory:


cd task_tracker

Install the dependencies:

flutter pub get

Run the app:

flutter run


Approach
In building this app, I focused on:

Implementing all core functionalities using SQLite for persistent storage.
Ensuring smooth state management using the Provider package.
Testing the app on both Android and iOS simulators to confirm cross-platform compatibility.


Contributing
Feel free to contribute by submitting issues or pull requests.

License
This project is licensed under the MIT License.