-- A Theory of Justice B1076544 --
UPDATE dbo.Book
SET Chapters = '<CHAPTERLIST xmlns="http://myChapters">
	<CHAPTER ChapNo="1">
		<TITLE>Justice as Fairness</TITLE>
		<SUMMARY>Overview of the main lines of the Theory of Justice</SUMMARY>
		<KEYWORD>Justice</KEYWORD>
		<KEYWORD>Fairness</KEYWORD>
		<REFERENCE>Collected Papers</REFERENCE>
	</CHAPTER>		
	<CHAPTER ChapNo="2">
		<TITLE>The Principles of Justice</TITLE>
		<SUMMARY>How would Theory of Justice affect institutions today</SUMMARY>
		<KEYWORD>Philosophy</KEYWORD>
		<KEYWORD>Institutions</KEYWORD>
	</CHAPTER>
	<CHAPTER ChapNo="3">
		<TITLE>The Original Position</TITLE>
		<SUMMARY>Good effects that a real justice system can have on society</SUMMARY>
		<KEYWORD>Justice System</KEYWORD>
		<KEYWORD>Society</KEYWORD>
	</CHAPTER>
</CHAPTERLIST>'
WHERE BookID = 'B1076544'
-- -- -- -- -- -- -- -- --

-- 1.
WITH XMLNAMESPACES ('http://myChapters' AS CH)
SELECT BookID, Title, Chapters.query('/CH:CHAPTERLIST/CH:CHAPTER/CH:REFERENCE') AS Chapters
FROM dbo.Book
WHERE Chapters.exist('/CH:CHAPTERLIST/CH:CHAPTER/CH:REFERENCE') = 1;


-- 2.
WITH XMLNAMESPACES ('http://myChapters' AS CH)
SELECT BookID, Title, Chapters.query('/CH:CHAPTERLIST/CH:CHAPTER[2]/CH:REFERENCE') AS Chapters
FROM dbo.Book
WHERE BookID = 'B1076543';

-- 3.

WITH XMLNAMESPACES ('http://myChapters' AS CH)
SELECT b.BookID, b.Title, b2.reference.value('.', 'varchar(50)') AS Reference
FROM dbo.Book AS b
CROSS APPLY b.Chapters.nodes('/CH:CHAPTERLIST/CH:CHAPTER/CH:REFERENCE') AS b2(reference)
WHERE b2.reference.value('.', 'varchar(50)') = 'Database Systems';
