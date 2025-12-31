CREATE TYPE UserRole AS ENUM ('Admin', 'Customer');

CREATE TABLE Users (
    user_id SERIAL PRIMARY KEY,
    name VARCHAR(55) NOT NULL,
    email VARCHAR(55) UNIQUE NOT NULL,
    password VARCHAR(55) NOT NULL,
    phone VARCHAR(55),
    role UserRole NOT NULL
    );

INSERT INTO Users (name, email, password, phone, role)
VALUES
('Bob', 'bob@example.com', 'bob123456', '	0987654321', 'Admin'),
('Charlie', 'charlie@example.com', 'charlie123456', '1122334455', 'Customer');

SELECT * FROM Users;

-- Create Vehicle Type and VehicleStatus type
CREATE TYPE VehicleType AS ENUM ('car', 'bike', 'truck');

CREATE TYPE VehicleStatus AS ENUM ('available', 'rented', 'maintenance');

CREATE TABLE Vehicles (
    vehicle_id SERIAL PRIMARY KEY,
    name VARCHAR(55) NOT NULL,
    type VehicleType NOT NULL,
    model VARCHAR(55),
    registration_number VARCHAR(55) UNIQUE NOT NULL,
    rental_price NUMERIC(10,2) NOT NULL CHECK(rental_price >= 0),
    status VehicleStatus NOT NULL
    );

INSERT INTO Vehicles (name, type, model, registration_number, rental_price, status)
VALUES
('Honda Civic', 'car', '2021', 'DEF-456', '60', 'rented'),
('Yamaha R15', 'bike', '2023', 'GHI-789', '30', 'available'),
('Ford F-150', 'truck', '2020', 'JKL-012', '100', 'maintenance');

SELECT * FROM Vehicles;

-- Create BookingStatus type and Booking Table
CREATE TYPE BookingStatus AS ENUM ('pending', 'confirmed', 'completed', 'cancelled');

CREATE TABLE Bookings (
    booking_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES Users(user_id) ON DELETE CASCADE,
    vehicle_id INT NOT NULL REFERENCES Vehicles(vehicle_id) ON DELETE CASCADE,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    status BookingStatus NOT NULL,
    total_cost NUMERIC(10,2) NOT NULL CHECK(total_cost >= 0)
);

INSERT INTO Bookings (user_id, vehicle_id, start_date, end_date, status, total_cost)
VALUES
('1', '1', '2023-11-01', '2023-11-03', 'completed', '120'),
('3', '3', '2023-12-01', '2023-12-02', 'confirmed', '60'),
('1', '3', '2023-12-10', '2023-12-12', 'pending', '100');

SELECT * FROM Bookings;

-- Query 1: JOIN
SELECT booking_id, users.name as customer_name, vehicles.name as vehicle_name, start_date, end_date, bookings.status
FROM bookings
INNER JOIN users ON bookings.user_id = users.user_id
INNER JOIN vehicles ON bookings.vehicle_id = vehicles.vehicle_id;

-- Query 2: EXISTS
SELECT * FROM vehicles v
WHERE NOT EXISTS(
    SELECT * FROM bookings b
    WHERE b.vehicle_id = v.vehicle_id
);

-- Query 3: WHERE
SELECT * FROM vehicles
WHERE "type" = 'car';

-- Query 4: GROUP BY
SELECT vehicles.name as vehicle_name, COUNT(bookings.vehicle_id) as total_bookings
FROM bookings
INNER JOIN vehicles ON bookings.vehicle_id = vehicles.vehicle_id
GROUP BY vehicles.vehicle_id
HAVING COUNT(bookings.vehicle_id) > 2;