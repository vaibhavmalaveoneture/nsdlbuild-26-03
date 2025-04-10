ALTER PROCEDURE UpdateOwnerDetailsBySignatoryId
    @SignatoryId INT,
    @NameAddressOfBo VARCHAR(255),
    @DateOfBirthOfBo DATE,
    @TaxResidencyJuridictionCode VARCHAR(10),
    @NationalityCode VARCHAR(10),
    @ActingAloneOrMoreNaturalPerson VARCHAR(50),
    @BoGroupPercentageShareHolding VARCHAR(10),
    @IdentityDocument VARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;

    -- Match based on SignatoryId and NameAddressOfBo
    MERGE INTO nsdlcaf.dbo.OwnerDetails AS Target
    USING (
        SELECT 
            @SignatoryId AS SignatoryId, 
            @NameAddressOfBo AS NameAddressOfBo, 
            @DateOfBirthOfBo AS DateOfBirthOfBo, 
            @TaxResidencyJuridictionCode AS TaxResidencyJuridictionCode, 
            @NationalityCode AS NationalityCode, 
            @ActingAloneOrMoreNaturalPerson AS ActingAloneOrMoreNaturalPerson, 
            @BoGroupPercentageShareHolding AS BoGroupPercentageShareHolding, 
            @IdentityDocument AS IdentityDocument
    ) AS Source
    ON Target.SignatoryId = Source.SignatoryId AND Target.NameAddressOfBo = Source.NameAddressOfBo
    WHEN MATCHED THEN
        UPDATE SET 
            DateOfBirthOfBo = Source.DateOfBirthOfBo,
            TaxResidencyJuridictionCode = Source.TaxResidencyJuridictionCode,
            NationalityCode = Source.NationalityCode,
            ActingAloneOrMoreNaturalPerson = Source.ActingAloneOrMoreNaturalPerson,
            BoGroupPercentageShareHolding = Source.BoGroupPercentageShareHolding,
            IdentityDocument = Source.IdentityDocument,
            UpdatedAt = GETDATE()
    WHEN NOT MATCHED THEN
        INSERT (SignatoryId, NameAddressOfBo, DateOfBirthOfBo, TaxResidencyJuridictionCode, NationalityCode, 
                ActingAloneOrMoreNaturalPerson, BoGroupPercentageShareHolding, IdentityDocument, CreatedAt, UpdatedAt)
        VALUES (Source.SignatoryId, Source.NameAddressOfBo, Source.DateOfBirthOfBo, Source.TaxResidencyJuridictionCode, 
                Source.NationalityCode, Source.ActingAloneOrMoreNaturalPerson, Source.BoGroupPercentageShareHolding, 
                Source.IdentityDocument, GETDATE(), GETDATE());
END;