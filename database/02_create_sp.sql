

CREATE PROCEDURE sp_GetCountryByShortCode
    @ShortCode VARCHAR(10)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        COUNTRY_ID AS Id,
        COUNTRY_Name AS Name,
        COUNTRY_ID AS Code,
        Country_CODE AS short_code
    FROM 
        nsdlcaf.dbo.PAN_Country_Code_Master 
    WHERE 
        Country_CODE = @ShortCode;
END;


CREATE PROCEDURE sp_GetCountryPanByShortCode
    @ShortCode VARCHAR(10)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT COUNTRY_ID AS Id,
                    COUNTRY_Name as Name,
                    COUNTRY_ID AS Code,
                    Country_CODE as short_code
                FROM nsdlcaf.dbo.PAN_Country_Code_Master 
                WHERE Country_CODE = @ShortCode;
END;




CREATE PROCEDURE sp_GetSignatoryWithOwnerDetails
    @ApplicationId VARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        ds.Details,
        dod.*
    FROM 
        nsdlcaf.dbo.Signatory ds
    INNER JOIN 
        nsdlcaf.dbo.OwnerDetails dod ON ds.Id = dod.SignatoryId
    WHERE 
        ds.ApplicationId = @ApplicationId;
END;
