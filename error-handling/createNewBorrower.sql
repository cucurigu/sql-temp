USE [LocalLibrary]
GO

/****** Object:  StoredProcedure [dbo].[createNewBorrower]    Script Date: 8/23/2018 11:37:08 AM ******/
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
END

-- MainTryCatch
-- @TODO: If anything fails in this block, apart from NestedTryCatch block
-- it should RAISERROR and rollback (perhaps there should be global BEGIN COMMIT for it, too)

SELECT @validAll AS compoundValidationResult; -- junk

  IF EXISTS (SELECT BorrowerID FROM dbo.Borrower WHERE BorrowerID = @BorrowerID) BEGIN
    RAISERROR('This BorrowerID is already in use.', 1, 2)
  END
  ELSE BEGIN
    INSERT INTO dbo.Borrower
      (BorrowerID, BorrowerFName, BorrowerLName, BorrowerAddress, BorrowerTelNo, BorrowerEmail)
    VALUES
      (@BorrowerID, @BorrowerFName, @BorrowerLName, @BorrowerAddress, @BorrowerTelNo, @BorrowerEmail)
  END

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

      -- NestedTryCatch
      -- @TODO: If it fails it should be SUPRESSED and not break the operation

      IF @BorrowerGenres IS NOT NULL
        /* Seperating Genres parameter and populating new temp table. */
        SELECT @BorrowerID as BorrowerID, name AS GenreID
        INTO #tmp_table_split
        FROM dbo.splitstring(@BorrowerGenres)
        -- Populating the actual table.
        INSERT INTO dbo.BorrowerGenre
        SELECT @BorrowerID as BorrowerID, g.GenreID FROM #tmp_table_split AS tmp JOIN dbo.Genre g on tmp.GenreID = g.GenreDescription -- validates genres.
      -- /NestedTryCatch
-- /MainTryCatch
END
