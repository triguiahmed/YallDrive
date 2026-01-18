# Car Rental App

## Overview
The Car Rental App is a Flutter-based mobile application designed to facilitate the renting and listing of cars. It follows Clean Architecture principles and leverages Firebase for authentication, data storage, and notifications. The app enables users to search for available cars, book them, and make payments, while also allowing car owners to list their vehicles and manage bookings.

## Features
- **User Authentication:** Firebase Authentication for secure login and sign-up.
- **Car Search:** Search for cars by location using Google API.
- **Booking System:** Users can book available cars, and owners can approve or deny requests.
- **Payments:** Integrated with Razorpay for seamless transactions.
- **Car Registration:** Owners can register their cars for rental.
- **Revenue Tracking:** Owners can check their generated revenue.
- **Notifications:** Firebase Cloud Messaging for real-time updates.

## Tech Stack
- **Flutter** (for cross-platform mobile development)
- **Firebase**
  - Authentication
  - Firestore Database
  - Cloud Storage
  - Cloud Messaging (FCM)
- **Google API** (for location-based car search)
- **Razorpay** (for handling payments)
- **Clean Architecture** (ensuring modularity and maintainability)

## App Flow
The following diagram illustrates the overall flow of the Car Rental App:

![Car Rental App Flow](./pictures/pictures/CarRentalAppFlow.png)

## Database
Firebase DB:

![Database](./pictures/pictures/DB.png)

### User Journey
1. **Login/Register** via Firebase Authentication.
2. **Customer Role:**
   - Access the Customer Home Screen.
   - Search for cars by location.
   - Book an available car.
   - Wait for owner approval.
   - Make payment upon approval.
   - View all bookings.
3. **Owner Role:**
   - Register a car.
   - Approve or deny booking requests.
   - Track revenue generated.

## Screenshots
Below are screenshots of the application displayed side by side:

| Splash Screen | Authentication Home | Sign Up |
|----------------|---------------------|--------|
| ![Splash](./pictures/pictures/01_Splash.png) | ![Auth Home](./pictures/pictures/02_authHome.png) | ![Sign Up](./pictures/pictures/03_signUp.png) |

| Login | Home | Search |
|--------|-------|--------|
| ![Login](./pictures/pictures/04_login.png) | ![Home](./pictures/pictures/05_cHome.png) | ![Search](./pictures/pictures/06_Search.png) |

| Search Results | Car Results | Booking |
|-----------------|------------|--------|
| ![Search Results](./pictures/pictures/07_SearchRes.png) | ![Car Results](./pictures/pictures/08_carRes.png) | ![Booking](./pictures/pictures/09_booking.png) |

| My Bookings | Profile | Edit Profile |
|--------------|---------|--------------|
| ![My Booking](./pictures/pictures/10_myBooking.png) | ![Profile](./pictures/pictures/11_Prof.png) | ![Edit Profile](./pictures/pictures/12_editProf.png) |

| Become Owner | Register Car | Owner Home |
|---------------|--------------|-----------|
| ![Become Owner](./pictures/pictures/13_BecomeOw.png) | ![Register Car](./pictures/pictures/14_register_car.png) | ![Owner Home](./pictures/pictures/15_oHome.png) |

| Owner Booking | Customer Payment | Payment |
|----------------|-----------------|---------|
| ![Owner Booking](./pictures/pictures/16_oBooking.png) | ![Customer Payment](./pictures/pictures/17_cuPay.png) | ![Payment](./pictures/pictures/18_pay.png) |

| Confirmation | Revenue | Help |
|--------------|---------|------|
| ![Confirmation](./pictures/pictures/19_conform.png) | ![Revenue](./pictures/pictures/20_revenue.png) | ![Help](./pictures/pictures/21_help.png) |

| Owner Cars |
|------------|
| ![Owner Cars](./pictures/pictures/22_owcars.png) |

## Installation & Setup
1. Clone the repository:
   ```sh
   git clone https://github.com/your-username/CarRentalApp.git
   cd CarRentalApp
   ```
2. Install dependencies:
   ```sh
   flutter pub get
   ```
3. Configure Firebase:
   - Set up a Firebase project.
   - Enable Authentication (Email/Google Sign-in).
   - Configure Firestore and Cloud Storage.
   - Enable Firebase Cloud Messaging (FCM).
   - Setup AppSecrets googleAPI, RazorpayAPI
4. Run the app:
   ```sh
   flutter run
   ```

## Contribution
Feel free to contribute to the project by submitting issues or pull requests.

## License
This project is licensed under the MIT License.

