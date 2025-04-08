CREATE PROCEDURE sp_GetBeneficialOwnershipByControlDetails
    @ApplicationId NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        is_no_entity_controls_through_voting AS IsNoEntityControlsThroughVoting,
        created_at AS CreatedAt,
        updated_at AS UpdatedAt
    FROM nsdlcaf.dbo.draft_fvci_benificial_ownership_by_control
    WHERE fvci_application_id = @ApplicationId;
END;
