
ALTER PROCEDURE Update_ContactInfo
    @ApplicationId NVARCHAR(50),
    @Type NVARCHAR(50),
    @CountryCode VARCHAR(255),
    @AreaCode NVARCHAR(50),
    @Number NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    MERGE INTO nsdlcaf.dbo.ContactInfo AS target
    USING (SELECT @ApplicationId AS ApplicationId, @Type AS Type) AS source
    ON target.ApplicationId = source.ApplicationId AND target.Type = source.Type

    WHEN MATCHED THEN 
        UPDATE SET 
            CountryCode = @CountryCode, 
            AreaCode = @AreaCode, 
            Number = @Number, 
            UpdatedAt = GETUTCDATE()

    WHEN NOT MATCHED THEN 
        INSERT (ApplicationId, Type, CountryCode, AreaCode, Number, CreatedAt, UpdatedAt)
        VALUES (@ApplicationId, @Type, @CountryCode, @AreaCode, @Number, GETUTCDATE(), GETUTCDATE());
END;