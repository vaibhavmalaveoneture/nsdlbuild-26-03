CREATE PROCEDURE UpsertBeneficialOwners
    @ApplicationId VARCHAR(255),
    @NameOfBeneficialOwner VARCHAR(255),
    @MethodOfControl VARCHAR(255),
    @CountryOfIncorporationCode VARCHAR(10),
    @PercentageStakeHeld INT,
    @IndividualOrNonIndividual VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    MERGE INTO nsdlcaf.dbo.draft_BeneficialOwners AS Target
    USING (
        SELECT 
            @ApplicationId AS ApplicationId,
            @NameOfBeneficialOwner AS NameOfBeneficialOwner,
            @MethodOfControl AS MethodOfControl,
            @CountryOfIncorporationCode AS CountryOfIncorporationCode,
            @PercentageStakeHeld AS PercentageStakeHeld,
            @IndividualOrNonIndividual AS IndividualOrNonIndividual
    ) AS Source
    ON Target.ApplicationId = Source.ApplicationId 
       AND Target.NameOfBeneficialOwner = Source.NameOfBeneficialOwner
    WHEN MATCHED THEN
        UPDATE SET 
            MethodOfControl = Source.MethodOfControl,
            CountryOfIncorporationCode = Source.CountryOfIncorporationCode,
            PercentageStakeHeld = Source.PercentageStakeHeld,
            IndividualOrNonIndividual = Source.IndividualOrNonIndividual,
            UpdatedAt = GETDATE()
    WHEN NOT MATCHED THEN
        INSERT (ApplicationId, NameOfBeneficialOwner, MethodOfControl, CountryOfIncorporationCode, 
                PercentageStakeHeld, IndividualOrNonIndividual, CreatedAt, UpdatedAt)
        VALUES (Source.ApplicationId, Source.NameOfBeneficialOwner, Source.MethodOfControl, Source.CountryOfIncorporationCode, 
                Source.PercentageStakeHeld, Source.IndividualOrNonIndividual, GETDATE(), GETDATE());
END;
