
-- Group Coding Lab 27
-- Tracks student grades in Linux and Python courses


-- 1. Create Database
DROP DATABASE IF EXISTS student_performance_db;
CREATE DATABASE student_performance_db;
USE student_performance_db;

-- 2. Create Tables


-- Table: students
CREATE TABLE students (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    student_name VARCHAR(100) NOT NULL,
    intake_year INT NOT NULL
);

-- Table: linux_grades
CREATE TABLE linux_grades (
    course_id INT PRIMARY KEY AUTO_INCREMENT,
    course_name VARCHAR(50) DEFAULT 'Linux',
    student_id INT,
    grade_obtained DECIMAL(5,2),
    FOREIGN KEY (student_id) REFERENCES students(student_id)
);

-- Table: python_grades
CREATE TABLE python_grades (
    course_id INT PRIMARY KEY AUTO_INCREMENT,
    course_name VARCHAR(50) DEFAULT 'Python',
    student_id INT,
    grade_obtained DECIMAL(5,2),
    FOREIGN KEY (student_id) REFERENCES students(student_id)
);


-- At least 15 students, with some taking one or both courses


INSERT INTO students (student_name, intake_year) VALUES
('Alice Johnson', 2023),
('Brian Kim', 2023),
('Catherine Lee', 2023),
('Daniel Smith', 2023),
('Eva Brown', 2023),
('Frank White', 2024),
('Grace Green', 2024),
('Henry Adams', 2024),
('Ivy Carter', 2024),
('James Hall', 2024),
('Karen Young', 2024),
('Leo Turner', 2025),
('Maria Lopez', 2025),
('Nathan Scott', 2025),
('Olivia King', 2025);

-- Linux Grades
INSERT INTO linux_grades (student_id, grade_obtained) VALUES
(1, 75.5),
(2, 45.0),
(3, 82.0),
(4, 49.5),
(5, 67.0),
(6, 90.0),
(7, 55.0),
(9, 62.5),
(10, 40.0),
(12, 71.0);

-- Python Grades
INSERT INTO python_grades (student_id, grade_obtained) VALUES
(1, 88.0),
(3, 79.5),
(4, 53.0),
(6, 91.0),
(8, 68.0),
(9, 47.0),
(11, 81.0),
(13, 59.5),
(14, 72.0),
(15, 95.0);


-- 4. Queries


-- Q1: Find students who scored less than 50% in the Linux course
SELECT s.student_id, s.student_name, l.grade_obtained
FROM students s
JOIN linux_grades l ON s.student_id = l.student_id
WHERE l.grade_obtained < 50;

-- Q2: Find students who took only one course (Linux OR Python, but not both)
SELECT s.student_id, s.student_name
FROM students s
WHERE (s.student_id IN (SELECT student_id FROM linux_grades)
       XOR
       s.student_id IN (SELECT student_id FROM python_grades));

-- Q3: Find students who took both courses
SELECT s.student_id, s.student_name
FROM students s
WHERE s.student_id IN (SELECT student_id FROM linux_grades)
  AND s.student_id IN (SELECT student_id FROM python_grades);

-- Q4: Calculate the average grade per course (Linux and Python separately)
SELECT 'Linux' AS course, AVG(grade_obtained) AS avg_grade
FROM linux_grades
UNION
SELECT 'Python' AS course, AVG(grade_obtained) AS avg_grade
FROM python_grades;

-- Q5: Identify the top-performing student across both courses
-- (based on their average across all courses they took)
SELECT s.student_id, s.student_name,
       AVG(grades.grade_obtained) AS overall_avg
FROM students s
JOIN (
    SELECT student_id, grade_obtained FROM linux_grades
    UNION ALL
    SELECT student_id, grade_obtained FROM python_grades
) AS grades
ON s.student_id = grades.student_id
GROUP BY s.student_id, s.student_name
ORDER BY overall_avg DESC
LIMIT 1;

