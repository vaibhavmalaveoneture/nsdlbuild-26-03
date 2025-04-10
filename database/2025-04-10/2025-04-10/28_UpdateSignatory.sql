ALTER PROCEDURE UpdateSignatory
    @ApplicationId VARCHAR(255),
    @Details VARCHAR(500),
    @SignatoryId INT OUTPUT  -- Output parameter to return the generated Id
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @ExistingId INT;

    -- Check if the record already exists
    SELECT @ExistingId = Id 
    FROM nsdlcaf.dbo.Signatory 
    WHERE ApplicationId = @ApplicationId AND Details = @Details;

    -- If exists, update and return existing Id
    IF @ExistingId IS NOT NULL
    BEGIN
        UPDATE nsdlcaf.dbo.Signatory
        SET UpdatedAt = GETDATE()
        WHERE Id = @ExistingId;

        SET @SignatoryId = @ExistingId;
    END
    ELSE
    BEGIN
        -- Insert a new record and return new SignatoryId
        INSERT INTO nsdlcaf.dbo.Signatory (ApplicationId, Details, CreatedAt, UpdatedAt)
        VALUES (@ApplicationId, @Details, GETDATE(), GETDATE());

        SET @SignatoryId = SCOPE_IDENTITY();
    END
END;