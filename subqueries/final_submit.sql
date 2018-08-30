-- 1. Select all students with a lower than average Exam mark, showing their name, ID and exam mark. -- ( To be revised )

SELECT sm.ExamMark,sm.StudentID
FROM dbo.StudentModule sm
  JOIN dbo.Student s on s.StudentID = sm.StudentID
WHERE sm.ExamMark > (SELECT AVG(ExamMark) FROM dbo.StudentModule)

-- 2. Show the lecturer(s) with the highest exam weighting for a module. -- ( To be revised )

SELECT m.ModuleConvenor, m.ModuleID, m.ExamWeight AS HighestExamWeight
FROM dbo.Module m
where M.ExamWeight = (SELECT MAX(m2.ExamWeight)
                      FROM dbo.Module AS m2
                      WHERE m.ModuleConvenor = m2.ModuleConvenor)

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

SELECT l.StaffID,
  CONCAT(l.FirstName, ' ', l.Surname) AS FullName,
  ISNULL(CAST((SELECT AVG(m2.ExamWeight) FROM dbo.Module AS m2 WHERE m.ModuleConvenor = m2.ModuleConvenor GROUP BY ModuleConvenor) AS NVARCHAR), 'N/A') AS AvgExamWeight,
  ISNULL(CAST((SELECT AVG(m2.CWWeight) FROM dbo.Module AS m2 WHERE m.ModuleConvenor = m2.ModuleConvenor GROUP BY ModuleConvenor) AS NVARCHAR), 'N/A') AS AvgCWWeight
FROM dbo.Module AS m
  FULL JOIN dbo.Lecturer l ON m.ModuleConvenor = l.StaffID
GROUP BY l.StaffID, l.Surname, l.FirstName, m.ModuleConvenor

-- 7. Select all courses that include both modules CS2026 and BS2029, showing their ID and description. --

SELECT CourseDescription, CourseCode FROM Course
WHERE CourseCode = (SELECT CourseCode FROM dbo.CourseModule WHERE ModuleID IN ('CS2026', 'BS2029')
GROUP BY CourseCode
HAVING Count(*) = 2)

-- 8. Show all the students that have completed both BS and CS courses, displaying their ID’s, names and the date completed. Investigate the use of CONVERT to display the date completed in such a way that it only shows the date (UK style). -- 

-- (Only works if the dates are the same ?)


SELECT sc.StudentID, s.FirstName, s.Surname, CONVERT(varchar, CONVERT(datetime, sc.DateCompleted) , 103) AS DateCompleted
FROM dbo.StudentCourse sc
JOIN dbo.Student s ON sc.StudentID = s.StudentID
WHERE sc.CourseCode IN (SELECT c.CourseCode FROM dbo.Course c WHERE c.CourseCode IN ('BS','CS')) AND sc.StudentID IN (SELECT StudentID FROM dbo.StudentCourse
GROUP BY StudentID
HAVING SUM(1) > 1)
GROUP BY sc.StudentID, s.FirstName, s.Surname, sc.DateCompleted


SELECT sc.StudentID, s.FirstName
	, s.Surname
	, CONVERT(varchar, CONVERT(datetime, sc.DateCompleted) , 103) AS DateCompleted
FROM dbo.StudentCourse sc
JOIN dbo.Student s ON sc.StudentID = s.StudentID
WHERE sc.CourseCode IN (SELECT c.CourseCode FROM dbo.Course c WHERE c.CourseCode IN('BS','CS'))
GROUP BY sc.StudentID, s.FirstName, s.Surname, sc.DateCompleted
HAVING SUM(1) > 1
ORDER BY SUM(1) DESC






