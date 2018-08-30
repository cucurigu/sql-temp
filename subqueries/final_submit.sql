-- 1. Select all students with a lower than average Exam mark, showing their name, ID and exam mark. --

SELECT sm.ExamMark,
       sm.StudentID,
       CONCAT(s.FirstName, ' ', s.Surname) AS FullName
  FROM dbo.StudentModule sm
  JOIN dbo.Student s on s.StudentID = sm.StudentID
WHERE sm.ExamMark < (SELECT AVG(ExamMark) FROM dbo.StudentModule)

-- 2. Show the lecturer(s) with the highest exam weighting for a module. --

SELECT m.ModuleConvenor, m.ModuleID, m.ExamWeight AS HighestExamWeight
  FROM dbo.Module m
 WHERE M.ExamWeight = (SELECT MAX(m2.ExamWeight)
                      FROM dbo.Module AS m2
                      WHERE m.ModuleConvenor = m2.ModuleConvenor)

-- 3. Select all courses where an ‘A’ has been awarded, showing course code and description. Do this using both a (a) nested query and (b) joins. --

SELECT c.*, sm.*, s.FirstName, s.Surname, s.StudentID
  FROM dbo.StudentModule sm JOIN dbo.Student s ON s.StudentID = sm.StudentID
  JOIN dbo.Course c ON c.CourseCode = sm.CourseCode
 WHERE sm.Grade = (SELECT 'A');

-- 4. Show each lecturer’s lowest coursework weighting, displaying the Staff ID, the Module ID and the weighting selected. --

SELECT MIN(m.CWWeight) AS LowestCWWeight
     , m.ModuleConvenor AS StaffID
	   , (SELECT mm.ModuleID
	        FROM dbo.Module mm
	       WHERE mm.CWWeight = MIN(m.CWWeight)
	         AND mm.ModuleConvenor = m.ModuleConvenor) AS ModuleID
  FROM dbo.Module m
 GROUP BY m.ModuleConvenor


-- 5. Show the lowest overall mark that each lecturer has awarded on any of their modules, displaying the Staff ID, the lecturer’s first and last names, the Module ID and description and the relevant mark. -- ( To be revised )

SELECT StaffID, FirstName, Surname, ModuleID, ModuleDescription, OverallMark
  FROM (
       SELECT l.StaffID, l.FirstName, l.Surname, m.ModuleID, m.ModuleDescription, sm.OverallMark
            , ROW_NUMBER() OVER(PARTITION BY m.ModuleConvenor ORDER BY sm.OverallMark) AS TheRank
         FROM dbo.Lecturer l
         JOIN dbo.Module m ON m.ModuleConvenor = l.StaffID
         JOIN StudentModule sm ON sm.ModuleID = m.ModuleID
     ) a
WHERE TheRank = 1


-- 6. Display the ID, Name and average Exam and Coursework weights for all lecturers and make sure all the columns have suitable headings, using a correlated query. Investigate use of the ISNULL function to produce suitable output in the case of a lecturer not teaching any modules --

SELECT l.StaffID
     , CONCAT(l.FirstName, ' ', l.Surname) AS FullName
     , ISNULL(CAST((SELECT AVG(m2.ExamWeight) FROM dbo.Module AS m2 WHERE m.ModuleConvenor = m2.ModuleConvenor GROUP BY ModuleConvenor) AS NVARCHAR), 'N/A') AS AvgExamWeight
     , ISNULL(CAST((SELECT AVG(m2.CWWeight) FROM dbo.Module AS m2 WHERE m.ModuleConvenor = m2.ModuleConvenor GROUP BY ModuleConvenor) AS NVARCHAR), 'N/A') AS AvgCWWeight
  FROM dbo.Module AS m
  FULL JOIN dbo.Lecturer l ON m.ModuleConvenor = l.StaffID
 GROUP BY l.StaffID, l.Surname, l.FirstName, m.ModuleConvenor

-- 7. Select all courses that include both modules CS2026 and BS2029, showing their ID and description. --

SELECT CourseDescription
     , CourseCode
  FROM Course
 WHERE CourseCode = (SELECT CourseCode
                       FROM dbo.CourseModule
                      WHERE ModuleID IN ('CS2026', 'BS2029')
 GROUP BY CourseCode
HAVING Count(*) = 2)

-- 8. Show all the students that have completed both BS and CS courses, displaying their ID’s, names and the date completed. Investigate the use of CONVERT to display the date completed in such a way that it only shows the date (UK style). --

SELECT sc.StudentID
     , s.FirstName
     , s.Surname
     , CONVERT(varchar, CONVERT(datetime, sc.DateCompleted) , 103) AS DateCompleted
  FROM dbo.StudentCourse sc
  JOIN dbo.Student s ON sc.StudentID = s.StudentID
 WHERE sc.CourseCode IN (SELECT c.CourseCode
                           FROM dbo.Course c
                          WHERE c.CourseCode IN ('BS','CS'))
                            AND sc.StudentID IN (SELECT StudentID
                                                   FROM dbo.StudentCourse
                                               GROUP BY StudentID
                                                 HAVING SUM(1) > 1)
 GROUP BY sc.StudentID, s.FirstName, s.Surname, sc.DateCompleted

-- 9. Complete the following:
-- a. Write a query to show the IDs and Email addresses of all the Students and Lecturers, with the exception of all the students who are Excluded and those students and lecturers without email addresses.

SELECT CONVERT(nvarchar, s.StudentID) AS ID
     , s.Email
  FROM dbo.Student s
 WHERE s.StudentID IN (SELECT s2.StudentID
                         FROM dbo.Student s2
                        WHERE s2.Excluded = '0'
                          AND s2.email IS NOT NULL)
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


SELECT cm.*
     , m.ModuleDescription
  FROM dbo.CourseModule cm JOIN dbo.Module m ON m.ModuleID = cm.ModuleID
 WHERE m.ModuleID IN (SELECT mm.ModuleID
                        FROM dbo.Module mm JOIN dbo.CourseModule cmm ON cmm.ModuleID = mm.ModuleID
                       GROUP BY mm.ModuleID
                      HAVING SUM(1) > 1)
   AND m.ModuleID NOT IN (SELECT mmm.ModuleID
                           FROM dbo.CourseModule mmm JOIN dbo.CourseModule cmmm ON cmmm.ModuleID = mmm.ModuleID
                          WHERE cmmm.CourseCode = 'BS');


-- c. Create a temporary table, dbo.CompModule, and write a query to insert the rows returned by 9b above into it.

CREATE TABLE dbo.CompModule (
  CourseCode NVARCHAR(2),
  ModuleID NVARCHAR(10),
  ModuleDescription NVARCHAR(100)
)

INSERT INTO dbo.CompModule
  SELECT cm.CourseCode
       , cm.ModuleID
       , ModuleDescription
    FROM dbo.CourseModule cm JOIN dbo.Module m ON m.ModuleID = cm.ModuleID
   WHERE m.ModuleID IN (SELECT mm.ModuleID
                          FROM dbo.Module mm JOIN dbo.CourseModule cmm ON cmm.ModuleID = mm.ModuleID
                         GROUP BY mm.ModuleID
                        HAVING SUM(1) > 1)
     AND m.ModuleID NOT IN (SELECT mmm.ModuleID
                              FROM dbo.CourseModule mmm JOIN dbo.CourseModule cmmm ON cmmm.ModuleID = mmm.ModuleID
                             WHERE cmmm.CourseCode = 'BS')

SELECT * FROM dbo.CompModule