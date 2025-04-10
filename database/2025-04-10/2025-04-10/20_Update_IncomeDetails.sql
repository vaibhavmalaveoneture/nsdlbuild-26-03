ALTER PROCEDURE Update_IncomeDetails
    @ApplicationId NVARCHAR(50),
    @BusinessCode NVARCHAR(255) NULL,
    @AnnualIncome NVARCHAR(255) NULL,
    @AssetLess NVARCHAR(255) NULL,
    @AsOnDate DATETIME NULL,
    @IncomeSourceList NVARCHAR(MAX)
AS
BEGIN
        SET NOCOUNT ON;

    -- Upsert IncomeDetails
    MERGE INTO nsdlcaf.dbo.IncomeDetails AS target
    USING (SELECT @ApplicationId AS ApplicationId) AS source
    ON target.ApplicationId = source.ApplicationId

    WHEN MATCHED THEN 
        UPDATE SET 
            BusinessCode = @BusinessCode,
            AnnualIncome = @AnnualIncome,
            AssetLess = @AssetLess,
            AsOnDate = @AsOnDate,
            UpdatedAt = GETUTCDATE()

    WHEN NOT MATCHED THEN 
        INSERT (ApplicationId, BusinessCode, AnnualIncome, AssetLess, AsOnDate, CreatedAt, UpdatedAt)
        VALUES (@ApplicationId, @BusinessCode, @AnnualIncome, @AssetLess, @AsOnDate, GETUTCDATE(), GETUTCDATE());

    -- Delete old IncomeSource records for this ApplicationId
    DELETE FROM nsdlcaf.dbo.IncomeSource WHERE ApplicationId = @ApplicationId;

    -- Insert new IncomeSource records (IncomeSourceList is a comma-separated list of integers)
    IF @IncomeSourceList IS NOT NULL
    BEGIN
        DECLARE @IncomeSource TABLE (IncomeSourceType INT);
        INSERT INTO @IncomeSource SELECT value FROM STRING_SPLIT(@IncomeSourceList, ',');

        INSERT INTO nsdlcaf.dbo.IncomeSource (ApplicationId, IncomeSourceType, CreatedAt)
        SELECT @ApplicationId, IncomeSourceType, GETUTCDATE() FROM @IncomeSource;
    END
END;