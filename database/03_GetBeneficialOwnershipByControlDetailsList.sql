CREATE PROCEDURE sp_GetBeneficialOwnershipByControlDetailsList
    @ApplicationId NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        id,
        fvci_application_id AS fvciApplicationId,
        name_of_bo AS nameOfBo,
        method_of_control AS methodOfControl,
        country,
        control_percentage AS controlPercentage,
        is_individual AS isIndividual,
        created_at AS createdAt,
        updated_at AS updatedAt
    FROM nsdlcaf.dbo.draft_fvci_benificial_ownership_by_control_bo_details
    WHERE fvci_application_id = @ApplicationId;
END;
