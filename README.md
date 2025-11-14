
# **EduNest – Academic Resource Management System**

### **Database Schema & Implementation (DBMS Mini Project)**

## **1. Overview**

EduNest is an academic resource management system designed to streamline interactions among students, faculty, administrators, and course-related resources.
This SQL file sets up the complete relational database required for the system, including core tables, relationships, triggers, stored procedures, and functions.
The database is built using **MySQL** and supports structured storage, academic workflows, and automated data processing through triggers.

---

## **2. Database Structure**

### **Database**

* **Name:** `miniproj`

The script automatically drops any existing database with the same name and creates a fresh one.

---

## **3. Tables Included**

### **1. Student**

Stores student details such as ID, name, email, department, semester, and password.

### **2. Faculty**

Contains faculty information including designation and optional supervisor relationships.

### **3. Admin**

Includes administrative users with specific roles (e.g., System Admin, Exam Controller).

### **4. Course**

Maintains course information mapped to the faculty teaching the course.

### **5. Enrollment**

Represents student enrollments in courses (many-to-many relationship).

### **6. Resource**

Tracks academic resources uploaded for various courses (PDFs, PPTs, ZIP files, etc.).

### **7. Assignment**

Stores assignments with deadlines and maximum marks for each course.

### **8. Submission**

Records student submissions, marks, and feedback for assignments.

### **9. AuditLog**

Logs important actions within the system with timestamps.

### **10. Student_Average**

Maintains computed average marks and total submissions for each student.

---

## **4. Key Features**

### **A. Triggers**

**1. `trg_auto_feedback` (Before Insert on Submission)**
Automatically generates default feedback if feedback is not provided.

**2. `trg_update_student_average` (After Insert on Submission)**
Updates or creates an entry in `Student_Average` for the concerned student by calculating:

* Average marks
* Total number of submissions

---

### **B. Stored Procedures**

**1. `GetStudentSubmissions(sid)`**
Returns all submissions made by a specific student along with assignment details.

**2. `AddResource(...)`**
Inserts a new resource into the Resource table.

---

### **C. Functions**

**1. `GetTotalMarks(studentId)`**
Calculates and returns the total marks obtained by a student.

**2. `CountSubmissions(assignId)`**
Returns the total number of submissions for a given assignment.

---

## **5. Additional Adjustments Included**

The script includes several `ALTER TABLE` statements to:

* Enable auto-increment for `Admin_ID`, `Course_ID`, and `Resource_ID`
* Safely drop and re-add foreign key constraints for modification
* Ensure table definitions meet MySQL requirements

These adjustments ensure smooth operation and prevent constraint-related errors.

---

## **6. Demonstration Queries**

The SQL file also provides sample queries demonstrating:

* **INNER JOIN**
* **LEFT JOIN**
* **RIGHT JOIN**
* **NATURAL JOIN**

These queries showcase relational connections between entities and help with analysis or academic presentations.

---

## **7. How to Execute the Script**

1. Open MySQL Workbench, phpMyAdmin, or MySQL CLI.
2. Load or paste the SQL file content.
3. Execute the script completely.
4. Verify the created tables and objects using:

   * `SHOW TABLES;`
   * `SHOW TRIGGERS;`
   * `SHOW PROCEDURE STATUS;`
   * `SHOW FUNCTION STATUS;`

---

## **8. Purpose**

This database forms the backend foundation for an academic management system supporting:

* Course management
* Assignment workflows
* Resource sharing
* Student performance tracking
* Audit logging
* Automated data processing (via triggers)


---

