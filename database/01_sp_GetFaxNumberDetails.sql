CREATE PROCEDURE sp_GetFaxNumberDetails
    @ApplicationId NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        country_code AS CountryCode,
        std_code AS StdCode,
        fax_number AS FaxNumber,
        fax_type AS FaxType,
        status AS Status,
        contacttype AS ContactType
    FROM nsdlcaf.dbo.draft_fvci_fax_number_details
    WHERE fvci_application_id = @ApplicationId;
END;
