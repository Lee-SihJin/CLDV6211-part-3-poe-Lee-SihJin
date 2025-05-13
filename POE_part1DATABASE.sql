-- DATABASE CREATION
USE master
IF EXISTS (SELECT *FROM sys.databases WHERE name ='POE_part1DATABASE')
DROP DATABASE POE_part1DATABASE
CREATE DATABASE POE_part1DATABASE

USE POE_part1DATABASE

CREATE TABLE Venue (
    VenueId INT IDENTITY(1,1) PRIMARY KEY,
    VenueName NVARCHAR(255) NOT NULL,
    Location NVARCHAR(255) NOT NULL,
    Capacity INT NOT NULL,
    ImageUrl NVARCHAR(500)
);

CREATE TABLE Event (
    EventId INT IDENTITY(1,1) PRIMARY KEY,
    EventName NVARCHAR(255) NOT NULL,
    EventDate DATETIME NOT NULL,
    Description TEXT,
    VenueId INT,
    FOREIGN KEY (VenueId) REFERENCES Venue(VenueId)
);

CREATE TABLE Booking (
    BookingId INT IDENTITY(1,1) PRIMARY KEY,
    EventId INT NOT NULL,
    VenueId INT NOT NULL,
    BookingDate DATETIME NOT NULL,
    FOREIGN KEY (EventId) REFERENCES Event(EventId),
    FOREIGN KEY (VenueId) REFERENCES Venue(VenueId),
    CONSTRAINT UC_Booking UNIQUE (VenueId, BookingDate)
);

INSERT INTO Venue (VenueName, Location, Capacity,ImageUrl)
VALUES ('Lt 1', 'Building B', '300','https://www.image1')

INSERT INTO Event (EventName, EventDate, Description, VenueId)
VALUES ('Tech Conference', '2025-05-15 10:00:00', 'Annual tech conference', 1),
       ('Music Fest', '2025-06-20 18:00:00', 'Outdoor music festival', 1);

INSERT INTO Booking (EventId, VenueId, BookingDate)
VALUES (1, 1, '2025-05-15 09:00:00'),
       (2, 1, '2025-06-20 17:00:00');

SELECT * FROM Venue;
SELECT * FROM Event;
SELECT * FROM Booking;