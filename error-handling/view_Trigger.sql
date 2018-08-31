USE LocalLibrary
GO

ALTER TRIGGER trOrg ON dbo.vwOrganisationalBorrower
INSTEAD OF INSERT
AS
BEGIN
  DECLARE @wasFound INT;
  SET @wasFound = 2;

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
        SET @wasFound = @wasFound - 1;
      END

      IF NOT EXISTS (SELECT 'True' FROM Inserted AS i
                JOIN dbo.BusinessBorrower bb
                ON i.BorrowerID = bb.BorrowerID)
      BEGIN
        RAISERROR('Not found in Business Borrower table.', 1, 3)
        SET @wasFound = @wasFound - 1;
      END

      BEGIN

        -- if not found in any of the tables and equals zero do not proceed
        IF (@wasFound = 0) BEGIN
          RAISERROR('Not found in both Business and Academic Borrower tables. Cannot proceed.', 1, 3)
          RETURN;
        END

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
