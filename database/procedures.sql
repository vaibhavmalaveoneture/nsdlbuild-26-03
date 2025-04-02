CREATE PROCEDURE nsdl.sp_Update_DesignatedBank
    @ApplicationId VARCHAR(255),
    @DesignatedBankAddress NVARCHAR(500)
AS
BEGIN
    SET NOCOUNT ON;

    -- Update only if the record exists
    IF EXISTS (SELECT 1 FROM nsdl.DesignatedBank WHERE ApplicationId = @ApplicationId)
    BEGIN
        UPDATE nsdl.DesignatedBank
        SET DesignatedBankAddress = @DesignatedBankAddress,
            UpdatedAt = GETDATE()
        WHERE ApplicationId = @ApplicationId;
    END
    ELSE
    BEGIN
        PRINT 'No existing record found for ApplicationId: ' + @ApplicationId;
    END
END;

CREATE PROCEDURE nsdl.sp_Update_DesignatedBankName
    @ApplicationId VARCHAR(255),
    @Name NVARCHAR(255),
    @Value INT,
    @Address NVARCHAR(500)
AS
BEGIN
    SET NOCOUNT ON;

    -- Update only if the record exists
    IF EXISTS (SELECT 1 FROM nsdl.DesignatedBankName WHERE ApplicationId = @ApplicationId AND Name = @Name)
    BEGIN
        UPDATE nsdl.DesignatedBankName
        SET Value = @Value,
            Address = @Address,
            UpdatedAt = GETDATE()
        WHERE ApplicationId = @ApplicationId AND Name = @Name;
    END
    ELSE
    BEGIN
        PRINT 'No existing record found for ApplicationId: ' + @ApplicationId + ' and Name: ' + @Name;
    END
END;

CREATE PROCEDURE nsdl.sp_Update_DisciplinaryHistory
    @ApplicationId VARCHAR(255),
    @DisciplinaryHistoryRadio BIT,
    @DisciplinaryHistoryText NVARCHAR(1000)
AS
BEGIN
    SET NOCOUNT ON;

    -- Update only if the record exists
    IF EXISTS (SELECT 1 FROM nsdl.DisciplinaryHistory WHERE ApplicationId = @ApplicationId)
    BEGIN
        UPDATE nsdl.DisciplinaryHistory
        SET DisciplinaryHistoryRadio = @DisciplinaryHistoryRadio,
            DisciplinaryHistoryText = @DisciplinaryHistoryText,
            UpdatedAt = GETDATE()
        WHERE ApplicationId = @ApplicationId;
    END
    ELSE
    BEGIN
        PRINT 'No existing record found for ApplicationId: ' + @ApplicationId;
    END
END;

CREATE PROCEDURE nsdl.sp_Update_DpInfo
    @ApplicationId VARCHAR(255),
    @Name NVARCHAR(255),
    @Value INT,
    @RegistrationNumber NVARCHAR(255),
    @DdpId INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Update only if the record exists
    IF EXISTS (SELECT 1 FROM nsdl.DpInfo WHERE ApplicationId = @ApplicationId)
    BEGIN
        UPDATE nsdl.DpInfo
        SET Name = @Name,
            Value = @Value,
            RegistrationNumber = @RegistrationNumber,
            DdpId = @DdpId,
            UpdatedAt = GETDATE()
        WHERE ApplicationId = @ApplicationId;
    END
    ELSE
    BEGIN
        PRINT 'No existing record found for ApplicationId: ' + @ApplicationId;
    END
END;

CREATE PROCEDURE nsdl.sp_Update_HasPan
    @ApplicationId INT,
    @HasPanRadio BIT,
    @HasPanNumber NVARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;

    -- Update only if the record exists
    IF EXISTS (SELECT 1 FROM nsdl.HasPan WHERE ApplicationId = @ApplicationId)
    BEGIN
        UPDATE nsdl.HasPan
        SET HasPanRadio = @HasPanRadio,
            HasPanNumber = @HasPanNumber,
            UpdatedAt = GETDATE()
        WHERE ApplicationId = @ApplicationId;
    END
    ELSE
    BEGIN
        PRINT 'No existing record found for ApplicationId: ' + CAST(@ApplicationId AS NVARCHAR);
    END
END;

CREATE PROCEDURE nsdl.sp_Update_PriorAssociation
    @ApplicationId INT,
    @PriorAssociationRadio BIT
AS
BEGIN
    SET NOCOUNT ON;

    -- Update only if the record exists
    IF EXISTS (SELECT 1 FROM nsdl.PriorAssociation WHERE ApplicationId = @ApplicationId)
    BEGIN
        UPDATE nsdl.PriorAssociation
        SET PriorAssociationRadio = @PriorAssociationRadio,
            UpdatedAt = GETDATE()
        WHERE ApplicationId = @ApplicationId;
    END
    ELSE
    BEGIN
        PRINT 'No existing record found for ApplicationId: ' + CAST(@ApplicationId AS NVARCHAR);
    END
END;

CREATE PROCEDURE nsdl.sp_Update_PriorAssociationRow
    @ApplicationId INT,
    @SebiRegNumber NVARCHAR(50),
    @EntityName NVARCHAR(255),
    @RegistrationType NVARCHAR(255),
    @RegistrationStart DATETIME,
    @RegistrationEnd DATETIME
AS
BEGIN
    SET NOCOUNT ON;

    -- Update only if the record exists
    IF EXISTS (
        SELECT 1 
        FROM nsdl.PriorAssociationRow 
        WHERE ApplicationId = @ApplicationId 
        AND SebiRegNumber = @SebiRegNumber 
        AND RegistrationStart = @RegistrationStart
    )
    BEGIN
        UPDATE nsdl.PriorAssociationRow
        SET EntityName = @EntityName,
            RegistrationType = @RegistrationType,
            RegistrationEnd = @RegistrationEnd,
            UpdatedAt = GETDATE()
        WHERE ApplicationId = @ApplicationId 
        AND SebiRegNumber = @SebiRegNumber 
        AND RegistrationStart = @RegistrationStart;
    END
    ELSE
    BEGIN
        PRINT 'No existing record found for ApplicationId: ' + CAST(@ApplicationId AS NVARCHAR);
    END
END;

CREATE PROCEDURE nsdl.sp_Update_ThroughGlobalCustodian
    @ApplicationId INT,
    @ThroughGlobalCustodianRadio NVARCHAR(50),
    @ThroughGlobalCustodianName NVARCHAR(255),
    @ThroughGlobalCustodianAddress NVARCHAR(500),
    @ThroughGlobalCustodianRegistration NVARCHAR(255),
    @ThroughGlobalCustodianCountry NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    -- Update only if the record exists
    IF EXISTS (
        SELECT 1 
        FROM nsdl.ThroughGlobalCustodian 
        WHERE ApplicationId = @ApplicationId
    )
    BEGIN
        UPDATE nsdl.ThroughGlobalCustodian
        SET ThroughGlobalCustodianRadio = @ThroughGlobalCustodianRadio,
            ThroughGlobalCustodianName = @ThroughGlobalCustodianName,
            ThroughGlobalCustodianAddress = @ThroughGlobalCustodianAddress,
            ThroughGlobalCustodianRegistration = @ThroughGlobalCustodianRegistration,
            ThroughGlobalCustodianCountry = @ThroughGlobalCustodianCountry,
            UpdatedAt = GETDATE()
        WHERE ApplicationId = @ApplicationId;
    END
    ELSE
    BEGIN
        PRINT 'No existing record found for ApplicationId: ' + CAST(@ApplicationId AS NVARCHAR);
    END
END;

-- SP_UpdateDDP
CREATE PROCEDURE [nsdl].[SP_UpdateDDP]
    @UserRegistrationId INT,
    @DdpId INT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE [nsdl].user_registrations
    SET ddp = @DdpId, pending_ddp_flag = 0, modified_dtm = GETDATE()
    WHERE ur_id = @UserRegistrationId;
END;

CREATE PROCEDURE nsdl.sp_UpdateDeclarationAndUndertaking
    @ApplicationId INT,
    @Name NVARCHAR(255),
    @Capacity NVARCHAR(255),
    @Place NVARCHAR(255),
    @Date DATETIME,
    @NameOfSignatory NVARCHAR(255),
    @DesignationOfSignatory NVARCHAR(255),
    @DateOfSignature DATETIME NULL,
    @Signature VARBINARY(MAX) NULL
AS
BEGIN
    SET NOCOUNT ON;

    -- Update only if the record exists
    IF EXISTS (SELECT 1 FROM nsdl.DeclarationAndUndertakingForm WHERE ApplicationId = @ApplicationId)
    BEGIN
        UPDATE nsdl.DeclarationAndUndertakingForm
        SET 
            Name = @Name,
            Capacity = @Capacity,
            Place = @Place,
            Date = @Date,
            NameOfSignatory = @NameOfSignatory,
            DesignationOfSignatory = @DesignationOfSignatory,
            DateOfSignature = @DateOfSignature,
            Signature = @Signature,
            UpdatedAt = GETDATE()
        WHERE ApplicationId = @ApplicationId;
    END
    ELSE
    BEGIN
        PRINT 'No existing record found for ApplicationId: ' + CAST(@ApplicationId AS NVARCHAR);
    END
END;

CREATE PROCEDURE nsdl.SP_UpdatePassword
    @UserId INT,
    @Password VARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE [nsdl].[users] SET new_password = @Password,is_forget_password = 0, last_pwd_change_dtm = GETDATE() WHERE user_id = @UserId;
END;

CREATE PROCEDURE [nsdl].[SP_UpdateRegistrationVerificationFlag]
    @UrId INT,
    @VerificationFlag INT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE [nsdl].user_registrations SET verification_flag = @VerificationFlag WHERE ur_id = @UrId;
END;

-- SP_UpdateUserRegistrationPassword
CREATE PROCEDURE nsdl.SP_UpdateUserRegistrationPassword
    @UserRegistrationId INT,
    @Password VARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE [nsdl].user_registrations
    SET new_password = @Password, modified_dtm = GETDATE()
    WHERE ur_id = @UserRegistrationId;
END;

CREATE PROCEDURE nsdl.Update_ApplicantOtherName
    @ApplicationId NVARCHAR(50),
    @OtherNameRadio BIT,
    @OtherNameField NVARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;

    -- Check if the record exists
    IF EXISTS (SELECT 1 FROM nsdl.ApplicantOtherName WHERE ApplicationId = @ApplicationId)
    BEGIN
        PRINT 'Updating existing applicant other name record: ' + @ApplicationId;

        UPDATE nsdl.ApplicantOtherName
        SET OtherNameRadio = @OtherNameRadio,
            OtherNameField = @OtherNameField,
            UpdatedAt = GETUTCDATE()
        WHERE ApplicationId = @ApplicationId;
    END
    ELSE
    BEGIN
        PRINT 'Applicant other name record does not exist for ApplicationId: ' + @ApplicationId;
    END
END;

CREATE PROCEDURE nsdl.Update_ApplicantType
    @ApplicationId NVARCHAR(50),
    @ApplicantTypeName NVARCHAR(255) NULL,
    @ApplicantTypeOtherEntity NVARCHAR(255) NULL
AS
BEGIN
    SET NOCOUNT ON;

    -- Check if the record exists
    IF EXISTS (SELECT 1 FROM nsdl.ApplicantType WHERE ApplicationId = @ApplicationId)
    BEGIN
        PRINT 'Updating existing Applicant Type record for ApplicationId: ' + @ApplicationId;

        UPDATE nsdl.ApplicantType
        SET ApplicantTypeName = @ApplicantTypeName,
            ApplicantTypeOtherEntity = @ApplicantTypeOtherEntity,
            UpdatedAt = GETUTCDATE()
        WHERE ApplicationId = @ApplicationId;
    END
    ELSE
    BEGIN
        PRINT 'Applicant Type record does not exist for ApplicationId: ' + @ApplicationId;
    END
END;

CREATE PROCEDURE nsdl.Update_ComplianceOfficerInfo
    @ApplicationId NVARCHAR(50),
    @ComplianceOfficerInfoName NVARCHAR(255) NULL,
    @ComplianceOfficerInfoJob NVARCHAR(255) NULL,
    @ComplianceOfficerInfoMobile NVARCHAR(50) NULL,
    @ComplianceOfficerInfoFax NVARCHAR(50) NULL,
    @ComplianceOfficerInfoEmail NVARCHAR(255) NULL
AS
BEGIN
    SET NOCOUNT ON;

    -- Check if the record exists
    IF EXISTS (SELECT 1 FROM nsdl.ComplianceOfficerInfo WHERE ApplicationId = @ApplicationId)
    BEGIN
        PRINT 'Updating existing Compliance Officer Info record for ApplicationId: ' + @ApplicationId;

        UPDATE nsdl.ComplianceOfficerInfo
        SET ComplianceOfficerInfoName = @ComplianceOfficerInfoName,
            ComplianceOfficerInfoJob = @ComplianceOfficerInfoJob,
            ComplianceOfficerInfoMobile = @ComplianceOfficerInfoMobile,
            ComplianceOfficerInfoFax = @ComplianceOfficerInfoFax,
            ComplianceOfficerInfoEmail = @ComplianceOfficerInfoEmail,
            UpdatedAt = GETUTCDATE()
        WHERE ApplicationId = @ApplicationId;
    END
    ELSE
    BEGIN
        PRINT 'Compliance Officer Info record does not exist for ApplicationId: ' + @ApplicationId;
    END
END;

CREATE PROCEDURE nsdl.Update_ContactDetails
    @ApplicationId NVARCHAR(50),
    @MobileNumber NVARCHAR(50) NULL,
    @EmailId NVARCHAR(255) NULL,
    @Website NVARCHAR(255) NULL
AS
BEGIN
    SET NOCOUNT ON;

    -- Check if the record exists
    IF EXISTS (SELECT 1 FROM nsdl.ContactDetails WHERE ApplicationId = @ApplicationId)
    BEGIN
        PRINT 'Updating existing Contact Details record for ApplicationId: ' + @ApplicationId;

        UPDATE nsdl.ContactDetails
        SET MobileNumber = @MobileNumber,
            EmailId = @EmailId,
            Website = @Website,
            UpdatedAt = GETUTCDATE()
        WHERE ApplicationId = @ApplicationId;
    END
    ELSE
    BEGIN
        PRINT 'Contact Details record does not exist for ApplicationId: ' + @ApplicationId;
    END
END;

CREATE PROCEDURE nsdl.Update_ContactInfo
    @ApplicationId NVARCHAR(50),
    @Type NVARCHAR(50),
    @CountryCode VARCHAR(255),
    @AreaCode NVARCHAR(50),
    @Number NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    -- Check if the record exists
    IF EXISTS (SELECT 1 FROM nsdl.ContactInfo WHERE ApplicationId = @ApplicationId AND Type = @Type)
    BEGIN
        PRINT 'Updating existing Contact Info record: ' + @ApplicationId + ' Type: ' + @Type;

        UPDATE nsdl.ContactInfo
        SET CountryCode = @CountryCode, 
            AreaCode = @AreaCode, 
            Number = @Number, 
            UpdatedAt = GETUTCDATE()
        WHERE ApplicationId = @ApplicationId AND Type = @Type;
    END
    ELSE
    BEGIN
        PRINT 'Contact Info record does not exist for ApplicationId: ' + @ApplicationId + ' Type: ' + @Type;
    END
END;

CREATE PROCEDURE nsdl.Update_CustodianInfo
    @ApplicationId varchar(255),
    @Name NVARCHAR(255),
    @Value INT,
    @RegistrationNumber NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    -- Check if the record exists
    IF EXISTS (SELECT 1 FROM nsdl.CustodianInfo WHERE ApplicationId = @ApplicationId)
    BEGIN
        PRINT 'Updating existing Custodian Info record for ApplicationId: ' + @ApplicationId;

        UPDATE nsdl.CustodianInfo
        SET Name = @Name,
            Value = @Value,
            RegistrationNumber = @RegistrationNumber,
            UpdatedAt = GETDATE()
        WHERE ApplicationId = @ApplicationId;
    END
    ELSE
    BEGIN
        PRINT 'Custodian Info record does not exist for ApplicationId: ' + @ApplicationId;
    END
END;

CREATE PROCEDURE nsdl.Update_DdpInfo
    @ApplicationId VARCHAR(255),
    @Name NVARCHAR(255),
    @Value INT,
    @RegistrationNumber NVARCHAR(255),
    @DdpId INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Check if the record exists
    IF EXISTS (SELECT 1 FROM nsdl.DdpInfo WHERE ApplicationId = @ApplicationId)
    BEGIN
        PRINT 'Updating existing DDP Info record for ApplicationId: ' + @ApplicationId;

        UPDATE nsdl.DdpInfo
        SET Name = @Name,
            Value = @Value,
            RegistrationNumber = @RegistrationNumber,
            DdpId = @DdpId,
            UpdatedAt = GETDATE()
        WHERE ApplicationId = @ApplicationId;
    END
    ELSE
    BEGIN
        PRINT 'DDP Info record does not exist for ApplicationId: ' + @ApplicationId;
    END
END;

CREATE PROCEDURE nsdl.Update_Ekyc
    @ApplicationId NVARCHAR(50),
    @Name NVARCHAR(255),
    @DateOfIncorporation DATETIME NULL,
    @DateOfCommencement DATETIME NULL,
    @PlaceOfIncorporation NVARCHAR(255),
    @CountryOfIncorporation VARCHAR(255),
    @CountryCodeOfIncorporation VARCHAR(255),
    @LegalForm NVARCHAR(255),
    @LEI NVARCHAR(50),
    @SameAsAbove BIT,
    @CommunicationAddress NVARCHAR(500),
    @UltimateBeneficialOwner NVARCHAR(255),
    @UltimateBeneficialOwnerHolding NVARCHAR(255),
    @BeneficialOwnership NVARCHAR(255),
    @ProofOfIdentity NVARCHAR(255),
    @ProofOfAddress NVARCHAR(255),
    @Date DATETIME NULL,
    @TypeOfEntity NVARCHAR(50),
    @SelectedCity NVARCHAR(255),
    @PoliticallyExposed NVARCHAR(255),
    @RelatedToPoliticallyExposed NVARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;

    -- Check if the ApplicationId exists
    IF EXISTS (SELECT 1 FROM nsdl.Ekyc WHERE ApplicationId = @ApplicationId)
    BEGIN
        PRINT 'Updating existing eKYC application: ' + @ApplicationId;

        UPDATE nsdl.Ekyc
        SET Name = @Name,
            DateOfIncorporation = @DateOfIncorporation,
            DateOfCommencement = @DateOfCommencement,
            PlaceOfIncorporation = @PlaceOfIncorporation,
            CountryOfIncorporation = @CountryOfIncorporation,
            CountryCodeOfIncorporation = @CountryCodeOfIncorporation,
            LegalForm = @LegalForm,
            LEI = @LEI,
            SameAsAbove = @SameAsAbove,
            CommunicationAddress = @CommunicationAddress,
            UltimateBeneficialOwner = @UltimateBeneficialOwner,
            UltimateBeneficialOwnerHolding = @UltimateBeneficialOwnerHolding,
            BeneficialOwnership = @BeneficialOwnership,
            ProofOfIdentity = @ProofOfIdentity,
            ProofOfAddress = @ProofOfAddress,
            Date = @Date,
            TypeOfEntity = @TypeOfEntity,
            SelectedCity = @SelectedCity,
            PoliticallyExposed = @PoliticallyExposed,
            RelatedToPoliticallyExposed = @RelatedToPoliticallyExposed,
            UpdatedAt = GETUTCDATE()
        WHERE ApplicationId = @ApplicationId;
    END
    ELSE
    BEGIN
        PRINT 'ApplicationId does not exist: ' + @ApplicationId;
    END
END;

CREATE PROCEDURE nsdl.Update_ForeignOffice
    @ApplicationId NVARCHAR(50),
    @ForeignFlatNum NVARCHAR(255),
    @ForeignBuildingName NVARCHAR(255),
    @ForeignCountryCode VARCHAR(255),
    @ForeignRoadName NVARCHAR(255),
    @ForeignAreaName NVARCHAR(255),
    @ForeignTownName NVARCHAR(255),
    @ForeignZipName NVARCHAR(50),
    @ForeignStateName NVARCHAR(255),
    @NotApplicableForeignOffice BIT
AS
BEGIN
    SET NOCOUNT ON;

    -- Check if the record exists
    IF EXISTS (SELECT 1 FROM nsdl.ForeignOffice WHERE ApplicationId = @ApplicationId)
    BEGIN
        PRINT 'Updating existing foreign office record: ' + @ApplicationId;

        UPDATE nsdl.ForeignOffice
        SET ForeignFlatNum = @ForeignFlatNum,
            ForeignBuildingName = @ForeignBuildingName,
            ForeignCountryCode = @ForeignCountryCode,
            ForeignRoadName = @ForeignRoadName,
            ForeignAreaName = @ForeignAreaName,
            ForeignTownName = @ForeignTownName,
            ForeignZipName = @ForeignZipName,
            ForeignStateName = @ForeignStateName,
            NotApplicableForeignOffice = @NotApplicableForeignOffice,
            UpdatedAt = GETUTCDATE()
        WHERE ApplicationId = @ApplicationId;
    END
    ELSE
    BEGIN
        PRINT 'Foreign office record does not exist for ApplicationId: ' + @ApplicationId;
    END
END;

CREATE PROCEDURE nsdl.Update_IncomeDetails
    @ApplicationId NVARCHAR(50),
    @BusinessCode NVARCHAR(255) NULL,
    @AnnualIncome NVARCHAR(255) NULL,
    @AssetLess NVARCHAR(255) NULL,
    @AsOnDate DATETIME NULL,
    @IncomeSourceList NVARCHAR(MAX)
AS
BEGIN
    SET NOCOUNT ON;

    -- Check if the record exists
    IF EXISTS (SELECT 1 FROM nsdl.IncomeDetails WHERE ApplicationId = @ApplicationId)
    BEGIN
        PRINT 'Updating existing Income Details record for ApplicationId: ' + @ApplicationId;

        UPDATE nsdl.IncomeDetails
        SET BusinessCode = @BusinessCode,
            AnnualIncome = @AnnualIncome,
            AssetLess = @AssetLess,
            AsOnDate = @AsOnDate,
            UpdatedAt = GETUTCDATE()
        WHERE ApplicationId = @ApplicationId;
       	DELETE FROM nsdl.IncomeSource WHERE ApplicationId = @ApplicationId;

    -- Insert new IncomeSource records (IncomeSourceList is a comma-separated list of integers)
    IF @IncomeSourceList IS NOT NULL
    BEGIN
        DECLARE @IncomeSource TABLE (IncomeSourceType INT);
        INSERT INTO @IncomeSource SELECT value FROM STRING_SPLIT(@IncomeSourceList, ',');

        INSERT INTO nsdl.IncomeSource (ApplicationId, IncomeSourceType, CreatedAt)
        SELECT @ApplicationId, IncomeSourceType, GETUTCDATE() FROM @IncomeSource;
    END
    END
    ELSE
    BEGIN
        PRINT 'Income Details record does not exist for ApplicationId: ' + @ApplicationId;
    END
END;

CREATE PROCEDURE nsdl.Update_InvestmentManager
    @ApplicationId NVARCHAR(50),
    @NameOfEntity NVARCHAR(255) NULL,
    @TypeOfEntity NVARCHAR(255) NULL,
    @CountryCode VARCHAR(255) NULL,
    @TelephoneNumber NVARCHAR(50) NULL,
    @FaxNumber NVARCHAR(50) NULL,
    @EmailId NVARCHAR(255) NULL
AS
BEGIN
    SET NOCOUNT ON;

    -- Check if the record exists
    IF EXISTS (SELECT 1 FROM nsdl.InvestmentManager WHERE ApplicationId = @ApplicationId)
    BEGIN
        PRINT 'Updating existing Investment Manager record for ApplicationId: ' + @ApplicationId;

        UPDATE nsdl.InvestmentManager
        SET NameOfEntity = @NameOfEntity,
            TypeOfEntity = @TypeOfEntity,
            CountryCode = @CountryCode,
            TelephoneNumber = @TelephoneNumber,
            FaxNumber = @FaxNumber,
            EmailId = @EmailId,
            UpdatedAt = GETUTCDATE()
        WHERE ApplicationId = @ApplicationId;
    END
    ELSE
    BEGIN
        PRINT 'Investment Manager record does not exist for ApplicationId: ' + @ApplicationId;
    END
END;

CREATE PROCEDURE nsdl.Update_ManagingOfficial
    @ApplicationId NVARCHAR(50),
    @GovernmentIdNumber NVARCHAR(50),
    @NameAndAddress NVARCHAR(500) NULL,
    @DateOfBirth DATETIME NULL,
    @TaxResidencyJurisdiction VARCHAR(255) NULL,
    @Nationality VARCHAR(255) NULL,
    @ActingAsGroupDetails NVARCHAR(500) NULL,
    @BoGroupShareholding NVARCHAR(255) NULL
AS
BEGIN
    SET NOCOUNT ON;

    -- Check if the record exists
    IF EXISTS (SELECT 1 FROM nsdl.ManagingOfficial WHERE ApplicationId = @ApplicationId AND GovernmentIdNumber = @GovernmentIdNumber)
    BEGIN
        PRINT 'Updating existing Managing Official record for ApplicationId: ' + @ApplicationId;

        UPDATE nsdl.ManagingOfficial
        SET NameAndAddress = @NameAndAddress,
            DateOfBirth = @DateOfBirth,
            TaxResidencyJurisdiction = @TaxResidencyJurisdiction,
            Nationality = @Nationality,
            ActingAsGroupDetails = @ActingAsGroupDetails,
            BoGroupShareholding = @BoGroupShareholding,
            UpdatedAt = GETUTCDATE()
        WHERE ApplicationId = @ApplicationId AND GovernmentIdNumber = @GovernmentIdNumber;
    END
    ELSE
    BEGIN
        PRINT 'Managing Official record does not exist for ApplicationId: ' + @ApplicationId;
    END
END;

CREATE PROCEDURE nsdl.Update_OfficeInIndia
    @ApplicationId NVARCHAR(50),
    @OfficeInIndiaRadio BIT,
    @IndianFlatNum NVARCHAR(255),
    @IndianBuildingName NVARCHAR(255),
    @IndianCountryCode VARCHAR(255),
    @IndianRoadName NVARCHAR(255),
    @IndianAreaName NVARCHAR(255),
    @IndianTownName NVARCHAR(255),
    @IndianZipName NVARCHAR(50),
    @IndianStateName NVARCHAR(255),
    @NotApplicableIndOffice BIT
AS
BEGIN
    SET NOCOUNT ON;

    -- Check if the record exists
    IF EXISTS (SELECT 1 FROM nsdl.OfficeInIndia WHERE ApplicationId = @ApplicationId)
    BEGIN
        PRINT 'Updating existing Office in India record: ' + @ApplicationId;

        UPDATE nsdl.OfficeInIndia
        SET OfficeInIndiaRadio = @OfficeInIndiaRadio,
            IndianFlatNum = @IndianFlatNum,
            IndianBuildingName = @IndianBuildingName,
            IndianCountryCode = @IndianCountryCode,
            IndianRoadName = @IndianRoadName,
            IndianAreaName = @IndianAreaName,
            IndianTownName = @IndianTownName,
            IndianZipName = @IndianZipName,
            IndianStateName = @IndianStateName,
            NotApplicableIndOffice = @NotApplicableIndOffice,
            UpdatedAt = GETUTCDATE()
        WHERE ApplicationId = @ApplicationId;
    END
    ELSE
    BEGIN
        PRINT 'Office in India record does not exist for ApplicationId: ' + @ApplicationId;
    END
END;

CREATE PROCEDURE nsdl.Update_RegisteredOffice
    @ApplicationId NVARCHAR(50),
    @RegisteredFlatNum NVARCHAR(255),
    @RegisteredBuildingName NVARCHAR(255),
    @RegisteredCountryCode VARCHAR(255),
    @RegisteredRoadName NVARCHAR(255),
    @RegisteredAreaName NVARCHAR(255),
    @RegisteredTownName NVARCHAR(255),
    @RegisteredZipName NVARCHAR(50),
    @RegisteredStateName NVARCHAR(255),
    @NotApplicableResidence BIT
AS
BEGIN
    SET NOCOUNT ON;

    -- Check if the record exists
    IF EXISTS (SELECT 1 FROM nsdl.RegisteredOffice WHERE ApplicationId = @ApplicationId)
    BEGIN
        PRINT 'Updating existing registered office record: ' + @ApplicationId;

        UPDATE nsdl.RegisteredOffice
        SET RegisteredFlatNum = @RegisteredFlatNum,
            RegisteredBuildingName = @RegisteredBuildingName,
            RegisteredCountryCode = @RegisteredCountryCode,
            RegisteredRoadName = @RegisteredRoadName,
            RegisteredAreaName = @RegisteredAreaName,
            RegisteredTownName = @RegisteredTownName,
            RegisteredZipName = @RegisteredZipName,
            RegisteredStateName = @RegisteredStateName,
            NotApplicableResidence = @NotApplicableResidence,
            UpdatedAt = GETUTCDATE()
        WHERE ApplicationId = @ApplicationId;
    END
    ELSE
    BEGIN
        PRINT 'Registered office record does not exist for ApplicationId: ' + @ApplicationId;
    END
END;

CREATE PROCEDURE nsdl.Update_RegistrationForm
    @ApplicationId INT,
    @ProvidedValidForm BIT,
    @RegulatoryAuthorityName NVARCHAR(255),
    @RegulatoryAuthorityCountry NVARCHAR(255),
    @RegulatoryAuthorityWebsite NVARCHAR(255),
    @RegulatoryAuthorityRegNumber NVARCHAR(255),
    @RegulatoryAuthorityCategory NVARCHAR(255),
    @DdpRegistrationNumber INT,
    @CustodianRegistrationNumber INT,
    @DpRegistrationNumber INT,
    @SelectedCity NVARCHAR(255),
    @HasOtherEntity BIT,
    @OtherEntityDetails NVARCHAR(500)
AS
BEGIN
    SET NOCOUNT ON;

    -- Check if the record exists
    IF EXISTS (SELECT 1 FROM nsdl.RegistrationForm WHERE ApplicationId = @ApplicationId)
    BEGIN
        PRINT 'Updating existing Registration Form record for ApplicationId: ' + CAST(@ApplicationId AS NVARCHAR);

        UPDATE nsdl.RegistrationForm
        SET ProvidedValidForm = @ProvidedValidForm,
            RegulatoryAuthorityName = @RegulatoryAuthorityName,
            RegulatoryAuthorityCountry = @RegulatoryAuthorityCountry,
            RegulatoryAuthorityWebsite = @RegulatoryAuthorityWebsite,
            RegulatoryAuthorityRegNumber = @RegulatoryAuthorityRegNumber,
            RegulatoryAuthorityCategory = @RegulatoryAuthorityCategory,
            DdpRegistrationNumber = @DdpRegistrationNumber,
            CustodianRegistrationNumber = @CustodianRegistrationNumber,
            DpRegistrationNumber = @DpRegistrationNumber,
            SelectedCity = @SelectedCity,
            HasOtherEntity = @HasOtherEntity,
            OtherEntityDetails = @OtherEntityDetails,
            UpdatedAt = GETDATE()
        WHERE ApplicationId = @ApplicationId;
    END
    ELSE
    BEGIN
        PRINT 'Registration Form record does not exist for ApplicationId: ' + CAST(@ApplicationId AS NVARCHAR);
    END
END;

CREATE PROCEDURE nsdl.Update_TaxResidency
    @ApplicationId NVARCHAR(50),
    @TRCNo NVARCHAR(255),
    @CountryCode VARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;

    -- Check if the record exists
    IF EXISTS (SELECT 1 FROM nsdl.TaxResidency WHERE ApplicationId = @ApplicationId AND TRCNo = @TRCNo)
    BEGIN
        PRINT 'Updating existing tax residency record: ' + @ApplicationId;

        UPDATE nsdl.TaxResidency
        SET CountryCode = @CountryCode,
            UpdatedAt = GETUTCDATE()
        WHERE ApplicationId = @ApplicationId AND TRCNo = @TRCNo;
    END
    ELSE
    BEGIN
        PRINT 'Tax residency record does not exist for ApplicationId: ' + @ApplicationId;
    END
END;

CREATE PROCEDURE nsdl.UpdateFvciApplication
@ApplicationId NVARCHAR(255),  
                        @UserId NVARCHAR(255),
                        @FvciRegistrationNumber NVARCHAR(255),
                        @CreatedAt DATETIME,
                        @UpdatedAt DATETIME,
                        @Status NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    -- Check if the ApplicationId exists
    IF EXISTS (SELECT 1 FROM nsdl.fvci_applications WHERE application_id = @ApplicationId)
    BEGIN

        UPDATE nsdl.fvci_applications
        SET user_id = @UserId,
            fvci_registration_number = @FvciRegistrationNumber,
            updated_at = @UpdatedAt,
            status = @Status
        WHERE application_id = @ApplicationId;
    END
    ELSE
    BEGIN
        PRINT 'ApplicationId does not exist: ' + @ApplicationId;
    END
END;
CREATE PROCEDURE nsdl.Upsert_Ekyc
    @ApplicationId NVARCHAR(50),
    @Name NVARCHAR(255),
    @DateOfIncorporation DATETIME NULL,
    @DateOfCommencement DATETIME NULL,
    @PlaceOfIncorporation NVARCHAR(255),
    @CountryOfIncorporation VARCHAR(255),
    @CountryCodeOfIncorporation VARCHAR(255),
    @LegalForm NVARCHAR(255),
    @LEI NVARCHAR(50),
    @SameAsAbove BIT,
    @CommunicationAddress NVARCHAR(500),
    @UltimateBeneficialOwner NVARCHAR(255),
    @UltimateBeneficialOwnerHolding NVARCHAR(255),
    @BeneficialOwnership NVARCHAR(255),
    @ProofOfIdentity NVARCHAR(255),
    @ProofOfAddress NVARCHAR(255),
    @Date DATETIME NULL,
    @TypeOfEntity NVARCHAR(50),
    @SelectedCity NVARCHAR(255),
    @PoliticallyExposed NVARCHAR(255),
    @RelatedToPoliticallyExposed NVARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;

    MERGE INTO nsdl.draft_Ekyc AS target
    USING (VALUES 
        (@ApplicationId, @Name, @DateOfIncorporation, @DateOfCommencement, 
         @PlaceOfIncorporation, @CountryOfIncorporation, @CountryCodeOfIncorporation, 
         @LegalForm, @LEI, @SameAsAbove, @CommunicationAddress, 
         @UltimateBeneficialOwner, @UltimateBeneficialOwnerHolding, @BeneficialOwnership, 
         @ProofOfIdentity, @ProofOfAddress, @Date, @TypeOfEntity, @SelectedCity, 
         @PoliticallyExposed, @RelatedToPoliticallyExposed)
    ) AS source (ApplicationId, Name, DateOfIncorporation, DateOfCommencement, 
                 PlaceOfIncorporation, CountryOfIncorporation, CountryCodeOfIncorporation, 
                 LegalForm, LEI, SameAsAbove, CommunicationAddress, 
                 UltimateBeneficialOwner, UltimateBeneficialOwnerHolding, BeneficialOwnership, 
                 ProofOfIdentity, ProofOfAddress, Date, TypeOfEntity, SelectedCity, 
                 PoliticallyExposed, RelatedToPoliticallyExposed)
    ON target.ApplicationId = source.ApplicationId
    WHEN MATCHED THEN
        UPDATE SET 
            Name = source.Name,
            DateOfIncorporation = source.DateOfIncorporation,
            DateOfCommencement = source.DateOfCommencement,
            PlaceOfIncorporation = source.PlaceOfIncorporation,
            CountryOfIncorporation = source.CountryOfIncorporation,
            CountryCodeOfIncorporation = source.CountryCodeOfIncorporation,
            LegalForm = source.LegalForm,
            LEI = source.LEI,
            SameAsAbove = source.SameAsAbove,
            CommunicationAddress = source.CommunicationAddress,
            UltimateBeneficialOwner = source.UltimateBeneficialOwner,
            UltimateBeneficialOwnerHolding = source.UltimateBeneficialOwnerHolding,
            BeneficialOwnership = source.BeneficialOwnership,
            ProofOfIdentity = source.ProofOfIdentity,
            ProofOfAddress = source.ProofOfAddress,
            Date = source.Date,
            TypeOfEntity = source.TypeOfEntity,
            SelectedCity = source.SelectedCity,
            PoliticallyExposed = source.PoliticallyExposed,
            RelatedToPoliticallyExposed = source.RelatedToPoliticallyExposed,
            UpdatedAt = GETUTCDATE()
    WHEN NOT MATCHED THEN
        INSERT (ApplicationId, Name, DateOfIncorporation, DateOfCommencement, 
                PlaceOfIncorporation, CountryOfIncorporation, CountryCodeOfIncorporation, 
                LegalForm, LEI, SameAsAbove, CommunicationAddress, 
                UltimateBeneficialOwner, UltimateBeneficialOwnerHolding, BeneficialOwnership, 
                ProofOfIdentity, ProofOfAddress, Date, TypeOfEntity, SelectedCity, 
                PoliticallyExposed, RelatedToPoliticallyExposed, CreatedAt, UpdatedAt)
        VALUES (source.ApplicationId, source.Name, source.DateOfIncorporation, source.DateOfCommencement, 
                source.PlaceOfIncorporation, source.CountryOfIncorporation, source.CountryCodeOfIncorporation, 
                source.LegalForm, source.LEI, source.SameAsAbove, source.CommunicationAddress, 
                source.UltimateBeneficialOwner, source.UltimateBeneficialOwnerHolding, source.BeneficialOwnership, 
                source.ProofOfIdentity, source.ProofOfAddress, source.Date, source.TypeOfEntity, source.SelectedCity, 
                source.PoliticallyExposed, source.RelatedToPoliticallyExposed, GETUTCDATE(), GETUTCDATE());
END;
CREATE PROCEDURE nsdl.Upsert_ApplicantOtherName
    @ApplicationId NVARCHAR(50),
    @OtherNameRadio BIT,
    @OtherNameField NVARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;

    MERGE INTO nsdl.draft_ApplicantOtherName AS target
    USING (SELECT @ApplicationId AS ApplicationId) AS source
    ON target.ApplicationId = source.ApplicationId

    WHEN MATCHED THEN 
        UPDATE SET 
            OtherNameRadio = @OtherNameRadio, 
            OtherNameField = @OtherNameField, 
            UpdatedAt = GETUTCDATE()

    WHEN NOT MATCHED THEN 
        INSERT (ApplicationId, OtherNameRadio, OtherNameField, CreatedAt, UpdatedAt)
        VALUES (@ApplicationId, @OtherNameRadio, @OtherNameField, GETUTCDATE(), GETUTCDATE());
END;
CREATE PROCEDURE nsdl.Upsert_TaxResidency
    @ApplicationId NVARCHAR(50),
    @TRCNo NVARCHAR(255),
    @CountryCode VARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;

    MERGE INTO nsdl.draft_TaxResidency AS target
    USING (SELECT @ApplicationId AS ApplicationId, @TRCNo as TRCNo) AS source
    ON target.ApplicationId = source.ApplicationId and target.TRCNo = source.TRCNo

    WHEN MATCHED THEN 
        UPDATE SET 
            TRCNo = @TRCNo, 
            CountryCode = @CountryCode, 
            UpdatedAt = GETUTCDATE()

    WHEN NOT MATCHED THEN 
        INSERT (ApplicationId, TRCNo, CountryCode, CreatedAt, UpdatedAt)
        VALUES (@ApplicationId, @TRCNo, @CountryCode, GETUTCDATE(), GETUTCDATE());
END;
CREATE PROCEDURE nsdl.Upsert_RegisteredOffice
    @ApplicationId NVARCHAR(50),
    @RegisteredFlatNum NVARCHAR(255),
    @RegisteredBuildingName NVARCHAR(255),
    @RegisteredCountryCode VARCHAR(255),
    @RegisteredRoadName NVARCHAR(255),
    @RegisteredAreaName NVARCHAR(255),
    @RegisteredTownName NVARCHAR(255),
    @RegisteredZipName NVARCHAR(50),
    @RegisteredStateName NVARCHAR(255),
    @NotApplicableResidence BIT
AS
BEGIN
    SET NOCOUNT ON;

    MERGE INTO nsdl.draft_RegisteredOffice AS target
    USING (SELECT @ApplicationId AS ApplicationId) AS source
    ON target.ApplicationId = source.ApplicationId

    WHEN MATCHED THEN 
        UPDATE SET 
            RegisteredFlatNum = @RegisteredFlatNum, 
            RegisteredBuildingName = @RegisteredBuildingName, 
            RegisteredCountryCode = @RegisteredCountryCode, 
            RegisteredRoadName = @RegisteredRoadName, 
            RegisteredAreaName = @RegisteredAreaName, 
            RegisteredTownName = @RegisteredTownName, 
            RegisteredZipName = @RegisteredZipName, 
            RegisteredStateName = @RegisteredStateName, 
            NotApplicableResidence = @NotApplicableResidence, 
            UpdatedAt = GETUTCDATE()

    WHEN NOT MATCHED THEN 
        INSERT (ApplicationId, RegisteredFlatNum, RegisteredBuildingName, RegisteredCountryCode, RegisteredRoadName, RegisteredAreaName, RegisteredTownName, RegisteredZipName, RegisteredStateName, NotApplicableResidence, CreatedAt, UpdatedAt)
        VALUES (@ApplicationId, @RegisteredFlatNum, @RegisteredBuildingName, @RegisteredCountryCode, @RegisteredRoadName, @RegisteredAreaName, @RegisteredTownName, @RegisteredZipName, @RegisteredStateName, @NotApplicableResidence, GETUTCDATE(), GETUTCDATE());
END;

CREATE PROCEDURE nsdl.Upsert_ForeignOffice
    @ApplicationId NVARCHAR(50),
    @ForeignFlatNum NVARCHAR(255),
    @ForeignBuildingName NVARCHAR(255),
    @ForeignCountryCode VARCHAR(255),
    @ForeignRoadName NVARCHAR(255),
    @ForeignAreaName NVARCHAR(255),
    @ForeignTownName NVARCHAR(255),
    @ForeignZipName NVARCHAR(50),
    @ForeignStateName NVARCHAR(255),
    @NotApplicableForeignOffice BIT
AS
BEGIN
    SET NOCOUNT ON;

    MERGE INTO nsdl.draft_ForeignOffice AS target
    USING (SELECT @ApplicationId AS ApplicationId) AS source
    ON target.ApplicationId = source.ApplicationId

    WHEN MATCHED THEN 
        UPDATE SET 
            ForeignFlatNum = @ForeignFlatNum, 
            ForeignBuildingName = @ForeignBuildingName, 
            ForeignCountryCode = @ForeignCountryCode, 
            ForeignRoadName = @ForeignRoadName, 
            ForeignAreaName = @ForeignAreaName, 
            ForeignTownName = @ForeignTownName, 
            ForeignZipName = @ForeignZipName, 
            ForeignStateName = @ForeignStateName, 
            NotApplicableForeignOffice = @NotApplicableForeignOffice, 
            UpdatedAt = GETUTCDATE()

    WHEN NOT MATCHED THEN 
        INSERT (ApplicationId, ForeignFlatNum, ForeignBuildingName, ForeignCountryCode, ForeignRoadName, ForeignAreaName, ForeignTownName, ForeignZipName, ForeignStateName, NotApplicableForeignOffice, CreatedAt, UpdatedAt)
        VALUES (@ApplicationId, @ForeignFlatNum, @ForeignBuildingName, @ForeignCountryCode, @ForeignRoadName, @ForeignAreaName, @ForeignTownName, @ForeignZipName, @ForeignStateName, @NotApplicableForeignOffice, GETUTCDATE(), GETUTCDATE());
END;

CREATE PROCEDURE nsdl.Upsert_OfficeInIndia
    @ApplicationId NVARCHAR(50),
    @OfficeInIndiaRadio BIT,
    @IndianFlatNum NVARCHAR(255),
    @IndianBuildingName NVARCHAR(255),
    @IndianCountryCode VARCHAR(255),
    @IndianRoadName NVARCHAR(255),
    @IndianAreaName NVARCHAR(255),
    @IndianTownName NVARCHAR(255),
    @IndianZipName NVARCHAR(50),
    @IndianStateName NVARCHAR(255),
    @NotApplicableIndOffice BIT
AS
BEGIN
    SET NOCOUNT ON;

    MERGE INTO nsdl.draft_OfficeInIndia AS target
    USING (SELECT @ApplicationId AS ApplicationId) AS source
    ON target.ApplicationId = source.ApplicationId

    WHEN MATCHED THEN 
        UPDATE SET 
            OfficeInIndiaRadio = @OfficeInIndiaRadio,
            IndianFlatNum = @IndianFlatNum, 
            IndianBuildingName = @IndianBuildingName, 
            IndianCountryCode = @IndianCountryCode, 
            IndianRoadName = @IndianRoadName, 
            IndianAreaName = @IndianAreaName, 
            IndianTownName = @IndianTownName, 
            IndianZipName = @IndianZipName, 
            IndianStateName = @IndianStateName, 
            NotApplicableIndOffice = @NotApplicableIndOffice, 
            UpdatedAt = GETUTCDATE()

    WHEN NOT MATCHED THEN 
        INSERT (ApplicationId, OfficeInIndiaRadio, IndianFlatNum, IndianBuildingName, IndianCountryCode, IndianRoadName, IndianAreaName, IndianTownName, IndianZipName, IndianStateName, NotApplicableIndOffice, CreatedAt, UpdatedAt)
        VALUES (@ApplicationId, @OfficeInIndiaRadio, @IndianFlatNum, @IndianBuildingName, @IndianCountryCode, @IndianRoadName, @IndianAreaName, @IndianTownName, @IndianZipName, @IndianStateName, @NotApplicableIndOffice, GETUTCDATE(), GETUTCDATE());
END;

CREATE PROCEDURE nsdl.Upsert_ContactDetails
    @ApplicationId NVARCHAR(50),
    @MobileNumber NVARCHAR(50) NULL,
    @EmailId NVARCHAR(255) NULL,
    @Website NVARCHAR(255) NULL
AS
BEGIN
    SET NOCOUNT ON;

    MERGE INTO nsdl.draft_ContactDetails AS target
    USING (SELECT @ApplicationId AS ApplicationId) AS source
    ON target.ApplicationId = source.ApplicationId

    WHEN MATCHED THEN 
        UPDATE SET 
            MobileNumber = @MobileNumber,
            EmailId = @EmailId,
            Website = @Website,
            UpdatedAt = GETUTCDATE()

    WHEN NOT MATCHED THEN 
        INSERT (ApplicationId, MobileNumber, EmailId, Website, CreatedAt, UpdatedAt)
        VALUES (@ApplicationId, @MobileNumber, @EmailId, @Website, GETUTCDATE(), GETUTCDATE());
END;

CREATE PROCEDURE nsdl.Upsert_ContactInfo
    @ApplicationId NVARCHAR(50),
    @Type NVARCHAR(50),
    @CountryCode VARCHAR(255),
    @AreaCode NVARCHAR(50),
    @Number NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    MERGE INTO nsdl.draft_ContactInfo AS target
    USING (SELECT @ApplicationId AS ApplicationId, @Type AS Type) AS source
    ON target.ApplicationId = source.ApplicationId AND target.Type = source.Type

    WHEN MATCHED THEN 
        UPDATE SET 
            CountryCode = @CountryCode, 
            AreaCode = @AreaCode, 
            Number = @Number, 
            UpdatedAt = GETUTCDATE()

    WHEN NOT MATCHED THEN 
        INSERT (ApplicationId, Type, CountryCode, AreaCode, Number, CreatedAt, UpdatedAt)
        VALUES (@ApplicationId, @Type, @CountryCode, @AreaCode, @Number, GETUTCDATE(), GETUTCDATE());
END;

CREATE PROCEDURE nsdl.Upsert_InvestmentManager
    @ApplicationId NVARCHAR(50),
    @NameOfEntity NVARCHAR(255) NULL,
    @TypeOfEntity NVARCHAR(255) NULL,
    @CountryCode VARCHAR(255) NULL,
    @TelephoneNumber NVARCHAR(50) NULL,
    @FaxNumber NVARCHAR(50) NULL,
    @EmailId NVARCHAR(255) NULL
AS
BEGIN
    SET NOCOUNT ON;

    MERGE INTO nsdl.draft_InvestmentManager AS target
    USING (SELECT @ApplicationId AS ApplicationId) AS source
    ON target.ApplicationId = source.ApplicationId

    WHEN MATCHED THEN 
        UPDATE SET 
            NameOfEntity = @NameOfEntity,
            TypeOfEntity = @TypeOfEntity,
            CountryCode = @CountryCode,
            TelephoneNumber = @TelephoneNumber,
            FaxNumber = @FaxNumber,
            EmailId = @EmailId,
            UpdatedAt = GETUTCDATE()

    WHEN NOT MATCHED THEN 
        INSERT (ApplicationId, NameOfEntity, TypeOfEntity, CountryCode, TelephoneNumber, FaxNumber, EmailId, CreatedAt, UpdatedAt)
        VALUES (@ApplicationId, @NameOfEntity, @TypeOfEntity, @CountryCode, @TelephoneNumber, @FaxNumber, @EmailId, GETUTCDATE(), GETUTCDATE());
END;

CREATE PROCEDURE nsdl.Upsert_ComplianceOfficerInfo
    @ApplicationId NVARCHAR(50),
    @ComplianceOfficerInfoName NVARCHAR(255) NULL,
    @ComplianceOfficerInfoJob NVARCHAR(255) NULL,
    @ComplianceOfficerInfoMobile NVARCHAR(50) NULL,
    @ComplianceOfficerInfoFax NVARCHAR(50) NULL,
    @ComplianceOfficerInfoEmail NVARCHAR(255) NULL
AS
BEGIN
    SET NOCOUNT ON;

    MERGE INTO nsdl.draft_ComplianceOfficerInfo AS target
    USING (SELECT @ApplicationId AS ApplicationId) AS source
    ON target.ApplicationId = source.ApplicationId

    WHEN MATCHED THEN 
        UPDATE SET 
            ComplianceOfficerInfoName = @ComplianceOfficerInfoName,
            ComplianceOfficerInfoJob = @ComplianceOfficerInfoJob,
            ComplianceOfficerInfoMobile = @ComplianceOfficerInfoMobile,
            ComplianceOfficerInfoFax = @ComplianceOfficerInfoFax,
            ComplianceOfficerInfoEmail = @ComplianceOfficerInfoEmail,
            UpdatedAt = GETUTCDATE()

    WHEN NOT MATCHED THEN 
        INSERT (ApplicationId, ComplianceOfficerInfoName, ComplianceOfficerInfoJob, ComplianceOfficerInfoMobile, ComplianceOfficerInfoFax, ComplianceOfficerInfoEmail, CreatedAt, UpdatedAt)
        VALUES (@ApplicationId, @ComplianceOfficerInfoName, @ComplianceOfficerInfoJob, @ComplianceOfficerInfoMobile, @ComplianceOfficerInfoFax, @ComplianceOfficerInfoEmail, GETUTCDATE(), GETUTCDATE());
END;

CREATE PROCEDURE nsdl.Upsert_ManagingOfficial
    @ApplicationId NVARCHAR(50),
    @GovernmentIdNumber NVARCHAR(50),
    @NameAndAddress NVARCHAR(500) NULL,
    @DateOfBirth DATETIME NULL,
    @TaxResidencyJurisdiction VARCHAR(255) NULL,
    @Nationality VARCHAR(255) NULL,
    @ActingAsGroupDetails NVARCHAR(500) NULL,
    @BoGroupShareholding NVARCHAR(255) NULL
AS
BEGIN
    SET NOCOUNT ON;

    -- Upsert using MERGE
    MERGE INTO nsdl.draft_ManagingOfficial AS target
    USING (SELECT @ApplicationId AS ApplicationId, @GovernmentIdNumber AS GovernmentIdNumber) AS source
    ON target.ApplicationId = source.ApplicationId AND target.GovernmentIdNumber = source.GovernmentIdNumber

    WHEN MATCHED THEN 
        UPDATE SET 
            NameAndAddress = @NameAndAddress,
            DateOfBirth = @DateOfBirth,
            TaxResidencyJurisdiction = @TaxResidencyJurisdiction,
            Nationality = @Nationality,
            ActingAsGroupDetails = @ActingAsGroupDetails,
            BoGroupShareholding = @BoGroupShareholding,
            UpdatedAt = GETUTCDATE()

    WHEN NOT MATCHED THEN 
        INSERT (ApplicationId, GovernmentIdNumber, NameAndAddress, DateOfBirth, TaxResidencyJurisdiction, Nationality, ActingAsGroupDetails, BoGroupShareholding, CreatedAt, UpdatedAt)
        VALUES (@ApplicationId, @GovernmentIdNumber, @NameAndAddress, @DateOfBirth, @TaxResidencyJurisdiction, @Nationality, @ActingAsGroupDetails, @BoGroupShareholding, GETUTCDATE(), GETUTCDATE());
END;

CREATE PROCEDURE nsdl.Upsert_IncomeDetails
    @ApplicationId NVARCHAR(50),
    @BusinessCode NVARCHAR(255) NULL,
    @AnnualIncome NVARCHAR(255) NULL,
    @AssetLess NVARCHAR(255) NULL,
    @AsOnDate DATETIME NULL,
    @IncomeSourceList NVARCHAR(MAX)
AS
BEGIN
    SET NOCOUNT ON;

    -- Upsert IncomeDetails
    MERGE INTO nsdl.draft_IncomeDetails AS target
    USING (SELECT @ApplicationId AS ApplicationId) AS source
    ON target.ApplicationId = source.ApplicationId

    WHEN MATCHED THEN 
        UPDATE SET 
            BusinessCode = @BusinessCode,
            AnnualIncome = @AnnualIncome,
            AssetLess = @AssetLess,
            AsOnDate = @AsOnDate,
            UpdatedAt = GETUTCDATE()

    WHEN NOT MATCHED THEN 
        INSERT (ApplicationId, BusinessCode, AnnualIncome, AssetLess, AsOnDate, CreatedAt, UpdatedAt)
        VALUES (@ApplicationId, @BusinessCode, @AnnualIncome, @AssetLess, @AsOnDate, GETUTCDATE(), GETUTCDATE());

    -- Delete old IncomeSource records for this ApplicationId
    DELETE FROM nsdl.draft_IncomeSource WHERE ApplicationId = @ApplicationId;

    -- Insert new IncomeSource records (IncomeSourceList is a comma-separated list of integers)
    IF @IncomeSourceList IS NOT NULL
    BEGIN
        DECLARE @IncomeSource TABLE (IncomeSourceType INT);
        INSERT INTO @IncomeSource SELECT value FROM STRING_SPLIT(@IncomeSourceList, ',');

        INSERT INTO nsdl.draft_IncomeSource (ApplicationId, IncomeSourceType, CreatedAt)
        SELECT @ApplicationId, IncomeSourceType, GETUTCDATE() FROM @IncomeSource;
    END
END;

CREATE PROCEDURE nsdl.Upsert_ApplicantType
    @ApplicationId NVARCHAR(50),
    @ApplicantTypeName NVARCHAR(255) NULL,
    @ApplicantTypeOtherEntity NVARCHAR(255) NULL
AS
BEGIN
    SET NOCOUNT ON;

    MERGE INTO nsdl.draft_ApplicantType AS target
    USING (SELECT @ApplicationId AS ApplicationId) AS source
    ON target.ApplicationId = source.ApplicationId

    WHEN MATCHED THEN 
        UPDATE SET 
            ApplicantTypeName = @ApplicantTypeName,
            ApplicantTypeOtherEntity = @ApplicantTypeOtherEntity,
            UpdatedAt = GETUTCDATE()

    WHEN NOT MATCHED THEN 
        INSERT (ApplicationId, ApplicantTypeName, ApplicantTypeOtherEntity, CreatedAt, UpdatedAt)
        VALUES (@ApplicationId, @ApplicantTypeName, @ApplicantTypeOtherEntity, GETUTCDATE(), GETUTCDATE());
END;

CREATE PROCEDURE nsdl.Upsert_RegistrationForm
    @ApplicationId INT,
    @ProvidedValidForm BIT,
    @RegulatoryAuthorityName NVARCHAR(255),
    @RegulatoryAuthorityCountry NVARCHAR(255),
    @RegulatoryAuthorityWebsite NVARCHAR(255),
    @RegulatoryAuthorityRegNumber NVARCHAR(255),
    @RegulatoryAuthorityCategory NVARCHAR(255),
    @DdpRegistrationNumber INT,
    @CustodianRegistrationNumber INT,
    @DpRegistrationNumber INT,
    @SelectedCity NVARCHAR(255),
    @HasOtherEntity BIT,
    @OtherEntityDetails NVARCHAR(500)
AS
BEGIN
    SET NOCOUNT ON;

    MERGE INTO nsdl.draft_RegistrationForm AS target
    USING (SELECT @ApplicationId AS ApplicationId) AS source
    ON target.ApplicationId = source.ApplicationId
    WHEN MATCHED THEN
        UPDATE SET 
            ProvidedValidForm = @ProvidedValidForm,
            RegulatoryAuthorityName = @RegulatoryAuthorityName,
            RegulatoryAuthorityCountry = @RegulatoryAuthorityCountry,
            RegulatoryAuthorityWebsite = @RegulatoryAuthorityWebsite,
            RegulatoryAuthorityRegNumber = @RegulatoryAuthorityRegNumber,
            RegulatoryAuthorityCategory = @RegulatoryAuthorityCategory,
            DdpRegistrationNumber = @DdpRegistrationNumber,
            CustodianRegistrationNumber = @CustodianRegistrationNumber,
            DpRegistrationNumber = @DpRegistrationNumber,
            SelectedCity = @SelectedCity,
            HasOtherEntity = @HasOtherEntity,
            OtherEntityDetails = @OtherEntityDetails,
            UpdatedAt = GETDATE()
    WHEN NOT MATCHED THEN
        INSERT (ApplicationId, ProvidedValidForm, RegulatoryAuthorityName, RegulatoryAuthorityCountry, 
                RegulatoryAuthorityWebsite, RegulatoryAuthorityRegNumber, RegulatoryAuthorityCategory, 
               	 DdpRegistrationNumber, CustodianRegistrationNumber, 
                 DpRegistrationNumber, SelectedCity, HasOtherEntity, OtherEntityDetails, CreatedAt, UpdatedAt)
        VALUES (@ApplicationId, @ProvidedValidForm, @RegulatoryAuthorityName, @RegulatoryAuthorityCountry, 
                @RegulatoryAuthorityWebsite, @RegulatoryAuthorityRegNumber, @RegulatoryAuthorityCategory, 
                @DdpRegistrationNumber, @CustodianRegistrationNumber, 
                @DpRegistrationNumber, @SelectedCity, @HasOtherEntity, @OtherEntityDetails, GETDATE(), GETDATE());

END;

CREATE PROCEDURE nsdl.sp_Upsert_ThroughGlobalCustodian
    @ApplicationId INT,
    @ThroughGlobalCustodianRadio NVARCHAR(50),
    @ThroughGlobalCustodianName NVARCHAR(255),
    @ThroughGlobalCustodianAddress NVARCHAR(500),
    @ThroughGlobalCustodianRegistration NVARCHAR(255),
    @ThroughGlobalCustodianCountry NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    MERGE INTO nsdl.draft_ThroughGlobalCustodian AS target
    USING (SELECT @ApplicationId AS ApplicationId) AS source
    ON target.ApplicationId = source.ApplicationId
    WHEN MATCHED THEN
        UPDATE SET 
            ThroughGlobalCustodianRadio = @ThroughGlobalCustodianRadio,
            ThroughGlobalCustodianName = @ThroughGlobalCustodianName,
            ThroughGlobalCustodianAddress = @ThroughGlobalCustodianAddress,
            ThroughGlobalCustodianRegistration = @ThroughGlobalCustodianRegistration,
            ThroughGlobalCustodianCountry = @ThroughGlobalCustodianCountry,
            UpdatedAt = GETDATE()
    WHEN NOT MATCHED THEN
        INSERT (ApplicationId, ThroughGlobalCustodianRadio, ThroughGlobalCustodianName, ThroughGlobalCustodianAddress, ThroughGlobalCustodianRegistration, ThroughGlobalCustodianCountry, CreatedAt, UpdatedAt)
        VALUES (@ApplicationId, @ThroughGlobalCustodianRadio, @ThroughGlobalCustodianName, @ThroughGlobalCustodianAddress, @ThroughGlobalCustodianRegistration, @ThroughGlobalCustodianCountry, GETDATE(), GETDATE());
END;


CREATE PROCEDURE nsdl.sp_Upsert_DesignatedBank
    @ApplicationId varchar(255),
    @DesignatedBankAddress NVARCHAR(500)
AS
BEGIN
    SET NOCOUNT ON;

    MERGE INTO nsdl.draft_DesignatedBank AS target
    USING (SELECT @ApplicationId AS ApplicationId) AS source
    ON target.ApplicationId = source.ApplicationId
    WHEN MATCHED THEN
        UPDATE SET 
            DesignatedBankAddress = @DesignatedBankAddress,
            UpdatedAt = GETDATE()
    WHEN NOT MATCHED THEN
        INSERT (ApplicationId, DesignatedBankAddress, CreatedAt, UpdatedAt)
        VALUES (@ApplicationId, @DesignatedBankAddress, GETDATE(), GETDATE());
END;

CREATE PROCEDURE nsdl.sp_Upsert_DesignatedBankName
    @ApplicationId varchar(255),
    @Name NVARCHAR(255),
    @Value INT,
    @Address NVARCHAR(500)
AS
BEGIN
    SET NOCOUNT ON;

    MERGE INTO nsdl.draft_DesignatedBankName AS target
    USING (SELECT @ApplicationId AS ApplicationId, @Name AS Name, @Value AS Value) AS source
    ON target.ApplicationId = source.ApplicationId AND target.Name = source.Name
    WHEN MATCHED THEN
        UPDATE SET 
            Value = @Value,
            Address = @Address,
            UpdatedAt = GETDATE()
    WHEN NOT MATCHED THEN
        INSERT (ApplicationId, Name, Value, Address, CreatedAt, UpdatedAt)
        VALUES (@ApplicationId, @Name, @Value, @Address, GETDATE(), GETDATE());
END;


CREATE PROCEDURE nsdl.sp_Upsert_PriorAssociation
    @ApplicationId INT,
    @PriorAssociationRadio BIT
AS
BEGIN
    SET NOCOUNT ON;

    MERGE INTO nsdl.draft_PriorAssociation AS target
    USING (SELECT @ApplicationId AS ApplicationId) AS source
    ON target.ApplicationId = source.ApplicationId
    WHEN MATCHED THEN
        UPDATE SET 
            PriorAssociationRadio = @PriorAssociationRadio,
            UpdatedAt = GETDATE()
    WHEN NOT MATCHED THEN
        INSERT (ApplicationId, PriorAssociationRadio, CreatedAt, UpdatedAt)
        VALUES (@ApplicationId, @PriorAssociationRadio, GETDATE(), GETDATE());
END;

CREATE PROCEDURE nsdl.sp_Upsert_PriorAssociationRow
    @ApplicationId INT,
    @SebiRegNumber NVARCHAR(50),
    @EntityName NVARCHAR(255),
    @RegistrationType NVARCHAR(255),
    @RegistrationStart DATETIME,
    @RegistrationEnd DATETIME
AS
BEGIN
    SET NOCOUNT ON;

    MERGE INTO nsdl.draft_PriorAssociationRow AS target
    USING (SELECT @ApplicationId AS ApplicationId, @SebiRegNumber AS SebiRegNumber, @RegistrationStart AS RegistrationStart) AS source
    ON target.ApplicationId = source.ApplicationId 
        AND target.SebiRegNumber = source.SebiRegNumber 
        AND target.RegistrationStart = source.RegistrationStart
    WHEN MATCHED THEN
        UPDATE SET 
            EntityName = @EntityName,
            RegistrationType = @RegistrationType,
            RegistrationEnd = @RegistrationEnd,
            UpdatedAt = GETDATE()
    WHEN NOT MATCHED THEN
        INSERT (ApplicationId, SebiRegNumber, EntityName, RegistrationType, RegistrationStart, RegistrationEnd, CreatedAt, UpdatedAt)
        VALUES (@ApplicationId, @SebiRegNumber, @EntityName, @RegistrationType, @RegistrationStart, @RegistrationEnd, GETDATE(), GETDATE());
END;

CREATE PROCEDURE nsdl.sp_Upsert_HasPan
    @ApplicationId INT,
    @HasPanRadio BIT,
    @HasPanNumber NVARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;

    MERGE INTO nsdl.draft_HasPan AS target
    USING (SELECT @ApplicationId AS ApplicationId) AS source
    ON target.ApplicationId = source.ApplicationId
    WHEN MATCHED THEN
        UPDATE SET 
            HasPanRadio = @HasPanRadio,
            HasPanNumber = @HasPanNumber,
            UpdatedAt = GETDATE()
    WHEN NOT MATCHED THEN
        INSERT (ApplicationId, HasPanRadio, HasPanNumber, CreatedAt, UpdatedAt)
        VALUES (@ApplicationId, @HasPanRadio, @HasPanNumber, GETDATE(), GETDATE());
END;

CREATE PROCEDURE nsdl.sp_Upsert_DisciplinaryHistory
    @ApplicationId varchar(255),
    @DisciplinaryHistoryRadio BIT,
    @DisciplinaryHistoryText NVARCHAR(1000)
AS
BEGIN
    SET NOCOUNT ON;

    MERGE INTO nsdl.draft_DisciplinaryHistory AS target
    USING (SELECT @ApplicationId AS ApplicationId) AS source
    ON target.ApplicationId = source.ApplicationId
    WHEN MATCHED THEN
        UPDATE SET 
            DisciplinaryHistoryRadio = @DisciplinaryHistoryRadio,
            DisciplinaryHistoryText = @DisciplinaryHistoryText,
            UpdatedAt = GETDATE()
    WHEN NOT MATCHED THEN
        INSERT (ApplicationId, DisciplinaryHistoryRadio, DisciplinaryHistoryText, CreatedAt, UpdatedAt)
        VALUES (@ApplicationId, @DisciplinaryHistoryRadio, @DisciplinaryHistoryText, GETDATE(), GETDATE());
END;

CREATE PROCEDURE nsdl.sp_Upsert_DdpInfo
    @ApplicationId varchar(255),
    @Name NVARCHAR(255),
    @Value INT,
    @RegistrationNumber NVARCHAR(255),
    @DdpId INT
AS
BEGIN
    SET NOCOUNT ON;

    MERGE INTO nsdl.draft_DdpInfo AS target
    USING (SELECT @ApplicationId AS ApplicationId) AS source
    ON target.ApplicationId = source.ApplicationId
    WHEN MATCHED THEN
        UPDATE SET 
            Name = @Name,
            Value = @Value,
            RegistrationNumber = @RegistrationNumber,
            DdpId = @DdpId,
            UpdatedAt = GETDATE()
    WHEN NOT MATCHED THEN
        INSERT (ApplicationId, Name, Value, RegistrationNumber, DdpId, CreatedAt, UpdatedAt)
        VALUES (@ApplicationId, @Name, @Value, @RegistrationNumber, @DdpId, GETDATE(), GETDATE());
END;

CREATE PROCEDURE nsdl.sp_Upsert_DpInfo
    @ApplicationId varchar(255),
    @Name NVARCHAR(255),
    @Value INT,
    @RegistrationNumber NVARCHAR(255),
    @DdpId INT
AS
BEGIN
    SET NOCOUNT ON;

    MERGE INTO nsdl.draft_DpInfo AS target
    USING (SELECT @ApplicationId AS ApplicationId) AS source
    ON target.ApplicationId = source.ApplicationId
    WHEN MATCHED THEN
        UPDATE SET 
            Name = @Name,
            Value = @Value,
            RegistrationNumber = @RegistrationNumber,
            DdpId = @DdpId,
            UpdatedAt = GETDATE()
    WHEN NOT MATCHED THEN
        INSERT (ApplicationId, Name, Value, RegistrationNumber, DdpId, CreatedAt, UpdatedAt)
        VALUES (@ApplicationId, @Name, @Value, @RegistrationNumber, @DdpId, GETDATE(), GETDATE());
END
;

CREATE PROCEDURE nsdl.sp_Upsert_CustodianInfo
    @ApplicationId varchar(255),
    @Name NVARCHAR(255),
    @Value INT,
    @RegistrationNumber NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    MERGE INTO nsdl.draft_CustodianInfo AS target
    USING (SELECT @ApplicationId AS ApplicationId) AS source
    ON target.ApplicationId = source.ApplicationId
    WHEN MATCHED THEN
        UPDATE SET 
            Name = @Name,
            Value = @Value,
            RegistrationNumber = @RegistrationNumber,
            UpdatedAt = GETDATE()
    WHEN NOT MATCHED THEN
        INSERT (ApplicationId, Name, Value, RegistrationNumber, CreatedAt, UpdatedAt)
        VALUES (@ApplicationId, @Name, @Value, @RegistrationNumber, GETDATE(), GETDATE());
END;

CREATE PROCEDURE nsdl.sp_UpsertDeclarationAndUndertaking
    @ApplicationId INT,
    @Name NVARCHAR(255),
    @Capacity NVARCHAR(255),
    @Place NVARCHAR(255),
    @Date DATETIME,
    @NameOfSignatory NVARCHAR(255),
    @DesignationOfSignatory NVARCHAR(255),
    @DateOfSignature DATETIME NULL,
    @Signature VARBINARY(MAX) NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM nsdl.draft_DeclarationAndUndertakingForm WHERE ApplicationId = @ApplicationId)
    BEGIN
        -- Update existing record
        UPDATE nsdl.draft_DeclarationAndUndertakingForm
        SET 
            Name = @Name,
            Capacity = @Capacity,
            Place = @Place,
            Date = @Date,
            NameOfSignatory = @NameOfSignatory,
            DesignationOfSignatory = @DesignationOfSignatory,
            DateOfSignature = @DateOfSignature,
            Signature = @Signature
        WHERE ApplicationId = @ApplicationId;
    END
    ELSE
    BEGIN
        -- Insert new record
        INSERT INTO nsdl.draft_DeclarationAndUndertakingForm 
        (ApplicationId, Name, Capacity, Place, Date, NameOfSignatory, DesignationOfSignatory, DateOfSignature, Signature)
        VALUES 
        (@ApplicationId, @Name, @Capacity, @Place, @Date, @NameOfSignatory, @DesignationOfSignatory, @DateOfSignature, @Signature);
    END
END;





CREATE PROCEDURE nsdl.UpsertDraftAnextureForm
    @ApplicationId VARCHAR(255),
    @IntermediateMaterial BIT,
    @EntityHolding INT,
    @NoEntityHolding INT,
    @BeneficialOwnership BIT
AS
BEGIN
    SET NOCOUNT ON;

    MERGE nsdl.draft_AnextureForm AS Target
    USING (
        SELECT 
            @ApplicationId AS ApplicationId,
            @IntermediateMaterial AS IntermediateMaterial,
            @EntityHolding AS EntityHolding,
            @NoEntityHolding AS NoEntityHolding,
            @BeneficialOwnership AS BeneficialOwnership
    ) AS Source
    ON Target.ApplicationId = Source.ApplicationId
    WHEN MATCHED THEN
        UPDATE SET 
            IntermediateMaterial = Source.IntermediateMaterial,
            EntityHolding = Source.EntityHolding,
            NoEntityHolding = Source.NoEntityHolding,
            BeneficialOwnership = Source.BeneficialOwnership,
            UpdatedAt = GETDATE()
    WHEN NOT MATCHED THEN
        INSERT (ApplicationId, IntermediateMaterial, EntityHolding, NoEntityHolding, BeneficialOwnership, CreatedAt, UpdatedAt)
        VALUES (Source.ApplicationId, Source.IntermediateMaterial, Source.EntityHolding, Source.NoEntityHolding, Source.BeneficialOwnership, GETDATE(), GETDATE());
END;
CREATE PROCEDURE nsdl.UpsertSegregatedPortfolio
    @ApplicationId VARCHAR(255),
    @SeggregatedPortfolioRadio BIT,
    @SeggregatedPortfolioText VARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;

    MERGE INTO nsdl.draft_SegregatedPortfolio AS Target
    USING (
        SELECT 
            @ApplicationId AS ApplicationId,
            @SeggregatedPortfolioRadio AS SeggregatedPortfolioRadio,
            @SeggregatedPortfolioText AS SeggregatedPortfolioText
    ) AS Source
    ON Target.ApplicationId = Source.ApplicationId
    WHEN MATCHED THEN
        UPDATE SET 
            SeggregatedPortfolioRadio = Source.SeggregatedPortfolioRadio,
            SeggregatedPortfolioText = Source.SeggregatedPortfolioText,
            UpdatedAt = GETDATE()
    WHEN NOT MATCHED THEN
        INSERT (ApplicationId, SeggregatedPortfolioRadio, SeggregatedPortfolioText, CreatedAt, UpdatedAt)
        VALUES (Source.ApplicationId, Source.SeggregatedPortfolioRadio, Source.SeggregatedPortfolioText, GETDATE(), GETDATE());
END;

CREATE PROCEDURE nsdl.UpsertBankDeclaration
    @ApplicationId VARCHAR(255),
    @BankDeclarationRadio VARCHAR(50),
    @BankDeclarationText VARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;

    MERGE INTO nsdl.draft_BankDeclaration AS Target
    USING (
        SELECT 
            @ApplicationId AS ApplicationId,
            @BankDeclarationRadio AS BankDeclarationRadio,
            @BankDeclarationText AS BankDeclarationText
    ) AS Source
    ON Target.ApplicationId = Source.ApplicationId
    WHEN MATCHED THEN
        UPDATE SET 
            BankDeclarationRadio = Source.BankDeclarationRadio,
            BankDeclarationText = Source.BankDeclarationText,
            UpdatedAt = GETDATE()
    WHEN NOT MATCHED THEN
        INSERT (ApplicationId, BankDeclarationRadio, BankDeclarationText, CreatedAt, UpdatedAt)
        VALUES (Source.ApplicationId, Source.BankDeclarationRadio, Source.BankDeclarationText, GETDATE(), GETDATE());
END;
CREATE PROCEDURE nsdl.UpsertConsentIntermediary
    @ApplicationId VARCHAR(255),
    @ConsentIntermediaryRadio BIT,
    @ConsentIntermediaryName VARCHAR(255),
    @ConsentIntermediaryEmail1 VARCHAR(255),
    @ConsentIntermediaryEmail2 VARCHAR(255),
    @ConsentIntermediaryEmail3 VARCHAR(255),
    @ConsentIntermediaryMobile VARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;

    MERGE INTO nsdl.draft_ConsentIntermediary AS Target
    USING (
        SELECT 
            @ApplicationId AS ApplicationId,
            @ConsentIntermediaryRadio AS ConsentIntermediaryRadio,
            @ConsentIntermediaryName AS ConsentIntermediaryName,
            @ConsentIntermediaryEmail1 AS ConsentIntermediaryEmail1,
            @ConsentIntermediaryEmail2 AS ConsentIntermediaryEmail2,
            @ConsentIntermediaryEmail3 AS ConsentIntermediaryEmail3,
            @ConsentIntermediaryMobile AS ConsentIntermediaryMobile
    ) AS Source
    ON Target.ApplicationId = Source.ApplicationId
    WHEN MATCHED THEN
        UPDATE SET 
            ConsentIntermediaryRadio = Source.ConsentIntermediaryRadio,
            ConsentIntermediaryName = Source.ConsentIntermediaryName,
            ConsentIntermediaryEmail1 = Source.ConsentIntermediaryEmail1,
            ConsentIntermediaryEmail2 = Source.ConsentIntermediaryEmail2,
            ConsentIntermediaryEmail3 = Source.ConsentIntermediaryEmail3,
            ConsentIntermediaryMobile = Source.ConsentIntermediaryMobile,
            UpdatedAt = GETDATE()
    WHEN NOT MATCHED THEN
        INSERT (ApplicationId, ConsentIntermediaryRadio, ConsentIntermediaryName, ConsentIntermediaryEmail1, 
                ConsentIntermediaryEmail2, ConsentIntermediaryEmail3, ConsentIntermediaryMobile, CreatedAt, UpdatedAt)
        VALUES (Source.ApplicationId, Source.ConsentIntermediaryRadio, Source.ConsentIntermediaryName, 
                Source.ConsentIntermediaryEmail1, Source.ConsentIntermediaryEmail2, Source.ConsentIntermediaryEmail3, 
                Source.ConsentIntermediaryMobile, GETDATE(), GETDATE());
END;
CREATE PROCEDURE nsdl.UpsertInformationOfSaSmFvciApplicant
    @ApplicationId VARCHAR(255),
    @Name VARCHAR(255),
    @RelationWithApplicant VARCHAR(255),
    @Pan VARCHAR(10),
    @NationalityCode VARCHAR(10),
    @DateOfBirth DATE,
    @ResidentialAddress VARCHAR(500),
    @IdentityDocNumber VARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;

    -- If Id is provided, try to update; otherwise, insert a new record
    MERGE INTO nsdl.draft_InformationOfSaSmFvciApplicant AS Target
    USING (
        SELECT 
            @ApplicationId AS ApplicationId, 
            @Name AS Name, 
            @RelationWithApplicant AS RelationWithApplicant, 
            @Pan AS Pan, 
            @NationalityCode AS NationalityCode, 
            @DateOfBirth AS DateOfBirth, 
            @ResidentialAddress AS ResidentialAddress, 
            @IdentityDocNumber AS IdentityDocNumber
    ) AS Source
    ON Target.ApplicationId = Source.ApplicationId and Target.Name = SOURCE.Name
    WHEN MATCHED THEN
        UPDATE SET 
            Name = Source.Name,
            RelationWithApplicant = Source.RelationWithApplicant,
            Pan = Source.Pan,
            NationalityCode = Source.NationalityCode,
            DateOfBirth = Source.DateOfBirth,
            ResidentialAddress = Source.ResidentialAddress,
            IdentityDocNumber = Source.IdentityDocNumber,
            UpdatedAt = GETDATE()
    WHEN NOT MATCHED THEN
        INSERT (ApplicationId, Name, RelationWithApplicant, Pan, NationalityCode, DateOfBirth, ResidentialAddress, IdentityDocNumber, CreatedAt, UpdatedAt)
        VALUES (Source.ApplicationId, Source.Name, Source.RelationWithApplicant, Source.Pan, Source.NationalityCode, Source.DateOfBirth, Source.ResidentialAddress, Source.IdentityDocNumber, GETDATE(), GETDATE());
END;
CREATE PROCEDURE nsdl.UpsertSignatory
    @ApplicationId VARCHAR(255),
    @Details VARCHAR(500),
    @SignatoryId INT OUTPUT  -- Output parameter to return the generated Id
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @ExistingId INT;

    -- Check if the record already exists
    SELECT @ExistingId = Id 
    FROM nsdl.draft_Signatory 
    WHERE ApplicationId = @ApplicationId AND Details = @Details;

    -- If exists, update and return existing Id
    IF @ExistingId IS NOT NULL
    BEGIN
        UPDATE nsdl.draft_Signatory
        SET UpdatedAt = GETDATE()
        WHERE Id = @ExistingId;

        SET @SignatoryId = @ExistingId;
    END
    ELSE
    BEGIN
        -- Insert a new record and return new SignatoryId
        INSERT INTO nsdl.draft_Signatory (ApplicationId, Details, CreatedAt, UpdatedAt)
        VALUES (@ApplicationId, @Details, GETDATE(), GETDATE());

        SET @SignatoryId = SCOPE_IDENTITY();
    END
END;
CREATE PROCEDURE nsdl.UpsertOwnerDetails
    @SignatoryId INT,
    @NameAddressOfBo VARCHAR(255),
    @DateOfBirthOfBo DATE,
    @TaxResidencyJuridictionCode VARCHAR(10),
    @NationalityCode VARCHAR(10),
    @ActingAloneOrMoreNaturalPerson VARCHAR(50),
    @BoGroupPercentageShareHolding VARCHAR(10),
    @IdentityDocument VARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;

    -- Match based on SignatoryId and NameAddressOfBo
    MERGE INTO nsdl.draft_OwnerDetails AS Target
    USING (
        SELECT 
            @SignatoryId AS SignatoryId, 
            @NameAddressOfBo AS NameAddressOfBo, 
            @DateOfBirthOfBo AS DateOfBirthOfBo, 
            @TaxResidencyJuridictionCode AS TaxResidencyJuridictionCode, 
            @NationalityCode AS NationalityCode, 
            @ActingAloneOrMoreNaturalPerson AS ActingAloneOrMoreNaturalPerson, 
            @BoGroupPercentageShareHolding AS BoGroupPercentageShareHolding, 
            @IdentityDocument AS IdentityDocument
    ) AS Source
    ON Target.SignatoryId = Source.SignatoryId AND Target.NameAddressOfBo = Source.NameAddressOfBo
    WHEN MATCHED THEN
        UPDATE SET 
            DateOfBirthOfBo = Source.DateOfBirthOfBo,
            TaxResidencyJuridictionCode = Source.TaxResidencyJuridictionCode,
            NationalityCode = Source.NationalityCode,
            ActingAloneOrMoreNaturalPerson = Source.ActingAloneOrMoreNaturalPerson,
            BoGroupPercentageShareHolding = Source.BoGroupPercentageShareHolding,
            IdentityDocument = Source.IdentityDocument,
            UpdatedAt = GETDATE()
    WHEN NOT MATCHED THEN
        INSERT (SignatoryId, NameAddressOfBo, DateOfBirthOfBo, TaxResidencyJuridictionCode, NationalityCode, 
                ActingAloneOrMoreNaturalPerson, BoGroupPercentageShareHolding, IdentityDocument, CreatedAt, UpdatedAt)
        VALUES (Source.SignatoryId, Source.NameAddressOfBo, Source.DateOfBirthOfBo, Source.TaxResidencyJuridictionCode, 
                Source.NationalityCode, Source.ActingAloneOrMoreNaturalPerson, Source.BoGroupPercentageShareHolding, 
                Source.IdentityDocument, GETDATE(), GETDATE());
END;
CREATE PROCEDURE nsdl.UpsertMaterialShareholder
    @ApplicationId VARCHAR(255),
    @NameOfBeneficialOwner VARCHAR(255),
    @DirectIndirectStake VARCHAR(255),
    @NameOfEntities VARCHAR(255),
    @CountryOfIncorporationOrNationalityCode VARCHAR(10),
    @PercentageStakeHeld INT,
    @IndividualOrNonIndividual VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    MERGE INTO nsdl.draft_MaterialShareholder AS Target
    USING (
        SELECT 
            @ApplicationId AS ApplicationId,
            @NameOfBeneficialOwner AS NameOfBeneficialOwner,
            @DirectIndirectStake AS DirectIndirectStake,
            @NameOfEntities AS NameOfEntities,
            @CountryOfIncorporationOrNationalityCode AS CountryOfIncorporationOrNationalityCode,
            @PercentageStakeHeld AS PercentageStakeHeld,
            @IndividualOrNonIndividual AS IndividualOrNonIndividual
    ) AS Source
    ON Target.ApplicationId = Source.ApplicationId 
       AND Target.NameOfBeneficialOwner = Source.NameOfBeneficialOwner
    WHEN MATCHED THEN
        UPDATE SET 
            DirectIndirectStake = Source.DirectIndirectStake,
            NameOfEntities = Source.NameOfEntities,
            CountryOfIncorporationOrNationalityCode = Source.CountryOfIncorporationOrNationalityCode,
            PercentageStakeHeld = Source.PercentageStakeHeld,
            IndividualOrNonIndividual = Source.IndividualOrNonIndividual,
            UpdatedAt = GETDATE()
    WHEN NOT MATCHED THEN
        INSERT (ApplicationId, NameOfBeneficialOwner, DirectIndirectStake, NameOfEntities, 
                CountryOfIncorporationOrNationalityCode, PercentageStakeHeld, IndividualOrNonIndividual, CreatedAt, UpdatedAt)
        VALUES (Source.ApplicationId, Source.NameOfBeneficialOwner, Source.DirectIndirectStake, Source.NameOfEntities, 
                Source.CountryOfIncorporationOrNationalityCode, Source.PercentageStakeHeld, Source.IndividualOrNonIndividual, GETDATE(), GETDATE());
END;
CREATE PROCEDURE nsdl.UpsertBeneficialOwners
    @ApplicationId VARCHAR(255),
    @NameOfBeneficialOwner VARCHAR(255),
    @MethodOfControl VARCHAR(255),
    @CountryOfIncorporationCode VARCHAR(10),
    @PercentageStakeHeld INT,
    @IndividualOrNonIndividual VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    MERGE INTO nsdl.draft_BeneficialOwners AS Target
    USING (
        SELECT 
            @ApplicationId AS ApplicationId,
            @NameOfBeneficialOwner AS NameOfBeneficialOwner,
            @MethodOfControl AS MethodOfControl,
            @CountryOfIncorporationCode AS CountryOfIncorporationCode,
            @PercentageStakeHeld AS PercentageStakeHeld,
            @IndividualOrNonIndividual AS IndividualOrNonIndividual
    ) AS Source
    ON Target.ApplicationId = Source.ApplicationId 
       AND Target.NameOfBeneficialOwner = Source.NameOfBeneficialOwner
    WHEN MATCHED THEN
        UPDATE SET 
            MethodOfControl = Source.MethodOfControl,
            CountryOfIncorporationCode = Source.CountryOfIncorporationCode,
            PercentageStakeHeld = Source.PercentageStakeHeld,
            IndividualOrNonIndividual = Source.IndividualOrNonIndividual,
            UpdatedAt = GETDATE()
    WHEN NOT MATCHED THEN
        INSERT (ApplicationId, NameOfBeneficialOwner, MethodOfControl, CountryOfIncorporationCode, 
                PercentageStakeHeld, IndividualOrNonIndividual, CreatedAt, UpdatedAt)
        VALUES (Source.ApplicationId, Source.NameOfBeneficialOwner, Source.MethodOfControl, Source.CountryOfIncorporationCode, 
                Source.PercentageStakeHeld, Source.IndividualOrNonIndividual, GETDATE(), GETDATE());
END;
CREATE PROCEDURE nsdl.UpsertManagers
    @ApplicationId VARCHAR(255),
    @NameOfEntity VARCHAR(255),
    @TypeOfEntity VARCHAR(255),
    @CountryCode VARCHAR(10),
    @TelephoneNumber VARCHAR(50),
    @FaxNumber VARCHAR(50),
    @EmailId VARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;

    MERGE INTO nsdl.draft_Managers AS Target
    USING (
        SELECT 
            @ApplicationId AS ApplicationId,
            @NameOfEntity AS NameOfEntity,
            @TypeOfEntity AS TypeOfEntity,
            @CountryCode AS CountryCode,
            @TelephoneNumber AS TelephoneNumber,
            @FaxNumber AS FaxNumber,
            @EmailId AS EmailId
    ) AS Source
    ON Target.ApplicationId = Source.ApplicationId 
       AND Target.NameOfEntity = Source.NameOfEntity
    WHEN MATCHED THEN
        UPDATE SET 
            TypeOfEntity = Source.TypeOfEntity,
            CountryCode = Source.CountryCode,
            TelephoneNumber = Source.TelephoneNumber,
            FaxNumber = Source.FaxNumber,
            EmailId = Source.EmailId,
            UpdatedAt = GETDATE()
    WHEN NOT MATCHED THEN
        INSERT (ApplicationId, NameOfEntity, TypeOfEntity, CountryCode, 
                TelephoneNumber, FaxNumber, EmailId, CreatedAt, UpdatedAt)
        VALUES (Source.ApplicationId, Source.NameOfEntity, Source.TypeOfEntity, Source.CountryCode, 
                Source.TelephoneNumber, Source.FaxNumber, Source.EmailId, GETDATE(), GETDATE());
END;


CREATE PROCEDURE nsdl.sp_InsertFromDraft
    @ApplicationId NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    -- Insert data from draft_fvci_applications to main table
    INSERT INTO nsdl.fvci_applications (user_id, application_id, fvci_registration_number, created_at, updated_at, status)
    SELECT user_id, application_id, fvci_registration_number, created_at, updated_at, status
    FROM nsdl.draft_fvci_applications WHERE application_id = @ApplicationId;

    -- Insert data from draft_Ekyc to main table
    INSERT INTO nsdl.Ekyc (ApplicationId, Name, DateOfIncorporation, DateOfCommencement, PlaceOfIncorporation, CountryOfIncorporation, 
                                      CountryCodeOfIncorporation, LegalForm, LEI, SameAsAbove, CommunicationAddress, UltimateBeneficialOwner, 
                                      UltimateBeneficialOwnerHolding, BeneficialOwnership, ProofOfIdentity, ProofOfAddress, [Date], TypeOfEntity, 
                                      SelectedCity, PoliticallyExposed, RelatedToPoliticallyExposed, CreatedAt, UpdatedAt)
    SELECT ApplicationId, Name, DateOfIncorporation, DateOfCommencement, PlaceOfIncorporation, CountryOfIncorporation, 
           CountryCodeOfIncorporation, LegalForm, LEI, SameAsAbove, CommunicationAddress, UltimateBeneficialOwner, 
           UltimateBeneficialOwnerHolding, BeneficialOwnership, ProofOfIdentity, ProofOfAddress, [Date], TypeOfEntity, 
           SelectedCity, PoliticallyExposed, RelatedToPoliticallyExposed, CreatedAt, UpdatedAt
    FROM nsdl.draft_Ekyc WHERE ApplicationId = @ApplicationId;

    -- Insert data from draft_ApplicantOtherName to main table
    INSERT INTO nsdl.ApplicantOtherName (ApplicationId, OtherNameRadio, OtherNameField, CreatedAt, UpdatedAt)
    SELECT ApplicationId, OtherNameRadio, OtherNameField, CreatedAt, UpdatedAt
    FROM nsdl.draft_ApplicantOtherName WHERE ApplicationId = @ApplicationId;

    -- Insert data from draft_ApplicantType to main table
    INSERT INTO nsdl.ApplicantType (ApplicationId, ApplicantTypeName, ApplicantTypeOtherEntity, CreatedAt, UpdatedAt)
    SELECT ApplicationId, ApplicantTypeName, ApplicantTypeOtherEntity, CreatedAt, UpdatedAt
    FROM nsdl.draft_ApplicantType WHERE ApplicationId = @ApplicationId;

    -- Insert data from draft_ComplianceOfficerInfo to main table
    INSERT INTO nsdl.ComplianceOfficerInfo (ApplicationId, ComplianceOfficerInfoName, ComplianceOfficerInfoJob, ComplianceOfficerInfoMobile, 
                                                       ComplianceOfficerInfoFax, ComplianceOfficerInfoEmail, CreatedAt, UpdatedAt)
    SELECT ApplicationId, ComplianceOfficerInfoName, ComplianceOfficerInfoJob, ComplianceOfficerInfoMobile, 
           ComplianceOfficerInfoFax, ComplianceOfficerInfoEmail, CreatedAt, UpdatedAt
    FROM nsdl.draft_ComplianceOfficerInfo WHERE ApplicationId = @ApplicationId;

    -- Insert data from draft_ContactDetails to main table
    INSERT INTO nsdl.ContactDetails (ApplicationId, MobileNumber, EmailId, Website, CreatedAt, UpdatedAt)
    SELECT ApplicationId, MobileNumber, EmailId, Website, CreatedAt, UpdatedAt
    FROM nsdl.draft_ContactDetails WHERE ApplicationId = @ApplicationId;

    -- Insert data from draft_ContactInfo to main table
    INSERT INTO nsdl.ContactInfo (ApplicationId, [Type], CountryCode, AreaCode, Number, CreatedAt, UpdatedAt)
    SELECT ApplicationId, [Type], CountryCode, AreaCode, Number, CreatedAt, UpdatedAt
    FROM nsdl.draft_ContactInfo WHERE ApplicationId = @ApplicationId;

    -- Insert data from draft_IncomeDetails to main table
    INSERT INTO nsdl.IncomeDetails (ApplicationId, BusinessCode, AnnualIncome, AssetLess, AsOnDate, CreatedAt, UpdatedAt)
    SELECT ApplicationId, BusinessCode, AnnualIncome, AssetLess, AsOnDate, CreatedAt, UpdatedAt
    FROM nsdl.draft_IncomeDetails WHERE ApplicationId = @ApplicationId;

    -- Insert data from draft_IncomeSource to main table
    INSERT INTO nsdl.IncomeSource (ApplicationId, IncomeSourceType, CreatedAt)
    SELECT ApplicationId, IncomeSourceType, CreatedAt
    FROM nsdl.draft_IncomeSource WHERE ApplicationId = @ApplicationId;

    -- Insert data from draft_ForeignOffice to main table
    INSERT INTO nsdl.ForeignOffice (ApplicationId, ForeignFlatNum, ForeignBuildingName, ForeignCountryCode, ForeignRoadName, 
                                               ForeignAreaName, ForeignTownName, ForeignZipName, ForeignStateName, NotApplicableForeignOffice, 
                                               CreatedAt, UpdatedAt)
    SELECT ApplicationId, ForeignFlatNum, ForeignBuildingName, ForeignCountryCode, ForeignRoadName, 
           ForeignAreaName, ForeignTownName, ForeignZipName, ForeignStateName, NotApplicableForeignOffice, 
           CreatedAt, UpdatedAt
    FROM nsdl.draft_ForeignOffice WHERE ApplicationId = @ApplicationId;

    -- Insert data from draft_ManagingOfficial to main table
    INSERT INTO nsdl.ManagingOfficial (ApplicationId, GovernmentIdNumber, NameAndAddress, DateOfBirth, TaxResidencyJurisdiction, 
                                                  Nationality, ActingAsGroupDetails, BoGroupShareholding, CreatedAt, UpdatedAt)
    SELECT ApplicationId, GovernmentIdNumber, NameAndAddress, DateOfBirth, TaxResidencyJurisdiction, 
           Nationality, ActingAsGroupDetails, BoGroupShareholding, CreatedAt, UpdatedAt
    FROM nsdl.draft_ManagingOfficial WHERE ApplicationId = @ApplicationId;

    -- Insert data from draft_OfficeInIndia to main table
    INSERT INTO nsdl.OfficeInIndia (ApplicationId, OfficeInIndiaRadio, IndianFlatNum, IndianBuildingName, IndianCountryCode, 
                                               IndianRoadName, IndianAreaName, IndianTownName, IndianZipName, IndianStateName, 
                                               NotApplicableIndOffice, CreatedAt, UpdatedAt)
    SELECT ApplicationId, OfficeInIndiaRadio, IndianFlatNum, IndianBuildingName, IndianCountryCode, 
           IndianRoadName, IndianAreaName, IndianTownName, IndianZipName, IndianStateName, 
           NotApplicableIndOffice, CreatedAt, UpdatedAt
    FROM nsdl.draft_OfficeInIndia WHERE ApplicationId = @ApplicationId;

    -- Insert data from draft_RegisteredOffice to main table
    INSERT INTO nsdl.RegisteredOffice (ApplicationId, RegisteredFlatNum, RegisteredBuildingName, RegisteredCountryCode, 
                                                  RegisteredRoadName, RegisteredAreaName, RegisteredTownName, RegisteredZipName, 
                                                  RegisteredStateName, NotApplicableResidence, CreatedAt, UpdatedAt)
    SELECT ApplicationId, RegisteredFlatNum, RegisteredBuildingName, RegisteredCountryCode, 
           RegisteredRoadName, RegisteredAreaName, RegisteredTownName, RegisteredZipName, 
           RegisteredStateName, NotApplicableResidence, CreatedAt, UpdatedAt
    FROM nsdl.draft_RegisteredOffice WHERE ApplicationId = @ApplicationId;

    INSERT INTO nsdl.TaxResidency (ApplicationId, TRCNo, CountryCode, CreatedAt, UpdatedAt)
    SELECT ApplicationId, TRCNo, CountryCode, CreatedAt, UpdatedAt
    FROM nsdl.draft_TaxResidency WHERE ApplicationId = @ApplicationId;
   
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
	
	INSERT INTO nsdl.DeclarationAndUndertakingForm (
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
	FROM nsdl.draft_DeclarationAndUndertakingForm
	WHERE ApplicationId = @ApplicationId;

	insert into nsdl.InvestmentManager(ApplicationId, NameOfEntity, TypeOfEntity, CountryCode, TelephoneNumber, FaxNumber, EmailId, CreatedAt, UpdatedAt)
	SELECT ApplicationId, NameOfEntity, TypeOfEntity, CountryCode, TelephoneNumber, FaxNumber, EmailId, GETDATE(), GETDATE()
	FROM nsdl.draft_InvestmentManager WHERE ApplicationId = @ApplicationId;

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
	    s.Id, o.NameAddressOfBo, o.DateOfBirthOfBo, o.TaxResidencyJuridictionCode, o.NationalityCode, 
	    o.ActingAloneOrMoreNaturalPerson, o.BoGroupPercentageShareHolding, o.IdentityDocument, o.CreatedAt, o.UpdatedAt
	FROM 
	    nsdl.draft_OwnerDetails o
	inner join nsdl.Signatory s on s.ApplicationId  = @ApplicationId;

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




END;
ALTER PROCEDURE nsdl.SP_GetApplicationData
    @ApplicationId NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT * FROM nsdl.draft_Ekyc WHERE ApplicationId = @ApplicationId;
    SELECT * FROM nsdl.draft_ApplicantOtherName WHERE ApplicationId = @ApplicationId;
    SELECT * FROM nsdl.draft_ApplicantType WHERE ApplicationId = @ApplicationId;
    SELECT * FROM nsdl.draft_ComplianceOfficerInfo WHERE ApplicationId = @ApplicationId;
    SELECT * FROM nsdl.draft_ContactDetails WHERE ApplicationId = @ApplicationId;
    SELECT * FROM nsdl.draft_ContactInfo WHERE ApplicationId = @ApplicationId;
    SELECT * FROM nsdl.draft_IncomeDetails WHERE ApplicationId = @ApplicationId;
    SELECT * FROM nsdl.draft_IncomeSource WHERE ApplicationId = @ApplicationId;
    SELECT * FROM nsdl.draft_ForeignOffice WHERE ApplicationId = @ApplicationId;
    SELECT * FROM nsdl.draft_ManagingOfficial WHERE ApplicationId = @ApplicationId;
    SELECT * FROM nsdl.draft_OfficeInIndia WHERE ApplicationId = @ApplicationId;
    SELECT * FROM nsdl.draft_RegisteredOffice WHERE ApplicationId = @ApplicationId;
    SELECT * FROM nsdl.draft_TaxResidency WHERE ApplicationId = @ApplicationId;
   	SELECT user_id UserId, application_id ApplicationId,fvci_registration_number fvciRegistrationNumber ,status ,created_at createdAt ,updated_at updatedAt from nsdl.draft_fvci_applications dfa 
   	where application_id = @ApplicationId;
   	SELECT * from nsdl.draft_RegistrationForm WHERE ApplicationId = @ApplicationId;
   	SELECT * from nsdl.draft_CustodianInfo WHERE ApplicationId = @ApplicationId;
   	SELECT * from nsdl.draft_DdpInfo WHERE ApplicationId = @ApplicationId;
   	SELECT * from nsdl.draft_DesignatedBank WHERE ApplicationId = @ApplicationId;
   	SELECT * from nsdl.draft_DesignatedBankName WHERE ApplicationId = @ApplicationId;
   	SELECT * from nsdl.draft_DisciplinaryHistory WHERE ApplicationId = @ApplicationId;
   	SELECT * from nsdl.draft_DpInfo WHERE ApplicationId = @ApplicationId;
   	SELECT * from nsdl.draft_HasPan WHERE ApplicationId = @ApplicationId;
    SELECT * from nsdl.draft_PriorAssociation WHERE ApplicationId = @ApplicationId;
   	SELECT * from nsdl.draft_PriorAssociationRow WHERE ApplicationId = @ApplicationId;
   	SELECT * from nsdl.draft_ThroughGlobalCustodian WHERE ApplicationId = @ApplicationId;
   	SELECT * from nsdl.draft_DeclarationAndUndertakingForm WHERE ApplicationId = @ApplicationId;
   	SELECT * from nsdl.draft_AnextureForm daf WHERE ApplicationId = @ApplicationId;
   	select * from nsdl.draft_SegregatedPortfolio dsp where ApplicationId = @ApplicationId;
   	SELECT * from nsdl.draft_BankDeclaration dbd where ApplicationId = @ApplicationId;
	SELECT * from nsdl.draft_ConsentIntermediary dci where ApplicationId = @ApplicationId;
	SELECT * from nsdl.draft_InformationOfSaSmFvciApplicant diossfa where ApplicationId = @ApplicationId;
	SELECT * from nsdl.draft_MaterialShareholder dms where ApplicationId = @ApplicationId;
	SELECT * from nsdl.draft_BeneficialOwners dbo where ApplicationId = @ApplicationId;
	SELECT * from nsdl.draft_Managers dm where ApplicationId = @ApplicationId;
	SELECT ds.Details ,dod.* from nsdl.draft_Signatory ds INNER JOIN nsdl.draft_OwnerDetails dod on ds.ApplicationId = @ApplicationId;

END

CREATE PROCEDURE nsdl.UpdateDraftAnextureForm
    @ApplicationId VARCHAR(255),
    @IntermediateMaterial BIT,
    @EntityHolding INT,
    @NoEntityHolding INT,
    @BeneficialOwnership BIT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE nsdl.AnextureForm
    SET 
        IntermediateMaterial = @IntermediateMaterial,
        EntityHolding = @EntityHolding,
        NoEntityHolding = @NoEntityHolding,
        BeneficialOwnership = @BeneficialOwnership,
        UpdatedAt = GETDATE()
    WHERE ApplicationId = @ApplicationId;
END;
CREATE PROCEDURE nsdl.UpdateSegregatedPortfolio
    @ApplicationId VARCHAR(255),
    @SeggregatedPortfolioRadio BIT,
    @SeggregatedPortfolioText VARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE nsdl.SegregatedPortfolio
    SET 
        SeggregatedPortfolioRadio = @SeggregatedPortfolioRadio,
        SeggregatedPortfolioText = @SeggregatedPortfolioText,
        UpdatedAt = GETDATE()
    WHERE ApplicationId = @ApplicationId;
END;
CREATE PROCEDURE nsdl.UpdateBankDeclaration
    @ApplicationId VARCHAR(255),
    @BankDeclarationRadio VARCHAR(50),
    @BankDeclarationText VARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE nsdl.BankDeclaration
    SET 
        BankDeclarationRadio = @BankDeclarationRadio,
        BankDeclarationText = @BankDeclarationText,
        UpdatedAt = GETDATE()
    WHERE ApplicationId = @ApplicationId;
END;
CREATE PROCEDURE nsdl.UpdateConsentIntermediary
    @ApplicationId VARCHAR(255),
    @ConsentIntermediaryRadio BIT,
    @ConsentIntermediaryName VARCHAR(255),
    @ConsentIntermediaryEmail1 VARCHAR(255),
    @ConsentIntermediaryEmail2 VARCHAR(255),
    @ConsentIntermediaryEmail3 VARCHAR(255),
    @ConsentIntermediaryMobile VARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE nsdl.ConsentIntermediary
    SET 
        ConsentIntermediaryRadio = @ConsentIntermediaryRadio,
        ConsentIntermediaryName = @ConsentIntermediaryName,
        ConsentIntermediaryEmail1 = @ConsentIntermediaryEmail1,
        ConsentIntermediaryEmail2 = @ConsentIntermediaryEmail2,
        ConsentIntermediaryEmail3 = @ConsentIntermediaryEmail3,
        ConsentIntermediaryMobile = @ConsentIntermediaryMobile,
        UpdatedAt = GETDATE()
    WHERE ApplicationId = @ApplicationId;
END;
CREATE PROCEDURE nsdl.UpdateInformationOfSaSmFvciApplicant
    @ApplicationId VARCHAR(255),
    @Name VARCHAR(255),
    @RelationWithApplicant VARCHAR(255),
    @Pan VARCHAR(10),
    @NationalityCode VARCHAR(10),
    @DateOfBirth DATE,
    @ResidentialAddress VARCHAR(500),
    @IdentityDocNumber VARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE nsdl.InformationOfSaSmFvciApplicant
    SET 
        RelationWithApplicant = @RelationWithApplicant,
        Pan = @Pan,
        NationalityCode = @NationalityCode,
        DateOfBirth = @DateOfBirth,
        ResidentialAddress = @ResidentialAddress,
        IdentityDocNumber = @IdentityDocNumber,
        UpdatedAt = GETDATE()
    WHERE ApplicationId = @ApplicationId AND Name = @Name;
END;
CREATE PROCEDURE nsdl.UpdateSignatory
    @ApplicationId varchar(255),
    @Details VARCHAR(500)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE nsdl.Signatory
    SET 
        Details = @Details,
        UpdatedAt = GETDATE()
    WHERE ApplicationId = @ApplicationId;
END;
CREATE PROCEDURE nsdl.UpdateOwnerDetailsBySignatoryId
    @ApplicationId varchar(255),
    @DateOfBirthOfBo DATE,
    @TaxResidencyJuridictionCode VARCHAR(10),
    @NationalityCode VARCHAR(10),
    @ActingAloneOrMoreNaturalPerson VARCHAR(50),
    @BoGroupPercentageShareHolding VARCHAR(10),
    @IdentityDocument VARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE nsdl.OwnerDetails
    SET 
        DateOfBirthOfBo = @DateOfBirthOfBo,
        TaxResidencyJuridictionCode = @TaxResidencyJuridictionCode,
        NationalityCode = @NationalityCode,
        ActingAloneOrMoreNaturalPerson = @ActingAloneOrMoreNaturalPerson,
        BoGroupPercentageShareHolding = @BoGroupPercentageShareHolding,
        IdentityDocument = @IdentityDocument,
        UpdatedAt = GETDATE()
    WHERE SignatoryId = (select Id from nsdl.Signatory where ApplicationId = @ApplicationId);
END;
CREATE PROCEDURE nsdl.UpdateMaterialShareholder
    @ApplicationId VARCHAR(255),
    @NameOfBeneficialOwner VARCHAR(255),
    @DirectIndirectStake VARCHAR(255),
    @NameOfEntities VARCHAR(255),
    @CountryOfIncorporationOrNationalityCode VARCHAR(10),
    @PercentageStakeHeld INT,
    @IndividualOrNonIndividual VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE nsdl.MaterialShareholder
    SET 
        DirectIndirectStake = @DirectIndirectStake,
        NameOfEntities = @NameOfEntities,
        CountryOfIncorporationOrNationalityCode = @CountryOfIncorporationOrNationalityCode,
        PercentageStakeHeld = @PercentageStakeHeld,
        IndividualOrNonIndividual = @IndividualOrNonIndividual,
        UpdatedAt = GETDATE()
    WHERE ApplicationId = @ApplicationId 
          AND NameOfBeneficialOwner = @NameOfBeneficialOwner;
END;
CREATE PROCEDURE nsdl.UpdateBeneficialOwners
    @ApplicationId VARCHAR(255),
    @NameOfBeneficialOwner VARCHAR(255),
    @MethodOfControl VARCHAR(255),
    @CountryOfIncorporationCode VARCHAR(10),
    @PercentageStakeHeld INT,
    @IndividualOrNonIndividual VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE nsdl.BeneficialOwners
    SET 
        MethodOfControl = @MethodOfControl,
        CountryOfIncorporationCode = @CountryOfIncorporationCode,
        PercentageStakeHeld = @PercentageStakeHeld,
        IndividualOrNonIndividual = @IndividualOrNonIndividual,
        UpdatedAt = GETDATE()
    WHERE ApplicationId = @ApplicationId 
          AND NameOfBeneficialOwner = @NameOfBeneficialOwner;
END;
CREATE PROCEDURE nsdl.UpdateManagers
    @ApplicationId VARCHAR(255),
    @NameOfEntity VARCHAR(255),
    @TypeOfEntity VARCHAR(255),
    @CountryCode VARCHAR(10),
    @TelephoneNumber VARCHAR(50),
    @FaxNumber VARCHAR(50),
    @EmailId VARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE nsdl.Managers
    SET 
        TypeOfEntity = @TypeOfEntity,
        CountryCode = @CountryCode,
        TelephoneNumber = @TelephoneNumber,
        FaxNumber = @FaxNumber,
        EmailId = @EmailId,
        UpdatedAt = GETDATE()
    WHERE ApplicationId = @ApplicationId 
          AND NameOfEntity = @NameOfEntity;
END;
ALTER PROCEDURE SaveFvciApplication
                        @ApplicationId NVARCHAR(255) = NULL,
                        @UserId NVARCHAR(255),
                        @FvciRegistrationNumber NVARCHAR(255),
                        @CreatedAt DATETIME,
                        @UpdatedAt DATETIME,
                        @Status NVARCHAR(50),
                        @GeneratedApplicationId NVARCHAR(255) OUTPUT
                    AS
                    BEGIN
                        SET NOCOUNT ON;
                       	
                        DECLARE @ExistingApplicationId NVARCHAR(255);
                        DECLARE @InsertedApplicationId TABLE (application_id NVARCHAR(255));
                        -- Check if ApplicationId is provided and exists
                        IF @ApplicationId IS NOT NULL AND @ApplicationId <> ''
                        BEGIN
	                       
	                        delete from nsdl.draft_TaxResidency where ApplicationId = @ApplicationId;
		
							delete from nsdl.draft_ContactInfo where ApplicationId = @ApplicationId;
							
							delete from nsdl.draft_ManagingOfficial where ApplicationId = @ApplicationId;
							
							delete from nsdl.draft_IncomeDetails where ApplicationId = @ApplicationId;
							
							delete from nsdl.draft_IncomeSource where ApplicationId = @ApplicationId;
							
							delete from nsdl.draft_PriorAssociationRow where ApplicationId = @ApplicationId;
							
							delete from nsdl.draft_Signatory where ApplicationId = @ApplicationId;
							
							delete from nsdl.draft_MaterialShareholder where ApplicationId = @ApplicationId;
							
							delete from nsdl.draft_BeneficialOwners where ApplicationId = @ApplicationId;
							
							delete from nsdl.draft_Managers where ApplicationId = @ApplicationId;
	                       
                            SELECT @ExistingApplicationId = application_id
                            FROM nsdl.draft_fvci_applications
                            WHERE application_id = @ApplicationId;
                            IF @ExistingApplicationId IS NOT NULL
                            BEGIN
                                PRINT 'Updating existing application: ' + @ExistingApplicationId;
                                UPDATE nsdl.draft_fvci_applications
                                SET user_id = @UserId,
                                    updated_at = @UpdatedAt,
                                    status = 1
                                WHERE application_id = @ExistingApplicationId;
                                -- Return existing ApplicationId
                                SET @GeneratedApplicationId = @ExistingApplicationId;
                                PRINT 'Returning existing ApplicationId: ' + @GeneratedApplicationId;
                                RETURN;
                            END
                        END
                        -- Insert new record and store the generated ApplicationId in a table variable
                        PRINT 'Inserting new application...';
                        INSERT INTO nsdl.draft_fvci_applications (user_id, fvci_registration_number, created_at, updated_at, status)
                        OUTPUT INSERTED.application_id INTO @InsertedApplicationId
                        VALUES (@UserId, @FvciRegistrationNumber, @CreatedAt, @UpdatedAt, '1');
                        -- Retrieve the generated ApplicationId from the table variable
                        SELECT @GeneratedApplicationId = application_id FROM @InsertedApplicationId;
                        PRINT 'Inserted ApplicationId: ' + COALESCE(@GeneratedApplicationId, 'NULL');
                    END;
CREATE PROCEDURE nsdl.UpdateFvciApplication
@ApplicationId NVARCHAR(255),
                        @UserId NVARCHAR(255),
                        @FvciRegistrationNumber NVARCHAR(255),
                        @CreatedAt DATETIME,
                        @UpdatedAt DATETIME,
                        @Status NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    -- Check if the ApplicationId exists
    IF EXISTS (SELECT 1 FROM nsdl.fvci_applications WHERE application_id = @ApplicationId)
    BEGIN
		
		delete from nsdl.TaxResidency where ApplicationId = @ApplicationId;
		
		delete from nsdl.ContactInfo where ApplicationId = @ApplicationId;
		
		delete from nsdl.ManagingOfficial where ApplicationId = @ApplicationId;
		
		delete from nsdl.IncomeDetails where ApplicationId = @ApplicationId;
		
		delete from nsdl.IncomeSource where ApplicationId = @ApplicationId;
		
		delete from nsdl.PriorAssociationRow where ApplicationId = @ApplicationId;
		
		delete from nsdl.Signatory where ApplicationId = @ApplicationId;
		
		delete from nsdl.MaterialShareholder where ApplicationId = @ApplicationId;
		
		delete from nsdl.BeneficialOwners where ApplicationId = @ApplicationId;
		
		delete from nsdl.Managers where ApplicationId = @ApplicationId;
        UPDATE nsdl.fvci_applications
        SET user_id = @UserId,
            fvci_registration_number = @FvciRegistrationNumber,
            updated_at = @UpdatedAt,
            status = @Status
        WHERE application_id = @ApplicationId;
    END
    ELSE
    BEGIN
        PRINT 'ApplicationId does not exist: ' + @ApplicationId;
    END
END;



ALTER PROCEDURE SP_GetMasterTables
    @Type VARCHAR(50) = '' -- Default to empty string for all tables
AS
BEGIN
    SET NOCOUNT ON;

    IF @Type = '' OR @Type = 'ATS'
    BEGIN
        SELECT * FROM [nsdl].[ATS_MSTR_TBL];
    END

    IF @Type = '' OR @Type = 'bank'
    BEGIN
        SELECT BKM_ID bank_id,BKM_Bnk_Id bank_code,BKM_Bnk_Nm bank_name,BKM_Crt_DTM created_dtm,BKM_Upd_DTM modified_dtm, CONCAT(' ', BKM_Addr_Ln_1,BKM_Addr_Ln_2,BKM_Addr_Ln_3,BKM_Addr_Ln_4,BKM_Pin_Cd, BKM_Pin_Cd) as  address FROM [nsdl].[Bnk_Mstr];
    END

    IF @Type = '' OR @Type = 'CAFApplicantStatus'
    BEGIN
        SELECT * FROM [nsdl].[CAF_Applicant_Status_MSTR];
    END

    IF @Type = '' OR @Type = 'CAFMasterApplicantStatus'
    BEGIN
        SELECT * FROM [nsdl].[CAF_MASTER_APPLICANT_STATUS];
    END

    IF @Type = '' OR @Type = 'CAFMasterBusProf'
    BEGIN
        SELECT * FROM [nsdl].[CAF_MASTER_BUS_PROF];
    END

    IF @Type = '' OR @Type = 'proof_of_address'
    BEGIN
        SELECT POA_DOC_CD code,POA_DOC_NM name FROM [nsdl].[CAF_MASTER_POA_DOC];
    END

    IF @Type = '' OR @Type = 'proof_of_identity'
    BEGIN
        SELECT POI_DOC_CD code,POI_DOC_NM name FROM [nsdl].[CAF_MASTER_POI_DOC];
    END

    IF @Type = '' OR @Type = 'source_of_income'
    BEGIN
        SELECT SRC_INCOMECD code,SRC_INCOME_NM name FROM [nsdl].[CAF_MASTER_SOI];
    END

    IF @Type = '' OR @Type = 'country' -- or CountryCodeFinal depending on which one is correct.
    BEGIN
        SELECT RMC_SRNo country_id, RMC_CODE_NAME country_name, RMC_CODE_ISDCODE country_code, RMC_CODE_ID country_short_code, RMC_CRT_DT created_dtm,RMC_UPDT_DT modified_dtm FROM [nsdl].[Country_Code_Master]; -- or Country_Code_Master depending on the correct table name.
    END
    
    IF @Type = '' OR @Type = 'country_pan' -- or CountryCodeFinal depending on which one is correct.
    BEGIN
        SELECT  COUNTRY_Name country_name, COUNTRY_ID country_code, Country_CODE country_short_code, Country_ISD country_isd_code FROM [nsdl].[country_pan_master]; -- or Country_Code_Master depending on the correct table name.
    END

    IF @Type = '' OR @Type = 'custodian'
    BEGIN
        SELECT Cust_Id cust_id,Cust_Reg_No cust_reg_no,Cust_nm cust_nm,Created_dtm created_dtm,Modified_dtm modified_dtm FROM [nsdl].[Custodian_MSTR_TBL];
    END

    IF @Type = '' OR @Type = 'ddp'
    BEGIN
        SELECT DDP_ID sebi_registration_no,Created_dtm created_dtm,Modified_dtm modified_dtm,DMT_DDP_NM_CD ddp_id,DMT_DDP_NM ddp_name FROM [nsdl].[DDP_MSTR_TBL];
    END

    IF @Type = '' OR @Type = 'FormAStatus'
    BEGIN
        SELECT * FROM [nsdl].[FormA_Status_Master];
    END
    
    IF @Type = '' OR @Type = 'prior_associations'
    BEGIN
        SELECT * FROM [nsdl].prior_association_master pam;
    END
    
    IF @Type = '' OR @Type = 'type_of_entity'
    BEGIN
        SELECT * FROM [nsdl].type_of_entity_master toem;
    END
    
    IF @Type = '' OR @Type = 'code_of_business'
    BEGIN
        SELECT * FROM [nsdl].code_of_business_master cobm ;
    END
    IF @Type = '' OR @Type = 'type_of_applicant'
    BEGIN
        SELECT * FROM [nsdl].FVCI_MASTER_TYPE_OF_APPLICANT ta ;
    END
    IF @Type = '' OR @Type = 'regulatory_authority'
     BEGIN
        SELECT Repository_nm regulatory_name, Country_Name country_name, Reg_Auth_Website website FROM [nsdl].regulatory_master rm ;
    END 
END;

