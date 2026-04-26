CREATE TABLE Users (
    user_id INTEGER PRIMARY KEY AUTOINCREMENT,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE User_Phones (
    phone_id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER,
    phone_number VARCHAR(15) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

CREATE TABLE User_Profiles (
    profile_id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER UNIQUE,
    address TEXT,
    bio TEXT,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

CREATE TABLE Categories (
    category_id INTEGER PRIMARY KEY AUTOINCREMENT,
    category_name VARCHAR(100) NOT NULL
);

CREATE TABLE Products (
    product_id INTEGER PRIMARY KEY AUTOINCREMENT,
    category_id INTEGER,
    name VARCHAR(200) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    stock_quantity INTEGER DEFAULT 0,
    FOREIGN KEY (category_id) REFERENCES Categories(category_id)
);

CREATE TABLE Orders (
    order_id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status TEXT CHECK(status IN ('Pending', 'Delivered', 'Cancelled')) DEFAULT 'Pending',
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

CREATE TABLE User_Roles_Mapping (
    user_id INTEGER,
    role_id INTEGER,
    PRIMARY KEY (user_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

INSERT INTO Categories (category_name) VALUES ('Electronics'), ('Home Appliances'), ('Clothing'), ('Books'), ('Fitness');


INSERT INTO Users (full_name, email) VALUES 
('Prathamesh V Shenoy', 'prathamesh@gmail.com'),
('Nihal A', 'nihal@gmail.com'),
('Preetham S', 'preetham@gmail.com'),
('Vikas K', 'vikas@gmail.com'),
('Chiranth R', 'chiranth@gmail.com');


INSERT INTO User_Phones (user_id, phone_number) VALUES (1, '9876543210'), (1, '9123456789'), (2, '8887776665'), (3, '7776665554'), (4, '6665554443');

INSERT INTO User_Profiles (user_id, address, bio) VALUES 
(1, 'Adyar, Mangaluru', 'Full Stack Developer'),
(2, 'MG Road, Bengaluru', 'Data Scientist'),
(3, 'Malpe, Udupi', 'UI/UX Designer'),
(4, 'Palace Road, Mysore', 'Mobile App Dev'),
(5, 'Gandhi Nagar, Hubli', 'QA Engineer');

INSERT INTO User_Roles_Mapping (user_id, role_id) VALUES (1, 101), (2, 102), (3, 102), (4, 102), (5, 101);

INSERT INTO Products (category_id, name, price, stock_quantity) VALUES 
(1, 'Smartphone X1', 49999.00, 50),
(1, 'Bluetooth Headphones', 2500.00, 100),
(2, 'Microwave Oven', 8500.00, 20),
(3, 'Cotton T-Shirt', 799.00, 200),
(4, 'Database Systems Book', 1200.00, 30);


INSERT INTO Orders (user_id, status) VALUES (1, 'Delivered'), (2, 'Pending'), (3, 'Delivered'), (4, 'Cancelled'), (5, 'Delivered');

INSERT INTO Order_Items (order_id, product_id, quantity, unit_price) VALUES 
(1, 1, 1, 49999.00), 
(1, 2, 1, 2500.00),
(2, 3, 1, 8500.00),
(3, 4, 2, 799.00),
(5, 5, 1, 1200.00);

SELECT u.full_name, up.address, GROUP_CONCAT(uph.phone_number) AS contact_details
FROM Users u
JOIN User_Profiles up ON u.user_id = up.user_id
JOIN User_Phones uph ON u.user_id = uph.user_id
GROUP BY u.user_id;

SELECT c.category_name, COUNT(p.product_id) AS number_of_products
FROM Categories c
LEFT JOIN Products p ON c.category_id = p.category_id
GROUP BY c.category_id;

SELECT c.category_name, AVG(p.price) AS average_price
FROM Categories c
JOIN Products p ON c.category_id = p.category_id
GROUP BY c.category_name;

SELECT c.category_name, SUM(p.price * p.stock_quantity) AS total_stock_value
FROM Categories c
JOIN Products p ON c.category_id = p.category_id
GROUP BY c.category_name;

SELECT c.category_name, p.name, SUM(oi.quantity) AS units_sold
FROM Categories c
JOIN Products p ON c.category_id = p.category_id
JOIN Order_Items oi ON p.product_id = oi.product_id
GROUP BY p.product_id
HAVING units_sold > 0;

CREATE TABLE Blocks (
    block_id INTEGER PRIMARY KEY AUTOINCREMENT,
    block_name VARCHAR(50) NOT NULL,
    warden_name VARCHAR(100)
);

CREATE TABLE Rooms (
    room_id INTEGER PRIMARY KEY AUTOINCREMENT,
    block_id INTEGER,
    room_number VARCHAR(10) NOT NULL,
    room_type TEXT CHECK(room_type IN ('Single', 'Double', 'Triple')) NOT NULL,
    FOREIGN KEY (block_id) REFERENCES Blocks(block_id)
);

CREATE TABLE Students (
    student_id INTEGER PRIMARY KEY AUTOINCREMENT,
    usn VARCHAR(20) UNIQUE NOT NULL,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE Student_Contacts (
    contact_id INTEGER PRIMARY KEY AUTOINCREMENT,
    student_id INTEGER,
    phone_number VARCHAR(15) NOT NULL,
    FOREIGN KEY (student_id) REFERENCES Students(student_id) ON DELETE CASCADE
);

CREATE TABLE Allocations (
    allocation_id INTEGER PRIMARY KEY AUTOINCREMENT,
    student_id INTEGER,
    room_id INTEGER,
    academic_year VARCHAR(10),
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (room_id) REFERENCES Rooms(room_id)
);

CREATE TABLE Amenities (
    amenity_id INTEGER PRIMARY KEY AUTOINCREMENT,
    amenity_name VARCHAR(50) NOT NULL,
    monthly_fee DECIMAL(10, 2)
);

CREATE TABLE Room_Amenities (
    room_id INTEGER,
    amenity_id INTEGER,
    PRIMARY KEY (room_id, amenity_id),
    FOREIGN KEY (room_id) REFERENCES Rooms(room_id),
    FOREIGN KEY (amenity_id) REFERENCES Amenities(amenity_id)
);

CREATE TABLE Events (
    event_id INTEGER PRIMARY KEY AUTOINCREMENT,
    event_name VARCHAR(100) NOT NULL
);

CREATE TABLE Student_Events (
    student_id INTEGER,
    event_id INTEGER,
    PRIMARY KEY (student_id, event_id),
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (event_id) REFERENCES Events(event_id)
);

INSERT INTO Blocks (block_name, warden_name) VALUES 
('Hemanth Block - A', 'Dr. Hemanth Prabhu'), 
('Namma Annex - B', 'Prof. Kishor Kumar');

INSERT INTO Rooms (block_id, room_number, room_type) VALUES 
(1, '101', 'Single'),
(1, '102', 'Double'), 
(1, '103', 'Triple'),
(2, '201', 'Single'), 
(2, '202', 'Double');


INSERT INTO Students (usn, name) VALUES 
('4SF24CS146', 'Prathamesh V Shenoy'),
('4SF24CS121', 'Nihal A'),
('4SF24CS149', 'Preetham S'),
('4SF4CS244', 'Vikas K'),
('4SF24CS015', 'Chiranth R');


INSERT INTO Student_Contacts (student_id, phone_number) VALUES 
(1, '9876543210'),
(1, '9123456789'), 
(2, '8887776665'), 
(3, '7776665554'), 
(4, '6665554443'), 
(5, '5554443332');

INSERT INTO Allocations (student_id, room_id, academic_year) VALUES 
(1, 1, '2025-26'), 
(2, 2, '2025-26'), 
(3, 3, '2025-26'), 
(4, 4, '2025-26'), 
(5, 5, '2025-26');

INSERT INTO Amenities (amenity_name, monthly_fee) VALUES 
('High-Speed WiFi', 500.00), 
('Air Conditioning', 2000.00), 
('Laundry Service', 300.00);


INSERT INTO Room_Amenities (room_id, amenity_id) VALUES 
(1, 1), 
(1, 2),
(2, 1),         
(4, 1), (4, 3); 


INSERT INTO Events (event_name) VALUES 
('Hostel Night 2026'), 
('Tech Workshop'), 
('Inter-Block Cricket');

INSERT INTO Student_Events (student_id, event_id) VALUES 
(1, 1), 
(1, 2),
(2, 1),         
(3, 3);         


SELECT b.block_name, SUM(am.monthly_fee) AS total_block_revenue
FROM Blocks b
JOIN Rooms r ON b.block_id = r.block_id
JOIN Room_Amenities ra ON r.room_id = ra.room_id
JOIN Amenities am ON ra.amenity_id = am.amenity_id
GROUP BY b.block_name;

SELECT e.event_name, COUNT(se.student_id) AS total_registrations
FROM Events e
LEFT JOIN Student_Events se ON e.event_id = se.event_id
GROUP BY e.event_id
ORDER BY total_registrations DESC;

SELECT s.name, SUM(am.monthly_fee) AS individual_amenity_cost
FROM Students s
JOIN Allocations al ON s.student_id = al.student_id
JOIN Rooms r ON al.room_id = r.room_id
JOIN Room_Amenities ra ON r.room_id = ra.room_id
JOIN Amenities am ON ra.amenity_id = am.amenity_id
GROUP BY s.student_id;

SELECT r.room_type, COUNT(a.student_id) AS student_count
FROM Rooms r
JOIN Allocations a ON r.room_id = a.room_id
GROUP BY r.room_type;

SELECT s.name, COUNT(sc.contact_id) AS numbers_on_record
FROM Students s
JOIN Student_Contacts sc ON s.student_id = sc.student_id
GROUP BY s.student_id;