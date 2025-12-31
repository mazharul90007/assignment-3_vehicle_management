## 🧱 Vehicle Rental Database Design & SQL Quries

### Entities

- **Users** – system users (Admin, Customer)
- **Vehicles** – rentable vehicles
- **Bookings** – rental records connecting users and vehicles

### Relationships

- One **User** → many **Bookings**
- One **Vehicle** → many **Bookings** / many **Bookings** → one **Vehicle**

---

## 🧩 ENUM Types Used

The project uses PostgreSQL `ENUM` types to ensure data integrity:

- `UserRole` → `Admin`, `Customer`
- `VehicleType` → `car`, `bike`, `truck`
- `VehicleStatus` → `available`, `rented`, `maintenance`
- `BookingStatus` → `pending`, `confirmed`, `completed`, `cancelled`

---

## 🗂️ Entity Relationship Diagram (ERD)

<p align="center">
  <img src="https://res.cloudinary.com/dp6urj3gj/image/upload/v1767186674/assignment3_lerz4r.png" alt="BD-Destination ER Diagram" width="700"/>
</p>

---

## 📊 Tables Overview

### Users Table

| Column   | Type        | Constraints      |
| -------- | ----------- | ---------------- |
| user_id  | SERIAL      | Primary Key      |
| name     | VARCHAR(55) | NOT NULL         |
| email    | VARCHAR(55) | UNIQUE, NOT NULL |
| password | VARCHAR(55) | NOT NULL         |
| phone    | VARCHAR(55) | Optional         |
| role     | UserRole    | NOT NULL         |

---

### Vehicles Table

| Column              | Type          | Constraints      |
| ------------------- | ------------- | ---------------- |
| vehicle_id          | SERIAL        | Primary Key      |
| name                | VARCHAR(55)   | NOT NULL         |
| type                | VehicleType   | NOT NULL         |
| model               | VARCHAR(55)   | Optional         |
| registration_number | VARCHAR(55)   | UNIQUE, NOT NULL |
| rental_price        | NUMERIC(10,2) | CHECK ≥ 0        |
| status              | VehicleStatus | NOT NULL         |

---

### Bookings Table

| Column     | Type          | Constraints            |
| ---------- | ------------- | ---------------------- |
| booking_id | SERIAL        | Primary Key            |
| user_id    | INT           | FK → Users, CASCADE    |
| vehicle_id | INT           | FK → Vehicles, CASCADE |
| start_date | DATE          | NOT NULL               |
| end_date   | DATE          | NOT NULL               |
| status     | BookingStatus | NOT NULL               |
| total_cost | NUMERIC(10,2) | CHECK ≥ 0              |

---

## 📌 Create Enum & Table Implemented SQL Queries

### 1️⃣ Create UserRole Enum

```sql
CREATE TYPE UserRole AS ENUM ('Admin', 'Customer');
```

### 2️⃣ Create Users Table

```sql
CREATE TABLE Users (
    user_id SERIAL PRIMARY KEY,
    name VARCHAR(55) NOT NULL,
    email VARCHAR(55) UNIQUE NOT NULL,
    password VARCHAR(55) NOT NULL,
    phone VARCHAR(55),
    role UserRole NOT NULL
    );
```

### 3️⃣ Insert Data into Users table

```sql
INSERT INTO Users (name, email, password, phone, role)
VALUES
('Bob', 'bob@example.com', 'bob123456', '	0987654321', 'Admin'),
('Charlie', 'charlie@example.com', 'charlie123456', '1122334455', 'Customer');
```

---

### 1️⃣ Create VehicleType Enum

```sql
CREATE TYPE VehicleType AS ENUM ('car', 'bike', 'truck');
```

### 2️⃣ Create VehicleStatus Enum

```sql
CREATE TYPE VehicleStatus AS ENUM ('available', 'rented', 'maintenance');
```

### 3️⃣ Create Vehicles Table

```sql
CREATE TABLE Vehicles (
    vehicle_id SERIAL PRIMARY KEY,
    name VARCHAR(55) NOT NULL,
    type VehicleType NOT NULL,
    model VARCHAR(55),
    registration_number VARCHAR(55) UNIQUE NOT NULL,
    rental_price NUMERIC(10,2) NOT NULL CHECK(rental_price >= 0),
    status VehicleStatus NOT NULL
    );
```

### 4️⃣ Insert data into vehicles table

```sql
INSERT INTO Vehicles (name, type, model, registration_number, rental_price, status)
VALUES
('Honda Civic', 'car', '2021', 'DEF-456', '60', 'rented'),
('Yamaha R15', 'bike', '2023', 'GHI-789', '30', 'available'),
('Ford F-150', 'truck', '2020', 'JKL-012', '100', 'maintenance');
```

---

### 1️⃣ Create BookingStatus Enum

```sql
CREATE TYPE BookingStatus AS ENUM ('pending', 'confirmed', 'completed', 'cancelled');
```

### 2️⃣ Create Bookings Table

```sql
CREATE TABLE Bookings (
    booking_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES Users(user_id) ON DELETE CASCADE,
    vehicle_id INT NOT NULL REFERENCES Vehicles(vehicle_id) ON DELETE CASCADE,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    status BookingStatus NOT NULL,
    total_cost NUMERIC(10,2) NOT NULL CHECK(total_cost >= 0)
);
```

### 3️⃣ Insert Data into bookings table

```sql
INSERT INTO Bookings (user_id, vehicle_id, start_date, end_date, status, total_cost)
VALUES
('1', '1', '2023-11-01', '2023-11-03', 'completed', '120'),
('3', '3', '2023-12-01', '2023-12-02', 'confirmed', '60'),
('1', '3', '2023-12-10', '2023-12-12', 'pending', '100');
```

---

## 📌 Implemented SQL Queries

### 1️⃣ JOIN:

1. Retrieve booking information along with Customer name and Vehicle name.

```sql
SELECT booking_id, users.name as customer_name, vehicles.name as vehicle_name, start_date, end_date, bookings.status
FROM bookings
INNER JOIN users ON bookings.user_id = users.user_id
INNER JOIN vehicles ON bookings.vehicle_id = vehicles.vehicle_id;
```

### 2️⃣ EXISTS:

1. Find all vehicles that have never been booked.

```sql
SELECT * FROM vehicles v
WHERE NOT EXISTS(
    SELECT * FROM bookings b
    WHERE b.vehicle_id = v.vehicle_id
);
```

### 3️⃣ WHERE:

1. Retrieve all available vehicles of a specific type (e.g. cars).

```sql
SELECT * FROM vehicles
WHERE "type" = 'car';
```

### 4️⃣ GROUP BY and HAVING:

1. Find the total number of bookings for each vehicle and display only those vehicles that have more than 2 bookings.

```sql
SELECT vehicles.name as vehicle_name, COUNT(bookings.vehicle_id) as total_bookings
FROM bookings
INNER JOIN vehicles ON bookings.vehicle_id = vehicles.vehicle_id
GROUP BY vehicles.vehicle_id
HAVING COUNT(bookings.vehicle_id) > 2;
```
