ALTER PROCEDURE sp_GetKycDocumentByPath
    @ApplicationId NVARCHAR(50),
    @FilePath NVARCHAR(500)
AS
BEGIN
    SET NOCOUNT ON;
if exists (select 1 from nsdlcaf.dbo.fvci_kyc_documents where fvci_application_id = @ApplicationId)
begin
    SELECT
        fvci_application_id AS FvciApplicationId,
        document_type AS DocumentType,
        document_identifier AS DocumentIdentifier,
        document_path AS DocumentPath,
        status AS Status
    FROM nsdlcaf.dbo.fvci_kyc_documents
    WHERE fvci_application_id = @ApplicationId
      AND document_path = @FilePath;
end
else
begin
	SELECT
        fvci_application_id AS FvciApplicationId,
        document_type AS DocumentType,
        document_identifier AS DocumentIdentifier,
        document_path AS DocumentPath,
        status AS Status
    FROM nsdlcaf.dbo.draft_fvci_kyc_documents
    WHERE fvci_application_id = @ApplicationId
      AND document_path = @FilePath;
end
END;