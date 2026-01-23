# Work Division Plan (Tour of Duty)

This document outlines a proposed work division for a team of 6 developers working on the YallDrive project. The division is based on the Clean Architecture structure (`lib/features/`) to minimize merge conflicts and ensure clear responsibilities.

## 👥 Person 1: Authentication & User Management
**Focus**: User Onboarding, Identity, and Profile Settings.

*   **Features**:
    *   **Sign Up & Login**: Implement UI and Logic for Email/Password auth.
    *   **Role Selection**: Handle logic for choosing "Owner" vs "Customer".
    *   **Profile Management**: Edit Name, Email, Phone. Upload Profile Picture.
    *   **Splash Screen**: App initialization logic.
*   **Codebase Areas**:
    *   `lib/features/auth/`
    *   `lib/features/splash/`
    *   `lib/features/profile/` (Profile editing parts)
*   **Backend**: Firebase Auth, `users` collection.

## 👥 Person 2: Car Management (Owner Side)
**Focus**: The "Supply" side of the marketplace. Managing the assets.

*   **Features**:
    *   **Register Car**: Form validation, Image picking/uploading (handling the optional image logic).
    *   **My Cars List**: Screen for owners to view their fleet.
    *   **Owner Dashboard**: Layout and Stats (Car count, active headers).
*   **Codebase Areas**:
    *   `lib/features/register/` (RegisterCar use cases & UI)
    *   `lib/features/profile/presentation/pages/owner/` (OwnerHome, OwnerCars)
*   **Backend**: `cars` collection, Firebase Storage.

## 👥 Person 3: Booking System (Core Logic)
**Focus**: The Transactional logic. Connecting Supply with Demand.

*   **Features**:
    *   **Booking Request**: Customer UI for selecting dates and sending requests.
    *   **Request Management**: Owner UI for receiving, approving, or denying requests.
    *   **Status Logic**: Handling state transitions (Pending -> Approved/Denied).
    *   **Conflict Checking**: Preventing double bookings for the same dates.
*   **Codebase Areas**:
    *   `lib/features/booking/`
    *   `lib/features/profile/presentation/pages/owner/owner_booking_request.dart`
*   **Backend**: `bookings` collection.

## 👥 Person 4: Discovery, Search & Reviews
**Focus**: The "Demand" side experience. Finding and evaluating cars.

*   **Features**:
    *   **Customer Home**: Display available cars.
    *   **Search & Filter**: Filter cars by location.
    *   **Car Details**: The detailed view of a car (connecting with Reviews).
    *   **Reviews**: Add Review, View Reviews, Star Rating component.
*   **Codebase Areas**:
    *   `lib/features/register/` (Read operations: GetAllCars, GetCarsByLocation)
    *   `lib/features/review/`
    *   `lib/features/register/presentation/pages/car_detail.dart`
*   **Backend**: `reviews` collection, specific complex queries on `cars`.

## 👥 Person 5: Payments & Revenue
**Focus**: Financial transactions and earnings.

*   **Features**:
    *   **Payment Setup**: Integration with Payment Gateway (Stripe).
    *   **Checkout**: Process payment for approved bookings.
    *   **Payment History**: List of past transactions.
    *   **Revenue Tracking**: Owner view of earnings.
*   **Codebase Areas**:
    *   `lib/features/payment/`
    *   `lib/features/profile/presentation/pages/owner/owner_revenue.dart`
*   **Backend**: `payments` collection.

## 👥 Person 6: Engagement, Support & Notifications
**Focus**: User retention, help, and timely updates.

*   **Features**:
    *   **Favorites**: Toggle functionality and "Saved Cars" screen.
    *   **AI Support Chat**: Customer Help screen with Chatbot integration (Groq/Llama).
    *   **Notifications**: Triggering Push Notifications on booking status changes.
*   **Codebase Areas**:
    *   `lib/features/favorites/`
    *   `lib/features/notification/`
    *   `lib/features/profile/presentation/pages/customer/customer_help.dart`
*   **Backend**: `favorites` collection, Cloud Functions (if using), External AI API APIs.
