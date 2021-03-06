USE [LocalLibrary]
GO
/****** Object:  XmlSchemaCollection [dbo].[BookChaptersSchema]    Script Date: 8/31/2018 5:35:25 PM ******/
CREATE XML SCHEMA COLLECTION [dbo].[BookChaptersSchema] AS N'<xsd:schema xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:t="http://myChapters" targetNamespace="http://myChapters" elementFormDefault="qualified"><xsd:element name="CHAPTERLIST"><xsd:complexType><xsd:complexContent><xsd:restriction base="xsd:anyType"><xsd:sequence><xsd:element name="CHAPTER"><xsd:complexType><xsd:complexContent><xsd:restriction base="xsd:anyType"><xsd:sequence><xsd:element name="TITLE" type="xsd:string" /><xsd:element name="SUMMARY" type="xsd:string" /><xsd:element name="KEYWORD" type="t:KEYWORDTYPE" maxOccurs="3" /></xsd:sequence><xsd:attribute name="ChapNo" type="t:CHAPNOTYPE" /></xsd:restriction></xsd:complexContent></xsd:complexType></xsd:element></xsd:sequence></xsd:restriction></xsd:complexContent></xsd:complexType></xsd:element><xsd:simpleType name="CHAPNOTYPE"><xsd:restriction base="xsd:string"><xsd:maxLength value="3" /><xsd:pattern value="[0-9]{1,3}" /></xsd:restriction></xsd:simpleType><xsd:simpleType name="KEYWORDTYPE"><xsd:restriction base="xsd:string"><xsd:maxLength value="20" /></xsd:restriction></xsd:simpleType></xsd:schema>'
GO
/****** Object:  XmlSchemaCollection [dbo].[BookChaptersSchema_New]    Script Date: 8/31/2018 5:35:25 PM ******/
CREATE XML SCHEMA COLLECTION [dbo].[BookChaptersSchema_New] AS N'<xsd:schema xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:t="http://myChapters" targetNamespace="http://myChapters" elementFormDefault="qualified"><xsd:element name="CHAPTERLIST"><xsd:complexType><xsd:complexContent><xsd:restriction base="xsd:anyType"><xsd:sequence><xsd:element name="CHAPTER"><xsd:complexType><xsd:complexContent><xsd:restriction base="xsd:anyType"><xsd:sequence><xsd:element name="TITLE" type="xsd:string" /><xsd:element name="SUMMARY" type="xsd:string" /><xsd:element name="KEYWORD" type="t:KEYWORDTYPE" maxOccurs="3" /><xsd:element name="REFERENCE" type="xsd:string" minOccurs="0" maxOccurs="100" /></xsd:sequence><xsd:attribute name="ChapNo" type="t:CHAPNOTYPE" /></xsd:restriction></xsd:complexContent></xsd:complexType></xsd:element></xsd:sequence></xsd:restriction></xsd:complexContent></xsd:complexType></xsd:element><xsd:simpleType name="CHAPNOTYPE"><xsd:restriction base="xsd:string"><xsd:maxLength value="3" /><xsd:pattern value="[0-9]{1,3}" /></xsd:restriction></xsd:simpleType><xsd:simpleType name="KEYWORDTYPE"><xsd:restriction base="xsd:string"><xsd:maxLength value="20" /></xsd:restriction></xsd:simpleType></xsd:schema>'
GO
/****** Object:  XmlSchemaCollection [dbo].[GenreTestSchema]    Script Date: 8/31/2018 5:35:25 PM ******/
CREATE XML SCHEMA COLLECTION [dbo].[GenreTestSchema] AS N'<xsd:schema xmlns:xsd="http://www.w3.org/2001/XMLSchema"><xsd:group name="GENRELISTGROUP"><xsd:sequence><xsd:element name="GENRE" type="xsd:anyType" minOccurs="0" maxOccurs="unbounded" /></xsd:sequence></xsd:group></xsd:schema>'
GO
/****** Object:  UserDefinedTableType [dbo].[tvpBorrowerList]    Script Date: 8/31/2018 5:35:25 PM ******/
CREATE TYPE [dbo].[tvpBorrowerList] AS TABLE(
	[BorrowerID] [nvarchar](100) NOT NULL
)
GO
/****** Object:  UserDefinedFunction [dbo].[adding]    Script Date: 8/31/2018 5:35:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[adding](@number1 varchar(50), @number2 varchar(50))
RETURNS varchar(50)
AS
BEGIN
RETURN UPPER(@number1 + @number2)
END

GO
/****** Object:  UserDefinedFunction [dbo].[fnBorrowerUsage]    Script Date: 8/31/2018 5:35:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fnBorrowerUsage](@booksCount int, @type nvarchar(30))
RETURNS VARCHAR(250)
AS
BEGIN
    DECLARE @label nvarchar(200)
    /*
    SET @label = (SELECT CONCAT(c.Label, ' ', c.Type) AS Description
                  FROM dbo.ConfigBorrowerBands AS c
                  WHERE c.type = @type
                  AND @booksCount BETWEEN c.ValueFrom AND c.ValueTo)
*/
    IF @type = 'Ordinary'
    BEGIN
    SET @label = 'Ordinary'
    END
    ELSE
    BEGIN
    SET @label = (SELECT CONCAT(c.Label, ' ', c.Type) AS Description
                  FROM dbo.ConfigBorrowerBands AS c
                  WHERE c.type = @type
                  AND @booksCount BETWEEN c.ValueFrom AND c.ValueTo)
    END

    RETURN @label
END

GO
/****** Object:  UserDefinedFunction [dbo].[fnTrimUpper]    Script Date: 8/31/2018 5:35:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[fnTrimUpper](@title nvarchar(50))
RETURNS nvarchar(50)
AS
BEGIN
RETURN LTRIM(UPPER(@title))
END
GO
/****** Object:  UserDefinedFunction [dbo].[GetBorrowerStatus]    Script Date: 8/31/2018 5:35:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[GetBorrowerStatus] (
  @BorrowerID NVARCHAR(8)
)
RETURNS NVARCHAR(100)
AS
BEGIN

  DECLARE @Status NVARCHAR(100)

  IF NOT EXISTS (SELECT BorrowerID FROM dbo.Borrower WHERE BorrowerID = @BorrowerID)
  BEGIN
  SET @Status = NULL
  END

  IF EXISTS (SELECT BorrowerID FROM dbo.AcademicBorrower WHERE BorrowerID = @BorrowerID)
  BEGIN
  SET @Status = 'Academic'
  END

  IF EXISTS (SELECT BorrowerID FROM dbo.BusinessBorrower WHERE BorrowerID = @BorrowerID)
  BEGIN
  SET @Status = 'Business'
  END

  RETURN @Status
END

GO
/****** Object:  UserDefinedFunction [dbo].[LPAD]    Script Date: 8/31/2018 5:35:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[LPAD]
(
    @string NVARCHAR(MAX), -- Initial string
    @length INT,          -- Size of final string
    @pad CHAR             -- Pad character
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
    RETURN REPLICATE(@pad, @length - LEN(@string)) + @string;
END

GO
/****** Object:  UserDefinedFunction [dbo].[PAD]    Script Date: 8/31/2018 5:35:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[PAD]
(
    @str NVARCHAR(MAX), -- Initial string
    @length INT,           -- Size of final string
    @pad CHAR,             -- Pad character
    @type NVARCHAR(8)      -- takes 'left' or 'right' default is right
)
RETURNS NVARCHAR(MAX)
AS
BEGIN

    DECLARE @out NVARCHAR(MAX);

    IF @type = 'left'
      BEGIN
        SET @out = REVERSE(REPLICATE(@pad, @length - LEN(@str)) + REVERSE(@str))
      END
    ELSE
      BEGIN
        SET @out = REPLICATE(@pad, @length - LEN(@str)) + @str;
      END

    RETURN @out
END

GO
/****** Object:  UserDefinedFunction [dbo].[resolveBorrower]    Script Date: 8/31/2018 5:35:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[resolveBorrower] (@query VARCHAR(250))
RETURNS VARCHAR(250)
AS BEGIN
    DECLARE @borrowerId VARCHAR(250)

    SET @borrowerId = (SELECT b.BorrowerID 
                         FROM dbo.Borrower AS b 
                        WHERE dbo.fnTrimUpper(CONCAT(b.BorrowerFName, ' ', b.BorrowerLName)) = dbo.fnTrimUpper(@query))
    RETURN @borrowerId
END
GO
/****** Object:  UserDefinedFunction [dbo].[returnBorrower]    Script Date: 8/31/2018 5:35:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[returnBorrower](@borrower nvarchar(50))
RETURNS nvarchar(50)
AS
BEGIN
RETURN @borrower
END


GO
/****** Object:  UserDefinedFunction [dbo].[RPAD]    Script Date: 8/31/2018 5:35:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[RPAD]
(
    @string NVARCHAR(MAX), -- Initial string
    @length INT,          -- Size of final string
    @pad CHAR             -- Pad character
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
    RETURN REPLICATE(@string, 5) + @pad;
END

GO
/****** Object:  UserDefinedFunction [dbo].[splitstring]    Script Date: 8/31/2018 5:35:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[splitstring] ( @stringToSplit VARCHAR(MAX) )
RETURNS
 @returnList TABLE ([Name] [nvarchar] (500))
AS
BEGIN

 DECLARE @name NVARCHAR(255)
 DECLARE @pos INT

 WHILE CHARINDEX(',', @stringToSplit) > 0
 BEGIN
  SELECT @pos  = CHARINDEX(',', @stringToSplit)  
  SELECT @name = SUBSTRING(@stringToSplit, 1, @pos-1)

  INSERT INTO @returnList 
  SELECT @name

  SELECT @stringToSplit = SUBSTRING(@stringToSplit, @pos+1, LEN(@stringToSplit)-@pos)
 END

 INSERT INTO @returnList
 SELECT @stringToSplit

 RETURN
END
GO
/****** Object:  Table [dbo].[AcademicBorrower]    Script Date: 8/31/2018 5:35:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AcademicBorrower](
	[BorrowerID] [nvarchar](8) NOT NULL,
	[DeliveryAddress] [nvarchar](50) NOT NULL,
	[Discount] [smallint] NOT NULL,
 CONSTRAINT [PK_AcademicBorrower] PRIMARY KEY CLUSTERED 
(
	[BorrowerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Audit_Table]    Script Date: 8/31/2018 5:35:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Audit_Table](
	[TranID] [int] IDENTITY(1,1) NOT NULL,
	[Handler] [nvarchar](200) NOT NULL,
	[Level] [int] NOT NULL,
	[DateStamp] [datetime] NULL,
	[ErrorLog] [nvarchar](2000) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[TranID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Author]    Script Date: 8/31/2018 5:35:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Author](
	[AuthorID] [nvarchar](8) NOT NULL,
	[AuthorName] [nvarchar](50) NOT NULL,
	[AuthorBio] [nvarchar](max) NULL,
	[AuthorPhoto] [varbinary](max) NULL,
 CONSTRAINT [PK_Author] PRIMARY KEY CLUSTERED 
(
	[AuthorID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Book]    Script Date: 8/31/2018 5:35:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Book](
	[BookID] [nvarchar](8) NOT NULL,
	[Title] [nvarchar](50) NOT NULL,
	[ISBN] [nvarchar](20) NOT NULL,
	[Publisher] [nvarchar](25) NOT NULL,
	[RenewalPeriod] [smallint] NOT NULL,
	[Fine] [money] NOT NULL,
	[MaxTotalFine]  AS ([Fine]*(5)),
	[SectionID] [nvarchar](8) NOT NULL,
	[Chapters] [xml] NULL,
 CONSTRAINT [PK_Book] PRIMARY KEY CLUSTERED 
(
	[BookID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[BookAuthor]    Script Date: 8/31/2018 5:35:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BookAuthor](
	[BookID] [nvarchar](8) NOT NULL,
	[AuthorID] [nvarchar](8) NOT NULL,
	[PrimaryAuthor] [bit] NOT NULL,
 CONSTRAINT [PK_BookAuthor] PRIMARY KEY CLUSTERED 
(
	[BookID] ASC,
	[AuthorID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[BookGenre]    Script Date: 8/31/2018 5:35:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BookGenre](
	[BookID] [nvarchar](8) NOT NULL,
	[GenreID] [nvarchar](8) NOT NULL,
 CONSTRAINT [PK_BookGenre] PRIMARY KEY CLUSTERED 
(
	[BookID] ASC,
	[GenreID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Borrower]    Script Date: 8/31/2018 5:35:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Borrower](
	[BorrowerID] [nvarchar](8) NOT NULL,
	[BorrowerLName] [nvarchar](25) NOT NULL,
	[BorrowerFName] [nvarchar](25) NOT NULL,
	[BorrowerAddress] [nvarchar](100) NOT NULL,
	[BorrowerTelNo] [nvarchar](20) NOT NULL,
	[BorrowerEmail] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_Borrower] PRIMARY KEY CLUSTERED 
(
	[BorrowerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[BorrowerGenre]    Script Date: 8/31/2018 5:35:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BorrowerGenre](
	[BorrowerID] [nvarchar](8) NOT NULL,
	[GenreID] [nvarchar](8) NOT NULL,
 CONSTRAINT [PK_BorrowerGenre] PRIMARY KEY CLUSTERED 
(
	[BorrowerID] ASC,
	[GenreID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[BusinessBorrower]    Script Date: 8/31/2018 5:35:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BusinessBorrower](
	[BorrowerID] [nvarchar](8) NOT NULL,
	[BusinessDescription] [nvarchar](100) NOT NULL,
	[DeliveryAddress] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_BusinessBorrower] PRIMARY KEY CLUSTERED 
(
	[BorrowerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ConfigBorrowerBands]    Script Date: 8/31/2018 5:35:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ConfigBorrowerBands](
	[Type] [nvarchar](8) NOT NULL,
	[Label] [nvarchar](8) NOT NULL,
	[ValueFrom] [int] NOT NULL,
	[ValueTo] [int] NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Genre]    Script Date: 8/31/2018 5:35:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Genre](
	[GenreID] [nvarchar](8) NOT NULL,
	[GenreDescription] [nvarchar](100) NOT NULL,
 CONSTRAINT [PK_Genre] PRIMARY KEY CLUSTERED 
(
	[GenreID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Kupa]    Script Date: 8/31/2018 5:35:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Kupa](
	[KupaID] [nvarchar](max) NOT NULL DEFAULT (''),
	[KupaText] [nvarchar](max) NOT NULL DEFAULT ('')
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[OrganisationalBorrower]    Script Date: 8/31/2018 5:35:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrganisationalBorrower](
	[BorrowerID] [nvarchar](8) NOT NULL,
	[AccountsDeptAddress] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_OrganisationalBorrower] PRIMARY KEY CLUSTERED 
(
	[BorrowerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[OrgContact]    Script Date: 8/31/2018 5:35:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrgContact](
	[OrgContactID] [nvarchar](8) NOT NULL,
	[BorrowerID] [nvarchar](8) NOT NULL,
	[ContactType] [nvarchar](1) NOT NULL,
	[ContactDetails] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_OrgContact] PRIMARY KEY CLUSTERED 
(
	[OrgContactID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SalaryAudit]    Script Date: 8/31/2018 5:35:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SalaryAudit](
	[TransactionID] [int] IDENTITY(1,1) NOT NULL,
	[StaffID] [nvarchar](8) NOT NULL,
	[SalaryAdjustMent] [money] NOT NULL,
	[AdjustmentDate] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_SalaryAudit] PRIMARY KEY CLUSTERED 
(
	[TransactionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Section]    Script Date: 8/31/2018 5:35:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Section](
	[SectionID] [nvarchar](8) NOT NULL,
	[ManagerStaffID] [nvarchar](8) NULL,
	[SectionDescription] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_Section] PRIMARY KEY CLUSTERED 
(
	[SectionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Staff]    Script Date: 8/31/2018 5:35:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Staff](
	[StaffID] [nvarchar](8) NOT NULL,
	[StaffLName] [nvarchar](25) NOT NULL,
	[StaffFName] [nvarchar](25) NOT NULL,
	[StaffTelNo] [nvarchar](20) NOT NULL,
	[DOB] [date] NOT NULL,
	[StaffType] [char](1) NOT NULL,
	[Salary] [money] NOT NULL,
	[Grade] [nvarchar](5) NOT NULL,
	[SectionID] [nvarchar](8) NOT NULL,
	[SupervisorID] [nvarchar](8) NULL,
 CONSTRAINT [PK_Staff] PRIMARY KEY CLUSTERED 
(
	[StaffID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Withdrawal]    Script Date: 8/31/2018 5:35:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Withdrawal](
	[StaffID] [nvarchar](8) NOT NULL,
	[BookID] [nvarchar](8) NOT NULL,
	[BorrowerID] [nvarchar](8) NOT NULL,
	[DateBorrowed] [date] NOT NULL,
	[ReturnDate] [date] NOT NULL,
	[Fine] [money] NULL,
 CONSTRAINT [PK_Withdrawal] PRIMARY KEY CLUSTERED 
(
	[StaffID] ASC,
	[BookID] ASC,
	[BorrowerID] ASC,
	[DateBorrowed] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  View [dbo].[BorrowerByType]    Script Date: 8/31/2018 5:35:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[BorrowerByType] AS
SELECT ab.BorrowerID
     , ab.DeliveryAddress
     , ab.Discount
     , 'Academic' AS BorrowerType
     , '' AS BorrowerOrgDescription 
  FROM dbo.AcademicBorrower ab
UNION
SELECT bb.BorrowerID
     , bb.DeliveryAddress
     , 0 AS Discount
     , 'Business' AS BorrowerType
     , bb.BusinessDescription AS BorrowerOrgDescription 
  FROM dbo.BusinessBorrower bb;

GO
/****** Object:  View [dbo].[WithdrawalByBorrower]    Script Date: 8/31/2018 5:35:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[WithdrawalByBorrower] AS
SELECT w.BorrowerID
    , SUM(1) AS BooksWithdrawn
	, SUM(CASE WHEN w.Fine IS NULL 
        THEN 0 
        ELSE w.Fine
      END) AS Fines
 FROM dbo.Withdrawal w
GROUP BY w.BorrowerID;

GO
/****** Object:  View [dbo].[BooksSummaryConslidated]    Script Date: 8/31/2018 5:35:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[BooksSummaryConslidated] AS
SELECT wbb.BorrowerID,
	   wbb.BooksWithdrawn,
	   wbb.Fines,
	   CASE WHEN bbt.DeliveryAddress IS NULL THEN '' ELSE bbt.DeliveryAddress END AS DeliveryAddress,
	   CASE WHEN bbt.Discount IS NULL THEN 0 ELSE bbt.Discount END AS Discount,
	   CASE WHEN bbt.BorrowerType is NULL THEN 'Ordinary' ELSE bbt.BorrowerType END AS BorrowerType,
	   Case WHEN bbt.BorrowerOrgDescription IS NULL THEN '' ELSE bbt.BorrowerOrgDescription END AS BorrowerOrgDescription
FROM dbo.WithdrawalByBorrower AS wbb
LEFT JOIN dbo.BorrowerByType AS bbt
ON wbb.BorrowerID = bbt.BorrowerID


GO
/****** Object:  View [dbo].[WithdrawnBooksDetails]    Script Date: 8/31/2018 5:35:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[WithdrawnBooksDetails] AS
SELECT w.BorrowerID
     , b.BookID
	   , b.Title
	   , b.ISBN
	   , b.SectionID
  FROM dbo.Book b JOIN dbo.Withdrawal w ON w.BookID = b.BookID;

GO
/****** Object:  View [dbo].[BorrowerInfo360]    Script Date: 8/31/2018 5:35:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[BorrowerInfo360] AS
SELECT bsc.*
     , wbd.BookID
	   , wbd.Title
	   , wbd.ISBN
	   , wbd.SectionID
  FROM dbo.BooksSummaryConslidated bsc JOIN WithdrawnBooksDetails wbd ON wbd.BorrowerId = bsc.BorrowerID;

GO
/****** Object:  View [dbo].[BorrowerSummarized]    Script Date: 8/31/2018 5:35:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[BorrowerSummarized] AS
SELECT b3.BookID
	 , b3.BorrowerID
	 , CONCAT(b.BorrowerFName, ' ', b.BorrowerLName) AS Name
     , b3.Title
	 , b3.BooksWithdrawn
	 , b3.Fines
	 , b3.BorrowerType
	 , b3.SectionID
	 , dbo.fnBorrowerUsage(b3.BooksWithdrawn, b3.BorrowerType) as Category
 FROM dbo.BorrowerInfo360 b3
 JOIN dbo.Borrower b ON b.BorrowerID = b3.BorrowerID
GO
/****** Object:  View [dbo].[BooksCategories]    Script Date: 8/31/2018 5:35:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[BooksCategories] AS
SELECT CASE 
            WHEN bg.GenreID IS NULL 
               THEN 'Unassigned' 
               ELSE bg.GenreID
       END AS GenreID
     , b.* FROM dbo.Book b LEFT JOIN dbo.BookGenre bg ON bg.BookID = b.BookID;

GO
/****** Object:  View [dbo].[BooksCategoriesDescription]    Script Date: 8/31/2018 5:35:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[BooksCategoriesDescription] AS
SELECT CASE 
            WHEN g.GenreDescription IS NULL 
               THEN 'Other' 
               ELSE g.GenreDescription
       END AS GenreDescription,
       bc.* 
  FROM dbo.BooksCategories bc
   LEFT JOIN dbo.Genre g ON g.GenreID = bc.GenreID;

GO
/****** Object:  View [dbo].[BooksBorrowedConsolidated]    Script Date: 8/31/2018 5:35:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[BooksBorrowedConsolidated] AS
SELECT bcd.GenreDescription
     , bcd.GenreID
	 , bcd.BookID
	 , dbo.fnTrimUpper(bcd.Title) AS Title
	 , w.BorrowerID
	 , w.DateBorrowed
	 , w.ReturnDate as DateReturned
	 , w.StaffID
	 , w.Fine
  FROM dbo.BooksCategoriesDescription bcd JOIN dbo.Withdrawal w ON w.BookID = bcd.BookID;

GO
/****** Object:  UserDefinedFunction [dbo].[fnBorrowerBooks]    Script Date: 8/31/2018 5:35:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fnBorrowerBooks](@name nvarchar(50), @GenreID nvarchar(50))
RETURNS TABLE
AS
RETURN
	SELECT bbc.Title, bbc.DateBorrowed, bbc.DateReturned 
	FROM dbo.BooksBorrowedConsolidated bbc 
	WHERE bbc.BorrowerID = dbo.resolveBorrower(@name) AND bbc.GenreID = @GenreID
GO
/****** Object:  View [dbo].[BooksFirst]    Script Date: 8/31/2018 5:35:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[BooksFirst] AS
SELECT 
w.BookID,
w.BorrowerID,
w.Fine,
b.SectionID
FROM dbo.Withdrawal as w JOIN dbo.Book AS b on w.BookID = b.BookID
GO
/****** Object:  View [dbo].[BookSummary]    Script Date: 8/31/2018 5:35:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[BookSummary] AS
SELECT
w.BookID,
w.BorrowerID,
w.Fine,
b.SectionID,
CONCAT(br.BorrowerFName, ' ', br.BorrowerLName) as Name
FROM dbo.Withdrawal AS w
JOIN dbo.Book AS b ON w.BookID = b.BookID
JOIN dbo.Borrower AS br ON w.BorrowerID = br.BorrowerID

GO
/****** Object:  View [dbo].[vwAuthorBooks]    Script Date: 8/31/2018 5:35:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vwAuthorBooks]
AS
SELECT     dbo.Author.AuthorID, dbo.Author.AuthorName, dbo.BookAuthor.BookID, dbo.Book.Title, dbo.Book.ISBN, dbo.Book.Publisher
FROM         dbo.Author INNER JOIN
                      dbo.BookAuthor ON dbo.Author.AuthorID = dbo.BookAuthor.AuthorID INNER JOIN
                      dbo.Book ON dbo.BookAuthor.BookID = dbo.Book.BookID


GO
/****** Object:  View [dbo].[vwOrganisationalBorrower]    Script Date: 8/31/2018 5:35:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwOrganisationalBorrower]
AS
SELECT        dbo.Borrower.BorrowerID, dbo.Borrower.BorrowerLName, dbo.Borrower.BorrowerFName, dbo.OrganisationalBorrower.AccountsDeptAddress, dbo.OrgContact.OrgContactID, dbo.OrgContact.ContactType, 
                         dbo.OrgContact.ContactDetails
FROM            dbo.Borrower INNER JOIN
                         dbo.OrganisationalBorrower ON dbo.Borrower.BorrowerID = dbo.OrganisationalBorrower.BorrowerID INNER JOIN
                         dbo.OrgContact ON dbo.OrganisationalBorrower.BorrowerID = dbo.OrgContact.BorrowerID

GO
INSERT [dbo].[AcademicBorrower] ([BorrowerID], [DeliveryAddress], [Discount]) VALUES (N'BR333333', N'Deliveries, University of West London, W13 2QT', 20)
INSERT [dbo].[AcademicBorrower] ([BorrowerID], [DeliveryAddress], [Discount]) VALUES (N'BR444444', N'76 Winston Walk, W4 3DY', 5)
INSERT [dbo].[Author] ([AuthorID], [AuthorName], [AuthorBio], [AuthorPhoto]) VALUES (N'A0987231', N'Thomas Connoley', N'Computer Lecturer', NULL)
INSERT [dbo].[Author] ([AuthorID], [AuthorName], [AuthorBio], [AuthorPhoto]) VALUES (N'A0987836', N'Caroline Begg', N'Computer Lecturer', NULL)
INSERT [dbo].[Author] ([AuthorID], [AuthorName], [AuthorBio], [AuthorPhoto]) VALUES (N'A1010104', N'Alan Coren', NULL, NULL)
INSERT [dbo].[Author] ([AuthorID], [AuthorName], [AuthorBio], [AuthorPhoto]) VALUES (N'A1762987', N'Quentin Charatan', N'Computer Lecturer', NULL)
INSERT [dbo].[Author] ([AuthorID], [AuthorName], [AuthorBio], [AuthorPhoto]) VALUES (N'A1764427', N'Aaron Kans', N'Computer Lecturer', NULL)
INSERT [dbo].[Author] ([AuthorID], [AuthorName], [AuthorBio], [AuthorPhoto]) VALUES (N'A2235671', N'James Kurose', N'Computer Lecturer', NULL)
INSERT [dbo].[Author] ([AuthorID], [AuthorName], [AuthorBio], [AuthorPhoto]) VALUES (N'A2239876', N'Keith Ross', N'Computer Lecturer', NULL)
INSERT [dbo].[Author] ([AuthorID], [AuthorName], [AuthorBio], [AuthorPhoto]) VALUES (N'A2341523', N'John Rawls', N'Harvard Professor in Philosophy', NULL)
INSERT [dbo].[Author] ([AuthorID], [AuthorName], [AuthorBio], [AuthorPhoto]) VALUES (N'A2455512', N'Robert Vieira', NULL, NULL)
INSERT [dbo].[Author] ([AuthorID], [AuthorName], [AuthorBio], [AuthorPhoto]) VALUES (N'A2890453', N'Immanuel Kant', NULL, NULL)
INSERT [dbo].[Author] ([AuthorID], [AuthorName], [AuthorBio], [AuthorPhoto]) VALUES (N'A4523671', N'Thomas Hobbes', NULL, NULL)
INSERT [dbo].[Author] ([AuthorID], [AuthorName], [AuthorBio], [AuthorPhoto]) VALUES (N'A5617892', N'Karl Popper', NULL, NULL)
INSERT [dbo].[Author] ([AuthorID], [AuthorName], [AuthorBio], [AuthorPhoto]) VALUES (N'A6902342', N'Jane Austen', NULL, NULL)
INSERT [dbo].[Author] ([AuthorID], [AuthorName], [AuthorBio], [AuthorPhoto]) VALUES (N'A7182255', N'Joseph Conrad', NULL, NULL)
INSERT [dbo].[Book] ([BookID], [Title], [ISBN], [Publisher], [RenewalPeriod], [Fine], [SectionID], [Chapters]) VALUES (N'B1023456', N'Golfing For Cats', N'0-674-12345-1', N'Collins', 31, 1.0000, N'Fict001', NULL)
INSERT [dbo].[Book] ([BookID], [Title], [ISBN], [Publisher], [RenewalPeriod], [Fine], [SectionID], [Chapters]) VALUES (N'B1023733', N'The Open Society and Its Enemies', N'0-728-86271-5', N'Routledge', 21, 0.5000, N'Phil004', NULL)
INSERT [dbo].[Book] ([BookID], [Title], [ISBN], [Publisher], [RenewalPeriod], [Fine], [SectionID], [Chapters]) VALUES (N'B1025611', N'Pride and Prejudice', N'0-113-09827-8', N'Collins', 14, 1.0000, N'Fict001', NULL)
INSERT [dbo].[Book] ([BookID], [Title], [ISBN], [Publisher], [RenewalPeriod], [Fine], [SectionID], [Chapters]) VALUES (N'B1038900', N'Computer Networking', N'0-623-98235-9', N'Addison Wesley', 14, 0.5000, N'Comp003', NULL)
INSERT [dbo].[Book] ([BookID], [Title], [ISBN], [Publisher], [RenewalPeriod], [Fine], [SectionID], [Chapters]) VALUES (N'B1042897', N'Critique of Pure Reason', N'0-345-09267-1', N'OUP', 31, 0.2500, N'Phil004', NULL)
INSERT [dbo].[Book] ([BookID], [Title], [ISBN], [Publisher], [RenewalPeriod], [Fine], [SectionID], [Chapters]) VALUES (N'B1043211', N'Professional SQL Server 2008 Programming', N'0-651-80923-9', N'Wrox', 31, 0.2500, N'Comp003', N'<CHAPTERLIST xmlns="http://myChapters"><CHAPTER ChapNo="1"><TITLE>Objects in SQL</TITLE><SUMMARY>Review of the basics</SUMMARY><KEYWORD>Objects</KEYWORD><KEYWORD>Model</KEYWORD><REFERENCE>Database Systems</REFERENCE><REFERENCE>Databases for Dummies</REFERENCE></CHAPTER><CHAPTER ChapNo="2"><TITLE>Tool Time</TITLE><SUMMARY>Utilities and Tools</SUMMARY><KEYWORD>Tools</KEYWORD></CHAPTER><CHAPTER ChapNo="3"><TITLE>Basic T-SQL</TITLE><SUMMARY>SQL Commands</SUMMARY><KEYWORD>DML</KEYWORD><KEYWORD>SQL</KEYWORD></CHAPTER></CHAPTERLIST>')
INSERT [dbo].[Book] ([BookID], [Title], [ISBN], [Publisher], [RenewalPeriod], [Fine], [SectionID], [Chapters]) VALUES (N'B1044236', N'Database Systems', N'0-112-36781-4', N'Wiley', 7, 1.0000, N'Comp003', N'<CHAPTERLIST xmlns="http://myChapters"><CHAPTER ChapNo="1"><TITLE>Introduction to Databases</TITLE><SUMMARY>Core Concepts</SUMMARY><KEYWORD>DBMS</KEYWORD><KEYWORD>DDL</KEYWORD><KEYWORD>DML</KEYWORD><REFERENCE>SQL Server</REFERENCE><REFERENCE>Databases for Dummies</REFERENCE></CHAPTER><CHAPTER ChapNo="2"><TITLE>Database Environment</TITLE><SUMMARY>Architecture and Core Components</SUMMARY><KEYWORD>Architecture</KEYWORD><KEYWORD>Model</KEYWORD></CHAPTER><CHAPTER ChapNo="3"><TITLE>The Relational Model</TITLE><SUMMARY>Codd Knows</SUMMARY><KEYWORD>Algebra</KEYWORD><KEYWORD>Calculus</KEYWORD></CHAPTER></CHAPTERLIST>')
INSERT [dbo].[Book] ([BookID], [Title], [ISBN], [Publisher], [RenewalPeriod], [Fine], [SectionID], [Chapters]) VALUES (N'B1067825', N'Emma', N'0-467-09723-8', N'Collins', 7, 1.0000, N'Fict001', NULL)
INSERT [dbo].[Book] ([BookID], [Title], [ISBN], [Publisher], [RenewalPeriod], [Fine], [SectionID], [Chapters]) VALUES (N'B1076543', N'Collected Papers', N'0-342-98765-3', N'Harvard University Press', 7, 0.2500, N'Phil004', N'<CHAPTERLIST xmlns="http://myChapters"><CHAPTER ChapNo="1"><TITLE>Outline of a Decision Procedure for Ethics</TITLE><SUMMARY>How to be good</SUMMARY><KEYWORD>Judgement</KEYWORD><KEYWORD>Reasonableness</KEYWORD><KEYWORD>DML</KEYWORD></CHAPTER><CHAPTER ChapNo="2"><TITLE>Two Concepts of Rules</TITLE><SUMMARY>Differing approaches to rules in their creation and in their application</SUMMARY><KEYWORD>Rules</KEYWORD><KEYWORD>Practice</KEYWORD><REFERENCE>Utility</REFERENCE><REFERENCE>The Social Contrick</REFERENCE><REFERENCE>Leviathan</REFERENCE></CHAPTER><CHAPTER ChapNo="3"><TITLE>Justice as Fairness</TITLE><SUMMARY>The first statement of the Theory of Justice</SUMMARY><KEYWORD>Justice</KEYWORD><KEYWORD>Fairness</KEYWORD></CHAPTER></CHAPTERLIST>')
INSERT [dbo].[Book] ([BookID], [Title], [ISBN], [Publisher], [RenewalPeriod], [Fine], [SectionID], [Chapters]) VALUES (N'B1076544', N'A Theory of Justice', N'0-345-88273-7', N'Harvard University', 14, 0.2500, N'Phil004', N'<CHAPTERLIST xmlns="http://myChapters"><CHAPTER ChapNo="1"><TITLE>Justice as Fairness</TITLE><SUMMARY>Overview of the main lines of the Theory of Justice</SUMMARY><KEYWORD>Justice</KEYWORD><KEYWORD>Fairness</KEYWORD><REFERENCE>Collected Papers</REFERENCE></CHAPTER><CHAPTER ChapNo="2"><TITLE>The Principles of Justice</TITLE><SUMMARY>How would Theory of Justice affect institutions today</SUMMARY><KEYWORD>Philosophy</KEYWORD><KEYWORD>Institutions</KEYWORD></CHAPTER><CHAPTER ChapNo="3"><TITLE>The Original Position</TITLE><SUMMARY>Good effects that a real justice system can have on society</SUMMARY><KEYWORD>Justice System</KEYWORD><KEYWORD>Society</KEYWORD></CHAPTER></CHAPTERLIST>')
INSERT [dbo].[Book] ([BookID], [Title], [ISBN], [Publisher], [RenewalPeriod], [Fine], [SectionID], [Chapters]) VALUES (N'B1088276', N'Leviathan', N'0-245-26788-0', N'Penguin', 31, 0.2500, N'Phil004', NULL)
INSERT [dbo].[Book] ([BookID], [Title], [ISBN], [Publisher], [RenewalPeriod], [Fine], [SectionID], [Chapters]) VALUES (N'B1094446', N'Java in Two Semesters', N'0-937-29910-6', N'McGraw Hill', 14, 0.7500, N'Comp003', NULL)
INSERT [dbo].[Book] ([BookID], [Title], [ISBN], [Publisher], [RenewalPeriod], [Fine], [SectionID], [Chapters]) VALUES (N'B1098123', N'The Secret Agent', N'0-998-02415-8', N'MacMillan', 14, 0.2500, N'Comp003', NULL)
INSERT [dbo].[Book] ([BookID], [Title], [ISBN], [Publisher], [RenewalPeriod], [Fine], [SectionID], [Chapters]) VALUES (N'B1098257', N'Northhanger Abbey', N'0-426-09872-6', N'Collins', 7, 1.0000, N'Fict001', NULL)
INSERT [dbo].[Book] ([BookID], [Title], [ISBN], [Publisher], [RenewalPeriod], [Fine], [SectionID], [Chapters]) VALUES (N'B1099228', N'Nostromo', N'0-935-92438-4', N'MacMillan', 14, 0.5000, N'Fict001', NULL)
INSERT [dbo].[BookAuthor] ([BookID], [AuthorID], [PrimaryAuthor]) VALUES (N'B1023456', N'A1010104', 1)
INSERT [dbo].[BookAuthor] ([BookID], [AuthorID], [PrimaryAuthor]) VALUES (N'B1023733', N'A5617892', 1)
INSERT [dbo].[BookAuthor] ([BookID], [AuthorID], [PrimaryAuthor]) VALUES (N'B1025611', N'A6902342', 1)
INSERT [dbo].[BookAuthor] ([BookID], [AuthorID], [PrimaryAuthor]) VALUES (N'B1038900', N'A2235671', 1)
INSERT [dbo].[BookAuthor] ([BookID], [AuthorID], [PrimaryAuthor]) VALUES (N'B1038900', N'A2239876', 0)
INSERT [dbo].[BookAuthor] ([BookID], [AuthorID], [PrimaryAuthor]) VALUES (N'B1043211', N'A2455512', 1)
INSERT [dbo].[BookAuthor] ([BookID], [AuthorID], [PrimaryAuthor]) VALUES (N'B1044236', N'A0987231', 1)
INSERT [dbo].[BookAuthor] ([BookID], [AuthorID], [PrimaryAuthor]) VALUES (N'B1044236', N'A0987836', 0)
INSERT [dbo].[BookAuthor] ([BookID], [AuthorID], [PrimaryAuthor]) VALUES (N'B1067825', N'A6902342', 1)
INSERT [dbo].[BookAuthor] ([BookID], [AuthorID], [PrimaryAuthor]) VALUES (N'B1076543', N'A2341523', 1)
INSERT [dbo].[BookAuthor] ([BookID], [AuthorID], [PrimaryAuthor]) VALUES (N'B1076544', N'A2341523', 1)
INSERT [dbo].[BookAuthor] ([BookID], [AuthorID], [PrimaryAuthor]) VALUES (N'B1088276', N'A4523671', 1)
INSERT [dbo].[BookAuthor] ([BookID], [AuthorID], [PrimaryAuthor]) VALUES (N'B1094446', N'A1762987', 1)
INSERT [dbo].[BookAuthor] ([BookID], [AuthorID], [PrimaryAuthor]) VALUES (N'B1094446', N'A1764427', 1)
INSERT [dbo].[BookAuthor] ([BookID], [AuthorID], [PrimaryAuthor]) VALUES (N'B1098123', N'A7182255', 1)
INSERT [dbo].[BookAuthor] ([BookID], [AuthorID], [PrimaryAuthor]) VALUES (N'B1098257', N'A6902342', 1)
INSERT [dbo].[BookAuthor] ([BookID], [AuthorID], [PrimaryAuthor]) VALUES (N'B1099228', N'A7182255', 1)
INSERT [dbo].[BookGenre] ([BookID], [GenreID]) VALUES (N'B1088276', N'G2')
INSERT [dbo].[BookGenre] ([BookID], [GenreID]) VALUES (N'B1094446', N'G3')
INSERT [dbo].[Borrower] ([BorrowerID], [BorrowerLName], [BorrowerFName], [BorrowerAddress], [BorrowerTelNo], [BorrowerEmail]) VALUES (N'BR111111', N'Botham', N'Ian', N'14 Acacia Avenue, Ware, Herts', N'01234 123654', N'ibotham@gmail.com')
INSERT [dbo].[Borrower] ([BorrowerID], [BorrowerLName], [BorrowerFName], [BorrowerAddress], [BorrowerTelNo], [BorrowerEmail]) VALUES (N'BR222222', N'Loren', N'Sophia', N'25 Keats Drive, W13 41b', N'01562 210978', N'sloren@yahoo.co.uk')
INSERT [dbo].[Borrower] ([BorrowerID], [BorrowerLName], [BorrowerFName], [BorrowerAddress], [BorrowerTelNo], [BorrowerEmail]) VALUES (N'BR333333', N'Mitchell', N'Joni', N'Dept. of Philosophy, The University of West London, W13 8NJ', N'020 8567 2901', N'jmitchell@londonwest.ac.uk')
INSERT [dbo].[Borrower] ([BorrowerID], [BorrowerLName], [BorrowerFName], [BorrowerAddress], [BorrowerTelNo], [BorrowerEmail]) VALUES (N'BR444444', N'Lennon', N'John', N'76 Winston Walk, W4 3DY', N'020 8566 5738', N'jlennon@gmail.com')
INSERT [dbo].[Borrower] ([BorrowerID], [BorrowerLName], [BorrowerFName], [BorrowerAddress], [BorrowerTelNo], [BorrowerEmail]) VALUES (N'BR555555', N'Newman', N'Paul', N'Ultra Post Production Facilities, Broadway, W5 7JM', N'020 8567 4335', N'pnewman@hotmail.com')
INSERT [dbo].[Borrower] ([BorrowerID], [BorrowerLName], [BorrowerFName], [BorrowerAddress], [BorrowerTelNo], [BorrowerEmail]) VALUES (N'BR666666', N'Springfield', N'Dusty', N'KY Research Ltd, 13 The Mall, W5 2BG', N'020 8578 4470', N'dspringfield@hotmail.co.uk')
INSERT [dbo].[BorrowerGenre] ([BorrowerID], [GenreID]) VALUES (N'BR111111', N'G1')
INSERT [dbo].[BorrowerGenre] ([BorrowerID], [GenreID]) VALUES (N'BR111111', N'G2')
INSERT [dbo].[BorrowerGenre] ([BorrowerID], [GenreID]) VALUES (N'BR222222', N'G1')
INSERT [dbo].[BorrowerGenre] ([BorrowerID], [GenreID]) VALUES (N'BR333333', N'G2')
INSERT [dbo].[BorrowerGenre] ([BorrowerID], [GenreID]) VALUES (N'BR444444', N'G1')
INSERT [dbo].[BorrowerGenre] ([BorrowerID], [GenreID]) VALUES (N'BR444444', N'G3')
INSERT [dbo].[BorrowerGenre] ([BorrowerID], [GenreID]) VALUES (N'BR555555', N'G1')
INSERT [dbo].[BorrowerGenre] ([BorrowerID], [GenreID]) VALUES (N'BR555555', N'G2')
INSERT [dbo].[BorrowerGenre] ([BorrowerID], [GenreID]) VALUES (N'BR555555', N'G3')
INSERT [dbo].[BorrowerGenre] ([BorrowerID], [GenreID]) VALUES (N'BR666666', N'G2')
INSERT [dbo].[BusinessBorrower] ([BorrowerID], [BusinessDescription], [DeliveryAddress]) VALUES (N'BR555555', N'TV Facilities House', N'Ultra Post Production Facilities, Broadway, W5 7JM')
INSERT [dbo].[BusinessBorrower] ([BorrowerID], [BusinessDescription], [DeliveryAddress]) VALUES (N'BR666666', N'Market Research', N'KY Research Ltd, 13 The Mall, W5 2BG')
INSERT [dbo].[ConfigBorrowerBands] ([Type], [Label], [ValueFrom], [ValueTo]) VALUES (N'Academic', N'Light', -100000, 2)
INSERT [dbo].[ConfigBorrowerBands] ([Type], [Label], [ValueFrom], [ValueTo]) VALUES (N'Academic', N'Medium', 3, 6)
INSERT [dbo].[ConfigBorrowerBands] ([Type], [Label], [ValueFrom], [ValueTo]) VALUES (N'Academic', N'Heavy', 7, 1000000)
INSERT [dbo].[ConfigBorrowerBands] ([Type], [Label], [ValueFrom], [ValueTo]) VALUES (N'Business', N'Light', -100000, 1)
INSERT [dbo].[ConfigBorrowerBands] ([Type], [Label], [ValueFrom], [ValueTo]) VALUES (N'Business', N'Medium', 2, 4)
INSERT [dbo].[ConfigBorrowerBands] ([Type], [Label], [ValueFrom], [ValueTo]) VALUES (N'Business', N'Heavy', 5, 1000000)
INSERT [dbo].[Genre] ([GenreID], [GenreDescription]) VALUES (N'G1', N'Fiction')
INSERT [dbo].[Genre] ([GenreID], [GenreDescription]) VALUES (N'G2', N'Philosophy')
INSERT [dbo].[Genre] ([GenreID], [GenreDescription]) VALUES (N'G3', N'Computer Science')
INSERT [dbo].[Kupa] ([KupaID], [KupaText]) VALUES (N'1', N'KupaBR888999')
INSERT [dbo].[OrganisationalBorrower] ([BorrowerID], [AccountsDeptAddress]) VALUES (N'BR333333', N'90210 Ho')
INSERT [dbo].[OrganisationalBorrower] ([BorrowerID], [AccountsDeptAddress]) VALUES (N'BR666666', N'Accounts Dept, KY Research, W5 2BH')
INSERT [dbo].[OrgContact] ([OrgContactID], [BorrowerID], [ContactType], [ContactDetails]) VALUES (N'OC31', N'BR333333', N'E', N'accounts@londonwest.ac.uk')
INSERT [dbo].[OrgContact] ([OrgContactID], [BorrowerID], [ContactType], [ContactDetails]) VALUES (N'OC61', N'BR666666', N'M', N'07812 373899')
INSERT [dbo].[Section] ([SectionID], [ManagerStaffID], [SectionDescription]) VALUES (N'Comp003', NULL, N'Computing')
INSERT [dbo].[Section] ([SectionID], [ManagerStaffID], [SectionDescription]) VALUES (N'Fict001', NULL, N'Fiction')
INSERT [dbo].[Section] ([SectionID], [ManagerStaffID], [SectionDescription]) VALUES (N'Phil004', NULL, N'Philosophy')
INSERT [dbo].[Staff] ([StaffID], [StaffLName], [StaffFName], [StaffTelNo], [DOB], [StaffType], [Salary], [Grade], [SectionID], [SupervisorID]) VALUES (N'L145377B', N'Paltrow', N'Gwynneth', N'020 8567 1978', CAST(N'1968-02-19' AS Date), N'L', 25000.0000, N'L2', N'Phil004', N'L198872B')
INSERT [dbo].[Staff] ([StaffID], [StaffLName], [StaffFName], [StaffTelNo], [DOB], [StaffType], [Salary], [Grade], [SectionID], [SupervisorID]) VALUES (N'L147744C', N'Damon', N'Matt', N'020 8578 2127', CAST(N'1967-01-24' AS Date), N'L', 25000.0000, N'L1', N'Fict001', N'M178235A')
INSERT [dbo].[Staff] ([StaffID], [StaffLName], [StaffFName], [StaffTelNo], [DOB], [StaffType], [Salary], [Grade], [SectionID], [SupervisorID]) VALUES (N'L165222B', N'Vooderman', N'Carol', N'020 8534 2121', CAST(N'1955-07-10' AS Date), N'L', 25000.0000, N'L1', N'Comp003', N'M223467D')
INSERT [dbo].[Staff] ([StaffID], [StaffLName], [StaffFName], [StaffTelNo], [DOB], [StaffType], [Salary], [Grade], [SectionID], [SupervisorID]) VALUES (N'L167223B', N'Thurman', N'Uma', N'020 8566 4735', CAST(N'1965-09-09' AS Date), N'L', 25000.0000, N'L1', N'Phil004', N'L198872B')
INSERT [dbo].[Staff] ([StaffID], [StaffLName], [StaffFName], [StaffTelNo], [DOB], [StaffType], [Salary], [Grade], [SectionID], [SupervisorID]) VALUES (N'L178987E', N'Pitt', N'Brad', N'020 8578 2133', CAST(N'1961-03-08' AS Date), N'L', 25000.0000, N'L2', N'Comp003', N'M223467D')
INSERT [dbo].[Staff] ([StaffID], [StaffLName], [StaffFName], [StaffTelNo], [DOB], [StaffType], [Salary], [Grade], [SectionID], [SupervisorID]) VALUES (N'L198872B', N'Robbins', N'Mark', N'020 8578 4664', CAST(N'1958-10-16' AS Date), N'M', 30000.0000, N'A2', N'Phil004', N'M223467D')
INSERT [dbo].[Staff] ([StaffID], [StaffLName], [StaffFName], [StaffTelNo], [DOB], [StaffType], [Salary], [Grade], [SectionID], [SupervisorID]) VALUES (N'M178235A', N'Hendrix', N'Jimi', N'020 82671990', CAST(N'1955-03-12' AS Date), N'M', 30000.0000, N'A2', N'Fict001', N'M223467D')
INSERT [dbo].[Staff] ([StaffID], [StaffLName], [StaffFName], [StaffTelNo], [DOB], [StaffType], [Salary], [Grade], [SectionID], [SupervisorID]) VALUES (N'M223467D', N'Hunt', N'Juliet', N'020 8956 2244', CAST(N'1961-04-18' AS Date), N'M', 50000.0000, N'A1', N'Comp003', NULL)
INSERT [dbo].[Withdrawal] ([StaffID], [BookID], [BorrowerID], [DateBorrowed], [ReturnDate], [Fine]) VALUES (N'L145377B', N'B1023733', N'BR555555', CAST(N'2010-03-04' AS Date), CAST(N'2010-03-18' AS Date), NULL)
INSERT [dbo].[Withdrawal] ([StaffID], [BookID], [BorrowerID], [DateBorrowed], [ReturnDate], [Fine]) VALUES (N'L147744C', N'B1099228', N'BR111111', CAST(N'2010-05-10' AS Date), CAST(N'2010-05-14' AS Date), 1.0000)
INSERT [dbo].[Withdrawal] ([StaffID], [BookID], [BorrowerID], [DateBorrowed], [ReturnDate], [Fine]) VALUES (N'L147744C', N'B1099228', N'BR222222', CAST(N'2010-03-10' AS Date), CAST(N'2010-03-24' AS Date), 2.0000)
INSERT [dbo].[Withdrawal] ([StaffID], [BookID], [BorrowerID], [DateBorrowed], [ReturnDate], [Fine]) VALUES (N'L165222B', N'B1044236', N'BR555555', CAST(N'2020-01-19' AS Date), CAST(N'2010-01-31' AS Date), NULL)
INSERT [dbo].[Withdrawal] ([StaffID], [BookID], [BorrowerID], [DateBorrowed], [ReturnDate], [Fine]) VALUES (N'L165222B', N'B1094446', N'BR222222', CAST(N'2010-05-27' AS Date), CAST(N'2010-06-13' AS Date), NULL)
INSERT [dbo].[Withdrawal] ([StaffID], [BookID], [BorrowerID], [DateBorrowed], [ReturnDate], [Fine]) VALUES (N'L167223B', N'B1042897', N'BR444444', CAST(N'2010-04-15' AS Date), CAST(N'2010-04-29' AS Date), 5.0000)
INSERT [dbo].[Withdrawal] ([StaffID], [BookID], [BorrowerID], [DateBorrowed], [ReturnDate], [Fine]) VALUES (N'L167223B', N'B1042897', N'BR555555', CAST(N'2010-06-20' AS Date), CAST(N'2010-07-04' AS Date), NULL)
INSERT [dbo].[Withdrawal] ([StaffID], [BookID], [BorrowerID], [DateBorrowed], [ReturnDate], [Fine]) VALUES (N'L167223B', N'B1088276', N'BR444444', CAST(N'2010-04-15' AS Date), CAST(N'2010-04-29' AS Date), 6.0000)
INSERT [dbo].[Withdrawal] ([StaffID], [BookID], [BorrowerID], [DateBorrowed], [ReturnDate], [Fine]) VALUES (N'L178987E', N'B1038900', N'BR333333', CAST(N'2010-07-15' AS Date), CAST(N'2010-07-29' AS Date), NULL)
INSERT [dbo].[Withdrawal] ([StaffID], [BookID], [BorrowerID], [DateBorrowed], [ReturnDate], [Fine]) VALUES (N'L178987E', N'B1044236', N'BR666666', CAST(N'2010-06-10' AS Date), CAST(N'2010-06-24' AS Date), NULL)
INSERT [dbo].[Withdrawal] ([StaffID], [BookID], [BorrowerID], [DateBorrowed], [ReturnDate], [Fine]) VALUES (N'L178987E', N'B1094446', N'BR333333', CAST(N'2010-02-01' AS Date), CAST(N'2010-02-15' AS Date), 4.0000)
INSERT [dbo].[Withdrawal] ([StaffID], [BookID], [BorrowerID], [DateBorrowed], [ReturnDate], [Fine]) VALUES (N'L198872B', N'B1023456', N'BR111111', CAST(N'2010-08-23' AS Date), CAST(N'2010-09-10' AS Date), NULL)
INSERT [dbo].[Withdrawal] ([StaffID], [BookID], [BorrowerID], [DateBorrowed], [ReturnDate], [Fine]) VALUES (N'L198872B', N'B1038900', N'BR111111', CAST(N'2010-03-05' AS Date), CAST(N'2010-03-19' AS Date), NULL)
INSERT [dbo].[Withdrawal] ([StaffID], [BookID], [BorrowerID], [DateBorrowed], [ReturnDate], [Fine]) VALUES (N'L198872B', N'B1076543', N'BR111111', CAST(N'2010-08-25' AS Date), CAST(N'2010-09-08' AS Date), NULL)
INSERT [dbo].[Withdrawal] ([StaffID], [BookID], [BorrowerID], [DateBorrowed], [ReturnDate], [Fine]) VALUES (N'M178235A', N'B1025611', N'BR444444', CAST(N'2010-01-20' AS Date), CAST(N'2010-02-04' AS Date), 2.0000)
INSERT [dbo].[Withdrawal] ([StaffID], [BookID], [BorrowerID], [DateBorrowed], [ReturnDate], [Fine]) VALUES (N'M178235A', N'B1025611', N'BR666666', CAST(N'2010-06-23' AS Date), CAST(N'2010-07-07' AS Date), NULL)
INSERT [dbo].[Withdrawal] ([StaffID], [BookID], [BorrowerID], [DateBorrowed], [ReturnDate], [Fine]) VALUES (N'M223467D', N'B1023456', N'BR222222', CAST(N'2010-08-25' AS Date), CAST(N'2010-09-08' AS Date), NULL)
INSERT [dbo].[Withdrawal] ([StaffID], [BookID], [BorrowerID], [DateBorrowed], [ReturnDate], [Fine]) VALUES (N'M223467D', N'B1076543', N'BR222222', CAST(N'2010-07-10' AS Date), CAST(N'2010-07-24' AS Date), 2.0000)
ALTER TABLE [dbo].[Audit_Table] ADD  DEFAULT ('') FOR [Handler]
GO
ALTER TABLE [dbo].[Audit_Table] ADD  DEFAULT ('') FOR [Level]
GO
ALTER TABLE [dbo].[Audit_Table] ADD  DEFAULT ('') FOR [ErrorLog]
GO
ALTER TABLE [dbo].[SalaryAudit] ADD  CONSTRAINT [DF_SalaryAudit_AdjustmentDate]  DEFAULT (getdate()) FOR [AdjustmentDate]
GO
ALTER TABLE [dbo].[AcademicBorrower]  WITH CHECK ADD  CONSTRAINT [FK_Borrower_AcademicBorrower] FOREIGN KEY([BorrowerID])
REFERENCES [dbo].[Borrower] ([BorrowerID])
GO
ALTER TABLE [dbo].[AcademicBorrower] CHECK CONSTRAINT [FK_Borrower_AcademicBorrower]
GO
ALTER TABLE [dbo].[Book]  WITH CHECK ADD  CONSTRAINT [FK_Section_Book] FOREIGN KEY([SectionID])
REFERENCES [dbo].[Section] ([SectionID])
GO
ALTER TABLE [dbo].[Book] CHECK CONSTRAINT [FK_Section_Book]
GO
ALTER TABLE [dbo].[BookAuthor]  WITH CHECK ADD  CONSTRAINT [FK_Author_BookAuthor] FOREIGN KEY([AuthorID])
REFERENCES [dbo].[Author] ([AuthorID])
GO
ALTER TABLE [dbo].[BookAuthor] CHECK CONSTRAINT [FK_Author_BookAuthor]
GO
ALTER TABLE [dbo].[BookAuthor]  WITH CHECK ADD  CONSTRAINT [FK_Book_BookAuthor] FOREIGN KEY([BookID])
REFERENCES [dbo].[Book] ([BookID])
GO
ALTER TABLE [dbo].[BookAuthor] CHECK CONSTRAINT [FK_Book_BookAuthor]
GO
ALTER TABLE [dbo].[BookGenre]  WITH CHECK ADD  CONSTRAINT [FK_Book_BookGenre] FOREIGN KEY([BookID])
REFERENCES [dbo].[Book] ([BookID])
GO
ALTER TABLE [dbo].[BookGenre] CHECK CONSTRAINT [FK_Book_BookGenre]
GO
ALTER TABLE [dbo].[BookGenre]  WITH CHECK ADD  CONSTRAINT [FK_Genre_BookGenre] FOREIGN KEY([GenreID])
REFERENCES [dbo].[Genre] ([GenreID])
GO
ALTER TABLE [dbo].[BookGenre] CHECK CONSTRAINT [FK_Genre_BookGenre]
GO
ALTER TABLE [dbo].[BorrowerGenre]  WITH CHECK ADD  CONSTRAINT [FK_Borrower_BorrowerGenre] FOREIGN KEY([BorrowerID])
REFERENCES [dbo].[Borrower] ([BorrowerID])
GO
ALTER TABLE [dbo].[BorrowerGenre] CHECK CONSTRAINT [FK_Borrower_BorrowerGenre]
GO
ALTER TABLE [dbo].[BorrowerGenre]  WITH CHECK ADD  CONSTRAINT [FK_Genre_BorrowerGenre] FOREIGN KEY([GenreID])
REFERENCES [dbo].[Genre] ([GenreID])
GO
ALTER TABLE [dbo].[BorrowerGenre] CHECK CONSTRAINT [FK_Genre_BorrowerGenre]
GO
ALTER TABLE [dbo].[BusinessBorrower]  WITH CHECK ADD  CONSTRAINT [FK_Borrower_BusinessBorrower] FOREIGN KEY([BorrowerID])
REFERENCES [dbo].[Borrower] ([BorrowerID])
GO
ALTER TABLE [dbo].[BusinessBorrower] CHECK CONSTRAINT [FK_Borrower_BusinessBorrower]
GO
ALTER TABLE [dbo].[OrganisationalBorrower]  WITH CHECK ADD  CONSTRAINT [FK_Borrower_OrganisationalBorrower] FOREIGN KEY([BorrowerID])
REFERENCES [dbo].[Borrower] ([BorrowerID])
GO
ALTER TABLE [dbo].[OrganisationalBorrower] CHECK CONSTRAINT [FK_Borrower_OrganisationalBorrower]
GO
ALTER TABLE [dbo].[OrgContact]  WITH CHECK ADD  CONSTRAINT [FK_OrgBorrower_OrgContact] FOREIGN KEY([BorrowerID])
REFERENCES [dbo].[OrganisationalBorrower] ([BorrowerID])
GO
ALTER TABLE [dbo].[OrgContact] CHECK CONSTRAINT [FK_OrgBorrower_OrgContact]
GO
ALTER TABLE [dbo].[SalaryAudit]  WITH CHECK ADD  CONSTRAINT [FK_Staff_SalaryAudit] FOREIGN KEY([StaffID])
REFERENCES [dbo].[Staff] ([StaffID])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[SalaryAudit] CHECK CONSTRAINT [FK_Staff_SalaryAudit]
GO
ALTER TABLE [dbo].[Section]  WITH CHECK ADD  CONSTRAINT [FK_Staff_Section] FOREIGN KEY([ManagerStaffID])
REFERENCES [dbo].[Staff] ([StaffID])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[Section] CHECK CONSTRAINT [FK_Staff_Section]
GO
ALTER TABLE [dbo].[Staff]  WITH CHECK ADD  CONSTRAINT [FK_Section_Staff] FOREIGN KEY([SectionID])
REFERENCES [dbo].[Section] ([SectionID])
GO
ALTER TABLE [dbo].[Staff] CHECK CONSTRAINT [FK_Section_Staff]
GO
ALTER TABLE [dbo].[Staff]  WITH CHECK ADD  CONSTRAINT [FK_StaffSuper_Staff] FOREIGN KEY([SupervisorID])
REFERENCES [dbo].[Staff] ([StaffID])
GO
ALTER TABLE [dbo].[Staff] CHECK CONSTRAINT [FK_StaffSuper_Staff]
GO
ALTER TABLE [dbo].[Withdrawal]  WITH CHECK ADD  CONSTRAINT [FK_Book_Withdrawal] FOREIGN KEY([BookID])
REFERENCES [dbo].[Book] ([BookID])
GO
ALTER TABLE [dbo].[Withdrawal] CHECK CONSTRAINT [FK_Book_Withdrawal]
GO
ALTER TABLE [dbo].[Withdrawal]  WITH CHECK ADD  CONSTRAINT [FK_Borrower_Withdrawal] FOREIGN KEY([BorrowerID])
REFERENCES [dbo].[Borrower] ([BorrowerID])
GO
ALTER TABLE [dbo].[Withdrawal] CHECK CONSTRAINT [FK_Borrower_Withdrawal]
GO
ALTER TABLE [dbo].[Withdrawal]  WITH CHECK ADD  CONSTRAINT [FK_Staff_Withdrawal] FOREIGN KEY([StaffID])
REFERENCES [dbo].[Staff] ([StaffID])
GO
ALTER TABLE [dbo].[Withdrawal] CHECK CONSTRAINT [FK_Staff_Withdrawal]
GO
ALTER TABLE [dbo].[AcademicBorrower]  WITH CHECK ADD  CONSTRAINT [CK_AcademicBorrower_Discount] CHECK  (([Discount]>(0) AND [Discount]<(30)))
GO
ALTER TABLE [dbo].[AcademicBorrower] CHECK CONSTRAINT [CK_AcademicBorrower_Discount]
GO
ALTER TABLE [dbo].[Book]  WITH CHECK ADD  CONSTRAINT [CK_Book_Fine] CHECK  (([Fine]>=(0.25) AND [Fine]<=(1.00)))
GO
ALTER TABLE [dbo].[Book] CHECK CONSTRAINT [CK_Book_Fine]
GO
ALTER TABLE [dbo].[Book]  WITH CHECK ADD  CONSTRAINT [CK_Book_RenewalPeriod] CHECK  (([RenewalPeriod]>=(1) AND [RenewalPeriod]<=(31)))
GO
ALTER TABLE [dbo].[Book] CHECK CONSTRAINT [CK_Book_RenewalPeriod]
GO
ALTER TABLE [dbo].[OrgContact]  WITH CHECK ADD  CONSTRAINT [CK_OrgContact_ContactType] CHECK  (([ContactType]='P' OR [ContactType]='E' OR [ContactType]='M' OR [ContactType]='A'))
GO
ALTER TABLE [dbo].[OrgContact] CHECK CONSTRAINT [CK_OrgContact_ContactType]
GO
ALTER TABLE [dbo].[Staff]  WITH CHECK ADD  CONSTRAINT [CK_StaffType] CHECK  (([StaffType]='M' OR [StaffType]='A' OR [StaffType]='L'))
GO
ALTER TABLE [dbo].[Staff] CHECK CONSTRAINT [CK_StaffType]
GO
/****** Object:  StoredProcedure [dbo].[createBorrower]    Script Date: 8/31/2018 5:35:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[createBorrower] (
    @BorrowerID NVARCHAR(10),
    @BorrowerFName NVARCHAR(100),
    @BorrowerLName NVARCHAR(100),
    @BorrowerAddress NVARCHAR(50),
    @BorrowerTelNo NVARCHAR(15),
    @BorrowerEmail NVARCHAR(100),
    @BorrowerStatus NVARCHAR(100) = NULL,
    @BorrowerDiscount INT = NULL,
    @BorrowerGenres NVARCHAR(100) = NULL
)
AS
BEGIN

/*** validation flags ***/
DECLARE @validBorrowerID NVARCHAR(1);
DECLARE @validBorrowerFName NVARCHAR(1);
DECLARE @validBorrowerLName NVARCHAR(1);
DECLARE @validBorrowerAddress NVARCHAR(1);
DECLARE @validBorrowerTelNo NVARCHAR(1);
DECLARE @validBorrowerEmail NVARCHAR(1);
DECLARE @validBorrowerStatus NVARCHAR(1);
DECLARE @validBorrowerDiscount NVARCHAR(1);
DECLARE @validBorrowerGenres NVARCHAR(1);

/*** validation statuses ***/
DECLARE @InvalidInputGenres NVARCHAR(200)
DECLARE @InputParamsValid NVARCHAR(1);
SET @InputParamsValid = 'F';


/*** null to empty strings or default value where allowed ***/
SET @BorrowerID = ISNULL(@BorrowerID, '');
SET @BorrowerTelNo = ISNULL(@BorrowerTelNo, '');
SET @BorrowerEmail = ISNULL(@BorrowerEmail, '');
SET @BorrowerAddress = ISNULL(@BorrowerAddress, 'Pending: TBC');
SET @BorrowerStatus = ISNULL(@BorrowerStatus, '');
SET @BorrowerGenres = ISNULL(@BorrowerGenres, '');
SET @BorrowerDiscount = ISNULL(@BorrowerDiscount, 0);

/*** set default to F - false in case any of the validations is skipped ***/
SET @validBorrowerID = 'T'; --
SET @validBorrowerFName = 'T'; -- @TODO: Alphanumerics with dash NOT empty.
SET @validBorrowerLName = 'T'; -- @TODO: Alphanumerics with dash NOT empty.
SET @validBorrowerAddress = 'T'; -- @TODO: Alphanumerics and spaces, and commas NOT empty.
SET @validBorrowerTelNo = 'T'; -- @TODO: Numerics optionaly +
SET @validBorrowerEmail = 'T'; --
SET @validBorrowerStatus = 'T'; --
SET @validBorrowerDiscount = 'F'; -- @TODO: Driven by Academics status only value range (0-30), follows constraints from dbo.AcademicBorrower
SET @validBorrowerGenres = 'T'; -- Validation is deligated to temp table highlighting genres invalid, but without interruption of the flow.

/*** compound validation result ***/
DECLARE @validAll NVARCHAR(9); /*** TTTTTTTTT (valid) or else TTFTFFTT (invalid) ***/

/*** @BorrowerID, @BorrowerEmail and @BorrowerStatus ***/
SET @validBorrowerID = (SELECT CASE WHEN LEN(@BorrowerID) < 1
  THEN 'F'
  ELSE 'T'
  END);

SET @validBorrowerFName = (SELECT CASE WHEN LEN(@BorrowerFName) > 0 AND @BorrowerFName NOT LIKE '%[^A-Za-z-]%'
  THEN 'T'
  ELSE 'F'
  END);

SET @validBorrowerLName = (SELECT CASE WHEN LEN(@validBorrowerLName) > 0 AND @BorrowerLName NOT LIKE '%[^A-Za-z-]%'
  THEN 'T'
  ELSE 'F'
  END);

SET @validBorrowerAddress = (SELECT CASE WHEN LEN(@validBorrowerAddress) > 0 AND @BorrowerAddress NOT LIKE '%[^0-9a-zA-Z ,]%'
  THEN 'T'
  ELSE 'F'
  END);

SET @validBorrowerTelNo = (SELECT CASE WHEN LEN(@validBorrowerTelNo) > 0 AND @BorrowerTelNo NOT LIKE '%[^0-9 +]%'
  THEN 'T'
  ELSE 'F'
  END);

-- BorrowerDiscount is validated in two steps
-- 1/ For non Academic it is always valid and value of the discount is zeroed
-- 2/ Academic borrowers can have discount within range of 1-30
-- we overload value but only for Academic -- 2/

IF (@BorrowerStatus != 'Academic')
  BEGIN
    SET @validBorrowerDiscount = 'T';
  END
ELSE IF (@BorrowerStatus = 'Academic')
  BEGIN
    IF ( CAST(@BorrowerDiscount AS int) > 0 AND CAST(@BorrowerDiscount AS int) < 31)
      BEGIN
        SET @validBorrowerDiscount = 'T';
      END
  END

SET @validBorrowerEmail = (SELECT CASE WHEN @BorrowerEmail LIKE '%_@_%_.__%'
  THEN 'T'
  ELSE 'F'
  END);

/*** compound validation ***/
-- @TODO: Check if parameters are not empty strings. (Name,Surname etc.)
SET @validAll = CONCAT(
    @validBorrowerID,
    @validBorrowerFName,
    @validBorrowerLName,
    @validBorrowerAddress,
    @validBorrowerTelNo,
    @validBorrowerEmail,
    @validBorrowerStatus,
    @validBorrowerDiscount,
    @validBorrowerGenres,
	''
);

-- (A) Validate input
--     on FAIL do set @InputParamsValid = 'F'
---   Flag for compund validation is added here

IF @validAll = 'TTTTTTTTT' BEGIN -- Check if something wasn't valid.
  SET @InputParamsValid = 'T'
END

-- CAUTION: Genre(s) validation is based on one-at-the-time
-- and RAISERROR without interrupting the flow

-- (B) Decide if @InsertBorrowerGenre = 'Y'
--     just set the flag for later

-- (C) We are entering main transaction now...

BEGIN TRAN; -- Main transaction

  BEGIN TRY

    -- (0) Invalid input

      IF @InputParamsValid != 'T'
        BEGIN
          THROW 90001, 'Invalid procedure input.', 1;
        END

    -- (1) Insert borrower
    
      IF EXISTS (SELECT BorrowerID FROM dbo.Borrower WHERE BorrowerID = @BorrowerID) BEGIN
        THROW 90002, 'This BorrowerID is already in use.', 1;
      END
      ELSE BEGIN
        INSERT INTO dbo.Borrower
          (BorrowerID, BorrowerFName, BorrowerLName, BorrowerAddress, BorrowerTelNo, BorrowerEmail)
        VALUES
          (@BorrowerID, @BorrowerFName, @BorrowerLName, @BorrowerAddress, @BorrowerTelNo, @BorrowerEmail)
      END

    -- (2) Insert relation to Academic|Business|NULL*
    --     *) Plain

      IF @BorrowerStatus = 'Academic'
        BEGIN
        IF NOT EXISTS (SELECT BorrowerID FROM dbo.AcademicBorrower WHERE BorrowerID = @BorrowerID)
          INSERT INTO dbo.AcademicBorrower (BorrowerID, DeliveryAddress, Discount)
          VALUES (@BorrowerID, @BorrowerAddress, @BorrowerDiscount)
        END

      IF @BorrowerStatus = 'Business'
        BEGIN
        IF NOT EXISTS (SELECT BorrowerID FROM dbo.BusinessBorrower WHERE BorrowerID = @BorrowerID)
          INSERT INTO dbo.BusinessBorrower (BorrowerID, BusinessDescription, DeliveryAddress)
          VALUES (@BorrowerID, '', @BorrowerAddress)
        END

    -- (3) Insert related Genre

      IF @BorrowerGenres IS NOT NULL
        /* Seperating Genres parameter and populating new temp table. */
        SELECT @BorrowerID as BorrowerID, name AS GenreID
        INTO #tmp_table_split
        FROM dbo.splitstring(@BorrowerGenres)
        -- Populating the actual table.
        INSERT INTO dbo.BorrowerGenre
        SELECT @BorrowerID as BorrowerID, g.GenreID FROM #tmp_table_split AS tmp JOIN dbo.Genre g on tmp.GenreID = g.GenreDescription -- validates genres.
        -- Picking Genre(s) passed as parameter that do not exist
        -- SELECT tt.GenreID as InvalidGenre
        --  FROM #tmp_table_split tt
        -- WHERE tt.GenreID NOT IN (SELECT GenreDescription FROM dbo.Genre);

        SET @InvalidInputGenres = CONCAT(
          '',
          (SELECT tt.GenreID + ', ' AS [text()]
                 FROM #tmp_table_split tt
                WHERE tt.GenreID NOT IN (SELECT GenreDescription FROM dbo.Genre)
             ORDER BY tt.GenreID
                  FOR XML PATH (''))
        );

        IF LEN(@InvalidInputGenres) > 0 BEGIN -- Just RAISEERROR do not stop the flow
          SET @InvalidInputGenres = CONCAT('Following Genre(s) passed do NOT exist: ', @InvalidInputGenres);
          RAISERROR(
            @InvalidInputGenres,
            1,
            1
          );
        END

  END TRY
  BEGIN CATCH -- MainCatch

    IF @@TRANCOUNT > 0
    ROLLBACK TRAN;  -- Main transaction (failed)

	THROW;  -- introduced in MS SQL Server 2012
	RETURN; -- procedure interrupted

  END CATCH;

  IF @@TRANCOUNT > 0
    COMMIT TRAN;  -- Main transaction (pass)
                  -- nothing was picked up in TRY / CATCH block

END
GO
/****** Object:  StoredProcedure [dbo].[createNewBorrower]    Script Date: 8/31/2018 5:35:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[createNewBorrower] (
    @BorrowerID NVARCHAR(10),
    @BorrowerFName NVARCHAR(100),
    @BorrowerLName NVARCHAR(100),
    @BorrowerAddress NVARCHAR(50),
    @BorrowerTelNo NVARCHAR(15),
    @BorrowerEmail NVARCHAR(100),
    @BorrowerStatus NVARCHAR(100) = NULL,
    @BorrowerDiscount INT = NULL,
    @BorrowerGenres NVARCHAR(100) = NULL
)
AS
BEGIN

/*** validation flags ***/
DECLARE @validBorrowerID NVARCHAR(1);
DECLARE @validBorrowerFName NVARCHAR(1);
DECLARE @validBorrowerLName NVARCHAR(1);
DECLARE @validBorrowerAddress NVARCHAR(1);
DECLARE @validBorrowerTelNo NVARCHAR(1);
DECLARE @validBorrowerEmail NVARCHAR(1);
DECLARE @validBorrowerStatus NVARCHAR(1);
DECLARE @validBorrowerDiscount NVARCHAR(1);
DECLARE @validBorrowerGenres NVARCHAR(1);

/*** null to empty strings or default value where allowed ***/
SET @BorrowerID = ISNULL(@BorrowerID, '');
SET @BorrowerTelNo = ISNULL(@BorrowerTelNo, '');
SET @BorrowerEmail = ISNULL(@BorrowerEmail, '');
SET @BorrowerAddress = ISNULL(@BorrowerAddress, 'Pending: TBC');
SET @BorrowerStatus = ISNULL(@BorrowerStatus, '');
SET @BorrowerGenres = ISNULL(@BorrowerGenres, '');
SET @BorrowerDiscount = ISNULL(@BorrowerDiscount, 0);

/*** set default to F - false in case any of the validations is skipped ***/
SET @validBorrowerID = 'T';
SET @validBorrowerFName = 'T';
SET @validBorrowerLName = 'T';
SET @validBorrowerAddress = 'T';
SET @validBorrowerTelNo = 'T';
SET @validBorrowerEmail = 'T';
SET @validBorrowerStatus = 'T';
SET @validBorrowerDiscount = 'T';
SET @validBorrowerGenres = 'T';

/*** compound validation result ***/
DECLARE @validAll NVARCHAR(9); /*** TTTTTTTTT (valid) or else TTFTFFTT (invalid) ***/

/*** @BorrowerID, @BorrowerEmail and @BorrowerStatus only ***/
SET @validBorrowerID = (SELECT CASE WHEN LEN(@BorrowerID) < 1
  THEN 'F'
  ELSE 'T'
  END);

SET @validBorrowerStatus = (SELECT CASE WHEN @BorrowerStatus != 'Academic' AND @BorrowerStatus != 'Business' AND @BorrowerStatus != ''
  THEN 'F'
  ELSE 'T'
  END);

SET @validBorrowerEmail = (SELECT CASE WHEN @BorrowerEmail LIKE '%_@_%_.__%'
  THEN 'T'
  ELSE 'F'
  END);

/*** compound validation ***/
-- @TODO: Check if parameters are not empty strings. (Name,Surname etc.)
SET @validAll = CONCAT(
    @validBorrowerID,
    @validBorrowerFName,
    @validBorrowerLName,
    @validBorrowerAddress,
    @validBorrowerTelNo,
    @validBorrowerEmail,
    @validBorrowerStatus,
    @validBorrowerDiscount,
    @validBorrowerGenres,
	''
);

--- @TODO: Throw error before BEGIN even starts ---
IF @validAll != 'TTTTTTTTT' BEGIN -- Check if something wasn't valid.
  RAISERROR('Input was not valid. Not passed.', 1, 1)
  RETURN;
END

SELECT 'IM HERE'
RETURN;

BEGIN TRAN

  BEGIN TRY

  INSERT INTO dbo.Borrower
    (BorrowerID, BorrowerFName, BorrowerLName, BorrowerAddress, BorrowerTelNo, BorrowerEmail)
  VALUES
    (@BorrowerID, @BorrowerFName, @BorrowerLName, @BorrowerAddress, @BorrowerTelNo, @BorrowerEmail)

    IF @BorrowerStatus = 'Academic'
    BEGIN
      IF NOT EXISTS (SELECT BorrowerID FROM dbo.AcademicBorrower WHERE BorrowerID = @BorrowerID)
        INSERT INTO dbo.AcademicBorrower (BorrowerID, DeliveryAddress, Discount)
        VALUES (@BorrowerID, @BorrowerAddress, @BorrowerDiscount)
    END

    IF @BorrowerStatus = 'Business'
      BEGIN
        IF NOT EXISTS (SELECT BorrowerID FROM dbo.BusinessBorrower WHERE BorrowerID = @BorrowerID)
          INSERT INTO dbo.BusinessBorrower (BorrowerID, BusinessDescription, DeliveryAddress)
          VALUES (@BorrowerID, '', @BorrowerAddress)
      END

    SAVE TRAN Stage1

    IF @BorrowerGenres IS NOT NULL
      /* Seperating Genres parameter and populating new temp table. */
      SELECT @BorrowerID as BorrowerID, name AS GenreID
      INTO #tmp_table_split
      FROM dbo.splitstring(@BorrowerGenres)
      -- Populating the actual table.
      INSERT INTO dbo.BorrowerGenre
      SELECT @BorrowerID as BorrowerID, g.GenreID FROM #tmp_table_split AS tmp JOIN dbo.Genre g on tmp.GenreID = g.GenreDescription -- validates genres.
    
  END TRY

BEGIN CATCH

IF @@TRANCOUNT > 0
ROLLBACK TRAN;  -- Main transaction (failed)

THROW;

END CATCH

IF @@TRANCOUNT > 0
COMMIT TRAN;  -- Main transaction (pass)

END
GO
/****** Object:  StoredProcedure [dbo].[createNewBorrower_new_test]    Script Date: 8/31/2018 5:35:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[createNewBorrower_new_test] (
    @BorrowerID NVARCHAR(10),
    @BorrowerFName NVARCHAR(100),
    @BorrowerLName NVARCHAR(100),
    @BorrowerAddress NVARCHAR(50),
    @BorrowerTelNo NVARCHAR(15),
    @BorrowerEmail NVARCHAR(100),
    @BorrowerStatus NVARCHAR(100) = NULL,
    @BorrowerDiscount INT = NULL,
    @BorrowerGenres NVARCHAR(100) = NULL
)
AS
BEGIN

/*** validation flags ***/
DECLARE @validBorrowerID NVARCHAR(1);
DECLARE @validBorrowerFName NVARCHAR(1);
DECLARE @validBorrowerLName NVARCHAR(1);
DECLARE @validBorrowerAddress NVARCHAR(1);
DECLARE @validBorrowerTelNo NVARCHAR(1);
DECLARE @validBorrowerEmail NVARCHAR(1);
DECLARE @validBorrowerStatus NVARCHAR(1);
DECLARE @validBorrowerDiscount NVARCHAR(1);
DECLARE @validBorrowerGenres NVARCHAR(1);

/*** null to empty strings or default value where allowed ***/
SET @BorrowerID = ISNULL(@BorrowerID, '');
SET @BorrowerTelNo = ISNULL(@BorrowerTelNo, '');
SET @BorrowerEmail = ISNULL(@BorrowerEmail, '');
SET @BorrowerAddress = ISNULL(@BorrowerAddress, 'Pending: TBC');
SET @BorrowerStatus = ISNULL(@BorrowerStatus, '');
SET @BorrowerGenres = ISNULL(@BorrowerGenres, '');
SET @BorrowerDiscount = ISNULL(@BorrowerDiscount, 0);

/*** set default to F - false in case any of the validations is skipped ***/
SET @validBorrowerID = 'T';
SET @validBorrowerFName = 'T';
SET @validBorrowerLName = 'T';
SET @validBorrowerAddress = 'T';
SET @validBorrowerTelNo = 'T';
SET @validBorrowerEmail = 'T';
SET @validBorrowerStatus = 'T';
SET @validBorrowerDiscount = 'T';
SET @validBorrowerGenres = 'T';

/*** compound validation result ***/
DECLARE @validAll NVARCHAR(9); /*** TTTTTTTTT (valid) or else TTFTFFTT (invalid) ***/

/*** @BorrowerID, @BorrowerEmail and @BorrowerStatus only ***/
SET @validBorrowerID = (SELECT CASE WHEN LEN(@BorrowerID) < 1
  THEN 'F'
  ELSE 'T'
  END);

SET @validBorrowerStatus = (SELECT CASE WHEN @BorrowerStatus != 'Academic' AND @BorrowerStatus != 'Business' AND @BorrowerStatus != ''
  THEN 'F'
  ELSE 'T'
  END);

SET @validBorrowerEmail = (SELECT CASE WHEN @BorrowerEmail LIKE '%_@_%_.__%'
  THEN 'T'
  ELSE 'F'
  END);

/*** compound validation ***/
-- @TODO: Check if parameters are not empty strings. (Name,Surname etc.)
SET @validAll = CONCAT(
    @validBorrowerID,
    @validBorrowerFName,
    @validBorrowerLName,
    @validBorrowerAddress,
    @validBorrowerTelNo,
    @validBorrowerEmail,
    @validBorrowerStatus,
    @validBorrowerDiscount,
    @validBorrowerGenres,
	''
);

--- @TODO: Throw error before BEGIN even starts ---
IF @validAll != 'TTTTTTTTT' BEGIN -- Check if something wasn't valid.
  RAISERROR('Input was not valid. Not passed.', 1, 1)
END

BEGIN TRY

    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

    BEGIN TRAN TestTran

    IF EXISTS (SELECT BorrowerID FROM dbo.Borrower WHERE BorrowerID = @BorrowerID) BEGIN
      RAISERROR('This BorrowerID is already in use.', 1, 2)
    END
    ELSE BEGIN
      INSERT INTO dbo.Borrower
        (BorrowerID, BorrowerFName, BorrowerLName, BorrowerAddress, BorrowerTelNo, BorrowerEmail)
      VALUES
        (@BorrowerID, @BorrowerFName, @BorrowerLName, @BorrowerAddress, @BorrowerTelNo, @BorrowerEmail)
    END

    SAVE TRAN Stage1

    IF @BorrowerGenres IS NOT NULL
      /* Seperating Genres parameter and populating new temp table. */
      SELECT @BorrowerID as BorrowerID, name AS GenreID
      INTO #tmp_table_split
      FROM dbo.splitstring(@BorrowerGenres)
      -- Populating the actual table.
      INSERT INTO dbo.BorrowerGenre
      SELECT @BorrowerID as BorrowerID, g.GenreID FROM #tmp_table_split AS tmp JOIN dbo.Genre g on tmp.GenreID = g.GenreDescription -- validates genres.

    COMMIT TRAN TestTran


END TRY

BEGIN CATCH

IF @BorrowerGenres IS NULL
  BEGIN
  ROLLBACK TRAN TestTran
  RAISERROR('No Genre data inserted', 11, 1)
END
ELSE IF @BorrowerGenres != 'Fiction' OR @BorrowerGenres != 'Philosophy'
BEGIN
  ROLLBACK TRAN Stage1
  COMMIT TRAN TestTran
  RAISERROR('Only first Genre Row stored', 11, 1)
END

END CATCH

END
GO
/****** Object:  StoredProcedure [dbo].[createNewBorrower_test_new]    Script Date: 8/31/2018 5:35:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[createNewBorrower_test_new] (
    @BorrowerID NVARCHAR(10),
    @BorrowerFName NVARCHAR(100),
    @BorrowerLName NVARCHAR(100),
    @BorrowerAddress NVARCHAR(50),
    @BorrowerTelNo NVARCHAR(15),
    @BorrowerEmail NVARCHAR(100),
    @BorrowerStatus NVARCHAR(100) = NULL,
    @BorrowerDiscount INT = NULL,
    @BorrowerGenres NVARCHAR(100) = NULL
)
AS
BEGIN

/*** validation flags ***/
DECLARE @validBorrowerID NVARCHAR(1);
DECLARE @validBorrowerFName NVARCHAR(1);
DECLARE @validBorrowerLName NVARCHAR(1);
DECLARE @validBorrowerAddress NVARCHAR(1);
DECLARE @validBorrowerTelNo NVARCHAR(1);
DECLARE @validBorrowerEmail NVARCHAR(1);
DECLARE @validBorrowerStatus NVARCHAR(1);
DECLARE @validBorrowerDiscount NVARCHAR(1);
DECLARE @validBorrowerGenres NVARCHAR(1);

/*** null to empty strings or default value where allowed ***/
SET @BorrowerID = ISNULL(@BorrowerID, '');
SET @BorrowerTelNo = ISNULL(@BorrowerTelNo, '');
SET @BorrowerEmail = ISNULL(@BorrowerEmail, '');
SET @BorrowerAddress = ISNULL(@BorrowerAddress, 'Pending: TBC');
SET @BorrowerStatus = ISNULL(@BorrowerStatus, '');
SET @BorrowerGenres = ISNULL(@BorrowerGenres, '');
SET @BorrowerDiscount = ISNULL(@BorrowerDiscount, 0);

/*** set default to F - false in case any of the validations is skipped ***/
SET @validBorrowerID = 'T';
SET @validBorrowerFName = 'T';
SET @validBorrowerLName = 'T';
SET @validBorrowerAddress = 'T';
SET @validBorrowerTelNo = 'T';
SET @validBorrowerEmail = 'T';
SET @validBorrowerStatus = 'T';
SET @validBorrowerDiscount = 'T';
SET @validBorrowerGenres = 'T';

/*** compound validation result ***/
DECLARE @validAll NVARCHAR(9); /*** TTTTTTTTT (valid) or else TTFTFFTT (invalid) ***/

/*** @BorrowerID, @BorrowerEmail and @BorrowerStatus only ***/
SET @validBorrowerID = (SELECT CASE WHEN LEN(@BorrowerID) < 1
  THEN 'F'
  ELSE 'T'
  END);

SET @validBorrowerStatus = (SELECT CASE WHEN @BorrowerStatus != 'Academic' AND @BorrowerStatus != 'Business' AND @BorrowerStatus != ''
  THEN 'F'
  ELSE 'T'
  END);

SET @validBorrowerEmail = (SELECT CASE WHEN @BorrowerEmail LIKE '%_@_%_.__%'
  THEN 'T'
  ELSE 'F'
  END);

/*** compound validation ***/
-- @TODO: Check if parameters are not empty strings. (Name,Surname etc.)
SET @validAll = CONCAT(
    @validBorrowerID,
    @validBorrowerFName,
    @validBorrowerLName,
    @validBorrowerAddress,
    @validBorrowerTelNo,
    @validBorrowerEmail,
    @validBorrowerStatus,
    @validBorrowerDiscount,
    @validBorrowerGenres,
	''
);

--- @TODO: Throw error before BEGIN even starts ---
IF @validAll != 'TTTTTTTTT' BEGIN -- Check if something wasn't valid.
  RAISERROR('Input was not valid. Not passed.', 11, 1)
END


BEGIN TRY

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

  BEGIN TRAN BorrowerTran

  INSERT INTO dbo.Borrower
    (BorrowerID, BorrowerFName, BorrowerLName, BorrowerAddress, BorrowerTelNo, BorrowerEmail)
  VALUES
    (@BorrowerID, @BorrowerFName, @BorrowerLName, @BorrowerAddress, @BorrowerTelNo, @BorrowerEmail)

  SAVE TRAN BorrowerStage1

  IF @BorrowerStatus = 'Academic'
  BEGIN
      INSERT INTO dbo.AcademicBorrower (BorrowerID, DeliveryAddress, Discount)
      VALUES (@BorrowerID, @BorrowerAddress, @BorrowerDiscount)
  END

  IF @BorrowerStatus = 'Business'
    BEGIN
        INSERT INTO dbo.BusinessBorrower (BorrowerID, BusinessDescription, DeliveryAddress)
        VALUES (@BorrowerID, '', @BorrowerAddress)
    END

END TRY

BEGIN CATCH

  IF @BorrowerGenres IS NULL
  BEGIN
    ROLLBACK TRAN BorrowerTran
    RAISERROR('ROLLBACK', 11, 1)
  END

  IF @BorrowerGenres NOT IN ('Fiction', 'Philosophy')
  BEGIN
    ROLLBACK TRAN BorrowerStage1
    COMMIT Tran BorrowerTran
    RAISERROR('asdsada', 11, 1)
  END

END CATCH

END
GO
/****** Object:  StoredProcedure [dbo].[csvInsertNewBorrower]    Script Date: 8/31/2018 5:35:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[csvInsertNewBorrower] (
    @BorrowerID NVARCHAR(10),
    @persons NVARCHAR(MAX)
)
AS
BEGIN
  SELECT T.C.value('.', 'NVARCHAR(100)') AS [Name]
  INTO #tblBorrowers
  FROM (SELECT CAST ('<Name>' + REPLACE(@persons, ',', '</Name><Name>') + '</Name>' AS XML) AS [Names]) AS A
  CROSS APPLY Names.nodes('/Name') as T(C)

  SELECT BorrowerFName, BorrowerID
  FROM dbo.Borrower b
  WHERE EXISTS (SELECT BorrowerFname FROM #tblBorrowers tmp WHERE tmp.Name = b.BorrowerFname)

  DROP TABLE #tblBorrowers
END

GO
/****** Object:  StoredProcedure [dbo].[spAddBook]    Script Date: 8/31/2018 5:35:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROC [dbo].[spAddBook]
	@ID nvarchar(8),
	@Title nvarchar(50),
	@ISBN nvarchar(25),
	@Publisher nvarchar(25),
	@Renewal smallint,
	@Fine money,
	@SectionID nvarchar(8)
AS
BEGIN TRY
	INSERT INTO dbo.Book
		(BookID, Title, ISBN, Publisher, RenewalPeriod, Fine, SectionID, Chapters)
	VALUES 
		(@ID, @Title, @ISBN, @Publisher, @Renewal, @Fine, @SectionID, NULL)
	SELECT * FROM dbo.Book
	
	RETURN 0
END TRY

BEGIN CATCH
	DECLARE @ErrorNo int
	DECLARE @SeverityNo int
	DECLARE @State smallint
	DECLARE @LineNo int
	DECLARE @Message nvarchar(4000)
	
	SET	@ErrorNo = ERROR_NUMBER()
	SET	@SeverityNo = ERROR_SEVERITY()
	SET @State = ERROR_STATE()
	SET @LineNo = ERROR_LINE()
	SET @Message = ERROR_MESSAGE()
	
	PRINT '***********************************************'
	PRINT '*              WARNING - ERROR                *'
	PRINT '***********************************************' 
	PRINT ''
	
	IF @ErrorNo = 547
	BEGIN
		-- Check or Foreign Key Constraint problem
		PRINT 'Error No: ' + CAST(@ErrorNo AS nvarchar)
		PRINT 'Check Constraint or Foreign Key problem; check Renewal Period and SectionID; see below:'
		PRINT 'Error Message: ' + @Message
	END
	ELSE IF @ErrorNo = 2627
	BEGIN		
		-- Primary Key problem
		RAISERROR(60000 , 15, 1, @ID) 
	END
	ELSE
	BEGIN		
		-- Unforeseen error
		PRINT 'Error No: ' + CAST(@ErrorNo AS nvarchar)
		PRINT 'Unanticipated error: see message below for more information'
		PRINT 'Error Message: ' + @Message
	END
	
	RETURN 1
END CATCH 


GO
/****** Object:  StoredProcedure [dbo].[spBorrowerBooks]    Script Date: 8/31/2018 5:35:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[spBorrowerBooks] 
@name VARCHAR(500), 
@GenreID VARCHAR(500)

AS

DECLARE @borrowed VARCHAR(6000);
DECLARE @maincat VARCHAR(50);
DECLARE @othercat VARCHAR(50);
DECLARE @category VARCHAR(500)

DECLARE @borrowed2 VARCHAR(5000);
DECLARE @borrowed3 VARCHAR(5000);


DECLARE @title VARCHAR(500);
DECLARE @dateBorrowed VARCHAR(500);
DECLARE @dateReturned VARCHAR(500);

SET @borrowed = (SELECT CONCAT(Title, '						  ', DateBorrowed, '  ', DateReturned) AS str
                  FROM dbo.fnBorrowerBooks(@name, @genreID)
				  --WHERE bbc.BorrowerID = dbo.resolveBorrower(@name)
				  FOR XML PATH(''));

SET @borrowed2 = REPLACE ( @borrowed, '<str>' , '' );
SET @borrowed3 = REPLACE ( @borrowed2, '</str>', CHAR(13) );

SET @category = CASE @GenreID
    WHEN 'G1' THEN 'Fiction'
    WHEN 'G2' THEN 'Philosophy'
    WHEN 'G3' THEN 'Computer Science'
END

PRINT '*************************************************************';
PRINT CONCAT('** Borrower Report for ', @name, ', Genre ', @category, ' **');
PRINT '*************************************************************';
PRINT '';
--- here comes the list from query

SET @maincat= (SELECT COUNT(*) FROM dbo.BooksBorrowedConsolidated bbc
WHERE bbc.BorrowerID = dbo.resolveBorrower(@name)
      AND bbc.GenreDescription = @category);

SET @othercat= (SELECT COUNT(*) FROM dbo.BooksBorrowedConsolidated bbc
WHERE bbc.BorrowerID = dbo.resolveBorrower(@name)
      AND bbc.GenreDescription != @category);


PRINT CONCAT('Title', '						   ', 'DateBorrowed', '  ', 'ReturnDate') 
PRINT @borrowed3;
PRINT '------------------------------ ------------ ---------- '
PRINT ''
PRINT CONCAT('Withdrawals for Genre ', @category, ' ', @maincat);
PRINT CONCAT('Withdrawals for all other Genres: ', @othercat);

PRINT ''
PRINT '*******************'
PRINT '** END OF REPORT **'
PRINT '*******************'
GO
/****** Object:  StoredProcedure [dbo].[spBorrowerSummary]    Script Date: 8/31/2018 5:35:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[spBorrowerSummary]
@SectionID nvarchar(10)

AS
-- Creating Temp Table
CREATE TABLE #BorrowerSummary(
 tKey int  IDENTITY(1,1) PRIMARY KEY,
 BookID nvarchar(8),
 BorrowerID nvarchar(8),
 Name nvarchar(51),
 Title nvarchar(50),
 BooksWithdrawn int,
 Fines money,
 BorrowerType nvarchar(8),
 SectionID nvarchar(8),
 Category nvarchar(250)
)

-- Populating temp table
INSERT INTO #BorrowerSummary (BookID,BorrowerID,Name,Title,BooksWithdrawn,Fines,BorrowerType,SectionID,Category)
SELECT * FROM dbo.BorrowerSummarized
WHERE SectionID = @SectionID
ORDER BY BorrowerID

-- Declare Variables
DECLARE @ProcessedBorrower nvarchar(10)
DECLARE @CurrentBorrower nvarchar(10)
DECLARE @Row int
DECLARE @Merged varchar(max)
DECLARE @Empty varchar(max)

SET @Row = 0
SET @CurrentBorrower = ''
SET @ProcessedBorrower = ''

PRINT 'ID         | Name              | Total Fine |   Total Loans  | Category'
PRINT '-----------+-------------------+------------+----------------+------------'
WHILE @Row <= (SELECT MAX(tKey) FROM #BorrowerSummary)
BEGIN

  SET @ProcessedBorrower = (SELECT BorrowerID FROM #BorrowerSummary WHERE tKey = @Row)
  SET @Empty = (SELECT CONCAT('                                                                                '
                     , Title)
                  FROM #BorrowerSummary WHERE tKey = @Row)

  SET @Merged = (SELECT CONCAT(
                          dbo.PAD(BorrowerID, 9, ' ', 'left')
                        , dbo.PAD(Name, 25, ' ', 'left')
                        , dbo.PAD(Fines, 10, ' ', 'right')
                        , dbo.PAD(BooksWithdrawn+' ', 15, ' ', 'right')
                        , ' '
                        , dbo.PAD(Category, 20, ' ', 'left')
                        , Title
                        ) FROM #BorrowerSummary WHERE tKey = @Row)

  SET @Row += 1

  IF @CurrentBorrower != @ProcessedBorrower
    BEGIN
      PRINT @Merged
      SET @CurrentBorrower = @ProcessedBorrower
    END
  ELSE
    BEGIN
      PRINT @Empty
    END
  END

GO
/****** Object:  StoredProcedure [dbo].[spDynamicSQL]    Script Date: 8/31/2018 5:35:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[spDynamicSQL]
	@TableName nvarchar(50),
	@OrderColumn nvarchar(50)
	
AS
	DECLARE @MyExec nvarchar(200)
	
	SET @MyExec = 'SELECT * FROM ' + @TableName + ' ORDER BY ' + @OrderColumn 
	PRINT @MyExec
	
	EXEC(@MyExec)
	
	SET @MyExec = 'Jane Austen'
	SELECT * FROM dbo.Author WHERE AuthorName = @MyExec
	
	
GO
/****** Object:  StoredProcedure [dbo].[spInsertNewBorroer]    Script Date: 8/31/2018 5:35:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spInsertNewBorroer] (
    @BorrowerID NVARCHAR(10),
    @BorrowerFName NVARCHAR(100),
    @BorrowerLName NVARCHAR(100),
    @BorrowerAddress NVARCHAR(200),
    @BorrowerTelNo NVARCHAR(15),
    @BorrowerEmail NVARCHAR(100),
    @BorrowerStatus NVARCHAR(30) -- Academic, Business if none then assume Ordinary
)
AS
BEGIN
/*
  INSERT INTO dbo.Borrower
    (BorrowerID, BorrowerFName, BorrowerLName, BorrowerAddress, BorrowerTelNo,  BorrowerEmail)
  VALUES
    (@BorrowerID, @BorrowerFName, @BorrowerLName, @BorrowerAddress, @BorrowerTelNo, @BorrowerEmail)
*/

PRINT CONCAT(@BorrowerID, + ' ', + @BorrowerFName, + ' ', + @BorrowerLName, + ' ', + @BorrowerAddress, + ' ', + @BorrowerTelNo, + ' ', + @BorrowerEmail)
PRINT @BorrowerStatus
PRINT 'Genres: '

END


GO
/****** Object:  StoredProcedure [dbo].[spInsertNewBorrower]    Script Date: 8/31/2018 5:35:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spInsertNewBorrower] (
    @BorrowerID NVARCHAR(10),
    @BorrowerFName NVARCHAR(100),
    @BorrowerLName NVARCHAR(100),
    @BorrowerAddress NVARCHAR(200),
    @BorrowerTelNo NVARCHAR(15),
    @BorrowerEmail NVARCHAR(100),
    @BorrowerStatus NVARCHAR(30) = NULL, -- Academic or Business -- If none then assuming Ordinary --
    @BorrowerGenres NVARCHAR(100) = NULL -- We are going to supply genres by their names (Fiction ~ Philosophy ~ Computer Science) and then turn them into GenreID and INSERT into dbo.BorrowerGenre
)
AS

BEGIN TRY

  INSERT INTO dbo.Borrower
    (BorrowerID, BorrowerFName, BorrowerLName, BorrowerAddress, BorrowerTelNo, BorrowerEmail)
  VALUES
    (@BorrowerID, @BorrowerFName, @BorrowerLName, @BorrowerAddress, @BorrowerTelNo, @BorrowerEmail)

    IF @BorrowerStatus = 'Academic' BEGIN
      INSERT INTO dbo.AcademicBorrower 
        (BorrowerID, DeliveryAddress, Discount)
      VALUES
        (@BorrowerID, @BorrowerAddress, 0)
      END

END TRY

BEGIN CATCH

  IF EXISTS (SELECT BorrowerID FROM dbo.Borrower WHERE BorrowerID = @BorrowerID)
  BEGIN
  RAISERROR('ERROR RAISED.... NOT PASSED', 1, 1)
  END

  IF EXISTS (SELECT BorrowerID FROM dbo.AcademicBorrower WHERE BorrowerID = @BorrowerID)
  BEGIN
  RAISERROR('THIS BORROWERID ALREADY EXISTS INSIDE ACADEMIC TABLE. NOT PASSED...',1 , 2)
  END


END CATCH
GO
/****** Object:  Trigger [dbo].[trCustomCheck]    Script Date: 8/31/2018 5:35:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- Will not work while the Check Constraints are active
-- Use to explain Trigger order of events?

CREATE TRIGGER [dbo].[trCustomCheck] ON [dbo].[Book]
AFTER INSERT, UPDATE
AS
	IF EXISTS (SELECT 'True' FROM Inserted AS i
			   WHERE i.Fine < 0.25 OR i.Fine > 1.00)
	BEGIN
		RAISERROR('Fine must be between £0.25 and £1.00', 10, 1)
		ROLLBACK TRAN
	END
	
	IF EXISTS (SELECT 'True' FROM Inserted AS i
			   WHERE i.RenewalPeriod < 1 OR i.RenewalPeriod > 31)
	BEGIN
		RAISERROR('Renewal Period must be between 1 and 31', 10, 1)
		ROLLBACK TRAN
	END
	
	IF NOT EXISTS (SELECT 'True' FROM Inserted AS i
				   INNER JOIN dbo.Section AS s
							  ON i.SectionID = s.SectionID)
	BEGIN
		RAISERROR('Section does not exist', 10, 1)
		ROLLBACK TRAN
	END
			

GO
/****** Object:  Trigger [dbo].[trStaffAuditTrail]    Script Date: 8/31/2018 5:35:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE TRIGGER [dbo].[trStaffAuditTrail] ON [dbo].[Staff]
AFTER UPDATE
AS
	INSERT INTO dbo.SalaryAudit(StaffID, SalaryAdjustMent)
	SELECT i.StaffID, i.Salary - d.Salary
	FROM Inserted AS i
	FULL JOIN Deleted d
			  ON i.StaffID = d.StaffID
	WHERE i.Salary - d.Salary != 0
	

GO
/****** Object:  Trigger [dbo].[trFineCheck]    Script Date: 8/31/2018 5:35:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE TRIGGER [dbo].[trFineCheck] ON [dbo].[Withdrawal]
AFTER INSERT
AS
	IF EXISTS (SELECT 'True' FROM Inserted AS i
			   INNER JOIN dbo.Withdrawal AS w
					ON i.BorrowerID = w.BorrowerID
			   WHERE w.Fine > 0)
	BEGIN
		RAISERROR('Borrower still has outstanding fines',10,1)
		ROLLBACK TRAN
	END

GO
/****** Object:  Trigger [dbo].[trCustomBookInsert]    Script Date: 8/31/2018 5:35:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[trCustomBookInsert] ON [dbo].[vwAuthorBooks]
INSTEAD OF INSERT
AS
BEGIN
	IF (SELECT COUNT(*) FROM inserted) > 0
	BEGIN
		IF EXISTS (SELECT 'True' FROM Inserted AS i
				   INNER JOIN dbo.Author AS a
				   ON i.AuthorID = a.AuthorID)
		BEGIN
			INSERT INTO dbo.Book(BookID, Title, ISBN, Publisher)
				 SELECT i.BookID,
						i.Title,
						i.ISBN,
						i.Publisher
				FROM Inserted AS i
			
			INSERT INTO dbo.BookAuthor(BookID, AuthorID)
				 SELECT i.BookID,
						i.AuthorID
				 FROM Inserted AS i
				 INNER JOIN dbo.Author AS a
						 ON i.AuthorID = a.AuthorID
		END
		ELSE
		BEGIN
			RAISERROR('No matching Author - insert cancelled', 10, 1)
		END
	END
END
GO
/****** Object:  Trigger [dbo].[trOrg]    Script Date: 8/31/2018 5:35:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [dbo].[trOrg] ON [dbo].[vwOrganisationalBorrower]
INSTEAD OF INSERT
AS
BEGIN
  IF (SELECT COUNT(*) FROM Inserted) > 0 BEGIN
    IF NOT EXISTS (SELECT 'True' FROM Inserted AS i
                JOIN dbo.Borrower AS b
                ON i.BorrowerID = b.BorrowerID)
    BEGIN
    RAISERROR('Not a valid BorrowerID.', 1, 1)
    END
      IF NOT EXISTS (SELECT 'True' FROM Inserted AS i
                JOIN dbo.AcademicBorrower ab
                ON i.BorrowerID = ab.BorrowerID)
      BEGIN
      RAISERROR('Not found in Academic Borrower table.', 1, 2)
      END

      IF NOT EXISTS (SELECT 'True' FROM Inserted AS i
                JOIN dbo.BusinessBorrower bb
                ON i.BorrowerID = bb.BorrowerID)
      BEGIN
      RAISERROR('Not found in Business Borrower table.', 1, 3)
      END

      BEGIN

      INSERT INTO dbo.OrganisationalBorrower(BorrowerID, AccountsDeptAddress)
        SELECT i.BorrowerID, ' '
        FROM Inserted AS i
        JOIN dbo.Borrower b on i.BorrowerID = b.BorrowerID

      INSERT INTO dbo.OrgContact(OrgContactID, BorrowerID, ContactType, ContactDetails)
        SELECT ' ', i.BorrowerID, 'E', ' '
        FROM Inserted as i
    END
  END
END
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Author"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 125
               Right = 198
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Book"
            Begin Extent = 
               Top = 6
               Left = 236
               Bottom = 125
               Right = 396
            End
            DisplayFlags = 280
            TopColumn = 5
         End
         Begin Table = "BookAuthor"
            Begin Extent = 
               Top = 6
               Left = 434
               Bottom = 110
               Right = 594
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwAuthorBooks'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwAuthorBooks'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Borrower"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 217
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "OrganisationalBorrower"
            Begin Extent = 
               Top = 6
               Left = 255
               Bottom = 102
               Right = 461
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "OrgContact"
            Begin Extent = 
               Top = 6
               Left = 499
               Bottom = 136
               Right = 669
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwOrganisationalBorrower'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwOrganisationalBorrower'
GO
