ALTER PROCEDURE UpdateInformationOfSaSmFvciApplicant
    @ApplicationId VARCHAR(255),
    @Name VARCHAR(255),
    @RelationWithApplicant VARCHAR(255),
    @Pan VARCHAR(10),
    @NationalityCode VARCHAR(10),
    @DateOfBirth DATE,
    @ResidentialAddress VARCHAR(500),
    @IdentityDocNumber VARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;

    -- If Id is provided, try to update; otherwise, insert a new record
    MERGE INTO nsdlcaf.dbo.InformationOfSaSmFvciApplicant AS Target
    USING (
        SELECT 
            @ApplicationId AS ApplicationId, 
            @Name AS Name, 
            @RelationWithApplicant AS RelationWithApplicant, 
            @Pan AS Pan, 
            @NationalityCode AS NationalityCode, 
            @DateOfBirth AS DateOfBirth, 
            @ResidentialAddress AS ResidentialAddress, 
            @IdentityDocNumber AS IdentityDocNumber
    ) AS Source
    ON Target.ApplicationId = Source.ApplicationId and Target.Name = SOURCE.Name
    WHEN MATCHED THEN
        UPDATE SET 
            Name = Source.Name,
            RelationWithApplicant = Source.RelationWithApplicant,
            Pan = Source.Pan,
            NationalityCode = Source.NationalityCode,
            DateOfBirth = Source.DateOfBirth,
            ResidentialAddress = Source.ResidentialAddress,
            IdentityDocNumber = Source.IdentityDocNumber,
            UpdatedAt = GETDATE()
    WHEN NOT MATCHED THEN
        INSERT (ApplicationId, Name, RelationWithApplicant, Pan, NationalityCode, DateOfBirth, ResidentialAddress, IdentityDocNumber, CreatedAt, UpdatedAt)
        VALUES (Source.ApplicationId, Source.Name, Source.RelationWithApplicant, Source.Pan, Source.NationalityCode, Source.DateOfBirth, Source.ResidentialAddress, Source.IdentityDocNumber, GETDATE(), GETDATE());
END;