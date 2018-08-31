
-- (A) Validate input
--     on FAIL do set @InputParamsValid = 'F'

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

