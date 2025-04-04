ALTER PROCEDURE sp_GetCountryByShortCode
    @ShortCode VARCHAR(10)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        RMC_SRNo AS Id,
        RMC_CODE_NAME AS Name,
        RMC_CODE_ISDCODE AS Code,
        RMC_CODE_ID AS short_code
    FROM 
        nsdlcaf.dbo.Country_Code_Master 
    WHERE 
        RMC_CODE_ID = @ShortCode;
END;

