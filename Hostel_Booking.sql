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
