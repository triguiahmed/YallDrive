# Firestore Database Schema

## 1. Users Collection (`users`)
*   `id` (string): Unique Auth ID.
*   `email` (string): User email.
*   `name` (string): Display name.
*   `role` (string): 'owner' or 'customer'.
*   `fcmtoken` (string): Firebase Cloud Messaging token for notifications.

## 2. Cars Collection (`cars`)
*   `carNumber` (string): Primary Key / License plate.
*   `ownerId` (string): Ref to `users.id`.
*   `make` (string): Transformed from name often or stored as part of details.
*   `carName` (string): E.g., Toyota Camry.
*   `pricePerDay` (number): Daily rental price.
*   `location` (string): City/Area.
*   `carImage` (string): URL from Firebase Storage
*   `isBooked` (boolean).

## 3. Bookings Collection (`bookings`)
*   `id` (string): Auto-generated.
*   `carNo` (string): Ref to `cars.carNumber`.
*   `userId` (string): Ref to `users.id` (Customer).
*   `ownerId` (string): Ref to `users.id`.
*   `startDate` (timestamp).
*   `endDate` (timestamp).
*   `price` (number): Total price.
*   `status` (string): 'Pending', 'Approved', 'Denied'.
*   `isApproved` (boolean).

## 4. Reviews Collection (`reviews`)
*   `id` (string): Auto-generated.
*   `carNo` (string): Ref to `cars.carNumber`.
*   `userId` (string): Ref to `users.id` (Author).
*   `rating` (number): 1-5.
*   `comment` (string).
*   `createdAt` (timestamp).

## 5. Favorites Collection (`favorites`)
*   `id` (string): Auto-generated.
*   `userId` (string): Ref to `users.id`.
*   `carNo` (string): Ref to `cars.carNumber`.
*   `createdAt` (timestamp).

## 6. Payments Collection (`payments`)
*   `id` (string): Auto-generated.
*   `bookingId` (string): Ref to `bookings.id`.
*   `userId` (string): Payer.
*   `amount` (number).
*   `status` (string): 'pending', 'succeeded', 'failed'.
*   `createdAt` (timestamp).
