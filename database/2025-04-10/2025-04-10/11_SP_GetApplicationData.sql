ALTER PROCEDURE SP_GetApplicationData
    @ApplicationId NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
   	
   	if exists (select 1 from nsdlcaf.dbo.fvci_applications fa where application_id=@ApplicationId)
BEGIN 
	    SELECT * FROM oneture_db.nsdlcaf.dbo.Ekyc WHERE ApplicationId = @ApplicationId;
    SELECT * FROM oneture_db.nsdlcaf.dbo.ApplicantOtherName WHERE ApplicationId = @ApplicationId;
    SELECT * FROM oneture_db.nsdlcaf.dbo.ApplicantType WHERE ApplicationId = @ApplicationId;
    SELECT * FROM oneture_db.nsdlcaf.dbo.ComplianceOfficerInfo WHERE ApplicationId = @ApplicationId;
    SELECT * FROM oneture_db.nsdlcaf.dbo.ContactDetails WHERE ApplicationId = @ApplicationId;
    SELECT * FROM oneture_db.nsdlcaf.dbo.ContactInfo WHERE ApplicationId = @ApplicationId;
    SELECT * FROM oneture_db.nsdlcaf.dbo.IncomeDetails WHERE ApplicationId = @ApplicationId;
    SELECT * FROM oneture_db.nsdlcaf.dbo.IncomeSource WHERE ApplicationId = @ApplicationId;
    SELECT * FROM oneture_db.nsdlcaf.dbo.ForeignOffice WHERE ApplicationId = @ApplicationId;
    SELECT * FROM oneture_db.nsdlcaf.dbo.ManagingOfficial WHERE ApplicationId = @ApplicationId;
    SELECT * FROM oneture_db.nsdlcaf.dbo.OfficeInIndia WHERE ApplicationId = @ApplicationId;
    SELECT * FROM oneture_db.nsdlcaf.dbo.RegisteredOffice WHERE ApplicationId = @ApplicationId;
    SELECT TRCNO, CountryCode Country FROM oneture_db.nsdlcaf.dbo.TaxResidency WHERE ApplicationId = @ApplicationId;
   	SELECT user_id UserId, application_id ApplicationId,fvci_registration_number fvciRegistrationNumber ,status Status,created_at createdAt ,updated_at updatedAt from oneture_db.nsdlcaf.dbo.fvci_applications dfa 
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
	SELECT document_type DocumentType, document_identifier DocumentIdentifier, document_path DocumentPath from nsdlcaf.dbo.fvci_kyc_documents dfkd where fvci_application_id =@ApplicationId and status = 1;
	select au.ApplicationId ,au.URNNo ,au.created_at CreatedAt,s.StatusName Status,au.Remarks from nsdlcaf.dbo.ApplicationURNDetails au inner join nsdlcaf.dbo.status_master s on au.Status =s.StatusID where ApplicationId =@ApplicationId;
	SELECT ds.Details ,dod.* from nsdlcaf.dbo.Signatory ds INNER JOIN nsdlcaf.dbo.OwnerDetails dod on ds.Id=dod.SignatoryId where ds.ApplicationId = @ApplicationId;
END
else 
begin

    SELECT * FROM oneture_db.nsdlcaf.dbo.draft_Ekyc WHERE ApplicationId = @ApplicationId;
    SELECT * FROM oneture_db.nsdlcaf.dbo.draft_ApplicantOtherName WHERE ApplicationId = @ApplicationId;
    SELECT * FROM oneture_db.nsdlcaf.dbo.draft_ApplicantType WHERE ApplicationId = @ApplicationId;
    SELECT * FROM oneture_db.nsdlcaf.dbo.draft_ComplianceOfficerInfo WHERE ApplicationId = @ApplicationId;
    SELECT * FROM oneture_db.nsdlcaf.dbo.draft_ContactDetails WHERE ApplicationId = @ApplicationId;
    SELECT * FROM oneture_db.nsdlcaf.dbo.draft_ContactInfo WHERE ApplicationId = @ApplicationId;
    SELECT * FROM oneture_db.nsdlcaf.dbo.draft_IncomeDetails WHERE ApplicationId = @ApplicationId;
    SELECT * FROM oneture_db.nsdlcaf.dbo.draft_IncomeSource WHERE ApplicationId = @ApplicationId;
    SELECT * FROM oneture_db.nsdlcaf.dbo.draft_ForeignOffice WHERE ApplicationId = @ApplicationId;
    SELECT * FROM oneture_db.nsdlcaf.dbo.draft_ManagingOfficial WHERE ApplicationId = @ApplicationId;
    SELECT * FROM oneture_db.nsdlcaf.dbo.draft_OfficeInIndia WHERE ApplicationId = @ApplicationId;
    SELECT * FROM oneture_db.nsdlcaf.dbo.draft_RegisteredOffice WHERE ApplicationId = @ApplicationId;
    SELECT TRCNO, CountryCode Country FROM oneture_db.nsdlcaf.dbo.draft_TaxResidency WHERE ApplicationId = @ApplicationId;
   	SELECT user_id UserId, application_id ApplicationId,fvci_registration_number fvciRegistrationNumber ,status Status,created_at createdAt ,updated_at updatedAt from oneture_db.nsdlcaf.dbo.draft_fvci_applications dfa 
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
	SELECT document_type DocumentType, document_identifier DocumentIdentifier, document_path DocumentPath from nsdlcaf.dbo.draft_fvci_kyc_documents dfkd where fvci_application_id = @ApplicationId  and status = 1;
		select au.ApplicationId ,au.URNNo ,au.created_at CreatedAt,s.StatusName Status,au.Remarks from nsdlcaf.dbo.ApplicationURNDetails au inner join nsdlcaf.dbo.status_master s on au.Status =s.StatusID where ApplicationId =@ApplicationId;	
	SELECT ds.Details ,dod.* from nsdlcaf.dbo.draft_Signatory ds INNER JOIN nsdlcaf.dbo.draft_OwnerDetails dod on ds.Id=dod.SignatoryId where ds.ApplicationId = @ApplicationId;
end
END