# QuickStay - Modern Hotel Booking Platform

A full-stack, enterprise-grade hotel reservation web application inspired by **Booking.com**, built using **Python Django**, **MySQL**, and a **custom responsive CSS design system**.

Engineered with clean architectural standards, relational database schema, user authentication, inventory tracking, faceted search & filtering, wishlist favoriting, Google SEO optimization (Rich Snippets, Sitemap, Robots.txt), and an online booking checkout lifecycle with printable vouchers.

---

## 🌟 Key Features

### 1. Home Page & Discovery
- **Hero Section**: Booking.com-inspired navy-blue aesthetic with header and subtext.
- **Interactive Search Bar**: Filter by destination city (Goa, Mumbai, Jaipur, Manali, Bengaluru, Kerala), check-in date, check-out date, and guest count.
- **Genius Loyalty Rewards Banner**: Highlight member discounts and perks.
- **Trending Destinations**: Destination cards with property counts and high-res imagery.
- **Featured Luxury Hotels**: Curated properties with ratings, star counts, starting prices, and instant wishlist toggles.
- **Value Proposition**: Free cancellation, 24/7 support, verified reviews, and price match guarantees.

### 2. Search & Hotel Listings (`/hotels/`)
- **Faceted Sidebar Filters**:
  - Min/Max budget sliders (per night).
  - Star ratings (5★, 4★, 3★, 2★).
  - Amenities (WiFi, Pool, Spa, Gym, AC, Airport Shuttle, Parking, etc.).
- **Sorting Options**: Recommended, Price (low to high), Price (high to low), Star rating (5 to 1).
- **Responsive Hotel Cards**:
  - Cover photo with high-res zoom.
  - Review score badges (e.g. `9.5 Exceptional · 28 reviews`).
  - Stay duration calculations (nights x guests).
  - Direct "See availability" CTA.

### 3. Hotel Details Page (`/hotels/<slug>/`)
- **Photo Gallery**: Hero cover photo + 4-image grid with hover zoom.
- **Property Highlights**: Cleanliness scores, location ratings, and staff ratings.
- **Room Types Inventory**: Deluxe King Room, Executive Suite, Ocean Villa, Family Studio with capacity, bed configurations, square footage, and amenities.
- **Interactive Location Map View**: Stylized visual map representation with nearby landmarks.
- **Property Policies**: Check-in/out hours, pet guidelines, cancellation terms.
- **Guest Reviews & Metrics**: Progress meters for Cleanliness, Comfort, Location, Staff, and Value for Money.
- **Verified Review Submission**: Authenticated guests can submit their own ratings and reviews.

### 4. Booking & Payment Lifecycle (`/book/<room_id>/`)
- **Step 1: Room Selection & Stay Dates**: Real-time calculation of nights, base price, and 12% GST tax.
- **Step 2: Guest Details & Special Requests**: Guest contact details, phone, and optional stay requests.
- **Step 3: Payment Simulation**:
  - Credit / Debit Card (with interactive card number, expiry, CVV fields).
  - UPI / QR Code (Google Pay, PhonePe, Paytm simulation).
  - Net Banking.
  - Pay at Hotel.
- **Step 4: Booking Confirmation Invoice (`/booking/confirmation/<id>/`)**:
  - Unique reservation reference code (e.g. `QS-2026-6587AE`).
  - Printable check-in pass with express QR code.
  - Itemized receipt showing tax breakdown and transaction reference.
  - One-click print/download voucher button.

### 5. User Authentication & Dashboard (`/dashboard/`)
- User Sign Up, Login, and Logout with automatic profile creation.
- **My Bookings Tab**: Active, past, and cancelled reservations with one-click cancellation.
- **Saved Wishlist Tab**: Saved favorite stays with instant availability check.
- **Profile Settings Tab**: Manage personal contact details, street address, and profile avatar.

### 6. Custom Admin Management Portal (`/admin-portal/`)
- Key Performance Indicators (KPIs): Total Hotels, Total Rooms, Total Bookings, Total Revenue.
- Hotel Management: Add new hotels, update rates, upload photos, manage amenities.
- Room Inventory: Manage room types, bed setups, and room availability.
- Guest Reservations: Monitor real-time bookings and update status (`Confirmed`, `Completed`, `Cancelled`).
- Built-in Django Admin also accessible at `/admin/`.

---

## 🛠️ Technology Stack

| Layer | Technology |
|---|---|
| **Frontend** | HTML5, CSS3 (Custom Design System, Zero external UI bloat), Vanilla JavaScript |
| **Backend** | Python 3.13, Django 6.1.1 |
| **Database** | MySQL (with seamless SQLite out-of-the-box fallback) |
| **Design Language** | Booking.com blue palette (`#003580`, `#006ce4`, `#febb02`) |
| **Typography** | Plus Jakarta Sans, FontAwesome 6 |

---

## 🗄️ Database Architecture

The project features a fully normalized relational schema:

1. **`Users` / `UserProfile`**: Stores user authentication credentials, phone, address, avatar, and role.
2. **`Hotels`**: Property details, address, city, star rating, cover image, starting price, coordinates.
3. **`HotelImages`**: Gallery photos per hotel (`1:N`).
4. **`Amenities`**: Hotel and room amenities linked via many-to-many junction (`N:M`).
5. **`Rooms`**: Room types, pricing, capacity, inventory count, available units (`1:N` with Hotels).
6. **`Bookings`**: Reservation dates, nights, guests, total pricing, status, and unique references (`1:N` with Users, Hotels, Rooms).
7. **`Reviews`**: Guest feedback, comments, and itemized sub-ratings (Cleanliness, Comfort, Location, Staff, Value).
8. **`Payments`**: Transaction IDs, payment method, amounts, and statuses (`1:1` with Bookings).
9. **`Wishlists`**: User favorite properties (`N:M` between Users and Hotels).

> 💡 **For College Lab / Viva Presentations**: A complete raw SQL file is included at [`schema.sql`](file:///C:/Users/l/.gemini/antigravity-ide/scratch/quickstay/schema.sql) containing all table creation DDL, foreign keys, indexes, and sample inserts!

---

## 🚀 Getting Started

### 1. Clone or Open the Project Directory
```powershell
cd C:\Users\l\.gemini\antigravity-ide\scratch\quickstay
```

### 2. Activate Virtual Environment
```powershell
.\.venv\Scripts\Activate.ps1
```

### 3. Database Setup

#### Option A: Immediate One-Click Run (Default SQLite)
The application works immediately out-of-the-box with zero database configuration.

#### Option B: Connecting to MySQL
To connect to MySQL (e.g., MySQL Workbench, XAMPP, or MariaDB):
1. Create database in MySQL:
   ```sql
   CREATE DATABASE quickstay_db CHARACTER SET utf8mb4;
   ```
2. Set environment variables (or adjust in `quickstay_core/settings.py`):
   ```powershell
   $env:USE_MYSQL="1"
   $env:DB_NAME="quickstay_db"
   $env:DB_USER="root"
   $env:DB_PASSWORD="your_password"
   $env:DB_HOST="127.0.0.1"
   $env:DB_PORT="3306"
   ```
3. Run migrations:
   ```powershell
   python manage.py migrate
   ```

### 4. Load Seed Data (Hotels, Rooms, Reviews, Demo Users)
Run the custom seed command to populate the database with realistic stays across Goa, Mumbai, Jaipur, Manali, Bengaluru, and Kerala:
```powershell
python manage.py seed_data
```

### 5. Start the Development Server
```powershell
python manage.py runserver 127.0.0.1:8000
```
Open **[http://127.0.0.1:8000](http://127.0.0.1:8000)** in your browser.

---

## 🔑 Demo Login Accounts

| Role | Username | Password | Notes |
|---|---|---|---|
| **Regular User** | `john_doe` | `password123` | Pre-loaded with upcoming & past bookings, wishlist items, and profile details |
| **Admin / Manager** | `admin` | `admin123` | Full access to `/admin-portal/` and Django system `/admin/` |

> *Tip: The Login page features 1-click quick-fill buttons for both demo accounts!*
