# YallDrive System Architecture

## Overview
YallDrive is built using **Clean Architecture** capabilities to ensure separation of concerns, testability, and scalability. The application uses **Flutter** for the UI and **Firebase** for the backend (Auth, Firestore, Storage).

## Detailed Layer Structure

### 1. Presentation Layer (`lib/features/*/presentation`)
Responsible for the UI and state management.
*   **Pages**: Flutter Widgets representing screens (e.g., `CarDetail`, `OwnerHome`).
*   **Widgets**: Reusable UI components (e.g., `ReviewCard`, `FavoriteButton`).
*   **BLoC/Cubit**: State management logic. Receives events from the UI and emits states.
    *   *Example:* `ReviewBloc` listens for `AddReviewEvent` and emits `ReviewLoading` -> `ReviewSuccess`.

### 2. Domain Layer (`lib/features/*/domain`)
The inner-most layer. Contains the business logic and is independent of external libraries/frameworks.
*   **Entities**: Pure Dart classes representing core data (e.g., `CarDetails`, `Review`, `Booking`).
*   **Repositories (Interfaces)**: Abstract definitions of how data should be handled (e.g., `ReviewRepository`).
*   **Use Cases**: Specific business actions (e.g., `GetReviewsForCar`, `BookCar`). Single responsibility principle.

### 3. Data Layer (`lib/features/*/data`)
Responsible for data retrieval and manipulation.
*   **Models**: DTOs (Data Transfer Objects) that extend Entities. They handle JSON serialization/deserialization (e.g., `ReviewModel.fromJson`).
*   **Data Sources**:
    *   **Remote**: Direct interaction with Firebase/Firestore.
    *   **Local**: (Optional) Local storage using Hive/SharedPreferences.
*   **Repositories (Implementation)**: Implements the domain repository interfaces, coordinating data sources.

## Dependency Injection
We use `get_it` for service location.
*   **File**: `lib/init_dependencies.dart`
*   Initializes all Repositories, Data Sources, Use Cases, and BLoCs at app startup.

## State Management Flow
1.  User interacts with **UI** (Clicks "Book Now").
2.  UI adds an **Event** to the **BLoC** (`BookingRequested`).
3.  **BLoC** calls the specific **Use Case** (`CreateBooking`).
4.  **Use Case** calls the **Repository Interface**.
5.  **Repository Implementation** calls the **Remote Data Source**.
6.  **Data Source** talks to **Firestore**.
7.  Result flows back up: Data > Repository > Use Case > BLoC.
8.  **BLoC** emits a new **State** (`BookingSuccess`).
9.  **UI** rebuilds to show the confirmation.
