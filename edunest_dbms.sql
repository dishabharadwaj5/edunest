-- =========================================================
--  DBMS MINI PROJECT : EduNest – Academic Resource Management

-- =========================================================

DROP DATABASE IF EXISTS miniproj;
CREATE DATABASE miniproj;
USE miniproj;

-- =========================================================
-- 1. STUDENT TABLE
-- =========================================================
CREATE TABLE Student (
    Student_ID INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Dept VARCHAR(50),
    Semester INT CHECK (Semester > 0),
    Password VARCHAR(50) NOT NULL
);

INSERT INTO Student VALUES
(101, 'Amit Kumar', 'amit.kumar@example.com', 'CSE', 5, 'amit123'),
(102, 'Riya Sharma', 'riya.sharma@example.com', 'ECE', 3, 'riya456'),
(103, 'Kunal Verma', 'kunal.verma@example.com', 'IT', 6, 'kunal789'),
(104, 'Sneha Rao', 'sneha.rao@example.com', 'ME', 2, 'sneha321'),
(105, 'Arjun Singh', 'arjun.singh@example.com', 'CSE', 4, 'arjun555'),
(106, 'Priya Nair', 'priya.nair@example.com', 'CSE', 6, 'priya321'),
(107, 'Mohit Das', 'mohit.das@example.com', 'ECE', 2, 'mohit654'),
(108, 'Ananya Patel', 'ananya.patel@example.com', 'IT', 5, 'ananya987');

-- =========================================================
-- 2. FACULTY TABLE
-- =========================================================
CREATE TABLE Faculty (
    Faculty_ID INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Dept VARCHAR(50),
    Designation VARCHAR(50),
    Password VARCHAR(50) NOT NULL,
    Supervisor_ID INT NULL
);

INSERT INTO Faculty VALUES
(201, 'Dr. Meera Iyer', 'meera.iyer@example.com', 'CSE', 'Professor', 'meera@123', NULL),
(202, 'Prof. Raj Malhotra', 'raj.malhotra@example.com', 'ECE', 'Associate Professor', 'raj@456', 201),
(203, 'Dr. Kavita Nair', 'kavita.nair@example.com', 'ME', 'Professor', 'kavita@789', NULL),
(204, 'Prof. Vinay Gupta', 'vinay.gupta@example.com', 'IT', 'Assistant Professor', 'vinay@321', 203),
(205, 'Prof. Sunita Menon', 'sunita.menon@example.com', 'CSE', 'Lecturer', 'sunita@555', 201),
(206, 'Dr. Rakesh Pillai', 'rakesh.pillai@example.com', 'CSE', 'Professor', 'rakesh@111', NULL),
(207, 'Prof. Neelima Joshi', 'neelima.joshi@example.com', 'ECE', 'Assistant Professor', 'neelima@222', 202),
(208, 'Prof. Aditya Mehra', 'aditya.mehra@example.com', 'IT', 'Lecturer', 'aditya@333', 204);

-- =========================================================
-- 3. ADMIN TABLE
-- =========================================================
CREATE TABLE Admin (
    Admin_ID INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Role VARCHAR(50) NOT NULL
);

INSERT INTO Admin VALUES
(301, 'Vikram Desai', 'vikram.desai@example.com', 'Super Admin'),
(302, 'Neha Kapoor', 'neha.kapoor@example.com', 'System Admin'),
(303, 'Rohit Bansal', 'rohit.bansal@example.com', 'Course Manager'),
(304, 'Sonal Verma', 'sonal.verma@example.com', 'Exam Controller'),
(305, 'Manoj Kulkarni', 'manoj.kulkarni@example.com', 'Network Admin'),
(306, 'Tanya Agarwal', 'tanya.agarwal@example.com', 'Library Manager');

-- =========================================================
-- 4. COURSE TABLE
-- =========================================================
CREATE TABLE Course (
    Course_ID INT PRIMARY KEY,
    CourseName VARCHAR(100) NOT NULL,
    Dept VARCHAR(50),
    Semester INT,
    Faculty_ID INT,
    FOREIGN KEY (Faculty_ID) REFERENCES Faculty(Faculty_ID)
);

INSERT INTO Course VALUES
(401, 'Database Systems', 'CSE', 5, 201),
(402, 'Digital Circuits', 'ECE', 3, 202),
(403, 'Thermodynamics', 'ME', 2, 203),
(404, 'Data Structures', 'CSE', 4, 205),
(405, 'Software Engineering', 'IT', 6, 204),
(406, 'Operating Systems', 'CSE', 6, 206),
(407, 'Signal Processing', 'ECE', 4, 207),
(408, 'Web Technologies', 'IT', 5, 208);

-- =========================================================
-- 5. ENROLLMENT TABLE
-- =========================================================
CREATE TABLE Enrollment (
    Student_ID INT,
    Course_ID INT,
    EnrollmentDate DATE NOT NULL,
    PRIMARY KEY (Student_ID, Course_ID),
    FOREIGN KEY (Student_ID) REFERENCES Student(Student_ID),
    FOREIGN KEY (Course_ID) REFERENCES Course(Course_ID)
);

INSERT INTO Enrollment VALUES
(101, 401, '2024-01-10'),
(101, 404, '2024-01-12'),
(102, 402, '2024-01-15'),
(103, 405, '2024-01-20'),
(104, 403, '2024-01-22'),
(106, 406, '2024-01-25'),
(107, 407, '2024-01-27'),
(108, 408, '2024-01-29');

-- =========================================================
-- 6. RESOURCE TABLE
-- =========================================================
CREATE TABLE Resource (
    Resource_ID INT PRIMARY KEY,
    Title VARCHAR(100),
    Type VARCHAR(50),
    UploadDate DATE,
    FileLink VARCHAR(255),
    Course_ID INT,
    FOREIGN KEY (Course_ID) REFERENCES Course(Course_ID)
);

INSERT INTO Resource VALUES
(501, 'DBMS Lecture Notes', 'PDF', '2024-02-01', 'dbms_notes.pdf', 401),
(502, 'Circuit Lab Manual', 'DOCX', '2024-02-03', 'circuits_lab.docx', 402),
(503, 'Thermodynamics Handbook', 'PDF', '2024-02-05', 'thermo_handbook.pdf', 403),
(504, 'DSA Code Examples', 'ZIP', '2024-02-07', 'dsa_codes.zip', 404),
(505, 'SE Project Guide', 'PDF', '2024-02-09', 'se_project.pdf', 405),
(506, 'OS Lecture Slides', 'PPT', '2024-02-11', 'os_slides.pptx', 406),
(507, 'Signal Processing Problems', 'PDF', '2024-02-13', 'signal_problems.pdf', 407),
(508, 'WebTech Tutorials', 'ZIP', '2024-02-15', 'webtech_tutorials.zip', 408);

-- =========================================================
-- 7. ASSIGNMENT TABLE
-- =========================================================
CREATE TABLE Assignment (
    Assign_ID INT PRIMARY KEY,
    Title VARCHAR(100),
    Deadline DATE NOT NULL,
    MaxMarks INT CHECK (MaxMarks > 0),
    Course_ID INT,
    FOREIGN KEY (Course_ID) REFERENCES Course(Course_ID)
);

INSERT INTO Assignment VALUES
(601, 'ER Diagram Assignment', '2024-03-01', 20, 401),
(602, 'Logic Gate Design', '2024-03-05', 25, 402),
(603, 'Heat Transfer Project', '2024-03-07', 30, 403),
(604, 'Linked List Implementation', '2024-03-10', 20, 404),
(605, 'SDLC Case Study', '2024-03-12', 25, 405),
(606, 'Process Scheduling Assignment', '2024-03-15', 20, 406),
(607, 'Filter Design Project', '2024-03-18', 30, 407),
(608, 'HTML-CSS Mini Project', '2024-03-20', 25, 408);

-- =========================================================
-- 8. SUBMISSION TABLE
-- =========================================================
CREATE TABLE Submission (
    Sub_ID INT PRIMARY KEY,
    FileLink VARCHAR(255),
    DateSubmitted DATE,
    MarksAwarded INT,
    Feedback VARCHAR(255),
    Student_ID INT,
    Assign_ID INT,
    FOREIGN KEY (Student_ID) REFERENCES Student(Student_ID),
    FOREIGN KEY (Assign_ID) REFERENCES Assignment(Assign_ID)
);

INSERT INTO Submission VALUES
(701, 'amit_erdiagram.pdf', '2024-02-28', 18, 'Good work', 101, 601),
(702, 'riya_circuits.pdf', '2024-03-04', 22, 'Well done', 102, 602),
(703, 'kunal_heat.pdf', '2024-03-06', 28, 'Excellent', 103, 603),
(704, 'sneha_linkedlist.zip', '2024-03-09', 19, 'Improvement needed', 104, 604),
(705, 'arjun_sdlc.docx', '2024-03-11', 23, 'Nice analysis', 105, 605),
(706, 'priya_os.pdf', '2024-03-14', 19, 'Very Good', 106, 606),
(707, 'mohit_filter.pdf', '2024-03-17', 27, 'Excellent effort', 107, 607),
(708, 'ananya_htmlcss.zip', '2024-03-19', 24, 'Nice design', 108, 608);

-- =========================================================
-- 9. AUDIT LOG TABLE
-- =========================================================
CREATE TABLE AuditLog (
    Log_ID INT AUTO_INCREMENT PRIMARY KEY,
    ActionType VARCHAR(50),
    Description VARCHAR(255),
    ActionTime TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =========================================================
-- 10. STUDENT AVERAGE TABLE (for Trigger 2)
-- =========================================================
CREATE TABLE Student_Average (
    Student_ID INT PRIMARY KEY,
    AvgMarks DECIMAL(5,2) DEFAULT 0,
    TotalSubmissions INT DEFAULT 0,
    FOREIGN KEY (Student_ID) REFERENCES Student(Student_ID)
);

-- =========================================================
-- TRIGGERS
-- =========================================================
DELIMITER //

-- Trigger 1 : Auto feedback if empty
CREATE TRIGGER trg_auto_feedback
BEFORE INSERT ON Submission
FOR EACH ROW
BEGIN
    IF NEW.Feedback IS NULL OR NEW.Feedback = '' THEN
        SET NEW.Feedback = 'Feedback will be provided soon.';
    END IF;
END;
//

-- Trigger 2 : Auto update student average marks
CREATE TRIGGER trg_update_student_average
AFTER INSERT ON Submission
FOR EACH ROW
BEGIN
    DECLARE avgMarks DECIMAL(5,2);
    DECLARE totalSubs INT;

    SELECT AVG(MarksAwarded), COUNT(*) INTO avgMarks, totalSubs
    FROM Submission WHERE Student_ID = NEW.Student_ID;

    INSERT INTO Student_Average (Student_ID, AvgMarks, TotalSubmissions)
    VALUES (NEW.Student_ID, avgMarks, totalSubs)
    ON DUPLICATE KEY UPDATE AvgMarks = avgMarks, TotalSubmissions = totalSubs;
END;
//
DELIMITER ;

-- =========================================================
-- PROCEDURES
-- =========================================================
DELIMITER //

CREATE PROCEDURE GetStudentSubmissions(IN sid INT)
BEGIN
    SELECT s.Sub_ID, a.Title AS Assignment, s.MarksAwarded, s.Feedback, s.DateSubmitted
    FROM Submission s
    JOIN Assignment a ON s.Assign_ID = a.Assign_ID
    WHERE s.Student_ID = sid;
END;
//

CREATE PROCEDURE AddResource(
    IN rid INT,
    IN rtitle VARCHAR(100),
    IN rtype VARCHAR(50),
    IN rdate DATE,
    IN rfile VARCHAR(255),
    IN cid INT
)
BEGIN
    INSERT INTO Resource(Resource_ID, Title, Type, UploadDate, FileLink, Course_ID)
    VALUES (rid, rtitle, rtype, rdate, rfile, cid);
END;
//
DELIMITER ;

-- =========================================================
-- FUNCTIONS
-- =========================================================
DELIMITER //

CREATE FUNCTION GetTotalMarks(studentId INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total INT;
    SELECT SUM(MarksAwarded) INTO total FROM Submission WHERE Student_ID = studentId;
    RETURN IFNULL(total, 0);
END;
//

CREATE FUNCTION CountSubmissions(assignId INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE totalSubs INT;
    SELECT COUNT(*) INTO totalSubs FROM Submission WHERE Assign_ID = assignId;
    RETURN totalSubs;
END;
//
DELIMITER ;

-- =========================================================
-- TEST COMMANDS
-- =========================================================

-- Trigger 1 test
INSERT INTO Submission(Sub_ID, FileLink, DateSubmitted, MarksAwarded, Student_ID, Assign_ID)
VALUES (716, 'no_feedback_auto.pdf', '2024-03-02', 15, 102, 601);
SELECT * FROM Submission WHERE Sub_ID = 716;

-- Trigger 2 test
INSERT INTO Submission(Sub_ID, FileLink, DateSubmitted, MarksAwarded, Feedback, Student_ID, Assign_ID)
VALUES (715, 'avg_trigger_test.pdf', '2024-03-04', 18, 'Testing Avg', 101, 601);
SELECT * FROM Student_Average WHERE Student_ID = 101;

-- Procedure tests
CALL GetStudentSubmissions(101);
CALL AddResource(509, 'DBMS Viva Notes', 'PDF', '2024-03-25', 'viva_notes.pdf', 401);
SELECT * FROM Resource WHERE Resource_ID = 509;

-- Function tests
SELECT GetTotalMarks(101) AS TotalMarks;
SELECT CountSubmissions(601) AS TotalSubmissions;

-- Show created objects
SHOW TRIGGERS;
SHOW PROCEDURE STATUS WHERE Db='miniproj';
SHOW FUNCTION STATUS WHERE Db='miniproj'; 




-- Step 1: Select your database
USE miniproj;

-- Step 2: Fix Admin table
ALTER TABLE Admin MODIFY Admin_ID INT AUTO_INCREMENT;
USE miniproj;
ALTER TABLE Course MODIFY Course_ID INT AUTO_INCREMENT;

USE miniproj;
SHOW CREATE TABLE Enrollment;
SHOW CREATE TABLE Resource;
SHOW CREATE TABLE Assignment;

SHOW CREATE TABLE Enrollment;
SHOW CREATE TABLE Resource;

USE miniproj;
ALTER TABLE Admin MODIFY Admin_ID INT AUTO_INCREMENT;
ALTER TABLE Course  MODIFY Course_ID INT AUTO_INCREMENT;

USE miniproj;

-- Step 1: Drop the foreign key temporarily
ALTER TABLE Resource DROP FOREIGN KEY resource_ibfk_1;

-- Step 2: Change Resource_ID to auto increment
ALTER TABLE Resource MODIFY Resource_ID INT AUTO_INCREMENT PRIMARY KEY;

-- Step 3: Re-add the foreign key
ALTER TABLE Resource
ADD CONSTRAINT resource_ibfk_1
FOREIGN KEY (Course_ID) REFERENCES Course(Course_ID);

SHOW CREATE TABLE Resource;

USE miniproj;

-- Step 1: Drop the foreign key temporarily (if needed)
ALTER TABLE Resource DROP FOREIGN KEY resource_ibfk_1;

-- Step 2: Make Resource_ID auto-increment (DON’T redefine the primary key)
ALTER TABLE Resource MODIFY Resource_ID INT AUTO_INCREMENT;

-- Step 3: Re-add the foreign key
ALTER TABLE Resource
ADD CONSTRAINT resource_ibfk_1
FOREIGN KEY (Course_ID) REFERENCES Course(Course_ID);

USE miniproj;

-- 1️⃣ Drop the foreign key temporarily (so we can modify the column)
ALTER TABLE Resource DROP FOREIGN KEY resource_ibfk_1;

-- 2️⃣ Modify the Resource_ID column to auto increment
ALTER TABLE Resource MODIFY Resource_ID INT NOT NULL AUTO_INCREMENT;

-- 3️⃣ Re-add the foreign key to Course
ALTER TABLE Resource
ADD CONSTRAINT resource_ibfk_1
FOREIGN KEY (Course_ID) REFERENCES Course(Course_ID);


-- =========================================================
-- DEMONSTRATION QUERIES FOR ALL TYPES OF JOINS
-- =========================================================

-- INNER JOIN
SELECT s.Sub_ID, s.MarksAwarded, a.Title AS Assignment
FROM Submission s
INNER JOIN Assignment a ON s.Assign_ID = a.Assign_ID;

-- LEFT JOIN
SELECT st.Student_ID, st.Name, s.Sub_ID, s.MarksAwarded
FROM Student st
LEFT JOIN Submission s ON st.Student_ID = s.Student_ID;

-- RIGHT JOIN
SELECT s.Sub_ID, a.Assign_ID, a.Title
FROM Submission s
RIGHT JOIN Assignment a ON s.Assign_ID = a.Assign_ID;

-- NATURAL JOIN
SELECT CourseName, Faculty_ID, Name AS FacultyName
FROM Course NATURAL JOIN Faculty;










