USE [LocalLibrary]
GO

/****** Object:  StoredProcedure [dbo].[createNewBorrower]    Script Date: 8/23/2018 11:37:08 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[createBorrower] (
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
SET @validBorrowerDiscount = 'T'; -- @TODO: Driven by Academics status only value range (0-30), follows constraints from dbo.AcademicBorrower
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

SET @validBorrowerDiscount = (SELECT CASE WHEN @BorrowerStatus = 'Academic' AND @BorrowerDiscount BETWEEN 1 AND 30
  THEN 'T'
  ELSE 'F'
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
