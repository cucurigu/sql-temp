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

  SELECT StaffID, FirstName, Surname, ModuleID, OverallMark
  FROM (
      SELECT l.StaffID, l.FirstName, l.Surname, m.ModuleID, m.ModuleDescription, sm.OverallMark
          , ROW_NUMBER() OVER(PARTITION BY m.ModuleConvenor ORDER BY sm.OverallMark) AS TheRank
      FROM dbo.Lecturer l
      JOIN dbo.Module m ON m.ModuleConvenor = l.StaffID
      JOIN dbo.StudentModule sm ON sm.ModuleID = m.ModuleID
  ) a
  WHERE TheRank = 1

-- 6. Display the ID, Name and average Exam and Coursework weights for all lecturers and make sure all the columns have suitable headings, using a correlated query. Investigate use of the ISNULL function to produce suitable output in the case of a lecturer not teaching any modules --

-- 7. Select all courses that include both modules CS2026 and BS2029, showing their ID and description. --

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
