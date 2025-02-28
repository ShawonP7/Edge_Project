# Prayer Time App

**Prayer Time App** is a mobile application designed to help users easily access prayer times for nearby mosques based on their location. The app allows imams to update prayer times for their mosques, and muqtadirs (users) can view prayer times for nearby mosques without logging in.

## Features

- **User-friendly Interface**: Clean and intuitive UI with modern design patterns.
- **Prayer Times**: View daily prayer times (Fajr, Dhuhr, Asr, Maghrib, Isha) for nearby mosques.
- **Nearby Mosque Locator**: The app finds and displays nearby mosques based on the user's current location.
- **Mosque Information**: Includes mosque name, description, and location.
- **Imam Dashboard**: Allows imams to update prayer times for their mosques and edit mosque details.
- **Firebase Integration**: User authentication (for imams) and database management for prayer times, mosque details, and locations.

## Tech Stack

- **Flutter**: Used for developing the mobile application.
- **Firebase**: Provides backend services like authentication, database (Firestore), and storage.
- **Google Maps API**: Used for location-based services (finding nearby mosques).
- **Geolocator**: Used for fetching the user's current location.
- **Geocoding**: Converts coordinates to a readable location name.

## Installation

### 1. Clone the repository

```bash
git clone https://github.com/yourusername/prayer-time-app.git
cd prayer-time-app
