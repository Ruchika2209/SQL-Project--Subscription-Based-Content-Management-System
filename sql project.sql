create database SubscriptionCMSDB;
use SubscriptionCMSDB;

CREATE TABLE Users (
    UserID INT AUTO_INCREMENT PRIMARY KEY,
    Username VARCHAR(100) NOT NULL,
    Password VARCHAR(255) NOT NULL,
    Email VARCHAR(100) NOT NULL,
    FullName VARCHAR(100),
    RegistrationDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Subscriptions (
    SubscriptionID INT AUTO_INCREMENT PRIMARY KEY,
    SubscriptionName VARCHAR(100) NOT NULL,
    Description TEXT,
    Price DECIMAL(10, 2) NOT NULL,
    DurationMonths INT NOT NULL
);

CREATE TABLE UserSubscriptions (
    UserSubscriptionID INT AUTO_INCREMENT PRIMARY KEY,
    UserID INT,
    SubscriptionID INT,
    StartDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    EndDate TIMESTAMP,
    FOREIGN KEY (UserID) REFERENCES Users(UserID),
    FOREIGN KEY (SubscriptionID) REFERENCES Subscriptions(SubscriptionID)
);
CREATE TABLE Categories (
    CategoryID INT AUTO_INCREMENT PRIMARY KEY,
    CategoryName VARCHAR(100) NOT NULL
);
CREATE TABLE Content (
    ContentID INT AUTO_INCREMENT PRIMARY KEY,
    Title VARCHAR(200) NOT NULL,
    Description TEXT,
    CategoryID INT,
    PublishDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ContentData TEXT,
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
);
CREATE TABLE Payments (
    PaymentID INT AUTO_INCREMENT PRIMARY KEY,
    UserID INT,
    SubscriptionID INT,
    PaymentDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Amount DECIMAL(10, 2),
    FOREIGN KEY (UserID) REFERENCES Users(UserID),
    FOREIGN KEY (SubscriptionID) REFERENCES Subscriptions(SubscriptionID)
);
CREATE TABLE ContentAccess (
    ContentAccessID INT AUTO_INCREMENT PRIMARY KEY,
    UserID INT,
    ContentID INT,
    AccessDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (UserID) REFERENCES Users(UserID),
    FOREIGN KEY (ContentID) REFERENCES Content(ContentID)
);

INSERT INTO Users (Username, Password, Email, FullName) VALUES
('jamesdavis', 'james123', 'james.davis@gmail.com', 'James Davis'),
('sophiaanderson', 'sophia90', 'sophia.anderson@gmail.com', 'Sophia Anderson'),
('liammoore', 'liaZ3', 'liam.moore@gmail.com', 'Liam Moore'),
('oliviajones', 'oliviaW4', 'olivia.jones@gmail.com', 'Olivia Jones'),
('noahthomas', 'noahV5', 'noah.thomas@gmail.com', 'Noah Thomas');

INSERT INTO Subscriptions (SubscriptionName, Description, Price, DurationMonths) VALUES
('Basic Access', 'Access to basic content library', 12.99, 1),
('Standard Access', 'Extended access to content', 22.99, 3),
('Gold Access', 'Full access to all features', 32.99, 6),
('Platinum Access', 'Premium content with extra perks', 42.99, 12),
('Executive Access', 'All-access with exclusive benefits for professionals', 79.99, 12);

INSERT INTO Categories (CategoryName) VALUES
('Technology'),
('Health & Wellness'),
('Finance & Investing'),
('Travel'),
('Education');

INSERT INTO Content (Title, Description, CategoryID, ContentData) VALUES
('Getting Started with Python', 'A beginner’s guide to Python programming.', 1, 'Python is an easy-to-learn programming language used in various applications...'),
('Mental Health Awareness', 'Tips and strategies for improving mental health.', 2, 'Maintaining mental health is crucial for overall well-being and productivity...'),
('Investing for Beginners', 'An introduction to investment strategies and principles.', 3, 'Investing involves putting money into assets to generate returns over time...'),
('Top Destinations for Solo Travelers', 'Best travel destinations for solo travelers.', 4, 'Explore the top destinations that are perfect for solo travel adventures...'),
('Online Learning Strategies', 'Effective methods for learning online.', 5, 'Online learning requires specific strategies to stay motivated and successful...');


INSERT INTO UserSubscriptions (UserID, SubscriptionID, StartDate, EndDate) VALUES
(1, 1, '2024-10-01', '2024-11-01'),
(2, 2, '2024-10-10', '2025-01-10'),
(3, 3, '2024-10-15', '2025-04-15'),
(4, 4, '2024-10-20', '2025-10-20'),
(5, 5, '2024-10-25', '2025-10-25');

INSERT INTO Payments (UserID, SubscriptionID, PaymentDate, Amount) VALUES
(1, 1, '2024-10-01', 199),
(2, 2, '2024-10-10', 299),
(3, 3, '2024-10-15', 399),
(4, 4, '2024-10-20', 499),
(5, 5, '2024-10-25', 799);

INSERT INTO ContentAccess (UserID, ContentID, AccessDate) VALUES
(1, 1, '2024-10-05'),
(1, 2, '2024-10-07'),
(2, 3, '2024-10-16'),
(3, 4, '2024-10-22'),
(4, 5, '2024-10-30');


SELECT * FROM Users;
SELECT * FROM Subscriptions;
SELECT * FROM UserSubscriptions;
SELECT * FROM Categories;
SELECT * FROM Content;
SELECT * FROM Payments;
SELECT * FROM ContentAccess;


SELECT * FROM Users WHERE Username = 'jamesdavis';

SELECT SubscriptionName, Price FROM Subscriptions;

SELECT Title, Description FROM Content
JOIN Categories ON Content.CategoryID = Categories.CategoryID
WHERE CategoryName = 'Technology';

SELECT s.SubscriptionName, COUNT(us.UserID) AS NumberOfUsers
FROM UserSubscriptions us
JOIN Subscriptions s ON us.SubscriptionID = s.SubscriptionID
GROUP BY s.SubscriptionName;

SELECT c.Title, c.Description, ca.AccessDate
FROM ContentAccess ca
JOIN Content c ON ca.ContentID = c.ContentID
WHERE ca.UserID = 1;

SELECT u.Username, SUM(p.Amount) AS TotalPaid
FROM Payments p
JOIN Users u ON p.UserID = u.UserID
GROUP BY u.Username;


SELECT u.Username, s.SubscriptionName, us.EndDate
FROM UserSubscriptions us
JOIN Subscriptions s ON us.SubscriptionID = s.SubscriptionID
JOIN Users u ON us.UserID = u.UserID
WHERE us.EndDate BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 30 DAY


SELECT SubscriptionName, Price
FROM Subscriptions
ORDER BY Price DESC
LIMIT 1;

SELECT c.Title, cat.CategoryName
FROM Content c
JOIN Categories cat ON c.CategoryID = cat.CategoryID;

SELECT c.Title, ca.AccessDate
FROM ContentAccess ca
JOIN Content c ON ca.ContentID = c.ContentID
WHERE ca.UserID = 1 AND ca.AccessDate BETWEEN '2024-08-01' AND '2024-08-31';

SELECT Title, Description
FROM Content
WHERE ContentID NOT IN (SELECT ContentID FROM ContentAccess);

SELECT u.Username, COUNT(ca.ContentID) AS NumberOfContentAccessed
FROM ContentAccess ca
JOIN Users u ON ca.UserID = u.UserID
GROUP BY u.Username
HAVING NumberOfContentAccessed > 2;

SELECT AVG(Price) AS AveragePrice
FROM Subscriptions;

SELECT u.Username, MAX(p.PaymentDate) AS MostRecentPayment
FROM Payments p
JOIN Users u ON p.UserID = u.UserID
GROUP BY u.Username;

SELECT cat.CategoryName, COUNT(c.ContentID) AS ContentCount
FROM Categories cat
LEFT JOIN Content c ON cat.CategoryID = c.CategoryID
GROUP BY cat.CategoryName;

SELECT u.Username, s.SubscriptionName, us.EndDate
FROM UserSubscriptions us
JOIN Subscriptions s ON us.SubscriptionID = s.SubscriptionID
JOIN Users u ON us.UserID = u.UserID
WHERE us.EndDate = CURDATE();


SELECT u.Username
FROM UserSubscriptions us1
JOIN UserSubscriptions us2 ON us1.UserID = us2.UserID
JOIN Users u ON us1.UserID = u.UserID
JOIN Subscriptions s1 ON us1.SubscriptionID = s1.SubscriptionID
JOIN Subscriptions s2 ON us2.SubscriptionID = s2.SubscriptionID
WHERE s1.SubscriptionName = 'Basic Access'
AND s2.SubscriptionName = 'Standard Access';

SELECT s.SubscriptionName, SUM(p.Amount) AS TotalRevenue
FROM Payments p
JOIN Subscriptions s ON p.SubscriptionID = s.SubscriptionID
GROUP BY s.SubscriptionName;


SELECT c.Title, COUNT(ca.ContentID) AS AccessCount
FROM ContentAccess ca
JOIN Content c ON ca.ContentID = c.ContentID
GROUP BY c.Title
ORDER BY AccessCount DESC
LIMIT 3;


SELECT u.Username
FROM Users u
LEFT JOIN Payments p ON u.UserID = p.UserID
WHERE p.PaymentID IS NULL;


SELECT SubscriptionName, DurationMonths
FROM Subscriptions
WHERE DurationMonths > 6;


SELECT u.Username, COUNT(us.UserSubscriptionID) AS TotalSubscriptions
FROM UserSubscriptions us
JOIN Users u ON us.UserID = u.UserID
GROUP BY u.Username;


SELECT c.Title, u.Username, ca.AccessDate
FROM ContentAccess ca
JOIN Content c ON ca.ContentID = c.ContentID
JOIN Users u ON ca.UserID = u.UserID
WHERE ca.AccessDate = (SELECT MAX(AccessDate) FROM ContentAccess WHERE ContentID = c.ContentID);

CREATE PROCEDURE AddUser(p_username VARCHAR(50), p_email VARCHAR(100), p_password VARCHAR(255))
    INSERT INTO Users (username, email, password_hash) VALUES (p_username, p_email, p_password);
    
    SELECT u.username, c.title
FROM user u
JOIN Subscriptions us ON u.user_id = us.user_id
JOIN content_access ca ON us.subscription_id = ca.subscription_id
JOIN content c ON ca.content_id = c.content_id
WHERE c.content_id = 1;

SELECT u.username
FROM user 
LEFT JOIN payment p ON u.user_id = p.user_id
WHERE p.payment_id IS NULL;

UPDATE Content
SET Description = 'An updated guide to astronomy.'
WHERE ContentID = 1;

ALTER TABLE Subscriptions
ADD COLUMN IsActive BOOLEAN DEFAULT TRUE;

UPDATE Users 
SET Email = 'newperson@gmail.com' 
WHERE Username = 'newuser';

UPDATE Subscriptions
SET Price = 15.99 
WHERE SubscriptionName = 'Basic Access';

SELECT * FROM Subscriptions 
WHERE SubscriptionName = 'Gold Access';

UPDATE Categories 
SET CategoryName = 'Health & Wellness' 
WHERE CategoryName = 'Health & Fitness';

select * from Categories;

DELETE FROM Categories 
WHERE CategoryName = 'Travel';

SELECT * 
FROM UserSubscriptions 
WHERE EndDate > NOW();

SELECT * 
FROM Content 
ORDER BY PublishDate DESC 
LIMIT 5;

SELECT u.Username, c.Title 
FROM ContentAccess ca
JOIN Users u ON ca.UserID = u.UserID
JOIN Content c ON ca.ContentID = c.ContentID
WHERE c.Title = 'Investing for Beginners';

SELECT us.UserID, s.SubscriptionName 
FROM UserSubscriptions us
JOIN Subscriptions s ON us.SubscriptionID = s.SubscriptionID
LEFT JOIN Payments p ON us.UserID = p.UserID AND us.SubscriptionID = p.SubscriptionID
WHERE p.PaymentID IS NULL AND us.EndDate > NOW();

SELECT u.Username, us.EndDate 
FROM UserSubscriptions us
JOIN Users u ON us.UserID = u.UserID
WHERE us.EndDate < NOW();

DELETE FROM ContentAccess 
WHERE UserID = 2 AND ContentID = 3;
select * from ContentAccess;









