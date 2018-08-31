USE [LocalLibrary]
GO

/****** Object:  StoredProcedure [dbo].[createNewBorrower]    Script Date: 8/23/2018 11:37:08 AM ******/
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
SET @validBorrowerFName = 'T'; -- @TODO: Validator required
SET @validBorrowerLName = 'T';
SET @validBorrowerAddress = 'T';
SET @validBorrowerTelNo = 'T';
SET @validBorrowerEmail = 'T'; --
SET @validBorrowerStatus = 'T'; --
SET @validBorrowerDiscount = 'T';
SET @validBorrowerGenres = 'T';

/*** compound validation result ***/
DECLARE @validAll NVARCHAR(9); /*** TTTTTTTTT (valid) or else TTFTFFTT (invalid) ***/

/*** @BorrowerID, @BorrowerEmail and @BorrowerStatus ***/
SET @validBorrowerID = (SELECT CASE WHEN LEN(@BorrowerID) < 1
  THEN 'F'
  ELSE 'T'
  END);

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

/*** Genre(s) validation is based on one-at-the-time and RAISERROR without interrupting the flow **/

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

-- (B) Decide if @InsertBorrowerGenre = 'Y'
--     just set the flag for later

-- (C) We are entering main transaction now...

BEGIN TRAN; -- Main transaction

  BEGIN TRY

    -- (1) Insert borrower

    -- (2) Insert relation to Academic|Business|NULL*
    --     *) Plain

    -- (3) If flag @InsertBorrowerGenre = 'Y'
    --     then insert Genre related




  -- @TODO: REMOVE below code needs replacing

  -- if @InputParamsValid = 'F' then
  -- THROW 9001, 'Invalid input parameters passed to the procedure.', 1;

  SELECT 'This will not fail' AS message;

  INSERT INTO dbo.Borrower
    (BorrowerID, BorrowerFName, BorrowerLName, BorrowerAddress, BorrowerTelNo, BorrowerEmail)
  VALUES
    ('BR111117', 'Greg', 'Len', '123 Road Street', '0712 821 821', 'greg@email.com') -- legit

  INSERT INTO dbo.Borrower
    (BorrowerID, BorrowerFName, BorrowerLName, BorrowerAddress, BorrowerTelNo, BorrowerEmail)
  VALUES
    ('BR111111', 'Greg', 'Len', '123 Road Street', '0712 821 821', 'greg@email.com') --//---         dodgy
  -- @TODO: /REMOVE End of dummie code


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

