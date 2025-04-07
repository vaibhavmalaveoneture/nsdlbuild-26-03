CREATE PROCEDURE sp_CheckFvciApplicationStatus
    @FvciApplicationId NVARCHAR(255),
    @Status NVARCHAR(50) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1 FROM nsdlcaf.dbo.fvci_applications
        WHERE application_id = @FvciApplicationId
    )
    BEGIN
        SET @Status = 'Submitted';
        RETURN;
    END

    IF EXISTS (
        SELECT 1 FROM nsdlcaf.dbo.draft_fvci_applications
        WHERE application_id = @FvciApplicationId
    )
    BEGIN
        SET @Status = 'Draft';
        RETURN;
    END

    SET @Status = 'not_found';
END;
