//  E commerce
CREATE TABLE Categories (
    category_id INTEGER PRIMARY KEY AUTOINCREMENT, 
    category_name VARCHAR(100) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Users (
    user_id INTEGER PRIMARY KEY AUTOINCREMENT,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    address TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE User_Phones (
    phone_id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER,
    phone_number VARCHAR(15) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

CREATE TABLE Products (
    product_id INTEGER PRIMARY KEY AUTOINCREMENT,
    category_id INTEGER,
    name VARCHAR(200) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    stock_quantity INTEGER DEFAULT 0,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, 
    FOREIGN KEY (category_id) REFERENCES Categories(category_id)
);


CREATE TABLE Orders (
    order_id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10, 2),
    status TEXT CHECK(status IN ('Pending', 'Shipped', 'Delivered', 'Cancelled')) DEFAULT 'Pending',
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

CREATE TABLE Order_Items (
    order_item_id INTEGER PRIMARY KEY AUTOINCREMENT,
    order_id INTEGER,
    product_id INTEGER,
    quantity INTEGER NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

INSERT INTO Categories (category_name, description) VALUES 
('Electronics', 'Gadgets, smartphones, and laptops'),
('Home Appliances', 'Kitchen and living room utility'),
('Clothing', 'Apparel for men, women, and kids'),
('Books', 'Academic and fictional literature'),
('Fitness', 'Gym equipment and accessories');

INSERT INTO Users (full_name, email, address) VALUES 
('Prathamesh V Shenoy', 'prathamesh@gmail.com', 'Adyar, Mangaluru'),
('Nihal A', 'nihal@gmail.com', 'MG Road, Bengaluru'),
('Preetham S', 'preetham@gmail.com', 'Malpe, Udupi'),
('Vikas K', 'vikas@gmail.com', 'Palace Road, Mysore '),
('Chiranth R', 'chiranth@gmail.com', 'Gandhi, Hubli');

INSERT INTO User_Phones (user_id, phone_number) VALUES 
(1, '9876543210'), (1, '9123456789'), 
(2, '8887776665'), (3, '7776665554');

INSERT INTO Products (category_id, name, price, stock_quantity) VALUES 
(1, 'Smartphone X1', 49999.00, 50),
(2, 'Bluetooth Headphones', 2500.00, 100),
(3, 'Microwave Oven', 8500.00, 20),
(4, 'Cotton T-Shirt', 799.00, 200),
(5, 'Database Systems Book', 1200.00, 30);

INSERT INTO Orders (user_id, total_amount, status) VALUES 
(1, 52499.00, 'Delivered'),
(2, 2500.00, 'Shipped'),
(3, 8500.00, 'Pending'),
(4, 799.00, 'Cancelled'),
(5, 1200.00, 'Delivered'),

INSERT INTO Order_Items (order_id, product_id, quantity, unit_price) VALUES 
(1, 1, 1, 49999.00), 
(2, 2, 1, 2500.00),
(3, 3, 1, 8500.00),
(4, 4, 1, 799.00),
(5, 5, 1, 1200.00);

SELECT u.full_name, p.name AS product_purchased, o.status
FROM Users u
JOIN Orders o ON u.user_id = o.user_id
JOIN Order_Items oi ON o.order_id = oi.order_id
JOIN Products p ON oi.product_id = p.product_id;


SELECT c.category_name, COUNT(p.product_id) AS product_count
FROM Categories c
LEFT JOIN Products p ON c.category_id = p.category_id
GROUP BY c.category_name;


//College Campus Hostel Booking
CREATE TABLE Blocks (
    block_id INTEGER PRIMARY KEY AUTOINCREMENT,
    block_name VARCHAR(50) NOT NULL,
    warden_name VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Rooms (
    room_id INTEGER PRIMARY KEY AUTOINCREMENT,
    block_id INTEGER,
    room_number VARCHAR(10) NOT NULL,
    room_type TEXT CHECK(room_type IN ('Single', 'Double', 'Triple')) NOT NULL,
    is_available BOOLEAN DEFAULT 1,
    FOREIGN KEY (block_id) REFERENCES Blocks(block_id)
);

CREATE TABLE Students (
    student_id INTEGER PRIMARY KEY AUTOINCREMENT,
    usn VARCHAR(20) UNIQUE NOT NULL,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Student_Contacts (
    contact_id INTEGER PRIMARY KEY AUTOINCREMENT,
    student_id INTEGER,
    contact_type TEXT CHECK(contact_type IN ('Personal', 'Parent')),
    phone_number VARCHAR(15) NOT NULL,
    FOREIGN KEY (student_id) REFERENCES Students(student_id) ON DELETE CASCADE
);

CREATE TABLE Allocations (
    allocation_id INTEGER PRIMARY KEY AUTOINCREMENT,
    student_id INTEGER,
    room_id INTEGER,
    academic_year VARCHAR(10),
    allotted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (room_id) REFERENCES Rooms(room_id)
);

CREATE TABLE Amenities (
    amenity_id INTEGER PRIMARY KEY AUTOINCREMENT,
    amenity_name VARCHAR(50) NOT NULL,
    monthly_fee DECIMAL(10, 2) DEFAULT 0.00
);

CREATE TABLE Room_Amenities (
    room_id INTEGER,
    amenity_id INTEGER,
    PRIMARY KEY (room_id, amenity_id),
    FOREIGN KEY (room_id) REFERENCES Rooms(room_id),
    FOREIGN KEY (amenity_id) REFERENCES Amenities(amenity_id)
);

INSERT INTO Blocks (block_name, warden_name) VALUES 
('Hemanth Block - A', 'Dr. Hemanth Prabhu'), ('Namma Annex', 'Prof. Kishor Kumar');

INSERT INTO Rooms (block_id, room_number, room_type) VALUES 
(1, '101', 'Single'), (1, '102', 'Double'), (1, '103', 'Triple'), (1, '201', 'Single'), (1, '202', 'Double'),
(2, '101', 'Single'), (2, '102', 'Double'), (2, '103', 'Triple'), (2, '201', 'Single'), (2, '202', 'Double');

INSERT INTO Students (usn, name, email) VALUES 
('4XX24CS001', 'Shravan kumar', 'prathamesh@example.com'),
('4XX24CS002', 'Vivek Bhandary', 'nihal@example.com'),
('4XX24CS003', 'Pradeep Kamath', 'preetham@example.com'),
('4XX24CS004', 'Pavan Pawaskar', 'vikas@example.com'),
('4XX24CS005', 'Darshan A', 'chiranth@example.com'),

INSERT INTO Student_Contacts (student_id, contact_type, phone_number) VALUES 
(1, 'Personal', '9876543210'), (1, 'Parent', '9123456789'),
(2, 'Personal', '8887776665'), (3, 'Personal', '7776665554'),
(4, 'Personal', '6665554443'), (5, 'Personal', '5554443332'),
(6, 'Personal', '4443332221'), (7, 'Personal', '3332221110'),
(8, 'Personal', '2221110009'), (9, 'Personal', '1110009998');

INSERT INTO Allocations (student_id, room_id, academic_year) VALUES 
(1, 1, '2025-26'), (2, 2, '2025-26'), (3, 3, '2025-26'), (4, 4, '2025-26'), (5, 5, '2025-26'),
(6, 6, '2025-26'), (7, 7, '2025-26'), (8, 8, '2025-26'), (9, 9, '2025-26'), (10, 10, '2025-26');

INSERT INTO Amenities (amenity_name, monthly_fee) VALUES 
('High-Speed WiFi', 500.00), ('Attached Bathroom', 1000.00), ('Air Conditioning', 2000.00), ('Laundry', 300.00), ('Study Table', 0.00);

INSERT INTO Room_Amenities (room_id, amenity_id) VALUES 
(1, 1), (1, 2), (2, 1), (3, 4);

SELECT s.name, b.block_name, r.room_number, r.room_type
FROM Students s
JOIN Allocations a ON s.student_id = a.student_id
JOIN Rooms r ON a.room_id = r.room_id
JOIN Blocks b ON r.block_id = b.block_id;

SELECT b.block_name, COUNT(a.student_id) AS total_students
FROM Blocks b
JOIN Rooms r ON b.block_id = r.block_id
JOIN Allocations a ON r.room_id = a.room_id
GROUP BY b.block_name;
