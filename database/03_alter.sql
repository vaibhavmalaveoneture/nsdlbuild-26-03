
ALTER PROCEDURE SP_GetApplicationData
    @ApplicationId NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
   	
   	if exists (select 1 from nsdlcaf.dbo.dbo.fvci_applications fa where application_id=@ApplicationId)
BEGIN 
	    SELECT * FROM nsdlcaf.dbo.Ekyc WHERE ApplicationId = @ApplicationId;
    SELECT * FROM nsdlcaf.dbo.ApplicantOtherName WHERE ApplicationId = @ApplicationId;
    SELECT * FROM nsdlcaf.dbo.ApplicantType WHERE ApplicationId = @ApplicationId;
    SELECT * FROM nsdlcaf.dbo.ComplianceOfficerInfo WHERE ApplicationId = @ApplicationId;
    SELECT * FROM nsdlcaf.dbo.ContactDetails WHERE ApplicationId = @ApplicationId;
    SELECT * FROM nsdlcaf.dbo.ContactInfo WHERE ApplicationId = @ApplicationId;
    SELECT * FROM nsdlcaf.dbo.IncomeDetails WHERE ApplicationId = @ApplicationId;
    SELECT * FROM nsdlcaf.dbo.IncomeSource WHERE ApplicationId = @ApplicationId;
    SELECT * FROM nsdlcaf.dbo.ForeignOffice WHERE ApplicationId = @ApplicationId;
    SELECT * FROM nsdlcaf.dbo.ManagingOfficial WHERE ApplicationId = @ApplicationId;
    SELECT * FROM nsdlcaf.dbo.OfficeInIndia WHERE ApplicationId = @ApplicationId;
    SELECT * FROM nsdlcaf.dbo.RegisteredOffice WHERE ApplicationId = @ApplicationId;
    SELECT TRCNO, CountryCode Country FROM nsdlcaf.dbo.TaxResidency WHERE ApplicationId = @ApplicationId;
   	SELECT user_id UserId, application_id ApplicationId,fvci_registration_number fvciRegistrationNumber ,status ,created_at createdAt ,updated_at updatedAt from nsdlcaf.dbo.fvci_applications dfa 
   	where application_id = @ApplicationId;
   	SELECT * from nsdlcaf.dbo.RegistrationForm WHERE ApplicationId = @ApplicationId;
   	SELECT * from nsdlcaf.dbo.CustodianInfo WHERE ApplicationId = @ApplicationId;
   	SELECT * from nsdlcaf.dbo.DdpInfo WHERE ApplicationId = @ApplicationId;
   	SELECT * from nsdlcaf.dbo.DesignatedBank WHERE ApplicationId = @ApplicationId;
   	SELECT * from nsdlcaf.dbo.DesignatedBankName WHERE ApplicationId = @ApplicationId;
   	SELECT * from nsdlcaf.dbo.DisciplinaryHistory WHERE ApplicationId = @ApplicationId;
   	SELECT * from nsdlcaf.dbo.DpInfo WHERE ApplicationId = @ApplicationId;
   	SELECT * from nsdlcaf.dbo.HasPan WHERE ApplicationId = @ApplicationId;
    SELECT * from nsdlcaf.dbo.PriorAssociation WHERE ApplicationId = @ApplicationId;
   	SELECT * from nsdlcaf.dbo.PriorAssociationRow WHERE ApplicationId = @ApplicationId;
   	SELECT * from nsdlcaf.dbo.ThroughGlobalCustodian WHERE ApplicationId = @ApplicationId;
   	SELECT * from nsdlcaf.dbo.DeclarationAndUndertakingForm WHERE ApplicationId = @ApplicationId;
   	SELECT * from nsdlcaf.dbo.AnextureForm daf WHERE ApplicationId = @ApplicationId;
   	select * from nsdlcaf.dbo.SegregatedPortfolio dsp where ApplicationId = @ApplicationId;
   	SELECT * from nsdlcaf.dbo.BankDeclaration dbd where ApplicationId = @ApplicationId;
	SELECT * from nsdlcaf.dbo.ConsentIntermediary dci where ApplicationId = @ApplicationId;
	SELECT * from nsdlcaf.dbo.InformationOfSaSmFvciApplicant diossfa where ApplicationId = @ApplicationId;
	SELECT * from nsdlcaf.dbo.MaterialShareholder dms where ApplicationId = @ApplicationId;
	SELECT * from nsdlcaf.dbo.BeneficialOwners dbo where ApplicationId = @ApplicationId;
	SELECT * from nsdlcaf.dbo.Managers dm where ApplicationId = @ApplicationId;
	select * from nsdlcaf.dbo.InvestmentManager dim where ApplicationId = @ApplicationId;
	SELECT ds.Details ,dod.* from nsdlcaf.dbo.Signatory ds INNER JOIN nsdlcaf.dbo.OwnerDetails dod on ds.Id=dod.SignatoryId where ds.ApplicationId = @ApplicationId;
END
else 
begin

    SELECT * FROM nsdlcaf.dbo.draft_Ekyc WHERE ApplicationId = @ApplicationId;
    SELECT * FROM nsdlcaf.dbo.draft_ApplicantOtherName WHERE ApplicationId = @ApplicationId;
    SELECT * FROM nsdlcaf.dbo.draft_ApplicantType WHERE ApplicationId = @ApplicationId;
    SELECT * FROM nsdlcaf.dbo.draft_ComplianceOfficerInfo WHERE ApplicationId = @ApplicationId;
    SELECT * FROM nsdlcaf.dbo.draft_ContactDetails WHERE ApplicationId = @ApplicationId;
    SELECT * FROM nsdlcaf.dbo.draft_ContactInfo WHERE ApplicationId = @ApplicationId;
    SELECT * FROM nsdlcaf.dbo.draft_IncomeDetails WHERE ApplicationId = @ApplicationId;
    SELECT * FROM nsdlcaf.dbo.draft_IncomeSource WHERE ApplicationId = @ApplicationId;
    SELECT * FROM nsdlcaf.dbo.draft_ForeignOffice WHERE ApplicationId = @ApplicationId;
    SELECT * FROM nsdlcaf.dbo.draft_ManagingOfficial WHERE ApplicationId = @ApplicationId;
    SELECT * FROM nsdlcaf.dbo.draft_OfficeInIndia WHERE ApplicationId = @ApplicationId;
    SELECT * FROM nsdlcaf.dbo.draft_RegisteredOffice WHERE ApplicationId = @ApplicationId;
    SELECT TRCNO, CountryCode Country FROM nsdlcaf.dbo.draft_TaxResidency WHERE ApplicationId = @ApplicationId;
   	SELECT user_id UserId, application_id ApplicationId,fvci_registration_number fvciRegistrationNumber ,status ,created_at createdAt ,updated_at updatedAt from nsdlcaf.dbo.draft_fvci_applications dfa 
   	where application_id = @ApplicationId;
   	SELECT * from nsdlcaf.dbo.draft_RegistrationForm WHERE ApplicationId = @ApplicationId;
   	SELECT * from nsdlcaf.dbo.draft_CustodianInfo WHERE ApplicationId = @ApplicationId;
   	SELECT * from nsdlcaf.dbo.draft_DdpInfo WHERE ApplicationId = @ApplicationId;
   	SELECT * from nsdlcaf.dbo.draft_DesignatedBank WHERE ApplicationId = @ApplicationId;
   	SELECT * from nsdlcaf.dbo.draft_DesignatedBankName WHERE ApplicationId = @ApplicationId;
   	SELECT * from nsdlcaf.dbo.draft_DisciplinaryHistory WHERE ApplicationId = @ApplicationId;
   	SELECT * from nsdlcaf.dbo.draft_DpInfo WHERE ApplicationId = @ApplicationId;
   	SELECT * from nsdlcaf.dbo.draft_HasPan WHERE ApplicationId = @ApplicationId;
    SELECT * from nsdlcaf.dbo.draft_PriorAssociation WHERE ApplicationId = @ApplicationId;
   	SELECT * from nsdlcaf.dbo.draft_PriorAssociationRow WHERE ApplicationId = @ApplicationId;
   	SELECT * from nsdlcaf.dbo.draft_ThroughGlobalCustodian WHERE ApplicationId = @ApplicationId;
   	SELECT * from nsdlcaf.dbo.draft_DeclarationAndUndertakingForm WHERE ApplicationId = @ApplicationId;
   	SELECT * from nsdlcaf.dbo.draft_AnextureForm daf WHERE ApplicationId = @ApplicationId;
   	select * from nsdlcaf.dbo.draft_SegregatedPortfolio dsp where ApplicationId = @ApplicationId;
   	SELECT * from nsdlcaf.dbo.draft_BankDeclaration dbd where ApplicationId = @ApplicationId;
	SELECT * from nsdlcaf.dbo.draft_ConsentIntermediary dci where ApplicationId = @ApplicationId;
	SELECT * from nsdlcaf.dbo.draft_InformationOfSaSmFvciApplicant diossfa where ApplicationId = @ApplicationId;
	SELECT * from nsdlcaf.dbo.draft_MaterialShareholder dms where ApplicationId = @ApplicationId;
	SELECT * from nsdlcaf.dbo.draft_BeneficialOwners dbo where ApplicationId = @ApplicationId;
	SELECT * from nsdlcaf.dbo.draft_Managers dm where ApplicationId = @ApplicationId;
	select * from nsdlcaf.dbo.draft_InvestmentManager dim where ApplicationId = @ApplicationId;
	SELECT ds.Details ,dod.* from nsdlcaf.dbo.draft_Signatory ds INNER JOIN nsdlcaf.dbo.draft_OwnerDetails dod on ds.Id=dod.SignatoryId where ds.ApplicationId = @ApplicationId;
end
END





ALTER PROCEDURE UpsertFvciKycDocuments
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
END;


ALTER PROCEDURE sp_UpsertDeclarationAndUndertaking
    @ApplicationId INT,
    @Name NVARCHAR(255),
    @Capacity NVARCHAR(255),
    @Place NVARCHAR(255),
    @Date DATETIME,
    @NameOfSignatory NVARCHAR(255),
    @DesignationOfSignatory NVARCHAR(255),
    @DateOfSignature DATETIME NULL,
    @Signature VARBINARY(MAX) NULL,
    @UpdatedAt DATETIME = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Ensure @UpdatedAt is set if not provided
    IF @UpdatedAt IS NULL 
        SET @UpdatedAt = GETDATE();

    MERGE INTO nsdlcaf.dbo.draft_DeclarationAndUndertakingForm AS target
    USING (SELECT @ApplicationId AS ApplicationId, 
                  @Name AS Name, 
                  @Capacity AS Capacity, 
                  @Place AS Place, 
                  @Date AS [Date], 
                  @NameOfSignatory AS NameOfSignatory, 
                  @DesignationOfSignatory AS DesignationOfSignatory,
                  @UpdatedAt AS UpdatedAt) AS source
    ON target.ApplicationId = source.ApplicationId
    
    -- When a match is found, update the existing record
    WHEN MATCHED THEN
        UPDATE SET target.Name = source.Name,
                   target.Capacity = source.Capacity,
                   target.Place = source.Place,
                   target.[Date] = source.[Date],
                   target.NameOfSignatory = source.NameOfSignatory,
                   target.DesignationOfSignatory = source.DesignationOfSignatory,
                   target.UpdatedAt = source.UpdatedAt
    
    -- When no match is found, insert a new record
    WHEN NOT MATCHED THEN
        INSERT (ApplicationId, Name, Capacity, Place, [Date], NameOfSignatory, 
                DesignationOfSignatory, CreatedAt, UpdatedAt)
        VALUES (source.ApplicationId, source.Name, source.Capacity, source.Place, source.[Date], 
                source.NameOfSignatory, source.DesignationOfSignatory, GETDATE(), source.UpdatedAt);
END;
