# 📍 Favorite Places App (Flutter)

This application allows users to save and manage their **favorite locations**, complete with a title, an image, and geographical details. Built with **Flutter** and **Dart**, the core focus of this project was on **accessing native device features** (Camera and Location), **managing data in a local database**, and mastering complex **state management** for a large, interactive data model.

---

## ✨ Key Features

* **Location Storage:** Users can **add** new places, providing a **title** and capturing a **picture** of the location.
* **Device Integration:** Accesses the **Camera** to allow users to take and store images directly within the app.
* **Geographical Data:** Automatically retrieves and stores the place's **real-time location** (latitude and longitude) upon saving.
* **Interactive Map View:** Displays the saved locations on an **interactive map** (e.g., using the `Maps_flutter` package).
* **Local Data Persistence:** All places are stored securely in a **local SQLite database** on the device, ensuring data persistence.
* **Detailed Views:** Users can tap on a saved place to view its **details**, including the image and a map showing its exact location.

---

## 📚 Learning Objectives & Concepts Practiced

This project provides essential, hands-on experience with advanced Flutter techniques necessary for developing feature-rich applications that heavily rely on device capabilities and structured local data:

* **Accessing Native Device Features:**
    * **Camera Integration:** Using the `image_picker` package to access the device's camera and retrieve image files.
    * **Location Services:** Utilizing the `location` or `geolocator` package to fetch the user's current GPS coordinates.
    * **Map Integration:** Implementing and configuring the `Maps_flutter` package to display and interact with geographical data.

* **Local Database Management (SQLite):**
    * **Data Persistence:** Setting up and managing a local database using the **`sqflite`** package.
    * **CRUD Operations:** Performing **C**reate, **R**ead, **U**pdate, and **D**elete operations on structured data models within the local database.
    * **Database Utility Functions:** Writing functions to connect to, initialize, and query the local database.

* **Advanced State Management (Provider/Riverpod):**
    * **Efficient Data Handling:** Utilizing a robust state management solution (like **Riverpod**) to manage the large collection of places and efficiently update the UI across multiple screens (e.g., the places list, the add screen, and the detail screen).
    * **Asynchronous State:** Managing state that depends on asynchronous operations (like fetching location, taking a picture, or reading/writing to the database).

* **Form Handling and Validation:**
    * Implementing robust forms for capturing the place title and ensuring all required fields (title, image, location) are present before saving.

---

## 📖 Udemy Course Reference

This project was developed as part of the **Flutter & Dart - The Complete Guide [2025 Edition]** course.

**Instructor:** Maximilian Schwarzmüller