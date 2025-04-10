ALTER PROCEDURE sp_Update_PriorAssociationRow
    @ApplicationId INT,
    @SebiRegNumber NVARCHAR(50),
    @EntityName NVARCHAR(255),
    @RegistrationType NVARCHAR(255),
    @RegistrationStart DATETIME,
    @RegistrationEnd DATETIME
AS
BEGIN
    SET NOCOUNT ON;

    MERGE INTO nsdlcaf.dbo.PriorAssociationRow AS target
    USING (SELECT @ApplicationId AS ApplicationId, @SebiRegNumber AS SebiRegNumber, @RegistrationStart AS RegistrationStart) AS source
    ON target.ApplicationId = source.ApplicationId 
        AND target.SebiRegNumber = source.SebiRegNumber 
        AND target.RegistrationStart = source.RegistrationStart
    WHEN MATCHED THEN
        UPDATE SET 
            EntityName = @EntityName,
            RegistrationType = @RegistrationType,
            RegistrationEnd = @RegistrationEnd,
            UpdatedAt = GETDATE()
    WHEN NOT MATCHED THEN
        INSERT (ApplicationId, SebiRegNumber, EntityName, RegistrationType, RegistrationStart, RegistrationEnd, CreatedAt, UpdatedAt)
        VALUES (@ApplicationId, @SebiRegNumber, @EntityName, @RegistrationType, @RegistrationStart, @RegistrationEnd, GETDATE(), GETDATE());
END;