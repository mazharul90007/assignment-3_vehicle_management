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

