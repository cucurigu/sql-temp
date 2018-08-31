USE LocalLibrary
GO

ALTER TRIGGER trOrg ON dbo.vwOrganisationalBorrower
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
