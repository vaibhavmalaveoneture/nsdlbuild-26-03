ALTER PROCEDURE UpdateManagers
    @ApplicationId VARCHAR(255),
    @NameOfEntity VARCHAR(255),
    @TypeOfEntity VARCHAR(255),
    @CountryCode VARCHAR(10),
    @TelephoneNumber VARCHAR(50),
    @FaxNumber VARCHAR(50),
    @EmailId VARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;

    MERGE INTO nsdlcaf.dbo.Managers AS Target
    USING (
        SELECT 
            @ApplicationId AS ApplicationId,
            @NameOfEntity AS NameOfEntity,
            @TypeOfEntity AS TypeOfEntity,
            @CountryCode AS CountryCode,
            @TelephoneNumber AS TelephoneNumber,
            @FaxNumber AS FaxNumber,
            @EmailId AS EmailId
    ) AS Source
    ON Target.ApplicationId = Source.ApplicationId 
       AND Target.NameOfEntity = Source.NameOfEntity
    WHEN MATCHED THEN
        UPDATE SET 
            TypeOfEntity = Source.TypeOfEntity,
            CountryCode = Source.CountryCode,
            TelephoneNumber = Source.TelephoneNumber,
            FaxNumber = Source.FaxNumber,
            EmailId = Source.EmailId,
            UpdatedAt = GETDATE()
    WHEN NOT MATCHED THEN
        INSERT (ApplicationId, NameOfEntity, TypeOfEntity, CountryCode, 
                TelephoneNumber, FaxNumber, EmailId, CreatedAt, UpdatedAt)
        VALUES (Source.ApplicationId, Source.NameOfEntity, Source.TypeOfEntity, Source.CountryCode, 
                Source.TelephoneNumber, Source.FaxNumber, Source.EmailId, GETDATE(), GETDATE());
END;