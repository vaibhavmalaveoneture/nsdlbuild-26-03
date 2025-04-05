CREATE PROCEDURE UpsertFvciKycDocuments
    @FvciApplicationId NVARCHAR(255),
    @DocumentType NVARCHAR(255),
    @DocumentIdentifier NVARCHAR(255),
    @DocumentPath NVARCHAR(500),
    @Status NVARCHAR(50),
    @CreatedAt DATETIME,
    @UpdatedAt DATETIME
AS
BEGIN
    SET NOCOUNT ON;
    IF @Status = '0'
    BEGIN
        -- Only UPDATE existing record when status = '0'
        UPDATE nsdlcaf.dbo.draft_fvci_kyc_documents
        SET 
            status = @Status,
            updated_at = @UpdatedAt
        WHERE 
            fvci_application_id = @FvciApplicationId
            AND document_path = @DocumentPath;
    END
    ELSE
    BEGIN
    MERGE INTO nsdlcaf.dbo.draft_fvci_kyc_documents AS target
    USING (SELECT @FvciApplicationId AS fvci_application_id, 
                  @DocumentType AS document_type, 
                  @DocumentIdentifier AS document_identifier, 
                  @DocumentPath AS document_path, 
                  @Status AS status, 
                  @CreatedAt AS created_at, 
                  @UpdatedAt AS updated_at
           ) AS source
    ON target.fvci_application_id = source.fvci_application_id 
    AND target.document_type = source.document_type and target.document_type <> 'additional'
     
    -- Only update if document_type is NOT 'additional'
    WHEN MATCHED  THEN
        UPDATE SET target.document_path = source.document_path,
                   target.status = source.status,
                   target.document_identifier = source.document_identifier,
                   target.updated_at = source.updated_at
                   
    WHEN NOT MATCHED THEN
        INSERT (fvci_application_id, document_type, document_identifier, document_path, status, created_at, updated_at)
        VALUES (source.fvci_application_id, source.document_type, source.document_identifier, 
                source.document_path, source.status, source.created_at, source.updated_at);
   END            
END;
