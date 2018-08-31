BEGIN TRAN; -- Main transaction

  BEGIN TRY

  SELECT 'This will not fail' AS message;

  INSERT INTO dbo.Borrower
    (BorrowerID, BorrowerFName, BorrowerLName, BorrowerAddress, BorrowerTelNo, BorrowerEmail)
  VALUES
    ('BR111117', 'Greg', 'Len', '123 Road Street', '0712 821 821', 'greg@email.com') -- legit

  INSERT INTO dbo.Borrower
    (BorrowerID, BorrowerFName, BorrowerLName, BorrowerAddress, BorrowerTelNo, BorrowerEmail)
  VALUES
    ('BR111111', 'Greg', 'Len', '123 Road Street', '0712 821 821', 'greg@email.com') --//---         dodgy

  END TRY
  BEGIN CATCH -- MainCatch
   
    IF @@TRANCOUNT > 0
    ROLLBACK TRAN;  -- Main transaction (failed)
      
	THROW; -- introduced in MS SQL Server 2012

  END CATCH;


IF @@TRANCOUNT > 0
  COMMIT TRAN;  -- Main transaction (pass)


