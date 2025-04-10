ALTER PROCEDURE Update_TaxResidency
    @ApplicationId NVARCHAR(50),
    @TRCNo NVARCHAR(255),
    @CountryCode VARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;

    MERGE INTO nsdlcaf.dbo.TaxResidency AS target
    USING (SELECT @ApplicationId AS ApplicationId, @TRCNo as TRCNo) AS source
    ON target.ApplicationId = source.ApplicationId and target.TRCNo = source.TRCNo

    WHEN MATCHED THEN 
        UPDATE SET 
            TRCNo = @TRCNo, 
            CountryCode = @CountryCode, 
            UpdatedAt = GETUTCDATE()

    WHEN NOT MATCHED THEN 
        INSERT (ApplicationId, TRCNo, CountryCode, CreatedAt, UpdatedAt)
        VALUES (@ApplicationId, @TRCNo, @CountryCode, GETUTCDATE(), GETUTCDATE());
END;