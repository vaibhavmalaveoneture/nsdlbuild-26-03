ALTER PROCEDURE sp_GetDraftFVCISubClassDetails
    @ApplicationId INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        id,
        fvci_application_id AS fvciApplicationId,
        name,
        created_at AS createdAt,
        updated_at AS updatedAt
    FROM nsdlcaf.dbo.draft_fvci_sub_class_details
    WHERE fvci_application_id = @ApplicationId;
END;