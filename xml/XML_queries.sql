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
