ALTER PROCEDURE UpsertMaterialShareholder
    @ApplicationId VARCHAR(255),
    @NameOfBeneficialOwner VARCHAR(255),
    @DirectIndirectStake VARCHAR(255),
    @NameOfEntities VARCHAR(255),
    @CountryOfIncorporationOrNationalityCode VARCHAR(10),
    @PercentageStakeHeld VARCHAR(255),
    @IndividualOrNonIndividual VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    MERGE INTO nsdlcaf.dbo.MaterialShareholder AS Target
    USING (
        SELECT 
            @ApplicationId AS ApplicationId,
            @NameOfBeneficialOwner AS NameOfBeneficialOwner,
            @DirectIndirectStake AS DirectIndirectStake,
            @NameOfEntities AS NameOfEntities,
            @CountryOfIncorporationOrNationalityCode AS CountryOfIncorporationOrNationalityCode,
            @PercentageStakeHeld AS PercentageStakeHeld,
            @IndividualOrNonIndividual AS IndividualOrNonIndividual
    ) AS Source
    ON Target.ApplicationId = Source.ApplicationId 
       AND Target.NameOfBeneficialOwner = Source.NameOfBeneficialOwner
    WHEN MATCHED THEN
        UPDATE SET 
            DirectIndirectStake = Source.DirectIndirectStake,
            NameOfEntities = Source.NameOfEntities,
            CountryOfIncorporationOrNationalityCode = Source.CountryOfIncorporationOrNationalityCode,
            PercentageStakeHeld = Source.PercentageStakeHeld,
            IndividualOrNonIndividual = Source.IndividualOrNonIndividual,
            UpdatedAt = GETDATE()
    WHEN NOT MATCHED THEN
        INSERT (ApplicationId, NameOfBeneficialOwner, DirectIndirectStake, NameOfEntities, 
                CountryOfIncorporationOrNationalityCode, PercentageStakeHeld, IndividualOrNonIndividual, CreatedAt, UpdatedAt)
        VALUES (Source.ApplicationId, Source.NameOfBeneficialOwner, Source.DirectIndirectStake, Source.NameOfEntities, 
                Source.CountryOfIncorporationOrNationalityCode, Source.PercentageStakeHeld, Source.IndividualOrNonIndividual, GETDATE(), GETDATE());
END;