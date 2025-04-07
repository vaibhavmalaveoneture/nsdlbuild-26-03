ALTER PROCEDURE sp_GetKycDocumentByPath
    @ApplicationId NVARCHAR(50),
    @FilePath NVARCHAR(500)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        fvci_application_id AS FvciApplicationId,
        document_type AS DocumentType, 
        document_identifier AS DocumentIdentifier, 
        document_path AS DocumentPath, 
        status AS Status
    FROM nsdlcaf.dbo.draft_fvci_kyc_documents 
    WHERE fvci_application_id = @ApplicationId
      AND document_path = @FilePath;
END;
