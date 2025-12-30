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

SELECT * FROM Vehicles