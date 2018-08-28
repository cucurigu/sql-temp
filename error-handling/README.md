SQL Server error handling and transactions
---

### Specification

1. If there is a problem updating the borrower tables, then the transaction should be rolled back to the beginning and an error thrown which should be picked up by the client. 

1. If a problem arises updating the borrowerGenre table, then the transaction should only be rolled back as far as the beginning of the updating of that table – the other borrower data should be left intact.
A suitable error should be thrown.

1. Once all has been successfully updated, all the data entered should be displayed, and the status of the borrower clearly indicated.

1. A suitable isolation level for the transaction should be set.

### Pseudo-code 

```
  -- Validate input if not null or empty
  -- if any required parameter is missing
  -- do not proceed any further
   
    
  BEGIN TRANSACTION; -- Main transaction
    
    BEGIN TRY -- MainTry
      
      -- (1) Insert Borrower 
   
      -- (2) Insert Borrower Status: Academic|Business

      -- (3) Link with Genre (sub transaction)
      --     for now without transaction wrapping, we may do this at the 
      --     input validation stage above MainTransaction
      
         
   
    END TRY
    BEGIN CATCH -- MainCatch
    
      -- Audit trail?
      
      -- Display error?
      SELECT 
        ERROR_NUMBER() AS ErrorNumber
      , ERROR_SEVERITY() AS ErrorSeverity
      , ERROR_STATE() AS ErrorState
      , ERROR_PROCEDURE() AS ErrorProcedure
      , ERROR_LINE() AS ErrorLine
      , ERROR_MESSAGE() AS ErrorMessage;
      
      -- Rollback
      IF @@TRANCOUNT > 0
      ROLLBACK TRANSACTION;  -- Main transaction (failed)
    
    END CATCH;
    
  IF @@TRANCOUNT > 0
      COMMIT TRANSACTION;  -- Main transaction (pass)
  GO
  
    

```