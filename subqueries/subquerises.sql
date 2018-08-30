SELECT * FROM dbo.Course
SELECT * FROM dbo.CourseModule
SELECT * FROM dbo.Lecturer
SELECT * FROM dbo.Module
SELECT * FROM dbo.Student
SELECT * FROM dbo.StudentCourse
SELECT * FROM dbo.StudentModule

-- 1. Select all students with a lower than average Exam mark, showing their name, ID and exam mark. --

SELECT (SELECT AVG(sub.ExamMark)
                       FROM dbo.StudentModule sub
					  WHERE CONCAT(sm.CourseCode, '-', sm.ModuleID) = CONCAT(sub.CourseCode, '-', sub.ModuleID)) AS AvgMark
     , sm.*
     , s.FirstName
	 , s.Surname
	 , s.StudentID
  FROM dbo.StudentModule sm JOIN dbo.Student s ON s.StudentID = sm.StudentID
 WHERE sm.ExamMark < (SELECT AVG(sub.ExamMark)
                       FROM dbo.StudentModule sub
					  WHERE CONCAT(sm.CourseCode, '-', sm.ModuleID) = CONCAT(sub.CourseCode, '-', sub.ModuleID));

-- 2. Show the lecturer(s) with the highest exam weighting for a module. --

SELECT SUM(1) AS Records
     , c.CourseCode
     , sm.ModuleID
     , (SELECT SUM(smm.ExamMark) FROM dbo.StudentModule smm WHERE smm.ModuleID = sm.ModuleID) AS ExamMarkTotal
	 , c.CourseDescription
	 , (SELECT m.ModuleDescription FROM dbo.Module m WHERE m.ModuleID = sm.ModuleID) AS ModuleDescription
	 , c.CourseTutorCode
	 , (SELECT CONCAT(l.FirstName, ' ', l.Surname) FROM dbo.Lecturer l WHERE l.StaffID = c.CourseTutorCode) AS Lecturer
  FROM dbo.Course c JOIN dbo.StudentModule sm ON c.CourseCode = sm.CourseCode
  GROUP BY c.CourseCode, sm.ModuleID, c.CourseTutorCode, c.CourseDescription
  ORDER BY (SELECT SUM(smm.ExamMark) FROM dbo.StudentModule smm WHERE smm.ModuleID = sm.ModuleID) DESC;

-- 3. Select all courses where an ‘A’ has been awarded, showing course code and description. Do this using both a (a) nested query and (b) joins. --

SELECT c.*, sm.*, s.FirstName, s.Surname, s.StudentID
  FROM dbo.StudentModule sm JOIN dbo.Student s ON s.StudentID = sm.StudentID
  JOIN dbo.Course c ON c.CourseCode = sm.CourseCode
 WHERE sm.Grade = (SELECT 'A');

-- 4. Show each lecturer’s lowest coursework weighting, displaying the Staff ID, the Module ID and the weighting selected. --

SELECT MIN(m.CWWeight) AS CWWeight
     , m.ModuleConvenor AS StaffID
	 , (SELECT mm.ModuleID FROM dbo.Module mm WHERE mm.CWWeight = MIN(m.CWWeight) AND mm.ModuleConvenor = m.ModuleConvenor) AS ModuleID
 FROM dbo.Module m
GROUP BY m.ModuleConvenor

-- 5. Show the lowest overall mark that each lecturer has awarded on any of their modules, displaying the Staff ID, the lecturer’s first and last names, the Module ID and description and the relevant mark. --

SELECT MIN(m.CWWeight) AS CWWeight
     , m.ModuleConvenor AS StaffID
	 , (SELECT mm.ModuleID FROM dbo.Module mm WHERE mm.CWWeight = MIN(m.CWWeight) AND mm.ModuleConvenor = m.ModuleConvenor) AS ModuleID
 FROM dbo.Module m
GROUP BY m.ModuleConvenor

SELECT m.ModuleID
	, m.ModuleDescription
	, l.FirstName
	, l.Surname
	, l.StaffID
	, (SELECT MIN(sm.OverallMark) FROM dbo.StudentModule sm WHERE m.ModuleID = sm.ModuleID AND m.ModuleConvenor = l.StaffID) AS OverallMark
 FROM dbo.Module m JOIN dbo.Lecturer l ON m.ModuleConvenor = l.StaffID
 ORDER BY (SELECT MIN(sm.OverallMark) FROM dbo.StudentModule sm WHERE m.ModuleID = sm.ModuleID AND m.ModuleConvenor = l.StaffID) ASC


 SELECT TOP (SELECT COUNT(*) FROM dbo.Lecturer l GROUP BY l.StaffID) m.ModuleID
	, m.ModuleDescription
	, l.FirstName
	, l.Surname
	, l.StaffID
	, (SELECT MIN(sm.OverallMark) FROM dbo.StudentModule sm WHERE m.ModuleID = sm.ModuleID AND m.ModuleConvenor = l.StaffID) AS OverallMark
 FROM dbo.Module m JOIN dbo.Lecturer l ON m.ModuleConvenor = l.StaffID
  AND l.StaffID in ('021478P','021345F')
 ORDER BY (SELECT MIN(sm.OverallMark) FROM dbo.StudentModule sm WHERE m.ModuleID = sm.ModuleID AND m.ModuleConvenor = l.StaffID) ASC


 SELECT DISTINCT x.StaffID
      , l.Surname
    , l.FirstName
    , l.Phone
    , l.Email
   FROM dbo.Lecturer x
   JOIN dbo.Lecturer l ON l.StaffID = x.StaffID
  WHERE x.StaffID IN ('021478P','021345F');

  SELECT DISTINCT x.StaffID
       , l.Surname
	   , l.FirstName
	   , l.Phone
	   , l.Email
	   , (SELECT TOP 1 CONCAT(md.ModuleID, ',', MIN(md.OverallMark), ',', (SELECT xm.ModuleDescription FROM dbo.Module xm WHERE xm.ModuleID = md.ModuleID)) AS ModuleMinOverallMark
   FROM dbo.StudentModule md JOIN dbo.CourseModule cm ON cm.ModuleID = md.ModuleID
        JOIN dbo.Module m ON m.ModuleID = md.ModuleID
	WHERE m.ModuleConvenor = x.StaffID
GROUP BY md.ModuleID
	ORDER BY MIN(md.OverallMark) ASC) AS pipi
    FROM dbo.Lecturer x
    JOIN dbo.Lecturer l ON l.StaffID = x.StaffID
   WHERE x.StaffID IN (SELECT DISTINCT xl.StaffID FROM dbo.Lecturer xl);

--- ??? @TODO: polish it up....


   DECLARE @mamrot VARCHAR(500);
   SET @mamrot = 'one,two,three'
   SELECT @mamrot;


   SELECT 'bzzz' AS madeup,
       PARSENAME(REPLACE(@mamrot,',','.'),1) One,
       PARSENAME(REPLACE(@mamrot,',','.'),2) Two
	;


-- 6. Display the ID, Name and average Exam and Coursework weights for all lecturers and make sure all the columns have suitable headings, using a correlated query. Investigate use of the ISNULL function to produce suitable output in the case of a lecturer not teaching any modules --

INSERT INTO dbo.Lecturer
VALUES
('021999G', 'Len', 'Greg', '020 7123 9123', 'greg@email.com')


-- (a) if you are after top-most AVG based on Courses only this is the answer

SELECT (SELECT CONCAT(l.FirstName, + ' ', + l.Surname)
          FROM dbo.Lecturer l JOIN dbo.Course cc ON cc.CourseTutorCode = l.StaffID
         WHERE cc.CourseCode = c.CourseCode)  AS FullName
     , c.CourseCode
	 , AVG(sm.ExamMark) AS AvgExamMark
	 , AVG(sm.CWMark) AS AvgCWMark
  FROM dbo.Course c JOIN dbo.StudentModule sm ON sm.CourseCode = c.CourseCode
 WHERE c.CourseTutorCode IN (SELECT DISTINCT cc2.CourseTutorCode FROM dbo.Course cc2)
 GROUP BY c.CourseCode

 UNION

  SELECT DISTINCT CONCAT(lx.FirstName, + ' ', + lx.Surname) AS FullName
       , 'N/A' AS CourseCode
	   , ISNULL(null, 0) AS AvgExamMark
	   , ISNULL(null, 0) AS AvgCWMark
    FROM dbo.Lecturer lx LEFT JOIN dbo.Course crs ON crs.CourseTutorCode = lx.StaffID
   WHERE (SELECT COUNT(1) AS found FROM dbo.Course cx WHERE cx.CourseTutorCode = lx.StaffID) = 0

-- (b) if you require a breakdown for Modules then here is your query

SELECT (SELECT CONCAT(l.FirstName, + ' ', + l.Surname)
          FROM dbo.Lecturer l JOIN dbo.Course cc ON cc.CourseTutorCode = l.StaffID
         WHERE cc.CourseCode = c.CourseCode)  AS FullName
     , c.CourseCode
     , sm.ModuleID
	 , AVG(sm.ExamMark) AS AvgExamMark
	 , AVG(sm.CWMark) AS AvgCWMark
  FROM dbo.Course c JOIN dbo.StudentModule sm ON sm.CourseCode = c.CourseCode
 WHERE c.CourseTutorCode IN (SELECT DISTINCT cc2.CourseTutorCode FROM dbo.Course cc2)
 GROUP BY c.CourseCode, sm.ModuleID

 UNION

  SELECT DISTINCT CONCAT(lx.FirstName, + ' ', + lx.Surname) AS FullName
       , 'N/A' AS CourseCode
	   , 'N/A' AS ModuleID
	   , ISNULL(null, 0) AS AvgExamMark
	   , ISNULL(null, 0) AS AvgCWMark
    FROM dbo.Lecturer lx LEFT JOIN dbo.Course crs ON crs.CourseTutorCode = lx.StaffID
   WHERE (SELECT COUNT(1) AS found FROM dbo.Course cx WHERE cx.CourseTutorCode = lx.StaffID) = 0



-- 7. Select all courses that include both modules CS2026 and BS2029, showing their ID and description. --

SELECT cm.*, m.ModuleDescription FROM dbo.CourseModule cm
JOIN dbo.Module m ON cm.ModuleID = m.ModuleID;

SELECT cm1.CourseCode, cm1.ModuleID, cm2.ModuleID
FROM dbo.CourseModule cm1
INNER JOIN dbo.CourseModule cm2
ON cm2.CourseCode = cm1.CourseCode
WHERE cm2.ModuleID = 'BS2029'
AND cm1.ModuleID = 'CS2026'

SELECT id, first_name
FROM student_details
WHERE id IN (SELECT student_id
FROM student_subjects
WHERE subject= 'Science');

-- 8. Show all the students that have completed both BS and CS courses, displaying their ID’s, names and the date completed. Investigate the use of CONVERT to display the date completed in such a way that it only shows the date (UK style). --

SELECT sc.StudentID, s.FirstName
	, s.Surname
	, CONVERT(varchar, CONVERT(datetime, sc.DateCompleted) , 103) AS DateCompleted
FROM dbo.StudentCourse sc
JOIN dbo.Student s ON sc.StudentID = s.StudentID
WHERE sc.CourseCode IN (SELECT c.CourseCode FROM dbo.Course c WHERE c.CourseCode IN('BS','CS'))
GROUP BY sc.StudentID, s.FirstName, s.Surname, sc.DateCompleted
HAVING SUM(1) > 1
ORDER BY SUM(1) DESC

-- 9. Complete the following:
-- a. Write a query to show the IDs and Email addresses of all the Students and Lecturers, with the exception of all the students who are Excluded and those students and lecturers without email addresses.

SELECT CONVERT(nvarchar, s.StudentID) AS ID,
	   s.Email
FROM dbo.Student s
WHERE s.StudentID IN (SELECT s2.StudentID FROM dbo.Student s2 WHERE s2.Excluded = '0' AND s2.email IS NOT NULL)
UNION
SELECT StaffID AS ID, email FROM dbo.Lecturer WHERE email IS NOT NULL

-- b. Write a query to show the Module IDs and Module Descriptions of all modules that are on both the CS and CN (Computer Networking) course, other than those that are on the BS course (you will need to create relevant data to test this).
INSERT INTO dbo.Course
VALUES ('CN', 'Computer Networking', '021478P', 'T')

INSERT INTO dbo.CourseModule VALUES
('CN', 'CN2050'),
('CN', 'CN2071'),
('CS', 'CN2050')

INSERT INTO dbo.Module VALUES
('CN2050', 'Networking Concepts', '021478P', '50', '50'),
('CN2071', 'Communications Engineering', '021478P', '30', '70')


 SELECT cm.*, m.ModuleDescription
   FROM dbo.CourseModule cm JOIN dbo.Module m ON m.ModuleID = cm.ModuleID
  WHERE m.ModuleID IN (
        SELECT mm.ModuleID
          FROM dbo.Module mm JOIN dbo.CourseModule cmm ON cmm.ModuleID = mm.ModuleID
         GROUP BY mm.ModuleID
        HAVING SUM(1) > 1) as t
   AND m.ModuleID NOT IN (
        SELECT mmm.ModuleID
          FROM dbo.CourseModule mmm JOIN dbo.CourseModule cmmm ON cmmm.ModuleID = mmm.ModuleID
         WHERE cmmm.CourseCode = 'BS') as b;

-- c. Create a temporary table, dbo.CompModule, and write a query to insert the rows returned by 9b above into it.

CREATE TABLE dbo.CompModule (
	CourseCode NVARCHAR(2),
	ModuleID NVARCHAR(10),
	ModuleDescription NVARCHAR(100)
)

 INSERT INTO dbo.CompModule
 SELECT cm.CourseCode, cm.ModuleID, ModuleDescription
   FROM dbo.CourseModule cm JOIN dbo.Module m ON m.ModuleID = cm.ModuleID
  WHERE m.ModuleID IN (
        SELECT mm.ModuleID
          FROM dbo.Module mm JOIN dbo.CourseModule cmm ON cmm.ModuleID = mm.ModuleID
         GROUP BY mm.ModuleID
        HAVING SUM(1) > 1)
   AND m.ModuleID NOT IN (
        SELECT mmm.ModuleID
          FROM dbo.CourseModule mmm JOIN dbo.CourseModule cmmm ON cmmm.ModuleID = mmm.ModuleID
         WHERE cmmm.CourseCode = 'BS')

SELECT * FROM dbo.CompModule
