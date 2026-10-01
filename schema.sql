-- ============================================================
-- QuickStay Hotel Booking System - MySQL Database Schema
-- Production Ready Relational Schema
-- Compatible with MySQL 5.7+ / 8.0+ / MariaDB
-- ============================================================

CREATE DATABASE IF NOT EXISTS `quickstay_db` 
CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

USE `quickstay_db`;

-- 1. USERS & USER PROFILES
-- ============================================================
CREATE TABLE IF NOT EXISTS `users` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `username` VARCHAR(150) NOT NULL UNIQUE,
    `first_name` VARCHAR(150) NOT NULL,
    `last_name` VARCHAR(150) NOT NULL,
    `email` VARCHAR(254) NOT NULL UNIQUE,
    `password` VARCHAR(255) NOT NULL,
    `is_staff` TINYINT(1) DEFAULT 0,
    `is_superuser` TINYINT(1) DEFAULT 0,
    `date_joined` DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `user_profiles` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `user_id` INT NOT NULL UNIQUE,
    `phone` VARCHAR(20) DEFAULT NULL,
    `address` VARCHAR(255) DEFAULT NULL,
    `city` VARCHAR(100) DEFAULT NULL,
    `country` VARCHAR(100) DEFAULT 'India',
    `avatar_url` VARCHAR(500) DEFAULT NULL,
    `is_hotel_manager` TINYINT(1) DEFAULT 0,
    `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT `fk_profile_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB;

-- 2. AMENITIES
-- ============================================================
CREATE TABLE IF NOT EXISTS `amenities` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(100) NOT NULL UNIQUE,
    `icon` VARCHAR(50) DEFAULT 'fa-check',
    `category` VARCHAR(50) DEFAULT 'General'
) ENGINE=InnoDB;

-- 3. HOTELS
-- ============================================================
CREATE TABLE IF NOT EXISTS `hotels` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(200) NOT NULL,
    `slug` VARCHAR(220) NOT NULL UNIQUE,
    `tagline` VARCHAR(255) DEFAULT NULL,
    `description` TEXT NOT NULL,
    `address` VARCHAR(255) NOT NULL,
    `city` VARCHAR(100) NOT NULL,
    `state` VARCHAR(100) DEFAULT NULL,
    `country` VARCHAR(100) DEFAULT 'India',
    `postal_code` VARCHAR(20) DEFAULT NULL,
    `star_rating` TINYINT UNSIGNED DEFAULT 4,
    `featured_image` VARCHAR(500) NOT NULL,
    `price_per_night_start` DECIMAL(10, 2) NOT NULL DEFAULT 2999.00,
    `check_in_time` VARCHAR(20) DEFAULT '14:00',
    `check_out_time` VARCHAR(20) DEFAULT '11:00',
    `is_featured` TINYINT(1) DEFAULT 0,
    `latitude` DECIMAL(9, 6) DEFAULT 15.299300,
    `longitude` DECIMAL(9, 6) DEFAULT 74.124000,
    `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
    `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX `idx_hotel_city` (`city`),
    INDEX `idx_hotel_price` (`price_per_night_start`),
    INDEX `idx_hotel_stars` (`star_rating`)
) ENGINE=InnoDB;

-- Hotel to Amenities Junction Table
CREATE TABLE IF NOT EXISTS `hotel_amenities` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `hotel_id` INT NOT NULL,
    `amenity_id` INT NOT NULL,
    UNIQUE KEY `unique_hotel_amenity` (`hotel_id`, `amenity_id`),
    CONSTRAINT `fk_ha_hotel` FOREIGN KEY (`hotel_id`) REFERENCES `hotels` (`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_ha_amenity` FOREIGN KEY (`amenity_id`) REFERENCES `amenities` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB;

-- Hotel Images Gallery
CREATE TABLE IF NOT EXISTS `hotel_images` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `hotel_id` INT NOT NULL,
    `image_url` VARCHAR(500) NOT NULL,
    `caption` VARCHAR(150) DEFAULT NULL,
    `is_primary` TINYINT(1) DEFAULT 0,
    CONSTRAINT `fk_hi_hotel` FOREIGN KEY (`hotel_id`) REFERENCES `hotels` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB;

-- 4. ROOMS
-- ============================================================
CREATE TABLE IF NOT EXISTS `rooms` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `hotel_id` INT NOT NULL,
    `name` VARCHAR(150) NOT NULL,
    `room_type` VARCHAR(50) DEFAULT 'Deluxe',
    `price_per_night` DECIMAL(10, 2) NOT NULL,
    `capacity_adults` SMALLINT UNSIGNED DEFAULT 2,
    `capacity_children` SMALLINT UNSIGNED DEFAULT 1,
    `bed_type` VARCHAR(100) DEFAULT '1 Extra-large double bed',
    `room_size_sqft` INT UNSIGNED DEFAULT 350,
    `total_rooms` INT UNSIGNED DEFAULT 10,
    `available_rooms` INT UNSIGNED DEFAULT 10,
    `amenities_list` VARCHAR(255) DEFAULT 'Free WiFi, AC, TV, En-suite Bathroom',
    `image_url` VARCHAR(500) DEFAULT NULL,
    `free_cancellation` TINYINT(1) DEFAULT 1,
    `breakfast_included` TINYINT(1) DEFAULT 1,
    `description` TEXT DEFAULT NULL,
    CONSTRAINT `fk_room_hotel` FOREIGN KEY (`hotel_id`) REFERENCES `hotels` (`id`) ON DELETE CASCADE,
    INDEX `idx_room_hotel` (`hotel_id`),
    INDEX `idx_room_price` (`price_per_night`)
) ENGINE=InnoDB;

-- 5. BOOKINGS
-- ============================================================
CREATE TABLE IF NOT EXISTS `bookings` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `booking_reference` VARCHAR(20) NOT NULL UNIQUE,
    `user_id` INT NOT NULL,
    `hotel_id` INT NOT NULL,
    `room_id` INT NOT NULL,
    `check_in` DATE NOT NULL,
    `check_out` DATE NOT NULL,
    `guests_count` SMALLINT UNSIGNED DEFAULT 2,
    `rooms_count` SMALLINT UNSIGNED DEFAULT 1,
    `nights` INT UNSIGNED DEFAULT 1,
    `base_amount` DECIMAL(10, 2) NOT NULL,
    `tax_amount` DECIMAL(10, 2) DEFAULT 0.00,
    `total_amount` DECIMAL(10, 2) NOT NULL,
    `guest_name` VARCHAR(150) NOT NULL,
    `guest_email` VARCHAR(254) NOT NULL,
    `guest_phone` VARCHAR(20) NOT NULL,
    `special_requests` TEXT DEFAULT NULL,
    `status` ENUM('Pending', 'Confirmed', 'Cancelled', 'Completed') DEFAULT 'Confirmed',
    `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT `fk_booking_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_booking_hotel` FOREIGN KEY (`hotel_id`) REFERENCES `hotels` (`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_booking_room` FOREIGN KEY (`room_id`) REFERENCES `rooms` (`id`) ON DELETE CASCADE,
    INDEX `idx_booking_ref` (`booking_reference`),
    INDEX `idx_booking_dates` (`check_in`, `check_out`),
    INDEX `idx_booking_status` (`status`)
) ENGINE=InnoDB;

-- 6. REVIEWS
-- ============================================================
CREATE TABLE IF NOT EXISTS `reviews` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `hotel_id` INT NOT NULL,
    `user_id` INT NOT NULL,
    `booking_id` INT DEFAULT NULL,
    `rating` DECIMAL(3, 1) DEFAULT 9.0,
    `cleanliness` DECIMAL(3, 1) DEFAULT 9.0,
    `comfort` DECIMAL(3, 1) DEFAULT 9.0,
    `location` DECIMAL(3, 1) DEFAULT 9.0,
    `staff` DECIMAL(3, 1) DEFAULT 9.0,
    `value_for_money` DECIMAL(3, 1) DEFAULT 8.5,
    `title` VARCHAR(150) NOT NULL,
    `comment` TEXT NOT NULL,
    `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT `fk_review_hotel` FOREIGN KEY (`hotel_id`) REFERENCES `hotels` (`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_review_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_review_booking` FOREIGN KEY (`booking_id`) REFERENCES `bookings` (`id`) ON DELETE SET NULL,
    INDEX `idx_review_hotel` (`hotel_id`)
) ENGINE=InnoDB;

-- 7. PAYMENTS
-- ============================================================
CREATE TABLE IF NOT EXISTS `payments` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `booking_id` INT NOT NULL UNIQUE,
    `transaction_id` VARCHAR(50) NOT NULL UNIQUE,
    `payment_method` ENUM('Credit Card', 'Debit Card', 'UPI / QR Code', 'Net Banking', 'Pay at Hotel') DEFAULT 'Credit Card',
    `amount` DECIMAL(10, 2) NOT NULL,
    `status` ENUM('Pending', 'Success', 'Failed', 'Refunded') DEFAULT 'Success',
    `payment_date` DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT `fk_payment_booking` FOREIGN KEY (`booking_id`) REFERENCES `bookings` (`id`) ON DELETE CASCADE,
    INDEX `idx_payment_txn` (`transaction_id`)
) ENGINE=InnoDB;

-- 8. WISHLIST / FAVORITES
-- ============================================================
CREATE TABLE IF NOT EXISTS `wishlists` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `user_id` INT NOT NULL,
    `hotel_id` INT NOT NULL,
    `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY `unique_user_hotel_wishlist` (`user_id`, `hotel_id`),
    CONSTRAINT `fk_wishlist_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_wishlist_hotel` FOREIGN KEY (`hotel_id`) REFERENCES `hotels` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB;

-- SAMPLE SEED DATA FOR TESTING / VIVA DEMO
-- ============================================================
INSERT INTO `amenities` (`name`, `icon`, `category`) VALUES
('Free High-Speed WiFi', 'wifi', 'Internet'),
('Swimming Pool', 'pool', 'Leisure'),
('Spa & Wellness Center', 'spa', 'Wellness'),
('Free Breakfast', 'utensils', 'Dining'),
('Air Conditioning', 'snowflake', 'Comfort'),
('Fitness Center & Gym', 'dumbbell', 'Fitness'),
('Airport Shuttle Service', 'shuttle-van', 'Transport'),
('Restaurant & Sky Lounge', 'wine-glass', 'Dining'),
('Free Valet Parking', 'car', 'Parking'),
('24/7 Front Desk & Concierge', 'concierge-bell', 'Service');
