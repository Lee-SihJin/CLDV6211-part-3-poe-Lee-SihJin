-- DATABASE CREATION
USE master
IF EXISTS (SELECT *FROM sys.databases WHERE name ='EventEaseDB')
DROP DATABASE EventEaseDB
CREATE DATABASE EventEaseDB

USE EventEaseDB

CREATE TABLE Venue (
    VenueId INT IDENTITY(1,1) PRIMARY KEY,
    VenueName NVARCHAR(255) NOT NULL,
    Location NVARCHAR(255) NOT NULL,
    Capacity INT NOT NULL CHECK (Capacity > 0),
    ImageUrl NVARCHAR(500) NULL
);

CREATE TABLE EventType(
	EventTypeId INT IDENTITY(1,1) PRIMARY KEY,
	Name NVARCHAR(100) NOT NULL
);

CREATE TABLE Event (
    EventId INT IDENTITY(1,1) PRIMARY KEY,
    EventName NVARCHAR(255) NOT NULL,
    EventDate DATETIME NOT NULL,
    Description TEXT,
    VenueId INT NULL,
	EventTypeId INT NULL,
    FOREIGN KEY (VenueId) REFERENCES Venue(VenueId) ON DELETE SET NULL,
	FOREIGN KEY (EventTypeId) REFERENCES EventType(EventTypeId) ON DELETE SET NULL,
);

CREATE TABLE Booking (
    BookingId INT IDENTITY(1,1) PRIMARY KEY,
    EventId INT NOT NULL,
    VenueId INT NOT NULL,
    BookingDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (EventId) REFERENCES Event(EventId) ON DELETE CASCADE,
    FOREIGN KEY (VenueId) REFERENCES Venue(VenueId) ON DELETE CASCADE,
    CONSTRAINT UQ_Venue_Event UNIQUE (VenueId, EventId)
);
CREATE UNIQUE INDEX UQ_Venue_Booking ON Booking (VenueId, BookingDate); 

INSERT INTO Venue (VenueName, Location, Capacity,ImageUrl)
VALUES ('Lt 1', 'Building B', '300','https://www.image1')

INSERT INTO EventType (Name)
VALUES
('Conference'),
('Wedding'),
('Birthday'),
('Concert'),
('Naming');

INSERT INTO Event (EventName, EventDate, Description, VenueId,EventTypeId)
VALUES ('Tech Conference', '2025-05-15 10:00:00', 'Annual tech conference', 1, 1),
       ('Music Fest', '2025-06-20 18:00:00', 'Outdoor music festival', 1, 4);

INSERT INTO Booking (EventId, VenueId, BookingDate)
VALUES (1, 1, '2025-05-15 09:00:00'),
       (2, 1, '2025-06-20 17:00:00');

SELECT * FROM Venue;
SELECT * FROM Event;
SELECT * FROM Booking;
SELECT * FROM EventType;
