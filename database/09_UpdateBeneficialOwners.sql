
CREATE PROCEDURE UpdateBeneficialOwners
    @ApplicationId VARCHAR(255),
    @NameOfBeneficialOwner VARCHAR(255),
    @MethodOfControl VARCHAR(255),
    @CountryOfIncorporationCode VARCHAR(10),
    @PercentageStakeHeld INT,
    @IndividualOrNonIndividual VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE nsdlcaf.dbo.BeneficialOwners
    SET 
        MethodOfControl = @MethodOfControl,
        CountryOfIncorporationCode = @CountryOfIncorporationCode,
        PercentageStakeHeld = @PercentageStakeHeld,
        IndividualOrNonIndividual = @IndividualOrNonIndividual,
        UpdatedAt = GETDATE()
    WHERE ApplicationId = @ApplicationId 
          AND NameOfBeneficialOwner = @NameOfBeneficialOwner;
END;