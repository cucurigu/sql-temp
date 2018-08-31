-- Using the view you created in week 3,
-- create an Insert Instead Of Trigger
-- that updates the Organisational Borrower
-- and Organisational Contact tables.
-- The insert should only be allowed to proceed if a valid Borrower ID
-- has been entered and should also only go ahead if
-- the borrower has an entry in either the Academic or Business Borrower table
-- separate errors for both conditions should be raised
-- Other errors associated with the relevant tables should also be trapped

DECLARE @myBorrowerID NVARCHAR(8);
DECLARE @myBorrowerID NVARCHAR(8);
SET @myBorrowerID = 'BR912345';
SET @myAccountDeptAddress = '90210 Hollywood Blvd., L.A.';

BEGIN TRAN; -- Main transaction

  BEGIN TRY

    IF (@myBorrowerID NOT IN (SELECT BorrowerID FROM vwOrganisationalBorrower)) BEGIN
      THROW 99005, 'BorrowerID does not exist.', 1;
    END

    IF (SELECT COUNT(*) FROM OrganisationalBorrower WHERE BorrowerID = @myBorrowerID) > 0 BEGIN
        UPDATE OrganisationalBorrower
           SET AccountsDeptAddress = @myAccountDeptAddress
         WHERE BorrowerID = @myBorrowerID;
      END
    ELSE BEGIN
        INSERT INTO OrganisationalBorrower (BorrowerID, AccountsDeptAddress)
        VALUES (@myBorrowerID, @myAccountDeptAddress);
      END

  END TRY
  BEGIN CATCH -- MainCatch: all other errors (exception grade) are picked up here, too

    IF @@TRANCOUNT > 0
    ROLLBACK TRAN;  -- Main transaction (failed)

	  THROW;  -- introduced in MS SQL Server 2012
	  RETURN; -- procedure interrupted

  END CATCH;

IF @@TRANCOUNT > 0
  COMMIT TRAN;  -- Main transaction (pass)
