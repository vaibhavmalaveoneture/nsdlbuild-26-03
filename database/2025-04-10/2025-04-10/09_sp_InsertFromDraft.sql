ALTER PROCEDURE sp_InsertFromDraft
    @ApplicationId NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRANSACTION;

    BEGIN TRY

    -- Insert data from draft_fvci_applications to main table
    INSERT INTO nsdlcaf.dbo.fvci_applications (user_id, application_id, fvci_registration_number, created_at, updated_at, status)
    SELECT user_id, application_id, fvci_registration_number, created_at, updated_at, 2
    FROM nsdlcaf.dbo.draft_fvci_applications WHERE application_id = @ApplicationId;

    -- Insert data from draft_Ekyc to main table
    INSERT INTO nsdlcaf.dbo.Ekyc (ApplicationId, Name, DateOfIncorporation, DateOfCommencement, PlaceOfIncorporation, CountryOfIncorporation, 
                                      CountryCodeOfIncorporation, LegalForm, LEI, SameAsAbove, CommunicationAddress, UltimateBeneficialOwner, 
                                      UltimateBeneficialOwnerHolding, BeneficialOwnership, ProofOfIdentity, ProofOfAddress, [Date], TypeOfEntity, 
                                      SelectedCity, PoliticallyExposed, RelatedToPoliticallyExposed, CreatedAt, UpdatedAt)
    SELECT ApplicationId, Name, DateOfIncorporation, DateOfCommencement, PlaceOfIncorporation, CountryOfIncorporation, 
           CountryCodeOfIncorporation, LegalForm, LEI, SameAsAbove, CommunicationAddress, UltimateBeneficialOwner, 
           UltimateBeneficialOwnerHolding, BeneficialOwnership, ProofOfIdentity, ProofOfAddress, [Date], TypeOfEntity, 
           SelectedCity, PoliticallyExposed, RelatedToPoliticallyExposed, CreatedAt, UpdatedAt
    FROM nsdlcaf.dbo.draft_Ekyc WHERE ApplicationId = @ApplicationId;

    -- Insert data from draft_ApplicantOtherName to main table
    INSERT INTO nsdlcaf.dbo.ApplicantOtherName (ApplicationId, OtherNameRadio, OtherNameField, CreatedAt, UpdatedAt)
    SELECT ApplicationId, OtherNameRadio, OtherNameField, CreatedAt, UpdatedAt
    FROM nsdlcaf.dbo.draft_ApplicantOtherName WHERE ApplicationId = @ApplicationId;

    -- Insert data from draft_ApplicantType to main table
    INSERT INTO nsdlcaf.dbo.ApplicantType (ApplicationId, ApplicantTypeName, ApplicantTypeOtherEntity, CreatedAt, UpdatedAt)
    SELECT ApplicationId, ApplicantTypeName, ApplicantTypeOtherEntity, CreatedAt, UpdatedAt
    FROM nsdlcaf.dbo.draft_ApplicantType WHERE ApplicationId = @ApplicationId;

    -- Insert data from draft_ComplianceOfficerInfo to main table
    INSERT INTO nsdlcaf.dbo.ComplianceOfficerInfo (ApplicationId, ComplianceOfficerInfoName, ComplianceOfficerInfoJob, ComplianceOfficerInfoMobile, 
                                                       ComplianceOfficerInfoFax, ComplianceOfficerInfoEmail, CreatedAt, UpdatedAt)
    SELECT ApplicationId, ComplianceOfficerInfoName, ComplianceOfficerInfoJob, ComplianceOfficerInfoMobile, 
           ComplianceOfficerInfoFax, ComplianceOfficerInfoEmail, CreatedAt, UpdatedAt
    FROM nsdlcaf.dbo.draft_ComplianceOfficerInfo WHERE ApplicationId = @ApplicationId;

    -- Insert data from draft_ContactDetails to main table
    INSERT INTO nsdlcaf.dbo.ContactDetails (ApplicationId, MobileNumber, EmailId, Website, CreatedAt, UpdatedAt)
    SELECT ApplicationId, MobileNumber, EmailId, Website, CreatedAt, UpdatedAt
    FROM nsdlcaf.dbo.draft_ContactDetails WHERE ApplicationId = @ApplicationId;

    -- Insert data from draft_ContactInfo to main table
    INSERT INTO nsdlcaf.dbo.ContactInfo (ApplicationId, [Type], CountryCode, AreaCode, Number, CreatedAt, UpdatedAt)
    SELECT ApplicationId, [Type], CountryCode, AreaCode, Number, CreatedAt, UpdatedAt
    FROM nsdlcaf.dbo.draft_ContactInfo WHERE ApplicationId = @ApplicationId;

    -- Insert data from draft_IncomeDetails to main table
    INSERT INTO nsdlcaf.dbo.IncomeDetails (ApplicationId, BusinessCode, AnnualIncome, AssetLess, AsOnDate, CreatedAt, UpdatedAt)
    SELECT ApplicationId, BusinessCode, AnnualIncome, AssetLess, AsOnDate, CreatedAt, UpdatedAt
    FROM nsdlcaf.dbo.draft_IncomeDetails WHERE ApplicationId = @ApplicationId;

    -- Insert data from draft_IncomeSource to main table
    INSERT INTO nsdlcaf.dbo.IncomeSource (ApplicationId, IncomeSourceType, CreatedAt)
    SELECT ApplicationId, IncomeSourceType, CreatedAt
    FROM nsdlcaf.dbo.draft_IncomeSource WHERE ApplicationId = @ApplicationId;

    -- Insert data from draft_ForeignOffice to main table
    INSERT INTO nsdlcaf.dbo.ForeignOffice (ApplicationId, ForeignFlatNum, ForeignBuildingName, ForeignCountryCode, ForeignRoadName, 
                                               ForeignAreaName, ForeignTownName, ForeignZipName, ForeignStateName, NotApplicableForeignOffice, 
                                               CreatedAt, UpdatedAt)
    SELECT ApplicationId, ForeignFlatNum, ForeignBuildingName, ForeignCountryCode, ForeignRoadName, 
           ForeignAreaName, ForeignTownName, ForeignZipName, ForeignStateName, NotApplicableForeignOffice, 
           CreatedAt, UpdatedAt
    FROM nsdlcaf.dbo.draft_ForeignOffice WHERE ApplicationId = @ApplicationId;

    -- Insert data from draft_ManagingOfficial to main table
    INSERT INTO nsdlcaf.dbo.ManagingOfficial (ApplicationId, GovernmentIdNumber, NameAndAddress, DateOfBirth, TaxResidencyJurisdiction, 
                                                  Nationality, ActingAsGroupDetails, BoGroupShareholding, CreatedAt, UpdatedAt)
    SELECT ApplicationId, GovernmentIdNumber, NameAndAddress, DateOfBirth, TaxResidencyJurisdiction, 
           Nationality, ActingAsGroupDetails, BoGroupShareholding, CreatedAt, UpdatedAt
    FROM nsdlcaf.dbo.draft_ManagingOfficial WHERE ApplicationId = @ApplicationId;

    -- Insert data from draft_OfficeInIndia to main table
    INSERT INTO nsdlcaf.dbo.OfficeInIndia (ApplicationId, OfficeInIndiaRadio, IndianFlatNum, IndianBuildingName, IndianCountryCode, 
                                               IndianRoadName, IndianAreaName, IndianTownName, IndianZipName, IndianStateName, 
                                               NotApplicableIndOffice, CreatedAt, UpdatedAt)
    SELECT ApplicationId, OfficeInIndiaRadio, IndianFlatNum, IndianBuildingName, IndianCountryCode, 
           IndianRoadName, IndianAreaName, IndianTownName, IndianZipName, IndianStateName, 
           NotApplicableIndOffice, CreatedAt, UpdatedAt
    FROM nsdlcaf.dbo.draft_OfficeInIndia WHERE ApplicationId = @ApplicationId;

    -- Insert data from draft_RegisteredOffice to main table
    INSERT INTO nsdlcaf.dbo.RegisteredOffice (ApplicationId, RegisteredFlatNum, RegisteredBuildingName, RegisteredCountryCode, 
                                                  RegisteredRoadName, RegisteredAreaName, RegisteredTownName, RegisteredZipName, 
                                                  RegisteredStateName, NotApplicableResidence, CreatedAt, UpdatedAt)
    SELECT ApplicationId, RegisteredFlatNum, RegisteredBuildingName, RegisteredCountryCode, 
           RegisteredRoadName, RegisteredAreaName, RegisteredTownName, RegisteredZipName, 
           RegisteredStateName, NotApplicableResidence, CreatedAt, UpdatedAt
    FROM nsdlcaf.dbo.draft_RegisteredOffice WHERE ApplicationId = @ApplicationId;

    INSERT INTO nsdlcaf.dbo.TaxResidency (ApplicationId, TRCNo, CountryCode, CreatedAt, UpdatedAt)
    SELECT ApplicationId, TRCNo, CountryCode, CreatedAt, UpdatedAt
    FROM nsdlcaf.dbo.draft_TaxResidency WHERE ApplicationId = @ApplicationId;
   
   	INSERT INTO nsdl.RegistrationForm (
    ApplicationId, ProvidedValidForm, RegulatoryAuthorityName, RegulatoryAuthorityCountry,
    RegulatoryAuthorityWebsite, RegulatoryAuthorityRegNumber, RegulatoryAuthorityCategory,
    DdpRegistrationNumber, CustodianRegistrationNumber, DpRegistrationNumber,
    SelectedCity, HasOtherEntity, OtherEntityDetails, CreatedAt, UpdatedAt
	)
	SELECT 
	    ApplicationId, ProvidedValidForm, RegulatoryAuthorityName, RegulatoryAuthorityCountry,
	    RegulatoryAuthorityWebsite, RegulatoryAuthorityRegNumber, RegulatoryAuthorityCategory,
	    DdpRegistrationNumber, CustodianRegistrationNumber, DpRegistrationNumber,
	    SelectedCity, HasOtherEntity, OtherEntityDetails, CreatedAt, UpdatedAt
	FROM nsdl.draft_RegistrationForm
	WHERE ApplicationId = @ApplicationId;

	INSERT INTO nsdl.CustodianInfo (
	    ApplicationId, Name, Value, RegistrationNumber, CreatedAt, UpdatedAt
	)
	SELECT 
	    ApplicationId, Name, Value, RegistrationNumber, GETDATE(), GETDATE()
	FROM nsdl.draft_CustodianInfo
	WHERE ApplicationId = @ApplicationId;

	INSERT INTO nsdl.DdpInfo (
	    ApplicationId, Name, Value, RegistrationNumber, DdpId, CreatedAt, UpdatedAt
	)
	SELECT 
	    ApplicationId, Name, Value, RegistrationNumber, DdpId, GETDATE(), GETDATE()
	FROM nsdl.draft_DdpInfo
	WHERE ApplicationId = @ApplicationId;

	INSERT INTO nsdl.DesignatedBank (
	    ApplicationId, DesignatedBankAddress, CreatedAt, UpdatedAt
	)
	SELECT 
	    ApplicationId, DesignatedBankAddress, GETDATE(), GETDATE()
	FROM nsdl.draft_DesignatedBank
	WHERE ApplicationId = @ApplicationId;

	INSERT INTO nsdl.DesignatedBankName (
	    ApplicationId, Name, Value, Address, CreatedAt, UpdatedAt
	)
	SELECT 
	    ApplicationId, Name, Value, Address, GETDATE(), GETDATE()
	FROM nsdl.draft_DesignatedBankName
	WHERE ApplicationId = @ApplicationId;

	INSERT INTO nsdl.DisciplinaryHistory (
	    ApplicationId, DisciplinaryHistoryRadio, DisciplinaryHistoryText, CreatedAt, UpdatedAt
	)
	SELECT 
	    ApplicationId, DisciplinaryHistoryRadio, DisciplinaryHistoryText, GETDATE(), GETDATE()
	FROM nsdl.draft_DisciplinaryHistory
	WHERE ApplicationId = @ApplicationId;

	INSERT INTO nsdl.DpInfo (
	    ApplicationId, Name, Value, RegistrationNumber, DdpId, CreatedAt, UpdatedAt
	)
	SELECT 
	    ApplicationId, Name, Value, RegistrationNumber, DdpId, GETDATE(), GETDATE()
	FROM nsdl.draft_DpInfo
	WHERE ApplicationId = @ApplicationId;

	INSERT INTO nsdl.HasPan (
	    ApplicationId, HasPanRadio, HasPanNumber, CreatedAt, UpdatedAt
	)
	SELECT 
	    ApplicationId, HasPanRadio, HasPanNumber, GETDATE(), GETDATE()
	FROM nsdl.draft_HasPan
	WHERE ApplicationId = @ApplicationId;

	INSERT INTO nsdl.PriorAssociation (
	    ApplicationId, PriorAssociationRadio, CreatedAt, UpdatedAt
	)
	SELECT 
	    ApplicationId, PriorAssociationRadio, GETDATE(), GETDATE()
	FROM nsdl.draft_PriorAssociation
	WHERE ApplicationId = @ApplicationId;

	INSERT INTO nsdl.PriorAssociationRow (
	    ApplicationId, SebiRegNumber, EntityName, RegistrationType, RegistrationStart, RegistrationEnd, CreatedAt, UpdatedAt
	)
	SELECT 
	    ApplicationId, SebiRegNumber, EntityName, RegistrationType, RegistrationStart, RegistrationEnd, GETDATE(), GETDATE()
	FROM nsdl.draft_PriorAssociationRow
	WHERE ApplicationId = @ApplicationId;
	
	INSERT INTO nsdl.ThroughGlobalCustodian (
	    ApplicationId, ThroughGlobalCustodianRadio, ThroughGlobalCustodianName, ThroughGlobalCustodianAddress, 
	    ThroughGlobalCustodianRegistration, ThroughGlobalCustodianCountry, CreatedAt, UpdatedAt
	)
	SELECT 
	    ApplicationId, ThroughGlobalCustodianRadio, ThroughGlobalCustodianName, ThroughGlobalCustodianAddress, 
	    ThroughGlobalCustodianRegistration, ThroughGlobalCustodianCountry, GETDATE(), GETDATE()
	FROM nsdl.draft_ThroughGlobalCustodian
	WHERE ApplicationId = @ApplicationId;
	
	INSERT INTO nsdlcaf.dbo.DeclarationAndUndertakingForm (
    ApplicationId, 
    Name, 
    Capacity, 
    Place, 
    [Date], 
    NameOfSignatory, 
    DesignationOfSignatory, 
    DateOfSignature, 
    Signature, 
    CreatedAt, 
    UpdatedAt
	)
	SELECT 
	    ApplicationId, 
	    Name, 
	    Capacity, 
	    Place, 
	    [Date], 
	    NameOfSignatory, 
	    DesignationOfSignatory, 
	    DateOfSignature, 
	    Signature, 
	    GETDATE(), 
	    GETDATE()
	FROM nsdlcaf.dbo.draft_DeclarationAndUndertakingForm
	WHERE ApplicationId = @ApplicationId;

	insert into nsdl.InvestmentManager(ApplicationId, NameOfEntity, TypeOfEntity, CountryCode, TelephoneNumber, FaxNumber, EmailId, CreatedAt, UpdatedAt)
	SELECT ApplicationId, NameOfEntity, TypeOfEntity, CountryCode, TelephoneNumber, FaxNumber, EmailId, GETDATE(), GETDATE()
	FROM nsdlcaf.dbo.draft_InvestmentManager WHERE ApplicationId = @ApplicationId;

	-- Inserting data from draft_AnextureForm to the main AnextureForm table where ApplicationId matches
	INSERT INTO nsdl.AnextureForm (
	    ApplicationId, IntermediateMaterial, EntityHolding, NoEntityHolding, BeneficialOwnership, CreatedAt, UpdatedAt
	)
	SELECT 
	    ApplicationId, IntermediateMaterial, EntityHolding, NoEntityHolding, BeneficialOwnership, CreatedAt, UpdatedAt
	FROM 
	    nsdl.draft_AnextureForm  -- Assuming the draft table is named draft_AnextureForm
	WHERE 
	    ApplicationId = @ApplicationId;
	
	-- Inserting data from draft_SegregatedPortfolio to the main SegregatedPortfolio table where ApplicationId matches
	INSERT INTO nsdl.SegregatedPortfolio (
	    ApplicationId, SeggregatedPortfolioRadio, SeggregatedPortfolioText, CreatedAt, UpdatedAt
	)
	SELECT 
	    ApplicationId, SeggregatedPortfolioRadio, SeggregatedPortfolioText, CreatedAt, UpdatedAt
	FROM 
	    nsdl.draft_SegregatedPortfolio  -- Assuming the draft table is named draft_SegregatedPortfolio
	WHERE 
	    ApplicationId = @ApplicationId;
		-- Inserting data from draft_BankDeclaration to the main BankDeclaration table where ApplicationId matches
	INSERT INTO nsdl.BankDeclaration (
	    ApplicationId, BankDeclarationRadio, BankDeclarationText, CreatedAt, UpdatedAt
	)
	SELECT 
	    ApplicationId, BankDeclarationRadio, BankDeclarationText, CreatedAt, UpdatedAt
	FROM 
	    nsdl.draft_BankDeclaration 
	WHERE 
	    ApplicationId = @ApplicationId;
	   
	INSERT INTO nsdl.ConsentIntermediary (
	    ApplicationId, ConsentIntermediaryRadio, ConsentIntermediaryName, ConsentIntermediaryEmail1, 
	    ConsentIntermediaryEmail2, ConsentIntermediaryEmail3, ConsentIntermediaryMobile, CreatedAt, UpdatedAt
	)
	SELECT 
	    ApplicationId, ConsentIntermediaryRadio, ConsentIntermediaryName, ConsentIntermediaryEmail1, 
	    ConsentIntermediaryEmail2, ConsentIntermediaryEmail3, ConsentIntermediaryMobile, CreatedAt, UpdatedAt
	FROM 
	    nsdl.draft_ConsentIntermediary  -- Assuming the draft table is named draft_ConsentIntermediary
	WHERE 
	    ApplicationId = @ApplicationId;
	-- Inserting data from draft_InformationOfSaSmFvciApplicant to the main InformationOfSaSmFvciApplicant table where ApplicationId matches
	INSERT INTO nsdl.InformationOfSaSmFvciApplicant (
	    ApplicationId, Name, RelationWithApplicant, Pan, NationalityCode, DateOfBirth, ResidentialAddress, 
	    IdentityDocNumber, CreatedAt, UpdatedAt
	)
	SELECT 
	    ApplicationId, Name, RelationWithApplicant, Pan, NationalityCode, DateOfBirth, ResidentialAddress, 
	    IdentityDocNumber, CreatedAt, UpdatedAt
	FROM 
	    nsdl.draft_InformationOfSaSmFvciApplicant  -- Assuming the draft table is named draft_InformationOfSaSmFvciApplicant
	WHERE 
	    ApplicationId = @ApplicationId;
	-- Inserting data from draft_Signatory to the main Signatory table where ApplicationId matches
	INSERT INTO nsdl.Signatory (
	    ApplicationId, Details, CreatedAt, UpdatedAt
	)
	SELECT 
	    ApplicationId, Details, CreatedAt, UpdatedAt
	FROM 
	    nsdl.draft_Signatory  -- Assuming the draft table is named draft_Signatory
	WHERE 
	    ApplicationId = @ApplicationId;
	-- Inserting data from draft_OwnerDetails to the main OwnerDetails table where ApplicationId matches
	INSERT INTO nsdl.OwnerDetails (
	    SignatoryId, NameAddressOfBo, DateOfBirthOfBo, TaxResidencyJuridictionCode, NationalityCode, 
	    ActingAloneOrMoreNaturalPerson, BoGroupPercentageShareHolding, IdentityDocument, CreatedAt, UpdatedAt
	)
	SELECT 
	    s2.Id, o.NameAddressOfBo, o.DateOfBirthOfBo, o.TaxResidencyJuridictionCode, o.NationalityCode, 
	    o.ActingAloneOrMoreNaturalPerson, o.BoGroupPercentageShareHolding, o.IdentityDocument, o.CreatedAt, o.UpdatedAt
	FROM 
	    nsdl.draft_OwnerDetails o
	inner join nsdl.draft_Signatory s on s.Id = o.SignatoryId 
	inner join nsdl.Signatory s2 on s.Details = s2.Details 
	where  s.ApplicationId = @ApplicationId;

	-- Inserting data from draft_MaterialShareholder to the main MaterialShareholder table where ApplicationId matches
	INSERT INTO nsdl.MaterialShareholder (
	    ApplicationId, NameOfBeneficialOwner, DirectIndirectStake, NameOfEntities, 
	    CountryOfIncorporationOrNationalityCode, PercentageStakeHeld, IndividualOrNonIndividual, 
	    CreatedAt, UpdatedAt
	)
	SELECT 
	    ApplicationId, NameOfBeneficialOwner, DirectIndirectStake, NameOfEntities, 
	    CountryOfIncorporationOrNationalityCode, PercentageStakeHeld, IndividualOrNonIndividual, 
	    CreatedAt, UpdatedAt
	FROM 
	    nsdl.draft_MaterialShareholder  -- Assuming the draft table is named draft_MaterialShareholder
	WHERE 
	    ApplicationId = @ApplicationId;
	-- Inserting data from draft_BeneficialOwners to the main BeneficialOwners table where ApplicationId matches
	INSERT INTO nsdl.BeneficialOwners (
	    ApplicationId, NameOfBeneficialOwner, MethodOfControl, CountryOfIncorporationCode, 
	    PercentageStakeHeld, IndividualOrNonIndividual, CreatedAt, UpdatedAt
	)
	SELECT 
	    ApplicationId, NameOfBeneficialOwner, MethodOfControl, CountryOfIncorporationCode, 
	    PercentageStakeHeld, IndividualOrNonIndividual, CreatedAt, UpdatedAt
	FROM 
	    nsdl.draft_BeneficialOwners  -- Assuming the draft table is named draft_BeneficialOwners
	WHERE 
	    ApplicationId = @ApplicationId;
	-- Inserting data from draft_Managers to the main Managers table where ApplicationId matches
	INSERT INTO nsdl.Managers (
	    ApplicationId, NameOfEntity, TypeOfEntity, CountryCode, TelephoneNumber, FaxNumber, EmailId, 
	    CreatedAt, UpdatedAt
	)
	SELECT 
	    ApplicationId, NameOfEntity, TypeOfEntity, CountryCode, TelephoneNumber, FaxNumber, EmailId, 
	    CreatedAt, UpdatedAt
	FROM 
	    nsdl.draft_Managers  -- Assuming the draft table is named draft_Managers
	WHERE 
	    ApplicationId = @ApplicationId;
	INSERT INTO nsdlcaf.dbo.fvci_kyc_documents
	(fvci_application_id, document_type, document_identifier, document_path, status, created_at, updated_at)
	select fvci_application_id, document_type, document_identifier, document_path, status, created_at, updated_at
	from nsdl.draft_fvci_kyc_documents 
	WHERE 
	    fvci_application_id = @ApplicationId;
	   
	SELECT top 1 au.ApplicationId applicationId, au.URNNo urnId, au.created_at createdAt
	from nsdl.fvci_applications fa 
	inner join nsdl.ApplicationURNDetails au on fa.application_id =au.ApplicationId 
	where fa.application_id = @ApplicationId
	order by au.created_at desc ;


COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH;

END;
