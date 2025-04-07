CREATE PROCEDURE UpdateMaterialShareholder
    @ApplicationId VARCHAR(255),
    @NameOfBeneficialOwner VARCHAR(255),
    @DirectIndirectStake VARCHAR(255),
    @NameOfEntities VARCHAR(255),
    @CountryOfIncorporationOrNationalityCode VARCHAR(10),
    @PercentageStakeHeld INT,
    @IndividualOrNonIndividual VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE nsdlcaf.dbo.MaterialShareholder
    SET 
        DirectIndirectStake = @DirectIndirectStake,
        NameOfEntities = @NameOfEntities,
        CountryOfIncorporationOrNationalityCode = @CountryOfIncorporationOrNationalityCode,
        PercentageStakeHeld = @PercentageStakeHeld,
        IndividualOrNonIndividual = @IndividualOrNonIndividual,
        UpdatedAt = GETDATE()
    WHERE ApplicationId = @ApplicationId 
          AND NameOfBeneficialOwner = @NameOfBeneficialOwner;
END;