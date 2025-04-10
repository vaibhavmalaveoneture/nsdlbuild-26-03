ALTER PROCEDURE sp_getPDFDatabyAppId
    @ApplicationId NVARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;
    -- Temporary variable to store the concatenated address
    DECLARE @Address NVARCHAR(MAX);
    -- Get the formatted address
    SELECT
        @Address = STRING_AGG(
            CONCAT(fad.RegisteredFlatNum, ' ',
                   fad.RegisteredBuildingName, ' ',
                   fad.RegisteredRoadName , ' ',
                   fad.RegisteredAreaName , ' ',
                   fad.RegisteredTownName , ' ',
                   fad.RegisteredStateName , ' ',
                   fad.RegisteredZipName, ' ',
                   ccm.RMC_CODE_NAME), ', ')
    FROM nsdlcaf.dbo.RegisteredOffice fad
    INNER JOIN nsdlcaf.dbo.Country_Code_Master ccm
        ON ccm.RMC_CODE_ID = fad.RegisteredCountryCode
    WHERE fad.ApplicationId  = @ApplicationId;
    -- Main query with multiple rows for signatories
    SELECT
        fkd.Name AS Username,
        fa.fvci_registration_number AS FvciRegNo,
        @Address AS Address,
        dfdud.Place AS Place,
        FORMAT(CAST(dfdud.[Date] AS DATE), 'MMMM dd, yyyy') AS Date,
        sab.AMT_SIGN_NAME AS AtsName,              -- New field for signatory details
        sab.certificate_name AS CertName,
        CONVERT(VARCHAR, sab.Modified_dtm, 120) AS CertSignedDate -- Format date properly
        -- sab.reason AS Reason,
        -- sab.ats_designation AS AtsDesignation
    FROM nsdlcaf.dbo.fvci_applications fa
    INNER JOIN nsdlcaf.dbo.Ekyc fkd
        ON fa.application_id = fkd.ApplicationId
    INNER JOIN nsdlcaf.dbo.DeclarationAndUndertakingForm dfdud
        ON dfdud.ApplicationId = fa.application_id
    LEFT JOIN nsdlcaf.dbo.SELECTED_ATS_BYDDP sab
        ON sab.APPLICATION_ID = fa.application_id
    WHERE
        fa.application_id = @ApplicationId;
END