
ALTER PROCEDURE Update_ManagingOfficial
    @ApplicationId NVARCHAR(50),
    @GovernmentIdNumber NVARCHAR(50),
    @NameAndAddress NVARCHAR(500) NULL,
    @DateOfBirth DATETIME NULL,
    @TaxResidencyJurisdiction VARCHAR(255) NULL,
    @Nationality VARCHAR(255) NULL,
    @ActingAsGroupDetails NVARCHAR(500) NULL,
    @BoGroupShareholding NVARCHAR(255) NULL
AS
BEGIN
    SET NOCOUNT ON;

    -- Upsert using MERGE
    MERGE INTO nsdlcaf.dbo.ManagingOfficial AS target
    USING (SELECT @ApplicationId AS ApplicationId, @GovernmentIdNumber AS GovernmentIdNumber) AS source
    ON target.ApplicationId = source.ApplicationId AND target.GovernmentIdNumber = source.GovernmentIdNumber

    WHEN MATCHED THEN 
        UPDATE SET 
            NameAndAddress = @NameAndAddress,
            DateOfBirth = @DateOfBirth,
            TaxResidencyJurisdiction = @TaxResidencyJurisdiction,
            Nationality = @Nationality,
            ActingAsGroupDetails = @ActingAsGroupDetails,
            BoGroupShareholding = @BoGroupShareholding,
            UpdatedAt = GETUTCDATE()

    WHEN NOT MATCHED THEN 
        INSERT (ApplicationId, GovernmentIdNumber, NameAndAddress, DateOfBirth, TaxResidencyJurisdiction, Nationality, ActingAsGroupDetails, BoGroupShareholding, CreatedAt, UpdatedAt)
        VALUES (@ApplicationId, @GovernmentIdNumber, @NameAndAddress, @DateOfBirth, @TaxResidencyJurisdiction, @Nationality, @ActingAsGroupDetails, @BoGroupShareholding, GETUTCDATE(), GETUTCDATE());
END;