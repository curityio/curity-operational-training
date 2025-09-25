IF OBJECT_ID('sp_clear_nonces', 'P') IS NOT NULL
    DROP PROCEDURE sp_clear_nonces;
GO

CREATE PROCEDURE sp_clear_nonces
AS

--
-- It is critical to avoid table scans and minimize locks when clearing expired data:
-- * Delete in batches to prevent table locks.
-- * The delete statement must use indexes that avoid table scans.
-- * Ensure no leftover locks if there are exceptions.
-- * Test the procedure under load.
-- * Implement logging that highlights slow DELETE commands.
--
DECLARE @batch_size INT = 1000;
DECLARE @rows       INT = 1;
DECLARE @deleted    INT = 0;
SET XACT_ABORT ON;

WHILE @rows > 0
BEGIN

    PRINT CONCAT(
        'sp_clear_nonces: Starting batch deletion at ',
        CONVERT(varchar(23), SYSDATETIME(), 121)
    );

    BEGIN TRY
        BEGIN TRANSACTION;
        DELETE TOP (@batch_size) FROM idsvr.dbo.nonces WHERE status = 'used';
        COMMIT TRANSACTION;

        SET @rows = @@ROWCOUNT;
        SET @deleted += @rows;
        PRINT CONCAT(
            'sp_clear_nonces: Completed batch deletion at ', 
            CONVERT(varchar(23), SYSDATETIME(), 121),
            ', batch rows deleted: ', @rows,
            ', cumulative rows deleted: ', @deleted
        );
    END TRY
    BEGIN CATCH
        
        PRINT CONCAT(
            'sp_clear_nonces: Problem encountered at ', 
            CONVERT(varchar(23), SYSDATETIME(), 121),
            ', number: ', ERROR_NUMBER(),
            ', message: ', ERROR_MESSAGE()
        );
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO
