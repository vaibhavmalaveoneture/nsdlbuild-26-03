CREATE PROCEDURE DeleteFvciBenificialOwnershipByControlBoDetailsByApplicationId
                            @FvciApplicationId NVARCHAR(255)
                        AS
                        BEGIN
                            SET NOCOUNT ON;

                            DELETE FROM nsdl.draft_fvci_benificial_ownership_by_control_bo_details
                            WHERE fvci_application_id = @FvciApplicationId;
                        END;

CREATE PROCEDURE DeleteFvciEkycBenificialOwnerDetailsForApplication
                            @FvciApplicationId NVARCHAR(255)
                        AS
                        BEGIN
                            SET NOCOUNT ON;

                            DELETE FROM nsdl.draft_fvci_ekyc_benificial_owner_details
                            WHERE fvci_application_id = @FvciApplicationId;
                        END;

CREATE PROCEDURE DeleteFvciInfoBasicOfOwnershipBoDetailsByApplicationId
                            @FvciApplicationId NVARCHAR(255)
                        AS
                        BEGIN
                            SET NOCOUNT ON;

                            DELETE FROM nsdl.draft_fvci_info_basic_of_ownership_bo_details
                            WHERE fvci_application_id = @FvciApplicationId;
                        END;

CREATE PROCEDURE DeleteFvciInformationOfSaSmFvciApplicantByApplicationId
                            @FvciApplicationId NVARCHAR(255)
                        AS
                        BEGIN
                            SET NOCOUNT ON;

                            DELETE FROM nsdl.draft_fvci_information_of_sa_sm_fvci_applicant
                            WHERE fvci_application_id = @FvciApplicationId;
                        END;

CREATE PROCEDURE DeleteFvciKycDocuments
                            @FvciApplicationId NVARCHAR(255)
                        AS
                        BEGIN
                            SET NOCOUNT ON;

                            DELETE FROM nsdl.draft_fvci_kyc_documents 
                            WHERE fvci_application_id = @FvciApplicationId;
                        END;

CREATE PROCEDURE DeleteFvciSubClassDetailsByApplicationId
                        @FvciApplicationId VARCHAR(50)
                    AS
                    BEGIN
                        SET NOCOUNT ON;
                        
                        -- First delete all related beneficial owner records.
                        DELETE FROM nsdl.draft_fvci_sub_class_benificial_owner_details
                        WHERE fvci_sub_class_details_id IN (
                            SELECT id FROM nsdl.draft_fvci_sub_class_details WHERE fvci_application_id = @FvciApplicationId
                        );

                        -- Now delete the sub-class details.
                        DELETE FROM nsdl.draft_fvci_sub_class_details
                        WHERE fvci_application_id = @FvciApplicationId;
                    END;

CREATE PROCEDURE SaveFvciApplication
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
                            SELECT @ExistingApplicationId = application_id
                            FROM nsdl.draft_fvci_applications
                            WHERE application_id = @ApplicationId;

                            IF @ExistingApplicationId IS NOT NULL
                            BEGIN
                                PRINT 'Updating existing application: ' + @ExistingApplicationId;

                                UPDATE nsdl.draft_fvci_applications
                                SET user_id = @UserId,
                                    updated_at = @UpdatedAt,
                                    status = @Status
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
                        VALUES (@UserId, @FvciRegistrationNumber, @CreatedAt, @UpdatedAt, @Status);

                        -- Retrieve the generated ApplicationId from the table variable
                        SELECT @GeneratedApplicationId = application_id FROM @InsertedApplicationId;

                        PRINT 'Inserted ApplicationId: ' + COALESCE(@GeneratedApplicationId, 'NULL');
                    END;

CREATE PROCEDURE SelectAllCustomers @City nvarchar(30)
AS
SELECT * FROM Customers WHERE City = @City;

ALTER PROCEDURE sp_approverejectappliation
                            @ApplicationId INT,
                            @Status VARCHAR(50),
                            @Remarks VARCHAR(255),
                            @RoleCode VARCHAR(50)
                        AS
                        BEGIN
                            SET NOCOUNT ON;

                            DECLARE @StateSide VARCHAR(50);

                            IF @Status = 'Approved' AND @RoleCode = 'DDPMaker'
                                SELECT @StateSide = StatusID FROM nsdl.statusmaster WHERE statuscode = 'DDP_MAKER_APPROVE';
                            ELSE IF @Status = 'Approved' AND @RoleCode = 'DDPChecker'
                                SELECT @StateSide = StatusID FROM nsdl.statusmaster WHERE statuscode = 'DDP_CHECKER_APPROVE';
                            ELSE IF @Status = 'Rejected' AND @RoleCode = 'DDPMaker'
                                SELECT @StateSide = StatusID FROM nsdl.statusmaster WHERE statuscode = 'DDP_MAKER_REJECT';
                            ELSE IF @Status = 'Rejected' AND @RoleCode = 'DDPChecker'
                                SELECT @StateSide = StatusID FROM nsdl.statusmaster WHERE statuscode = 'DDP_CHECKER_REJECT';

                            UPDATE nsdl.fvci_applications
                            SET 
                                remarks = @Remarks,
                                status = @StateSide,
                                updated_at = GETDATE()
                            WHERE application_id = @ApplicationId;

                            IF @@ROWCOUNT = 0
                            BEGIN
                                PRINT 'No records updated. User ID might not exist.';
                            END
                        END;

CREATE PROCEDURE SP_ApproveUserRegistration
    @UrId INT,
    @AdminDpId INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

        -- Step 1: Fetch user registration
        DECLARE @UserName VARCHAR(255),
                @Password VARCHAR(255),
                @NewPassword VARCHAR(255),
                @EmailId VARCHAR(255),
                @DdpId INT,
                @ContactNo VARCHAR(20),
                @Address VARCHAR(MAX),
                @RoleId INT,
                @UserTypeId VARCHAR(50),
                @EntityName VARCHAR(100),
                @DOB DATETIME;

        -- Fetch registration
        SELECT 
            @UserName = COALESCE(User_Name_FPIAPP, GCNameoffUser),
            @Password = password,
            @NewPassword = new_password,
            @EmailId = UserName,
            @DdpId = ddp,
            @ContactNo = number,
            @Address = CONCAT(address1, ', ', city, ', ', state, ', ', Country),
            @RoleId = RollID,
            @UserTypeId = UserType,
            @EntityName = entity_name,
            @DOB = DOB
        FROM nsdl.User_Registration1
        WHERE ur_id = @UrId;

        -- Step 2: If user not found
        IF @EmailId IS NULL
        BEGIN
            ROLLBACK TRANSACTION;
            SELECT 'ERROR' AS Status, 'User registration not found.' AS Message;
            RETURN;
        END

        -- Step 3: Check DDP match
        IF @DdpId <> @AdminDpId
        BEGIN
            ROLLBACK TRANSACTION;
            SELECT 'UNAUTHORIZED' AS Status, 'Admin DDP does not match user DDP.' AS Message;
            RETURN;
        END

        -- Step 4: Insert into users table
        INSERT INTO nsdl.users 
            (user_nm, password, new_password, email_id, dp_id, contact_no, address, role_id, entity_nm, dob, registration_id)
        VALUES 
            (@UserName, @Password, @NewPassword, @EmailId, @DdpId, @ContactNo, @Address, @RoleId, @EntityName, @DOB, @UrId);

        IF @@ROWCOUNT = 0
        BEGIN
            ROLLBACK TRANSACTION;
            SELECT 'ERROR' AS Status, 'Failed to insert user.' AS Message;
            RETURN;
        END

        -- Step 5: Update verification flag
        UPDATE nsdl.User_Registration1
        SET Verification_flag = 2
        WHERE ur_id = @UrId;

        -- Step 6: Commit
        COMMIT TRANSACTION;
        SELECT 'SUCCESS' AS Status, 'User approved and inserted successfully.' AS Message;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SELECT 'ERROR' AS Status, ERROR_MESSAGE() AS Message;
    END CATCH
END;

ALTER PROCEDURE SP_CheckDuplicateEmailOrPhone
    @EmailId VARCHAR(255),
    @Number VARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT COUNT(1) 
    FROM [nsdl].user_registrations 
    WHERE email_id = @EmailId OR number = @Number;
END;

CREATE PROCEDURE sp_GetAddressDetails
    @ApplicationId NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        flat_block_no AS FlatBlockNo,
        building_premises_village_name AS BuildingPremisesVillageName,
        road_street_lane_name AS RoadStreetLaneName,
        area_locality_subdivision AS AreaLocalitySubdivision,
        town_city_district AS TownCityDistrict,
        zip_code AS ZipCode,
        state AS State,
        countrycode AS CountryCode,
        type_of_address AS TypeOfAddress
    FROM nsdl.draft_fvci_address_details
    WHERE fvci_application_id = @ApplicationId;
END;

-- SP_GetAllUserRegistrations
ALTER PROCEDURE SP_GetAllUserRegistrations
    @DdpId INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    IF @DdpId IS NULL
        SELECT * FROM [nsdl].User_Registration1 WHERE Verification_flag > 1 ORDER BY create_dtm desc;
    ELSE
        SELECT * FROM [nsdl].User_Registration1 WHERE ddp = @DdpId  ORDER BY create_dtm desc;
END;

CREATE PROCEDURE sp_getapplications
                            @rolecode NVARCHAR(50),
                            @userid INT
                        AS
                        BEGIN
                            SET NOCOUNT ON;
                            DECLARE @ddpid INT;

                            -- If rolecode is 'GCUST' or 'FVCIA', fetch from both tables
                            IF @rolecode IN ('GCUST', 'FVCIA')
                            BEGIN
                                WITH Combined AS (
								        -- Draft Applications
								        SELECT 
								            dfa.application_id AS ApplicationId,
								            dfa.user_id AS UserId,
								            dfkd.name AS Name,
								            dfa.fvci_registration_number AS FvciRegistrationNumber,
								            dfa.created_at AS CreatedAt,
						            dfa.updated_at AS UpdatedAt,
						            sm.StatusName AS Status,
						            2 AS Priority  -- Lower priority for draft
						        FROM nsdl.draft_fvci_applications dfa 
						        INNER JOIN nsdl.draft_fvic_kyc_details dfkd 
						            ON dfa.application_id = dfkd.fvci_application_id
						        INNER JOIN nsdl.status_master sm
						            ON sm.StatusID = dfa.status
						        WHERE dfa.user_id = @UserId
						
						        UNION ALL
						
						        -- Final Applications
						        SELECT 
						            fa.application_id AS ApplicationId,
						            fa.user_id AS UserId,
						            fkd.name AS Name,
						            fa.fvci_registration_number AS FvciRegistrationNumber,
						            fa.created_at AS CreatedAt,
						            fa.updated_at AS UpdatedAt,
						            sm.StatusName AS Status,
						            1 AS Priority  -- Higher priority for final
						        FROM nsdl.fvci_applications fa 
						        INNER JOIN nsdl.fvic_kyc_details fkd 
						            ON fa.application_id = fkd.fvci_application_id
						        INNER JOIN nsdl.status_master sm
						            ON sm.StatusID = fa.status
						        WHERE fa.user_id = @UserId
						    )
						
						    , Ranked AS (
						        SELECT *,
						               ROW_NUMBER() OVER (PARTITION BY ApplicationId ORDER BY Priority, CreatedAt DESC) AS RowNum
						        FROM Combined
						    )
						
						    SELECT 
						        UserId,
						        Name,
						        ApplicationId,
						        FvciRegistrationNumber,
						        CreatedAt,
						        UpdatedAt,
						        Status
						    FROM Ranked
						    WHERE RowNum = 1
						    ORDER BY CreatedAt DESC;
                            END
                            else if @rolecode = 'DDPAdmin'
                            begin
                                SELECT @ddpid = dp_id  
                                FROM nsdl.users 
                                WHERE user_id = @userid;
                                
                                SELECT 
                  fa.user_id AS UserId,
                                    fkd.name AS Name,
                                    fa.application_id AS ApplicationId,
                                    fa.fvci_registration_number AS FvciRegistrationNumber,
                                    fa.created_at AS CreatedAt,
                                    fa.updated_at AS UpdatedAt,
                                    sm.StatusName AS Status
                                FROM nsdl.fvci_applications fa 
                                INNER JOIN nsdl.fvic_kyc_details fkd 
                                    ON fa.application_id = fkd.fvci_application_id
                                INNER JOIN nsdl.users u 
                                    on u.user_id = fa.user_id and u.dp_id = @ddpid
                                INNER JOIN nsdl.status_master sm
                                    on sm.StatusID= fa.status
        ORDER BY fa.created_at DESC; 
                            end
                            else if @rolecode = 'DDPMaker'
                            begin
                                SELECT @ddpid = dp_id  
                                FROM nsdl.users 
                                WHERE user_id = @userid;
                                
                                SELECT 
                                    fa.user_id AS UserId,
                                    fkd.name AS Name,
                                    fa.application_id AS ApplicationId,
                                    fa.fvci_registration_number AS FvciRegistrationNumber,
                                    fa.created_at AS CreatedAt,
                                    fa.updated_at AS UpdatedAt,
                                    sm.StatusName AS Status, 
                                    sabd.IS_VERIFY as isVerify,
                                    atsmaster.AMT_EmailID as EmailId
                                FROM nsdl.fvci_applications fa 
                                INNER JOIN nsdl.fvic_kyc_details fkd 
                                    ON fa.application_id = fkd.fvci_application_id and fa.status >= 2
                                INNER JOIN nsdl.users u 
                                    on u.user_id = fa.user_id and u.dp_id = @ddpid
                                INNER JOIN nsdl.status_master sm
                                    on sm.StatusID= fa.status
                                left join nsdl.SELECTED_ATS_BYDDP sabd on fa.application_id = sabd.APPLICATION_ID
                                left join nsdl.ATS_MSTR_TBL atsmaster on sabd.AMT_ASM_ID  =  atsmaster.AMT_ASM_ID
                                ORDER BY fa.created_at DESC; 
                            end
                            else if @rolecode = 'DDPChecker'
                            begin
                                SELECT @ddpid = dp_id  
                                FROM nsdl.users 
                                WHERE user_id = @userid;
                                
                                SELECT 
                                    fa.user_id AS UserId,
                                    fkd.name AS Name,
                                    fa.application_id AS ApplicationId,
                                    fa.fvci_registration_number AS FvciRegistrationNumber,
                                    fa.created_at AS CreatedAt,
                                    fa.updated_at AS UpdatedAt,
                                    sm.StatusName AS Status,
                                    sabd.IS_VERIFY as isVerify,
                                    atsmaster.AMT_EmailID as EmailId
                                FROM nsdl.fvci_applications fa 
                                INNER JOIN nsdl.fvic_kyc_details fkd 
                                    ON fa.application_id = fkd.fvci_application_id and fa.status >= 3
                                INNER JOIN nsdl.users u 
                                    on u.user_id = fa.user_id and u.dp_id = @ddpid
                                INNER JOIN nsdl.status_master sm
                                    on sm.StatusID= fa.status
                                left join nsdl.SELECTED_ATS_BYDDP sabd on fa.application_id = sabd.APPLICATION_ID
                                left join nsdl.ATS_MSTR_TBL atsmaster on sabd.AMT_ASM_ID  =  atsmaster.AMT_ASM_ID
                                ORDER BY fa.created_at DESC;
                            end
                            -- If rolecode is anything else, return unauthorized message
                            ELSE
          BEGIN
                                SELECT 'Unauthorized rolecode' AS Message;
                            END
                        END;

CREATE PROCEDURE SP_GetATSMasterByDdpCode
    @DdpId INT
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT * 
    FROM [nsdl].[ATS_MSTR_TBL]
    WHERE [AMT_DDP_CODE] = @DdpId;
END;

CREATE PROCEDURE sp_GetBankDetails
    @ApplicationId NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        is_bank AS IsBank,
        name_of_bank AS NameOfBank,
        have_office_in_india AS HaveOfficeInIndia
    FROM nsdl.draft_fvci_is_bank
    WHERE fvci_application_id = @ApplicationId;
END;

CREATE PROCEDURE sp_GetBasisOfOwnershipDetailsList
    @ApplicationId NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        id,
        fvci_application_id AS fvciApplicationId,
        name_of_bo AS nameOfBo,
        stake,
        name_of_entity AS nameOfEntity,
        country,
        stake_percentage AS stakePercentage,
        is_individual AS isIndividual,
        created_at AS createdAt,
        updated_at AS updatedAt
    FROM nsdl.draft_fvci_info_basic_of_ownership_bo_details
    WHERE fvci_application_id = @ApplicationId;
END;

CREATE PROCEDURE sp_GetBeneficialOwnershipByControlDetails
    @ApplicationId NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        is_no_entity_controls_through_voting AS IsNoEntityControlsThroughVoting,
        created_at AS CreatedAt,
        updated_at AS UpdatedAt
    FROM nsdl.draft_fvci_benificial_ownership_by_control
    WHERE fvci_application_id = @ApplicationId;
END;

CREATE PROCEDURE sp_GetBeneficialOwnershipByControlDetailsList
    @ApplicationId NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        id,
        fvci_application_id AS fvciApplicationId,
        name_of_bo AS nameOfBo,
        method_of_control AS methodOfControl,
        country,
        control_percentage AS controlPercentage,
        is_individual AS isIndividual,
        created_at AS createdAt,
        updated_at AS updatedAt
    FROM nsdl.draft_fvci_benificial_ownership_by_control_bo_details
    WHERE fvci_application_id = @ApplicationId;
END;

CREATE PROCEDURE sp_GetComplianceOfficerDetails
    @ApplicationId NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        name AS Name,
        job_title AS JobTitle,
        phone_number AS PhoneNumber,
        fax_number AS FaxNumber,
        status AS Status
    FROM nsdl.draft_fvci_complaince_officer_details
    WHERE fvci_application_id = @ApplicationId;
END;

CREATE PROCEDURE sp_GetComplianceOfficerEmail
    @ApplicationId NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        email AS Email,
        status AS Status
    FROM nsdl.draft_fvci_complaince_officer_emails
    WHERE fvci_application_id = @ApplicationId;
END;

CREATE PROCEDURE sp_GetContactDetails
    @ApplicationId NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        fax_number AS FaxNumber,
        website AS Website,
        mobile_number AS MobileNumber,
        email_id AS EmailId
    FROM nsdl.draft_fvci_ekyc_contact_details
    WHERE fvci_application_id = @ApplicationId;
END;

ALTER PROCEDURE SP_GetDashboardData  
AS  
BEGIN  
    SET NOCOUNT ON;
	SELECT 
        1000 AS total_fpi_count,  
        500 AS total_fvci_count; 
       
       
    DECLARE @CountryData1 TABLE (  
        name NVARCHAR(100),  
        total_count INT,  
        flag_link NVARCHAR(255), 
        country_code NVARCHAR(2)
    );  

    INSERT INTO @CountryData1 (name, total_count, flag_link, country_code)  
    VALUES  
        ('AUSTRALIA', 300, 'AU', 'AU'),  
        ('AUSTRIA', 250, 'AT', 'AT'),
        ('BAHRAIN', 250, 'UA', 'UA'),
        ('India', 250, 'UA', 'AT'), 
        ('AUSTRALIA', 300, 'AU', 'AU'),  
        ('AUSTRIA', 250, 'AT', 'AT'),
        ('BAHRAIN', 250, 'UA', 'UA'),
        ('India', 250, 'UA', 'AT'),
        ('BAHRAIN', 250, 'UA', 'UA'),
        ('BELGIUM', 150, 'UA', 'BE');  

    SELECT * FROM @CountryData1;  
   	
 
END;

CREATE PROCEDURE sp_GetDeclarationUndertakingDetails
    @ApplicationId NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        id,
        fvci_application_id AS fvciApplicationId,
        name,
        capacity,
        date,
        place,
        name_of_signatory AS nameOfSignatory,
        designation_of_signatory AS designationOfSignatory,
        date_of_signature AS dateOfSignature,
        signature,
        created_at AS createdAt,
        updated_at AS updatedAt
    FROM nsdl.draft_fvci_declaration_undertaking_details
    WHERE fvci_application_id = @ApplicationId;
END;

CREATE   PROCEDURE sp_getfvciapplicationdetails
    @ApplicationId NVARCHAR(50),
    @UserId INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        user_id AS UserId,
        application_id AS ApplicationId,
        fvci_registration_number AS FvciRegistrationNumber,
        status as Status,
        created_at AS CreatedAt,
        updated_at AS UpdatedAt 
    FROM nsdl.draft_fvci_applications 
    WHERE application_id = @ApplicationId;
END;

CREATE   PROCEDURE sp_getfvciekycbeneficialownerdetails
    @ApplicationId NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        name_address AS NameAddress,
        date_of_birth AS DateOfBirth,
        tax_residancy_juridication AS TaxResidancyJuridication,
        natinality AS Nationality,
        acting_alonng_person_group_name_address AS ActingAlongPersonGroupNameAddress,
        bo_ownership_in_fvci AS BoOwnershipInFvci,
        giverment_doc_identity_number AS GovermentDocIdentityNumber,
        status AS Status
    FROM nsdl.draft_fvci_ekyc_benificial_owner_details
    WHERE fvci_application_id = @ApplicationId;
END;

CREATE   PROCEDURE sp_getfvciincomedetails
    @ApplicationId NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        source_of_income AS SourceOfIncome, 
        code_of_business AS CodeOfBusiness,
        gross_annual_income AS GrossAnnualIncome, 
        net_worth AS NetWorth, 
        as_on_date AS AsOnDate,
        status AS Status
    FROM nsdl.draft_fvci_income_details
    WHERE fvci_application_id = @ApplicationId;
END;

CREATE PROCEDURE sp_GetFvciIndianMarketAssocians
    @ApplicationId NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        name AS Name,
        associated_as AS AssociatedAs,
        registration_number AS RegistrationNumber,
        period_of_registration AS PeriodOfRegistration
    FROM nsdl.draft_fvci_indian_market_associans
    WHERE fvci_application_id = @ApplicationId;
END;

CREATE   PROCEDURE sp_getfvciownershipdetails
    @ApplicationId NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        is_no_entity_holding_gt AS IsNoEntityHoldingGt,
        entity_holding AS EntityHolding
    FROM nsdl.draft_fvci_info_basic_of_ownership_details
    WHERE fvci_application_id = @ApplicationId;
END;

CREATE   PROCEDURE sp_getfvickycdetails
    @ApplicationId NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        name,
        has_other_name AS HasOtherName,
        other_name AS OtherName,
        date_of_incorporation AS DateOfIncorporation,
        date_of_commencement AS DateOfCommencement,
        place_of_incorporation AS PlaceOfIncorporation,
        country_of_incorporation AS CountryOfIncorporation,
        isd_country_code_of_incorportation AS IsdCountryCodeOfIncorporation,
        NULLIF(legal_form_and_law_of_incorporation, '') AS LegalFormAndLawOfIncorporation,
        legal_entity_identifier AS LegalEntityIdentifier,
        address_of_cummunication AS AddressOfCommunication,
        have_office_in_india AS HaveOfficeInIndia,
        benificial_ownership_holding AS BenificialOwnershipHolding,
        does_other_person_holder_ownership AS DoesOtherPersonHolderOwnership,
        is_politically_exposed AS IsPoliticallyExposed,
        is_related_to_politically_exposed AS IsRelatedToPoliticallyExposed
    FROM nsdl.draft_fvic_kyc_details
    WHERE fvci_application_id = @ApplicationId;
END;

CREATE PROCEDURE sp_getfvicregistrationdetails
    @ApplicationId NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        fvci_application_id AS FvciApplicationId,
        type_of_applicant AS TypeOfApplicant,
        other_type_of_applicant AS OtherTypeOfApplicant,
        type_of_entity AS TypeOfEntity,
        is_provided_facta_crs_provided AS IsProvidedFactaCrsProvided,
        is_coming_from_global_custodian AS IsComingFromGlobalCustodian,
        ddp_name AS DdpName,
        ddp_registration_number AS DdpRegistrationNumber,
        custodian_name AS CustodianName,
        custodian_registration_number AS CustodianRegistrationNumber,
        dp_name AS DpName,
        dp_registration_number AS DpRegistrationNumber,
        bank_name AS BankName,
        bank_address AS BankAddress,
        is_associated_with_securities_market AS IsAssociatedWithSecuritiesMarket,
        details_of_prior_association AS DetailsOfPriorAssociation,
        does_hold_pan AS DoesHoldPan,
        pan_number AS PanNumber,
        is_violated_law AS IsViolatedLaw,
        created_at AS CreatedAt,
        updated_at AS UpdatedAt
    FROM nsdl.draft_fvic_registration_details
    WHERE fvci_application_id = @ApplicationId;
END;

CREATE PROCEDURE sp_GetGlobalCustodianDetails
    @ApplicationId NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        name AS Name,
        country AS Country,
        registration_number AS RegistrationNumber,
        address AS Address
    FROM nsdl.draft_fvci_global_custodian_details 
    WHERE fvci_application_id = @ApplicationId;
END;

CREATE PROCEDURE sp_GetInvestmentManagerDetails
    @ApplicationId NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        name AS Name,
        type AS Type, 
        country AS Country,
        phone_number AS PhoneNumber,
        fax_number AS FaxNumber,
        email AS Email,
        status AS Status
    FROM nsdl.draft_fvci_investment_manager_details
    WHERE fvci_application_id = @ApplicationId;
END;

CREATE PROCEDURE sp_GetKraPermission
    @ApplicationId NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        is_kra_required AS IsKraRequired,
        name_of_fvci_represntative AS NameOfFvciRepresentative,
        email_1 AS Email1,
        email_2 AS Email2,
        email_3 AS Email3,
        phone_number AS PhoneNumber
    FROM nsdl.draft_fvci_kra_for_permission_to_download_kyc_doc
    WHERE fvci_application_id = @ApplicationId;
END;

CREATE PROCEDURE sp_GetKycDocumentByPath
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
    FROM nsdl.draft_fvci_kyc_documents 
    WHERE fvci_application_id = @ApplicationId
      AND document_path = @FilePath;
END;

CREATE PROCEDURE sp_GetKycDocuments
    @ApplicationId NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        fvci_application_id AS FvciApplicationId,
        document_type AS DocumentType, 
        document_identifier AS DocumentIdentifier, 
        document_path AS DocumentPath, 
        status AS Status
    FROM nsdl.draft_fvci_kyc_documents 
    WHERE fvci_application_id = @ApplicationId;
END;

CREATE PROCEDURE sp_GetKycLeiDetails
    @ApplicationId NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        trc_number AS TrcNumber, 
        country_of_tax_residence AS CountryOfTaxResidence
    FROM nsdl.draft_fvci_kyc_lei_details
    WHERE fvci_application_id = @ApplicationId;
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
END;

ALTER PROCEDURE SP_GetOtpRecord
    @UrId INT = NULL,
    @UserId INT = NULL,
    @OtpNo VARCHAR(10)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT ur_id, user_id, otp_no, used_yn, otp_dt
    FROM [nsdl].[otp_master]
    WHERE otp_no = @OtpNo AND used_yn = 'N'
      AND (ur_id = @UrId OR @UrId IS NULL)
      AND (user_id = @UserId OR @UserId IS NULL);

END;

ALTER PROCEDURE SP_GetPermissionsByRoleId
    @RoleId INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT p.id AS PermissionId, p.permission_code AS PermissionCode, p.permission AS PermissionName
    FROM [nsdl].[permissions] p
    JOIN [nsdl].[role_permissions] rp ON rp.permission_id = p.id
    WHERE rp.role_id = @RoleId AND p.status = 1;
END;

CREATE PROCEDURE sp_GetRegulatoryAuthority
    @ApplicationId NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        regulatory_authority_name AS RegulatoryAuthorityName,
        regulatory_authority_country AS RegulatoryAuthorityCountry,
        regulatory_authority_website AS RegulatoryAuthorityWebsite,
        regulatory_authority_reg_number AS RegulatoryAuthorityRegNumber,
        regulatory_authority_category AS RegulatoryAuthorityCategory
    FROM nsdl.draft_fvci_regulatory_authority_details 
    WHERE fvci_application_id = @ApplicationId;
END;

CREATE PROCEDURE sp_GetSasmDetails
    @ApplicationId NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        name AS Name,
        relationship_with_applicant AS RelationshipWithApplicant,
        pan AS Pan,
        country AS Country,
        TRY_CONVERT(datetime, date_of_birth) AS DateOfBirth,
        address AS Address,
        goverment_id AS GovermentId
    FROM nsdl.draft_fvci_information_of_sa_sm_fvci_applicant
    WHERE fvci_application_id = @ApplicationId;
END;

-- SP_GetStoredPasswordHash
ALTER PROCEDURE SP_GetStoredPasswordHash
    @EmailId VARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT password 
    FROM [nsdl].User_Registration1 
    WHERE UserName = @EmailId;
END;

CREATE PROCEDURE sp_GetTelephoneNumberDetails
    @ApplicationId NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        country_code AS CountryCode,
        std_code AS StdCode,
        phone_number AS PhoneNumber,
        phone_type AS PhoneType,
        status AS Status,
        contacttype AS ContactType
    FROM nsdl.draft_fvci_telephone_number_details
    WHERE fvci_application_id = @ApplicationId;
END;

ALTER PROCEDURE SP_GetUserByEmail
    @EmailId VARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * FROM [nsdl].[users] WHERE email_id = @EmailId;
END;

ALTER PROCEDURE SP_GetUserProfileById
    @UserId INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT 
        user_id,
        user_nm,
        email_id,
        contact_no,
        address,
        role_id,
        dp_id,
        status,
        created_dtm,
        modified_dtm,
        login_dtm,
        last_pwd_change_dtm,
        user_type_id,
        is_forget_password,
        allow_otp,
        otp_cnt,
        otp_dtm,
        closed_dtm,
        app_type,
        pannumber,
        dob,
        entity_nm
    FROM [nsdl].[users]
    WHERE user_id = @UserId ORDER BY created_dtm DESC;
END;

ALTER PROCEDURE SP_GetUserRegistrationByEmail
    @EmailId VARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT ur_id, UserName, Verification_flag 
    FROM [nsdl].User_Registration1 
    WHERE UserName = @EmailId;
END;

-- SP_GetUserRegistrationById
ALTER PROCEDURE SP_GetUserRegistrationById
    @UrId INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * FROM [nsdl].user_registrations WHERE ur_id = @UrId;
END;

ALTER PROCEDURE SP_GetUserRegistrationId
    @EmailId VARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT user_id FROM [nsdl].[users] WHERE email_id = @EmailId;
END;

ALTER PROCEDURE SP_GetUserRegistrationIdByEmail
    @EmailId VARCHAR(255),
    @IsVerified BIT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT ur_id 
    FROM [nsdl].User_Registration1 
    WHERE UserName = @EmailId 
    AND Verification_flag >= CASE WHEN @IsVerified = 1 THEN 1 ELSE 0 END
    AND (@IsVerified = 1 OR ddp IS NULL);
END;

ALTER PROCEDURE SP_GetUserRole
    @UserId INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT rm.role_id, rm.role_code, rm.role_name, rm.visible, rm.status
    FROM [nsdl].[roles_master] rm
    JOIN [nsdl].[users] u ON rm.role_id = u.role_id
    WHERE u.user_id = @UserId;
END;

ALTER PROCEDURE SP_GetUserRolePermission
    @UserID INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT u.user_id, r.role_code, STRING_AGG(p.permissioncode, ',') AS permissioncode
    FROM [nsdl].[users] u
    INNER JOIN [nsdl].[roles_master] r ON u.role_id = r.role_id
    INNER JOIN [nsdl].[rolepermissionmapping] p ON r.role_code = p.role_code
    WHERE u.user_id = @UserID
    GROUP BY u.user_id, r.role_code;
END;

CREATE PROCEDURE sp_GetViolationDetails
    @ApplicationId NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        description AS Description
    FROM nsdl.draft_fvci_incidents_of_law_voilation
    WHERE fvci_application_id = @ApplicationId;
END;

ALTER PROCEDURE SP_HasActiveSession
    @UserId INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT COUNT(1) 
    FROM [nsdl].sessions 
    WHERE user_id = @UserId 
    AND expires_at > GETDATE() 
    AND is_active = 1;
END;

CREATE PROCEDURE sp_InsertApiLog
    @UserId NVARCHAR(100),
    @RequestPath NVARCHAR(500),
    @HttpMethod NVARCHAR(10),
    @QueryString NVARCHAR(MAX),
    @RequestBody NVARCHAR(MAX),
    @ResponseBody NVARCHAR(MAX),
    @StatusCode INT,
    @ResponseTime BIGINT
AS
BEGIN
    INSERT INTO nsdl.apilogs (UserId, RequestPath, HttpMethod, QueryString, RequestBody, ResponseBody, StatusCode, ResponseTime, Timestamp)
    VALUES (@UserId, @RequestPath, @HttpMethod, @QueryString, @RequestBody, @ResponseBody, @StatusCode, @ResponseTime, GETUTCDATE());
END;

CREATE PROCEDURE SP_InsertFvciApplication @ApplicationID NVARCHAR(255)
                        AS
                        BEGIN
                            SET NOCOUNT ON;

                            DECLARE @TempTable TABLE
                            (
                                draft_id INT,
                                new_id INT
                            );
                            BEGIN TRY
                                BEGIN TRANSACTION;
                                INSERT INTO nsdl.fvci_applications
                                (
                                    user_id,
                                    application_id,
                                    fvci_registration_number,
                                    created_at,
                                    updated_at,
                                    status
                                )
                                SELECT user_id,
                                    application_id,
                                    fvci_registration_number,
                                    created_at,
                                    updated_at,
                                    2
                                FROM nsdl.draft_fvci_applications
                                WHERE application_id = @ApplicationID;
                                INSERT INTO nsdl.fvic_kyc_details
                                (
                                    fvci_application_id,
                                    name,
                                    has_other_name,
                                    other_name,
                                    date_of_incorporation,
                                    date_of_commencement,
                                    place_of_incorporation,
                                    country_of_incorporation,
                                    isd_country_code_of_incorportation,
                                    legal_form_and_law_of_incorporation,
                                    legal_entity_identifier,
                                    address_of_cummunication,
                                    have_office_in_india,
                                    benificial_ownership_holding,
                                    does_other_person_holder_ownership,
                                    is_politically_exposed,
                                    is_related_to_politically_exposed,
                                    created_at,
                                    updated_at
                                )
                                SELECT fvci_application_id,
                                    name,
                                    has_other_name,
                                    other_name,
                                    date_of_incorporation,
                                    date_of_commencement,
                                    place_of_incorporation,
                                    country_of_incorporation,
                                    isd_country_code_of_incorportation,
                                    legal_form_and_law_of_incorporation,
                                    legal_entity_identifier,
                                    address_of_cummunication,
                                    have_office_in_india,
                                    benificial_ownership_holding,
                                    does_other_person_holder_ownership,
                                    is_politically_exposed,
                                    is_related_to_politically_exposed,
                                    created_at,
                                    updated_at
                                FROM nsdl.draft_fvic_kyc_details
                                WHERE fvci_application_id = @ApplicationID;
                                INSERT INTO nsdl.fvci_kyc_lei_details
                                (
                fvci_application_id,
                                    trc_number,
                                    country_of_tax_residence,
                                    created_at,
                                    updated_at
                                )
                                SELECT fvci_application_id,
                                    trc_number,
                                    country_of_tax_residence,
                                    created_at,
                                    updated_at
                                FROM nsdl.draft_fvci_kyc_lei_details
                                WHERE fvci_application_id = @ApplicationID;
                                INSERT INTO nsdl.fvci_address_details
                                (
                                    fvci_application_id,
                                    flat_block_no,
                                    building_premises_village_name,
                                    road_street_lane_name,
                                    area_locality_subdivision,
                                    town_city_district,
                                    zip_code,
                                    state,
                                    countrycode,
                                    type_of_address,
                                    created_at,
                                    updated_at
                                )
                                SELECT fvci_application_id,
                                    flat_block_no,
                                    building_premises_village_name,
                                    road_street_lane_name,
                                    area_locality_subdivision,
                                    town_city_district,
                                    zip_code,
                                    state,
                                    countrycode,
                                    type_of_address,
                                    created_at,
                                    updated_at
                                FROM nsdl.draft_fvci_address_details
                                WHERE fvci_application_id = @ApplicationID;
                                INSERT INTO nsdl.fvci_telephone_number_details
                                (
                                    fvci_application_id,
                                    country_code,
                                    std_code,
                                    phone_number,
                                    phone_type,
                                    status,
                                    created_at,
                                    updated_at,
                                    contacttype
                                )
                                SELECT fvci_application_id,
                                    country_code,
                                    std_code,
                                    phone_number,
                                    phone_type,
                                    status,
                                    created_at,
                                    updated_at,
                                    contacttype
                                FROM nsdl.draft_fvci_telephone_number_details
                                WHERE fvci_application_id = @ApplicationID;
                                INSERT INTO nsdl.fvci_ekyc_contact_details
                                (
                                    fvci_application_id,
                                    fax_number,
                                    website,
                                    mobile_number,
                                    email_id,
                                    created_at,
                                    updated_at
                                )
                                SELECT fvci_application_id,
               fax_number,
                 website,
                                    mobile_number,
                                    email_id,
                                    created_at,
                                    updated_at
                                FROM nsdl.draft_fvci_ekyc_contact_details
                                WHERE fvci_application_id = @ApplicationID;
                                INSERT INTO nsdl.fvci_investment_manager_details
                                (
                                    fvci_application_id,
                                    name,
                                    [type],
                                    country,
                                    phone_number,
                                    fax_number,
                                    email,
                                    status,
                                    created_at,
                                    updated_at
                                )
                                SELECT fvci_application_id,
                                    name,
                                    [type],
                                    country,
                                    phone_number,
                                    fax_number,
                                    email,
                                    status,
                                    created_at,
                                    updated_at
                                FROM nsdl.draft_fvci_investment_manager_details
                                WHERE fvci_application_id = @ApplicationID;
                                INSERT INTO nsdl.fvci_complaince_officer_details
                                (
                                    fvci_application_id,
                                    name,
                                    job_title,
                                    phone_number,
                                    status,
                                    created_at,
                                    updated_at
                                )
                                SELECT fvci_application_id,
                                    name,
                                    job_title,
                                    phone_number,
                                    status,
                                    created_at,
                                    updated_at
                                FROM nsdl.draft_fvci_complaince_officer_details
                                WHERE fvci_application_id = @ApplicationID;
                                INSERT INTO nsdl.fvci_complaince_officer_emails
                                (
                                    fvci_application_id,
                                    email,
                                    status,
                                    created_at,
                                    updated_at
                                )
                                SELECT fvci_application_id,
                                    email,
                                    status,
                                    created_at,
                                    updated_at
                                FROM nsdl.draft_fvci_complaince_officer_emails
                                WHERE fvci_application_id = @ApplicationID;
                                INSERT INTO nsdl.fvci_kyc_documents
                                (
                                    fvci_application_id,
                                    document_type,
                                    document_identifier,
                                    document_path,
                                    status,
                                    created_at,
                    updated_at
                                )
                                SELECT fvci_application_id,
       document_type,
                                    document_identifier,
                                    document_path,
                                    status,
                                    created_at,
                                    updated_at
                                FROM nsdl.draft_fvci_kyc_documents
                                WHERE fvci_application_id = @ApplicationID;
                                INSERT INTO nsdl.fvci_regulatory_authority_details
                                (
                                    fvci_application_id,
                                    regulatory_authority_name,
                                    regulatory_authority_country,
                                    regulatory_authority_website,
                                    regulatory_authority_reg_number,
                                    regulatory_authority_category,
                                    created_at,
                                    updated_at
                                )
                                SELECT fvci_application_id,
                                    regulatory_authority_name,
                                    regulatory_authority_country,
                                    regulatory_authority_website,
                                    regulatory_authority_reg_number,
                                    regulatory_authority_category,
                                    created_at,
                                    updated_at
                                FROM nsdl.draft_fvci_regulatory_authority_details
                                WHERE fvci_application_id = @ApplicationId;
                                INSERT INTO nsdl.fvci_global_custodian_details
                                (
                                    fvci_application_id,
                                    name,
                                    country,
                                    registration_number,
                                    address,
                                    created_at,
                                    updated_at
                                )
                                SELECT fvci_application_id,
                                    name,
                                    country,
                                    registration_number,
                                    address,
                                    created_at,
                                    updated_at
                                FROM nsdl.draft_fvci_global_custodian_details
                                WHERE fvci_application_id = @ApplicationId;
                                INSERT INTO nsdl.fvci_declaration_undertaking_details
                                (
                                    fvci_application_id,
                                    name,
                                    capacity,
                                    [date],
                                    place,
                                    name_of_signatory,
                                    designation_of_signatory,
                                    date_of_signature,
                                    signature,
                                    created_at,
                                    updated_at
                                )
                                SELECT d.fvci_application_id,
                                    d.name,
                                    d.capacity,
                                    d.[date],
                                    d.place,
                                    d.name_of_signatory,
                                    d.designation_of_signatory,
                                    d.date_of_signature,
                           d.signature,
                                    d.created_at,
                                    d.updated_at
                                FROM nsdl.draft_fvci_declaration_undertaking_details d
                                WHERE d.fvci_application_id = @ApplicationId;
                                INSERT INTO nsdl.fvci_is_bank
                                (
                                    fvci_application_id,
                                    is_bank,
                                    name_of_bank,
                                    have_office_in_india,
                                    created_at,
                                    updated_at
                                )
                                SELECT fvci_application_id,
                                    is_bank,
                                    name_of_bank,
                                    have_office_in_india,
                                    created_at,
                                    updated_at
                                FROM nsdl.draft_fvci_is_bank
                                WHERE fvci_application_id = @ApplicationId;
                                INSERT INTO nsdl.fvci_kra_for_permission_to_download_kyc_doc
                                (
                                    fvci_application_id,
                                    is_kra_required,
                                    name_of_fvci_represntative,
                                    email_1,
                                    email_2,
                                    email_3,
                                    phone_number,
                                    created_at,
                                    updated_at
                                )
                                SELECT fvci_application_id,
                                    is_kra_required,
                                    name_of_fvci_represntative,
                                    email_1,
                                    email_2,
                                    email_3,
                                    phone_number,
                                    created_at,
                                    updated_at
                                FROM nsdl.draft_fvci_kra_for_permission_to_download_kyc_doc
                                WHERE fvci_application_id = @ApplicationId;
                                INSERT INTO nsdl.fvci_benificial_ownership_by_control
                                (
                                    fvci_application_id,
                                    is_no_entity_controls_through_voting,
                                    created_at,
                                    updated_at
                                )
                                SELECT fvci_application_id,
                                    is_no_entity_controls_through_voting,
                                    created_at,
                                    updated_at
                                FROM nsdl.draft_fvci_benificial_ownership_by_control
                                WHERE fvci_application_id = @ApplicationId;
                                INSERT INTO nsdl.fvci_benificial_ownership_by_control_bo_details
                                (
                                    fvci_application_id,
                                    name_of_bo,
                                    method_of_control,
                                    country,
                                    control_percentage,
                                    is_individual,
                                    created_at,
                                    updated_at
                                )
                                SELECT fvci_application_id,
                                    name_of_bo,
                                    method_of_control,
                                    country,
                                    control_percentage,
                                    is_individual,
                                    created_at,
                                    updated_at
          FROM nsdl.draft_fvci_benificial_ownership_by_control_bo_details
         WHERE fvci_application_id = @ApplicationId;
                                INSERT INTO nsdl.fvci_info_basic_of_ownership_bo_details
                                (
                                    fvci_application_id,
                                    name_of_bo,
                            stake,
                                    name_of_entity,
                                    country,
                                    stake_percentage,
                                    is_individual,
                                    created_at,
                                    updated_at
                                )
                                SELECT fvci_application_id,
                                    name_of_bo,
                                    stake,
                                    name_of_entity,
                                    country,
                                    stake_percentage,
                                    is_individual,
                                    created_at,
                                    updated_at
                                FROM nsdl.draft_fvci_info_basic_of_ownership_bo_details
                                WHERE fvci_application_id = @ApplicationId;
                                INSERT INTO nsdl.fvci_info_basic_of_ownership_details
                                (
                                    fvci_application_id,
                                    is_no_entity_holding_gt,
                                    entity_holding,
                                    created_at,
                                    updated_at
                                )
                                SELECT fvci_application_id,
                                    is_no_entity_holding_gt,
                                    entity_holding,
                                    created_at,
                                    updated_at
                                FROM nsdl.draft_fvci_info_basic_of_ownership_details
                                WHERE fvci_application_id = @ApplicationId;
                                INSERT INTO nsdl.fvci_income_details
                                (
                                    fvci_application_id,
                                    source_of_income,
                                    code_of_business,
                                    gross_annual_income,
                                    net_worth,
                                    as_on_date,
                                    status,
                                    created_at,
                                    updated_at
                                )
                                SELECT fvci_application_id,
                                    source_of_income,
                                    code_of_business,
                                    gross_annual_income,
                                    net_worth,
                                    as_on_date,
                                    status,
                                    created_at,
                                    updated_at
                                FROM nsdl.draft_fvci_income_details
                                WHERE fvci_application_id = @ApplicationId;
                                INSERT INTO nsdl.fvic_registration_details
                                (
                                    fvci_application_id,
                                    type_of_applicant,
  other_type_of_applicant,
                                    type_of_entity,
                                   is_provided_facta_crs_provided,
                                    is_coming_from_global_custodian,
                                    ddp_name,
                                    ddp_registration_number,
                                    custodian_name,
                                custodian_registration_number,
                                    dp_name,
                                    dp_registration_number,
                                    bank_name,
                                    bank_address,
                                    is_associated_with_securities_market,
                                    does_hold_pan,
                                    pan_number,
                                    is_violated_law,
                                    created_at,
                                    updated_at
                                )
                                SELECT fvci_application_id,
                                    type_of_applicant,
                                    other_type_of_applicant,
                                    type_of_entity,
                                    is_provided_facta_crs_provided,
                                    is_coming_from_global_custodian,
                                    ddp_name,
                                    ddp_registration_number,
                                    custodian_name,
                                    custodian_registration_number,
                                    dp_name,
                                    dp_registration_number,
                                    bank_name,
                                    bank_address,
                                    is_associated_with_securities_market,
                                    does_hold_pan,
                                    pan_number,
                                    is_violated_law,
                                    created_at,
                                    updated_at
                                FROM nsdl.draft_fvic_registration_details
                                WHERE fvci_application_id = @ApplicationId;
                                INSERT INTO nsdl.fvci_ekyc_benificial_owner_details
                                (
                                    fvci_application_id,
                                    name_address,
                                    date_of_birth,
                                    tax_residancy_juridication,
                                    natinality,
                                    acting_alonng_person_group_name_address,
                                    bo_ownership_in_fvci,
                                    giverment_doc_identity_number,
                                    status,
                                    created_at,
                                    updated_at
                                )
                                SELECT fvci_application_id,
                                    name_address,
                                    date_of_birth,
                                    tax_residancy_juridication,
                                    natinality,
                                    acting_alonng_person_group_name_address,
                                    bo_ownership_in_fvci,
                                    giverment_doc_identity_number,
                                    status,
                                    created_at,
                                    updated_at
                                FROM nsdl.draft_fvci_ekyc_benificial_owner_details
                                WHERE fvci_application_id = @ApplicationId;
                                INSERT INTO nsdl.fvci_information_of_sa_sm_fvci_applicant
                                (
                             fvci_application_id,
                                    name,
                                    relationship_with_applicant,
                                    pan,
                                    country,
                                    date_of_birth,
                                    address,
                                    goverment_id,
                                    created_at,
                 updated_at
                                )
                                SELECT fvci_application_id,
                                    name,
                                    relationship_with_applicant,
                                    pan,
                                    country,
                                    date_of_birth,
                                    address,
                                    goverment_id,
                                    created_at,
                                    updated_at
                                FROM nsdl.draft_fvci_information_of_sa_sm_fvci_applicant
                                WHERE fvci_application_id = @ApplicationId;
                                INSERT INTO nsdl.fvci_incidents_of_law_voilation
                                (
                                    fvci_application_id,
                                    description,
                                    created_at,
                                    updated_at
                                )
                                SELECT fvci_application_id,
                                    description,
                                    created_at,
                                    updated_at
                                FROM nsdl.draft_fvci_incidents_of_law_voilation
                                WHERE fvci_application_id = @ApplicationId;
                                INSERT INTO nsdl.fvci_indian_market_associans
                                (
                                    fvci_application_id,
                                    name,
                                    associated_as,
                                    registration_number,
                                    period_of_registration,
                                    created_at,
                                    updated_at
                                )
                                SELECT fvci_application_id,
                                    name,
                                    associated_as,
                                    registration_number,
                                    period_of_registration,
                                    created_at,
                                    updated_at
                                FROM nsdl.draft_fvci_indian_market_associans
                                WHERE fvci_application_id = @ApplicationId;


                                COMMIT TRANSACTION;
                            END TRY
                            BEGIN CATCH
                                DECLARE @ErrorMessage NVARCHAR(4000),
                                        @ErrorSeverity INT,
                                        @ErrorState INT;
                                SELECT @ErrorMessage = ERROR_MESSAGE(),
                                    @ErrorSeverity = ERROR_SEVERITY(),
                                    @ErrorState = ERROR_STATE();

                                -- Raising the exact error
                                RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
                            END CATCH;
                        END;

ALTER PROCEDURE SP_InsertOTP
    @UrId INT = NULL,
    @UserId INT = NULL,
    @OtpNo VARCHAR(10), -- Adjust the length as needed
    @ModuleNm VARCHAR(100) = 'General OTP' -- Adjust the length as needed
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO [nsdl].[otp_master] (ur_id, user_id, otp_no, module_nm, used_yn)
    VALUES (
        CASE WHEN @UrId > 0 THEN @UrId ELSE NULL END,
        CASE WHEN @UserId > 0 THEN @UserId ELSE NULL END,
        @OtpNo,
        @ModuleNm,
        'N'
    );
END;

CREATE PROCEDURE sp_InsertSelectedAtsByDdp
    @ApplicationId INT,
    @SignRequired INT,
    @AtsUser NVARCHAR(MAX) -- JSON format: '[{"ats_name": "tarun sing", "asm_id": 2}, {"ats_name": "amit sing", "asm_id": 3}]'
AS
BEGIN
    SET NOCOUNT ON;
    -- Declare a table variable to hold parsed JSON data
    DECLARE @AtsUserTable TABLE (
        AMT_ASM_ID INT,
        AMT_SIGN_NAME VARCHAR(255)
    );
    -- Parse JSON data and insert into table variable
    INSERT INTO @AtsUserTable (AMT_ASM_ID, AMT_SIGN_NAME)
    SELECT
        JSON_VALUE(ats.value, '$.asm_id') AS AMT_ASM_ID,
        JSON_VALUE(ats.value, '$.ats_name') AS AMT_SIGN_NAME
    FROM OPENJSON(@AtsUser) AS ats;
    -- Insert data into main table
    INSERT INTO nsdl.SELECTED_ATS_BYDDP (
        APPLICATION_ID,
        AMT_ASM_ID,
        AMT_SIGN_NAME,
        AMT_SIGN_REQD
    )
    SELECT
        @ApplicationId AS APPLICATION_ID,
        AMT_ASM_ID,
        AMT_SIGN_NAME,
        @SignRequired AS AMT_SIGN_REQD
    FROM @AtsUserTable;
END;

-- SP_InsertUserFromRegistration
ALTER PROCEDURE SP_InsertUserFromRegistration
    @UserName VARCHAR(255),
    @Password VARCHAR(255),
    @EmailId VARCHAR(255),
    @DdpId INT,
    @ContactNo VARCHAR(20),
    @Address VARCHAR(255),
    @RoleId INT,
    @UserTypeId INT,
    @EntityName VARCHAR(255),
    @Dob DATETIME,
    @UrId INT
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO [nsdl].users 
    (user_nm, new_password, email_id, dp_id, contact_no, address, role_id, user_type_id, entity_nm, dob, registration_id)
    VALUES 
    (@UserName, @Password, @EmailId, @DdpId, @ContactNo, @Address, @RoleId, @UserTypeId, @EntityName, @Dob, @UrId);
END;

ALTER PROCEDURE SP_InvalidatePreviousSession
    @UserId INT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE [nsdl].sessions 
    SET is_active = 0 
    WHERE user_id = @UserId AND is_active = 1;
END;

ALTER PROCEDURE SP_IsDuplicateEmailOrPhone
    @EmailId VARCHAR(255),
    @Number VARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT COUNT(*) 
    FROM [nsdl].User_Registration1 
    WHERE Verification_flag >= 1 AND (UserName = @EmailId OR number = @Number);
END;

ALTER PROCEDURE SP_IsSessionValid
    @UserId INT,
    @JwtToken VARCHAR(MAX)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT COUNT(1) 
    FROM [nsdl].sessions 
    WHERE user_id = @UserId 
      AND jwt_token = @JwtToken
      AND expires_at > GETUTCDATE() 
      AND is_active = 1;
END;

ALTER PROCEDURE SP_MarkOtpAsUsed
    @UrId INT = NULL,
    @UserId INT = NULL,
    @OtpNo VARCHAR(10)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE [nsdl].[otp_master]
    SET used_yn = 'Y'
    WHERE otp_no = @OtpNo
      AND (ur_id = @UrId OR @UrId IS NULL)
      AND (user_id = @UserId OR @UserId IS NULL);
END;

CREATE PROCEDURE SP_MarkOtpAsUsedURverificationFlag
    @UrId INT = NULL,
    @UserId INT = NULL,
    @OtpNo VARCHAR(10)
AS
BEGIN
    SET NOCOUNT ON;

 UPDATE [nsdl].[otp_master]
    SET used_yn = 'Y'
    WHERE otp_no = @OtpNo
      AND (ur_id = @UrId OR @UrId IS NULL)
      AND (user_id = @UserId OR @UserId IS NULL);

    UPDATE [nsdl].[User_Registration1]
    SET Verification_flag = 1
    WHERE ur_id = @UrId;
END;

ALTER PROCEDURE SP_MarkUserAsForgotPassword
    @UserId INT,
    @IsForgotPassword BIT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE [nsdl].[users] SET is_forget_password = @IsForgotPassword, last_pwd_change_dtm = GETDATE() WHERE user_id = @UserId;
END;

CREATE PROCEDURE SP_MarkUserRegistrationAsVerified
    @UrId INT = NULL,
    @UserId INT = NULL,
    @OtpNo VARCHAR(10)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE [nsdl].[otp_master]
    SET used_yn = 'Y'
    WHERE otp_no = @OtpNo
      AND (ur_id = @UrId OR @UrId IS NULL)
      AND (user_id = @UserId OR @UserId IS NULL);
    
    UPDATE nsdl.User_Registration1
    SET Verification_flag = 1, modified_dtm = GETDATE()
    WHERE ur_id = @UrId;
END;

ALTER PROCEDURE SP_RegisterUser
    @UserAs INT,
    @UserName VARCHAR(255),
    @EntityName VARCHAR(255),
    @SpecifyReg VARCHAR(255),
    @SpecifyOther VARCHAR(255),
    @LeiRegNo VARCHAR(255),
    @LeiDetails VARCHAR(255),
    @GCName VARCHAR(255),
    @GCRegNo VARCHAR(255),
    @GCUserName VARCHAR(255),
    @DOB DATETIME,
    @City VARCHAR(255),
    @State VARCHAR(255),
    @Pincode VARCHAR(20),
    @Country VARCHAR(255),
    @CountryCode VARCHAR(10),
    @Address1 VARCHAR(255),
    @Address2 VARCHAR(255),
    @Address3 VARCHAR(255),
    @Number VARCHAR(20),
    @AreaCode VARCHAR(10),
    @EmailId VARCHAR(255),
    @Password VARCHAR(255),
    @UserTypeId INT
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO nsdl.user_registrations (
        user_as, user_name_fpi_app, entity_name, specify_reg, specify_other,
        lei_reg_no, lei_details, gc_name, gc_reg_no, gc_name_of_user,
        dob, city, state, pincode, country, country_code, address_1, address_2, address_3,
        number, area_code, email_id, new_password, pending_ddp_flag, user_type_id, created_dtm
    ) VALUES (
        @UserAs, @UserName, @EntityName, @SpecifyReg, @SpecifyOther,
        @LeiRegNo, @LeiDetails, @GCName, @GCRegNo, @GCUserName,
        @DOB, @City, @State, @Pincode, @Country, @CountryCode, @Address1, @Address2, @Address3,
        @Number, @AreaCode, @EmailId, @Password, @UserTypeId, 1, GETDATE()
    );
END;

CREATE PROCEDURE SP_RegisterUser1
    @RollID INT,
    @Useras varchar(30), 
    @UserType varchar(50), 
    @EntityName VARCHAR(100), 
    @SpecifyReg VARCHAR(255),
    @LeiRegNo VARCHAR(255),
    @LeiDetails VARCHAR(255),
    @User_Name_FPIAPP VARCHAR(255),
    @GCName VARCHAR(255),
    @GCRegNo VARCHAR(255),
    @GCUserName VARCHAR(255),
    @Address1 VARCHAR(255),
    @Address2 VARCHAR(255),
    @Address3 VARCHAR(255),
    @City VARCHAR(255),
    @State VARCHAR(255),
    @Pincode VARCHAR(20),
    @Country VARCHAR(255),
    @CountryCode VARCHAR(10),
    @AreaCode VARCHAR(10),
    @Number VARCHAR(20),
    @UserName VARCHAR(255),
    @Password VARCHAR(255),
    @NewPassword VARCHAR(255),
    @SpecifyOther VARCHAR(255),
    @DOB DATETIME
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO nsdl.User_Registration1 (
       RollID, UserType, entity_name,  Specify_reg, LEIRegNo, LEIDetails, User_Name_FPIAPP, 
       GCName, GCregNo, GCNameoffUser, address1, city, state, pincode, Country, Countrycode, areacode, number, 
       UserName, password, new_password,  SpecifyOther, DOB,  create_dtm,  Verification_flag, Pending_ddp_flag, modified_dtm
    ) VALUES (
        @RollID, @Useras,  @EntityName, @SpecifyReg, @LeiRegNo,  @LeiDetails, @User_Name_FPIAPP, @GCName, 
        @GCRegNo, @GCUserName, @Address1, @City, @State, @Pincode, @Country,  @CountryCode,  @AreaCode, @Number,
        @UserName, @Password , @NewPassword,  @SpecifyOther, @DOB, GETDATE(), 0 , 0, GETDATE()
    );
END;

CREATE PROCEDURE SP_RegisterUserCombined
    @Number VARCHAR(20),
    @Useras VARCHAR(30), 
    @EntityName VARCHAR(100), 
    @SpecifyReg VARCHAR(255),
    @LeiRegNo VARCHAR(255),
    @LeiDetails VARCHAR(255),
    @User_Name_FPIAPP VARCHAR(255),
    @GCName VARCHAR(255),
    @GCRegNo VARCHAR(255),
    @GCUserName VARCHAR(255),
    @Address1 VARCHAR(255),
    @Address2 VARCHAR(255),
    @Address3 VARCHAR(255),
    @City VARCHAR(255),
    @State VARCHAR(255),
    @Pincode VARCHAR(20),
    @Country VARCHAR(255),
    @CountryCode VARCHAR(10),
    @AreaCode VARCHAR(10),
    @UserName VARCHAR(255),
    @Password VARCHAR(255),
    @NewPassword VARCHAR(255),
    @SpecifyOther VARCHAR(255),
    @DOB DATETIME
AS
BEGIN
    SET NOCOUNT ON;

    -- Define constants (these values you are currently taking from config, we hardcode here)
    DECLARE @UserTypeId VARCHAR(50);
    DECLARE @RollID INT;

    -- Map UserTypeId and RollID based on Useras
    SET @UserTypeId = 
        CASE @Useras
            WHEN 'FPI_INDIVIDUAL' THEN 'FPI_INDIVIDUAL'   -- Replace with actual value e.g. '1'
            WHEN 'FPI_NONINDIVIDUAL' THEN 'FPI_NONINDIVIDUAL' -- Replace with actual value e.g. '2'
            WHEN 'GLOBAL_CUSTODIAN' THEN 'GLOBAL_CUSTODIAN'  -- Replace with actual value e.g. '3'
            ELSE NULL
        END;

    SET @RollID = 
        CASE @Useras
            WHEN 'FPI_INDIVIDUAL' THEN 56   -- Replace with actual value (from config RollID)
            WHEN 'FPI_NONINDIVIDUAL' THEN 56
            WHEN 'GLOBAL_CUSTODIAN' THEN 59
            ELSE NULL
        END;

    IF @UserTypeId IS NULL OR @RollID IS NULL
    BEGIN
        SELECT 'ERROR' AS Status, 'Invalid user type specified.' AS Message;
        RETURN;
    END

    -- Check for duplicate email or phone
    IF EXISTS (
        SELECT 1 
        FROM [nsdl].User_Registration1
        WHERE Verification_flag >= 1 AND (UserName = @UserName OR number = @Number)
    )
    BEGIN
        SELECT 'DUPLICATE' AS Status, 'Email ID or Phone Number already registered.' AS Message;
        RETURN;
    END

    -- Insert record
    INSERT INTO nsdl.User_Registration1 (
       RollID, UserType, entity_name,  Specify_reg, LEIRegNo, LEIDetails, User_Name_FPIAPP, 
       GCName, GCregNo, GCNameoffUser, address1, city, state, pincode, Country, Countrycode, areacode, number, 
       UserName, password, new_password,  SpecifyOther, DOB,  create_dtm,  Verification_flag, Pending_ddp_flag, modified_dtm
    ) VALUES (
        @RollID, @UserTypeId,  @EntityName, @SpecifyReg, @LeiRegNo,  @LeiDetails, @User_Name_FPIAPP, @GCName, 
        @GCRegNo, @GCUserName, @Address1, @City, @State, @Pincode, @Country,  @CountryCode,  @AreaCode, @Number,
        @UserName, @Password , @NewPassword,  @SpecifyOther, @DOB, GETDATE(), 0 , 0, GETDATE()
    );

    -- Success message
    SELECT 'SUCCESS' AS Status, 'User registered successfully.' AS Message;
END;

CREATE PROCEDURE SP_RejectUserRegistration
    @UrId INT,
    @AdminDpId INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

        DECLARE @DdpId INT;

        -- Step 1: Fetch DDP ID of the user registration
        SELECT @DdpId = ddp
        FROM nsdl.User_Registration1
        WHERE ur_id = @UrId;

        -- Step 2: Check if user registration exists
        IF @DdpId IS NULL
        BEGIN
            ROLLBACK TRANSACTION;
            SELECT 'ERROR' AS Status, 'User registration not found.' AS Message;
            RETURN;
        END

        -- Step 3: Check DDP match
        IF @DdpId <> @AdminDpId
        BEGIN
            ROLLBACK TRANSACTION;
            SELECT 'UNAUTHORIZED' AS Status, 'Admin DDP does not match user DDP.' AS Message;
            RETURN;
        END

        -- Step 4: Update Verification_flag to 3 (Rejected)
        UPDATE nsdl.User_Registration1
        SET Verification_flag = 3
        WHERE ur_id = @UrId;

        -- Step 5: Commit
        COMMIT TRANSACTION;
        SELECT 'SUCCESS' AS Status, 'User rejected successfully.' AS Message;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SELECT 'ERROR' AS Status, ERROR_MESSAGE() AS Message;
    END CATCH
END;

-- SP_SetVerificationFlag
ALTER PROCEDURE SP_SetVerificationFlag
    @UserId INT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE [nsdl].user_registrations
    SET verification_flag = 1
    WHERE ur_id = @UserId;
END;

ALTER PROCEDURE SP_StoreSession
    @SessionId VARCHAR(MAX),
    @UserId INT,
    @Token VARCHAR(MAX),
    @ExpiresAt DATETIME
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO [nsdl].sessions (session_id, user_id, jwt_token, is_active, created_at, expires_at)
    VALUES (@SessionId, @UserId, @Token, 1, GETDATE(), @ExpiresAt);
END;

CREATE PROCEDURE sp_UpdateCertificateDetails
    @application_id INT,
    @cert_serial_no NVARCHAR(255),
    @cert_thumbprint NVARCHAR(255),
    @cert_validdate NVARCHAR(50),
    @cert_subname NVARCHAR(255),
    @userId INT,
    @Success BIT OUTPUT,  -- Output parameter for success/failure
    @ResponseMessage NVARCHAR(255) OUTPUT -- Output parameter for response message
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @asm_id INT;

    
    -- Fetch AMT_ASM_ID based on the user ID
    SELECT @asm_id = CAST(AMT_ASM_ID AS INT) 
    FROM nsdl.ATS_MSTR_TBL 
    WHERE AMT_EmailID = (
        SELECT email_id 
        FROM nsdl.users 
        WHERE user_id = @userId
    );

        -- If no valid asm_id is found, return an error
    IF @asm_id IS NULL
    BEGIN
        SET @Success = 0;
        SET @ResponseMessage = 'ASM ID not found for the given user.';
        RETURN;
    END

    UPDATE nsdl.SELECTED_ATS_BYDDP
    SET 
        certificate_serial_no = @cert_serial_no,
        certificate_thumbprint = @cert_thumbprint,
        certificate_expdate = @cert_validdate,
        certificate_name = @cert_subname,
        IS_VERIFY = 1
    WHERE 
        APPLICATION_ID = @application_id
        AND AMT_ASM_ID = @asm_id;

    IF @@ROWCOUNT = 0
    BEGIN
        SET @Success = 0; -- Failure case
        SET @ResponseMessage = CONCAT('-','No records updated. Please check if application_id and asm_id exist.', @application_id,  @asm_id);
    END
    ELSE
    BEGIN
        SET @Success = 1; -- Success case
        SET @ResponseMessage = 'Certificate details updated successfully.';
    END
END;

-- SP_UpdateDDP
ALTER PROCEDURE SP_UpdateDDP
    @UserRegistrationId INT,
    @DdpId INT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE [nsdl].User_Registration1
    SET ddp = @DdpId, Pending_ddp_flag = 1, modified_dtm = GETDATE()
    WHERE ur_id = @UserRegistrationId;
END;

CREATE PROCEDURE sp_UpdateFVCIRegNo
    @application_id INT,
    @Success BIT OUTPUT,
    @ResponseMessage NVARCHAR(255) OUTPUT

AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @missing_asm_count INT;
    DECLARE @last_serial_no INT;
    DECLARE @new_serial_no INT;
    DECLARE @financial_year NVARCHAR(10);
    DECLARE @new_reg_no NVARCHAR(20);
    -- Check for missing certificate values
    SELECT @missing_asm_count = COUNT(*)
    FROM nsdl.SELECTED_ATS_BYDDP
    WHERE APPLICATION_ID = @application_id
    AND (
        certificate_serial_no IS NULL OR LTRIM(RTRIM(CAST(certificate_serial_no AS NVARCHAR(MAX)))) = ''
        -- OR certificate_thumbprint IS NULL OR LTRIM(RTRIM(CAST(certificate_thumbprint AS NVARCHAR(MAX)))) = ''
        OR certificate_expdate IS NULL OR  LTRIM(RTRIM(CAST(certificate_expdate AS NVARCHAR(MAX)))) = ''
        OR certificate_name IS NULL OR LTRIM(RTRIM(CAST(certificate_name AS NVARCHAR(MAX)))) = ''
    );
      -- Exit early if missing values are found
    IF @missing_asm_count > 0
    BEGIN
        SET @Success = 0;
        SET @ResponseMessage = 'Cannot update reg_no: Some asm_id values still have missing certificate details.';
        RETURN;
    END;
    -- Generate financial year format (e.g., '23-24' for 2023-2024)
    SET @financial_year = RIGHT(YEAR(GETDATE()), 2) + 
                          RIGHT(YEAR(GETDATE()) + 1, 2);
    -- Get the last serial number for the current financial year
    SELECT @last_serial_no = MAX(serial_no)
    FROM nsdl.fvci_applications
    WHERE fvci_registration_number LIKE 'INFVCI' + @financial_year + '%';
    -- Ensure numbering starts from 00001
    SET @new_serial_no = ISNULL(@last_serial_no, 0) + 1;
    -- Construct the new reg_no in the format INFVCI23240001
    SET @new_reg_no = 'INFVCI' + @financial_year + FORMAT(@new_serial_no, '0000');
    -- Update the record
    UPDATE nsdl.fvci_applications
    SET fvci_registration_number = @new_reg_no, serial_no = @new_serial_no
    WHERE application_id = @application_id;

    -- Return success response
    SET @Success = 1;
    SET @ResponseMessage = 'reg_no updated successfully: ' + @new_reg_no;
END;

ALTER PROCEDURE SP_UpdatePassword
    @UserId INT,
    @Password VARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE [nsdl].[users] SET new_password = @Password,is_forget_password = 0, last_pwd_change_dtm = GETDATE() WHERE user_id = @UserId;
END;

ALTER PROCEDURE SP_UpdateRegistrationVerificationFlag
    @UrId INT,
    @VerificationFlag INT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE [nsdl].user_registrations SET verification_flag = @VerificationFlag WHERE ur_id = @UrId;
END;

-- SP_UpdateUserRegistrationPassword
ALTER PROCEDURE SP_UpdateUserRegistrationPassword
    @UserRegistrationId INT,
    @Password VARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE [nsdl].user_registrations
    SET new_password = @Password, modified_dtm = GETDATE()
    WHERE ur_id = @UserRegistrationId;
END;

CREATE PROCEDURE UpdateCertificateDetails
    @application_id INT,
    @asm_id INT,
    @cert_serial_no NVARCHAR(255),
    @cert_thumbprint NVARCHAR(255),
    @cert_validdate NVARCHAR(50),
    @cert_subname NVARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE nsdl.SELECTED_ATS_BYDDP
    SET 
        certificate_serial_no = @cert_serial_no,
        certificate_thumbprint = @cert_thumbprint,
        certificate_expdate = @cert_validdate,
        certificate_name = @cert_subname
    WHERE 
        APPLICATION_ID = @application_id
        AND AMT_ASM_ID = @asm_id;

    IF @@ROWCOUNT = 0
    BEGIN
        PRINT 'No records updated. Please check if application_id and asm_id exist.';
    END
    ELSE
    BEGIN
        PRINT 'Certificate details updated successfully.';
    END
END;

CREATE PROCEDURE UpsertFvciAddressDetails
    @FvciApplicationId NVARCHAR(255),
    @FlatBlockNo NVARCHAR(255),
    @BuildingPremisesVillageName NVARCHAR(255),
    @RoadStreetLaneName NVARCHAR(255),
    @AreaLocalitySubdivision VARCHAR(255),
    @TownCityDistrict VARCHAR(255),
    @ZipCode NVARCHAR(255),
    @State VARCHAR(255),
    @CountryCode VARCHAR(4),
    @TypeOfAddress VARCHAR(255),
    @CreatedAt DATETIME,
    @UpdatedAt DATETIME
AS
BEGIN
    SET NOCOUNT ON;

    MERGE INTO nsdl.draft_fvci_address_details AS target
    USING (SELECT 
                @FvciApplicationId AS fvci_application_id, 
                @FlatBlockNo AS flat_block_no, 
                @BuildingPremisesVillageName AS building_premises_village_name, 
                @RoadStreetLaneName AS road_street_lane_name, 
                @AreaLocalitySubdivision AS area_locality_subdivision, 
                @TownCityDistrict AS town_city_district, 
                @ZipCode AS zip_code, 
                @State AS state, 
                @CountryCode AS countrycode, 
                @TypeOfAddress AS type_of_address, 
                @CreatedAt AS created_at, 
                @UpdatedAt AS updated_at
          ) AS source
    ON target.fvci_application_id = source.fvci_application_id 
       AND target.type_of_address = source.type_of_address
    WHEN MATCHED THEN
        UPDATE SET 
            target.flat_block_no = source.flat_block_no, 
            target.building_premises_village_name = source.building_premises_village_name,
            target.road_street_lane_name = source.road_street_lane_name,
            target.area_locality_subdivision = source.area_locality_subdivision,
            target.town_city_district = source.town_city_district,
            target.zip_code = source.zip_code,
            target.state = source.state,
            target.countrycode = source.countrycode,
            target.updated_at = source.updated_at
    WHEN NOT MATCHED THEN
        INSERT (fvci_application_id, flat_block_no, building_premises_village_name, 
                road_street_lane_name, area_locality_subdivision, town_city_district, 
                zip_code, state, countrycode, type_of_address, created_at, updated_at)
        VALUES (source.fvci_application_id, source.flat_block_no, source.building_premises_village_name, 
                source.road_street_lane_name, source.area_locality_subdivision, source.town_city_district, 
                source.zip_code, source.state, source.countrycode, source.type_of_address, 
                source.created_at, source.updated_at);

END;

CREATE PROCEDURE UpsertFvciBenificialOwnershipByControl
                        @FvciApplicationId NVARCHAR(255),
                        @IsNoEntityControlsThroughVoting BIT,
                        @CreatedAt DATETIME,
                        @UpdatedAt DATETIME
                    AS
                    BEGIN
                        SET NOCOUNT ON;

                        MERGE INTO nsdl.draft_fvci_benificial_ownership_by_control AS target
                        USING (SELECT @FvciApplicationId AS fvci_application_id, 
                                    @IsNoEntityControlsThroughVoting AS is_no_entity_controls_through_voting, 
                                    @CreatedAt AS created_at, 
                                    @UpdatedAt AS updated_at
                            ) AS source
                        ON target.fvci_application_id = source.fvci_application_id
                        WHEN MATCHED THEN
                            UPDATE SET target.is_no_entity_controls_through_voting = source.is_no_entity_controls_through_voting,
                                    target.updated_at = source.updated_at
                        WHEN NOT MATCHED THEN
                            INSERT (fvci_application_id, is_no_entity_controls_through_voting, created_at, updated_at)
                            VALUES (source.fvci_application_id, source.is_no_entity_controls_through_voting, source.created_at, source.updated_at);
                    END;

CREATE PROCEDURE UpsertFvciBenificialOwnershipByControlBoDetails
                            @FvciApplicationId NVARCHAR(255),
                            @NameOfBo NVARCHAR(255),
                            @MethodOfControl NVARCHAR(255),
                            @Country NVARCHAR(255),
                            @ControlPercentage DECIMAL(10,2),
                            @IsIndividual BIT,
                            @CreatedAt DATETIME,
                            @UpdatedAt DATETIME
                        AS
                        BEGIN
                            SET NOCOUNT ON;

                            MERGE INTO nsdl.draft_fvci_benificial_ownership_by_control_bo_details AS target
                            USING (SELECT @FvciApplicationId AS fvci_application_id, 
                                        @NameOfBo AS name_of_bo, 
                                        @MethodOfControl AS method_of_control, 
                                        @Country AS country, 
                                        @ControlPercentage AS control_percentage, 
                                        @IsIndividual AS is_individual, 
                                        @CreatedAt AS created_at, 
                                        @UpdatedAt AS updated_at
                                ) AS source
                            ON target.fvci_application_id = source.fvci_application_id AND target.name_of_bo = source.name_of_bo
                            WHEN MATCHED THEN
                                UPDATE SET target.method_of_control = source.method_of_control,
                                        target.country = source.country,
                                        target.control_percentage = source.control_percentage,
                                        target.is_individual = source.is_individual,
                                        target.updated_at = source.updated_at
                            WHEN NOT MATCHED THEN
                                INSERT (fvci_application_id, name_of_bo, method_of_control, country, control_percentage, is_individual, created_at, updated_at)
                                VALUES (source.fvci_application_id, source.name_of_bo, source.method_of_control, source.country, 
                                        source.control_percentage, source.is_individual, source.created_at, source.updated_at);
                        END;

CREATE PROCEDURE UpsertFvciComplianceOfficerDetails
                            @FvciApplicationId NVARCHAR(255),
                            @Name NVARCHAR(255),
                            @JobTitle NVARCHAR(255),
                            @PhoneNumber NVARCHAR(50),
                            @FaxNumber NVARCHAR(255),
                            @Status NVARCHAR(50),
                            @CreatedAt DATETIME,
                            @UpdatedAt DATETIME
                        AS
                        BEGIN
                            SET NOCOUNT ON;
                            MERGE INTO nsdl.draft_fvci_complaince_officer_details AS target
                            USING (SELECT @FvciApplicationId AS fvci_application_id, 
                                        @Name AS name, 
                                        @JobTitle AS job_title, 
                                        @PhoneNumber AS phone_number, 
                                        @FaxNumber AS fax_number,
                                        @Status AS status, 
                                        @CreatedAt AS created_at, 
                                        @UpdatedAt AS updated_at
                                ) AS source
                            ON target.fvci_application_id = source.fvci_application_id 
                            WHEN MATCHED THEN
                                UPDATE SET target.name = source.name, 
                                        target.job_title = source.job_title,
                                        target.phone_number = source.phone_number,
                                        target.fax_number = source.fax_number,
                                        target.status = source.status,
                                        target.updated_at = source.updated_at
                            WHEN NOT MATCHED THEN
                                INSERT (fvci_application_id, name, job_title, phone_number, fax_number, status, created_at, updated_at)
                                VALUES (source.fvci_application_id, source.name, source.job_title, source.phone_number, source.fax_number, 
                                        source.status, source.created_at, source.updated_at);
                        END;

CREATE PROCEDURE UpsertFvciComplianceOfficerEmail
                            @FvciApplicationId NVARCHAR(255),
                            @Email NVARCHAR(255),
                            @Status NVARCHAR(50),
                            @CreatedAt DATETIME,
                            @UpdatedAt DATETIME
                        AS
                        BEGIN
                            SET NOCOUNT ON;
                            MERGE INTO nsdl.draft_fvci_complaince_officer_emails AS target
                            USING (SELECT @FvciApplicationId AS fvci_application_id, 
                                        @Email AS email, 
                                        @Status AS status, 
                                        @CreatedAt AS created_at, 
                                        @UpdatedAt AS updated_at
                                ) AS source
                            ON target.fvci_application_id = source.fvci_application_id
                            WHEN MATCHED THEN
                                UPDATE SET target.email = source.email,
                                        target.status = source.status,
                                        target.updated_at = source.updated_at
                            WHEN NOT MATCHED THEN
                                INSERT (fvci_application_id, email, status, created_at, updated_at)
                                VALUES (source.fvci_application_id, source.email, source.status, source.created_at, source.updated_at);
                        END;

CREATE PROCEDURE UpsertFvciContactDetails
                            @FvciApplicationId NVARCHAR(255),
                            @FaxNumber NVARCHAR(255),
                            @Website NVARCHAR(500),
                            @MobileNumber NVARCHAR(50),
                            @EmailId NVARCHAR(255),
                            @CreatedAt DATETIME,
                            @UpdatedAt DATETIME
                        AS
                        BEGIN
                            SET NOCOUNT ON;

                            MERGE INTO nsdl.draft_fvci_ekyc_contact_details AS target
                            USING (SELECT @FvciApplicationId AS fvci_application_id, 
                                        @FaxNumber AS fax_number, 
                                        @Website AS website, 
                                        @MobileNumber AS mobile_number, 
                                        @EmailId AS email_id, 
                                        @CreatedAt AS created_at, 
                                        @UpdatedAt AS updated_at
                                ) AS source
                            ON target.fvci_application_id = source.fvci_application_id
                            WHEN MATCHED THEN
                                UPDATE SET target.fax_number = source.fax_number, 
                                        target.website = source.website,
                                        target.mobile_number = source.mobile_number,
                                        target.email_id = source.email_id,
                                        target.updated_at = source.updated_at
                            WHEN NOT MATCHED THEN
                                INSERT (fvci_application_id, fax_number, website, mobile_number, email_id, created_at, updated_at)
                                VALUES (source.fvci_application_id, source.fax_number, source.website, source.mobile_number, source.email_id, source.created_at, source.updated_at);
                        END;

CREATE PROCEDURE UpsertFvciDeclarationUndertakingDetails
                        @FvciApplicationId NVARCHAR(255),
                        @Name NVARCHAR(255),
                        @Capacity NVARCHAR(255),
                        @Date DATE,
                        @Place NVARCHAR(255),
                        @NameOfSignatory NVARCHAR(255),
                        @DesignationOfSignatory NVARCHAR(255),
                        @CreatedAt DATETIME,
                        @UpdatedAt DATETIME
                    AS
                    BEGIN
                        SET NOCOUNT ON;

                        MERGE INTO nsdl.draft_fvci_declaration_undertaking_details AS target
                        USING (SELECT @FvciApplicationId AS fvci_application_id, 
                                    @Name AS name, 
                                    @Capacity AS capacity, 
                                    @Date AS date, 
                                    @Place AS place, 
                                    @NameOfSignatory AS name_of_signatory, 
                                    @DesignationOfSignatory AS designation_of_signatory
                                 
                            ) AS source
                        ON target.fvci_application_id = source.fvci_application_id  -- Ensures only one Declaration per application
                        WHEN MATCHED THEN
                            UPDATE SET target.name = source.name,
                                    target.capacity = source.capacity,
                                    target.date = getdate(),
                                    target.place = source.place,
                                    target.name_of_signatory = source.name_of_signatory,
                                    target.designation_of_signatory = source.designation_of_signatory   
                        WHEN NOT MATCHED THEN
                            INSERT (fvci_application_id, name, capacity, date, place, name_of_signatory, designation_of_signatory)
                            VALUES (source.fvci_application_id, source.name, source.capacity, getdate(), source.place, 
                                    source.name_of_signatory, source.designation_of_signatory);
                    END;

CREATE PROCEDURE UpsertFvciEkycBenificialOwnerDetails
                            @Id INT = NULL,
                            @FvciApplicationId NVARCHAR(255),
                            @NameAddress NVARCHAR(500),
                            @DateOfBirth DATE,
                            @TaxResidancyJuridication NVARCHAR(255),
                            @Nationality NVARCHAR(255),
                            @ActingAlongPersonGroupNameAddress NVARCHAR(500),
                            @BoOwnershipInFvci DECIMAL(10,2),
                            @GovermentDocIdentityNumber NVARCHAR(255),
                            @Status NVARCHAR(50),
                            @CreatedAt DATETIME,
                            @UpdatedAt DATETIME
                        AS
                        BEGIN
                            SET NOCOUNT ON;

                            MERGE INTO nsdl.draft_fvci_ekyc_benificial_owner_details AS target
                            USING (
                                SELECT 
                                    @Id AS id, 
                                    @FvciApplicationId AS fvci_application_id,
                                    @NameAddress AS name_address, 
                                    @DateOfBirth AS date_of_birth, 
                                    @TaxResidancyJuridication AS tax_residancy_juridication, 
                                    @Nationality AS natinality, 
                                    @ActingAlongPersonGroupNameAddress AS acting_alonng_person_group_name_address, 
                                    @BoOwnershipInFvci AS bo_ownership_in_fvci, 
                                    @GovermentDocIdentityNumber AS giverment_doc_identity_number, 
                                    @Status AS status, 
                                    @CreatedAt AS created_at, 
                                    @UpdatedAt AS updated_at
                            ) AS source
                            ON target.id = source.id
                            WHEN MATCHED THEN
                                UPDATE SET target.fvci_application_id = source.fvci_application_id,
                                        target.name_address = source.name_address,
                                        target.date_of_birth = source.date_of_birth,
                                        target.tax_residancy_juridication = source.tax_residancy_juridication,
                                        target.natinality = source.natinality,
                                        target.acting_alonng_person_group_name_address = source.acting_alonng_person_group_name_address,
                                        target.bo_ownership_in_fvci = source.bo_ownership_in_fvci,
                                        target.giverment_doc_identity_number = source.giverment_doc_identity_number,
                                        target.status = source.status,
                                        target.updated_at = source.updated_at
                            WHEN NOT MATCHED THEN
                                INSERT (fvci_application_id, name_address, date_of_birth, tax_residancy_juridication, natinality, 
                                        acting_alonng_person_group_name_address, bo_ownership_in_fvci, giverment_doc_identity_number, status, created_at, updated_at)
                                VALUES (source.fvci_application_id, source.name_address, source.date_of_birth, source.tax_residancy_juridication, 
                                        source.natinality, source.acting_alonng_person_group_name_address, source.bo_ownership_in_fvci, 
                                        source.giverment_doc_identity_number, source.status, source.created_at, source.updated_at);
                        END;

CREATE PROCEDURE UpsertFvciGlobalCustodianDetails
                        @FvciApplicationId NVARCHAR(255),
                        @Name NVARCHAR(255),
                        @Country NVARCHAR(255),
                        @RegistrationNumber NVARCHAR(255),
                        @Address NVARCHAR(500),
                        @CreatedAt DATETIME,
                        @UpdatedAt DATETIME
                    AS
                    BEGIN
                        SET NOCOUNT ON;

                        MERGE INTO nsdl.draft_fvci_global_custodian_details AS target
                        USING (SELECT @FvciApplicationId AS fvci_application_id, 
                                    @Name AS name, 
                                    @Country AS country, 
                                    @RegistrationNumber AS registration_number, 
                                    @Address AS address, 
                                    @CreatedAt AS created_at, 
                                    @UpdatedAt AS updated_at
                            ) AS source
                        ON target.fvci_application_id = source.fvci_application_id  -- Ensures only one Global Custodian per application
                        WHEN MATCHED THEN
                            UPDATE SET target.name = source.name,
                                    target.country = source.country,
                                    target.registration_number = source.registration_number,
                                    target.address = source.address,
                                    target.updated_at = source.updated_at
                        WHEN NOT MATCHED THEN
                            INSERT (fvci_application_id, name, country, registration_number, address, created_at, updated_at)
                            VALUES (source.fvci_application_id, source.name, source.country, source.registration_number, 
                                    source.address, source.created_at, source.updated_at);
                    END;

CREATE PROCEDURE UpsertFvciIncidentsOfLawViolation
                            @FvciApplicationId NVARCHAR(255),
                            @Description NVARCHAR(MAX),
                            @CreatedAt DATETIME,
                            @UpdatedAt DATETIME
                        AS
                        BEGIN
                            SET NOCOUNT ON;

                            MERGE INTO nsdl.draft_fvci_incidents_of_law_voilation AS target
                            USING (SELECT @FvciApplicationId AS fvci_application_id, 
                                        @Description AS description, 
                                        @CreatedAt AS created_at, 
                                        @UpdatedAt AS updated_at
                                ) AS source
                            ON target.fvci_application_id = source.fvci_application_id
                            WHEN MATCHED THEN
                                UPDATE SET target.description = source.description,
                                        target.updated_at = source.updated_at
                            WHEN NOT MATCHED THEN
                                INSERT (fvci_application_id, description, created_at, updated_at)
                                VALUES (source.fvci_application_id, source.description, source.created_at, source.updated_at);
                        END;

CREATE PROCEDURE UpsertFvciIncomeDetails
                    @FvciApplicationId NVARCHAR(255),
                    @SourceOfIncome NVARCHAR(255),
                    @CodeOfBusiness NVARCHAR(255),
                    @GrossAnnualIncome FLOAT,
                    @NetWorth FLOAT,
                    @AsOnDate DATE,
                    @Status INT,
                    @CreatedAt DATETIME,
                    @UpdatedAt DATETIME
                        AS
                        BEGIN
                            SET NOCOUNT ON;

                            MERGE INTO nsdl.draft_fvci_income_details AS target
                            USING (
                                SELECT 
                                    @FvciApplicationId AS fvci_application_id, 
                                    @SourceOfIncome AS source_of_income, 
                                    @CodeOfBusiness AS code_of_business, 
                                    @GrossAnnualIncome AS gross_annual_income, 
                                    @NetWorth AS net_worth, 
                                    @AsOnDate AS as_on_date, 
                                    @Status AS status, 
                                    @CreatedAt AS created_at, 
                                    @UpdatedAt AS updated_at
                            ) AS source
                            ON target.fvci_application_id = source.fvci_application_id and target.source_of_income = source.source_of_income and target.code_of_business= source.code_of_business
                            WHEN MATCHED THEN
                                UPDATE SET target.source_of_income = source.source_of_income,
                                        target.code_of_business = source.code_of_business,
                                        target.gross_annual_income = source.gross_annual_income,
                                        target.net_worth = source.net_worth,
                                        target.as_on_date = source.as_on_date,
                                        target.status = source.status,
                                        target.updated_at = source.updated_at
                            WHEN NOT MATCHED THEN
                                INSERT (fvci_application_id, source_of_income, code_of_business, gross_annual_income, net_worth, as_on_date, status, created_at, updated_at)
                                VALUES (source.fvci_application_id, source.source_of_income, source.code_of_business, source.gross_annual_income, 
                                        source.net_worth, source.as_on_date, source.status, source.created_at, source.updated_at);
                        END;

CREATE PROCEDURE UpsertFvciIndianMarketAssocians
                            @FvciApplicationId NVARCHAR(255),
                            @Name NVARCHAR(255),
                            @AssociatedAs NVARCHAR(255),
                            @RegistrationNumber NVARCHAR(255),
                            @PeriodOfRegistration NVARCHAR(255),
                            @CreatedAt DATETIME,
                            @UpdatedAt DATETIME
                        AS
                        BEGIN
                            SET NOCOUNT ON;
                            MERGE INTO nsdl.draft_fvci_indian_market_associans AS target
                            USING (SELECT @FvciApplicationId AS fvci_application_id, 
                                        @Name AS name, 
                                        @AssociatedAs AS associated_as, 
                                        @RegistrationNumber AS registration_number, 
                                        @PeriodOfRegistration AS period_of_registration, 
                                        @CreatedAt AS created_at, 
                                        @UpdatedAt AS updated_at
                                ) AS source
                            ON target.fvci_application_id = source.fvci_application_id
                            WHEN MATCHED THEN
                                UPDATE SET target.name = source.name,
                                        target.associated_as = source.associated_as,
                                        target.registration_number = source.registration_number,
                                        target.period_of_registration = source.period_of_registration,
                                        target.updated_at = source.updated_at
                            WHEN NOT MATCHED THEN
                                INSERT (fvci_application_id, name, associated_as, registration_number, period_of_registration, created_at, updated_at)
                                VALUES (source.fvci_application_id, source.name, source.associated_as, source.registration_number, 
                                        source.period_of_registration, source.created_at, source.updated_at);
                        END;

CREATE PROCEDURE UpsertFvciInfoBasicOfOwnershipBoDetails
                        @FvciApplicationId NVARCHAR(255),
                        @NameOfBo NVARCHAR(255),
                        @Stake NVARCHAR(255),
                        @NameOfEntity NVARCHAR(255),
                        @Country NVARCHAR(255),
                        @StakePercentage DECIMAL(10,2),
                        @IsIndividual BIT,
                        @CreatedAt DATETIME,
                        @UpdatedAt DATETIME
                    AS
                    BEGIN
                        SET NOCOUNT ON;

                        MERGE INTO nsdl.draft_fvci_info_basic_of_ownership_bo_details AS target
                        USING (SELECT @FvciApplicationId AS fvci_application_id, 
                                    @NameOfBo AS name_of_bo, 
                                    @Stake AS stake, 
                                    @NameOfEntity AS name_of_entity, 
                                    @Country AS country, 
                                    @StakePercentage AS stake_percentage, 
                                    @IsIndividual AS is_individual, 
                                    @CreatedAt AS created_at, 
                                    @UpdatedAt AS updated_at
                            ) AS source
                        ON target.fvci_application_id = source.fvci_application_id AND target.name_of_bo = source.name_of_bo
                        WHEN MATCHED THEN
                            UPDATE SET target.stake = source.stake,
                                    target.name_of_entity = source.name_of_entity,
                                    target.country = source.country,
                                    target.stake_percentage = source.stake_percentage,
                                    target.is_individual = source.is_individual,
                                    target.updated_at = source.updated_at
                        WHEN NOT MATCHED THEN
                            INSERT (fvci_application_id, name_of_bo, stake, name_of_entity, country, stake_percentage, is_individual, created_at, updated_at)
                            VALUES (source.fvci_application_id, source.name_of_bo, source.stake, source.name_of_entity, 
                                    source.country, source.stake_percentage, source.is_individual, source.created_at, source.updated_at);
                    END;

CREATE PROCEDURE UpsertFvciInformationOfSaSmFvciApplicant
                        @FvciApplicationId NVARCHAR(255),
                        @Name NVARCHAR(255),
                        @RelationshipWithApplicant NVARCHAR(255),
                        @Pan NVARCHAR(50),
                        @Country NVARCHAR(255),
                        @DateOfBirth DATE,
                        @Address NVARCHAR(500),
                        @GovermentId NVARCHAR(255),
                        @CreatedAt DATETIME,
                        @UpdatedAt DATETIME
                    AS
                    BEGIN
                        SET NOCOUNT ON;

                        MERGE INTO nsdl.draft_fvci_information_of_sa_sm_fvci_applicant AS target
                        USING (SELECT @FvciApplicationId AS fvci_application_id, 
                                    @Name AS name, 
                                    @RelationshipWithApplicant AS relationship_with_applicant, 
                                    @Pan AS pan, 
                                    @Country AS country, 
                                    @DateOfBirth AS date_of_birth, 
                                    @Address AS address, 
                                    @GovermentId AS goverment_id, 
                                    @CreatedAt AS created_at, 
                                    @UpdatedAt AS updated_at
                            ) AS source
                        ON target.fvci_application_id = source.fvci_application_id and target.name=source.name
                        WHEN MATCHED THEN
                            UPDATE SET target.name = source.name,
                                    target.relationship_with_applicant = source.relationship_with_applicant,
                                    target.pan = source.pan,
                                    target.country = source.country,
                                    target.date_of_birth = source.date_of_birth,
                                    target.address = source.address,
                                    target.goverment_id = source.goverment_id,
                                    target.updated_at = source.updated_at
                        WHEN NOT MATCHED THEN
                            INSERT (fvci_application_id, name, relationship_with_applicant, pan, country, date_of_birth, address, goverment_id, created_at, updated_at)
                            VALUES (source.fvci_application_id, source.name, source.relationship_with_applicant, source.pan, source.country, 
                                    source.date_of_birth, source.address, source.goverment_id, source.created_at, source.updated_at);
                    END;

CREATE PROCEDURE UpsertFvciInvestmentManagerDetails
                            @FvciApplicationId NVARCHAR(255),
                            @Name NVARCHAR(255),
                            @Type NVARCHAR(100),
                            @Country NVARCHAR(255),
                            @PhoneNumber NVARCHAR(50),
                            @FaxNumber NVARCHAR(50),
                            @Email NVARCHAR(255),
                            @Status NVARCHAR(50),
                            @CreatedAt DATETIME,
                            @UpdatedAt DATETIME
                        AS
                        BEGIN
                            SET NOCOUNT ON;

                            MERGE INTO nsdl.draft_fvci_investment_manager_details AS target
                            USING (SELECT @FvciApplicationId AS fvci_application_id, 
                                        @Name AS name, 
                                        @Type AS type, 
                                        @Country AS country, 
                                        @PhoneNumber AS phone_number, 
                                        @FaxNumber AS fax_number, 
                                        @Email AS email, 
                                        @Status AS status, 
                                        @CreatedAt AS created_at, 
                                        @UpdatedAt AS updated_at
                                ) AS source
                            ON target.fvci_application_id = source.fvci_application_id 
                            WHEN MATCHED THEN
                                UPDATE SET target.name = source.name, 
                                        target.type = source.type,
                                        target.country = source.country,
                                        target.phone_number = source.phone_number,
                                        target.fax_number = source.fax_number,
                                        target.email = source.email,
                                        target.status = source.status,
                                        target.updated_at = source.updated_at
                            WHEN NOT MATCHED THEN
                                INSERT (fvci_application_id, name, type, country, phone_number, fax_number, email, status, created_at, updated_at)
                                VALUES (source.fvci_application_id, source.name, source.type, source.country, source.phone_number, 
                                        source.fax_number, source.email, source.status, source.created_at, source.updated_at);
                        END;

CREATE PROCEDURE UpsertFvciIsBank
                        @FvciApplicationId NVARCHAR(255),
                        @IsBank BIT,
                        @NameOfBank NVARCHAR(255),
                        @HaveOfficeInIndia BIT,
                        @CreatedAt DATETIME,
                        @UpdatedAt DATETIME
                    AS
                    BEGIN
                        SET NOCOUNT ON;

                        MERGE INTO nsdl.draft_fvci_is_bank AS target
                        USING (SELECT @FvciApplicationId AS fvci_application_id, 
                                    @IsBank AS is_bank, 
                                    @NameOfBank AS name_of_bank, 
                                    @HaveOfficeInIndia AS have_office_in_india, 
                                    @CreatedAt AS created_at, 
                                    @UpdatedAt AS updated_at
                            ) AS source
                        ON target.fvci_application_id = source.fvci_application_id
                        WHEN MATCHED THEN
                            UPDATE SET target.is_bank = source.is_bank,
                                    target.name_of_bank = source.name_of_bank,
                                    target.have_office_in_india = source.have_office_in_india,
                                    target.updated_at = source.updated_at
                        WHEN NOT MATCHED THEN
                            INSERT (fvci_application_id, is_bank, name_of_bank, have_office_in_india, created_at, updated_at)
                            VALUES (source.fvci_application_id, source.is_bank, source.name_of_bank, 
                                    source.have_office_in_india, source.created_at, source.updated_at);
                    END;

CREATE PROCEDURE UpsertFvciKraPermission
                            @FvciApplicationId NVARCHAR(255),
                            @IsKraRequired BIT,
                            @NameOfFvciRepresentative NVARCHAR(255),
                            @Email1 NVARCHAR(255),
                            @Email2 NVARCHAR(255),
                            @Email3 NVARCHAR(255),
                            @PhoneNumber NVARCHAR(50),
                            @CreatedAt DATETIME,
                            @UpdatedAt DATETIME
                        AS
                        BEGIN
                            SET NOCOUNT ON;

                            MERGE INTO nsdl.draft_fvci_kra_for_permission_to_download_kyc_doc AS target
                            USING (SELECT @FvciApplicationId AS fvci_application_id, 
                                        @IsKraRequired AS is_kra_required, 
                                        @NameOfFvciRepresentative AS name_of_fvci_represntative, 
                                        @Email1 AS email_1, 
                                        @Email2 AS email_2, 
                                        @Email3 AS email_3, 
                                        @PhoneNumber AS phone_number, 
                                        @CreatedAt AS created_at, 
                                        @UpdatedAt AS updated_at
                                ) AS source
                            ON target.fvci_application_id = source.fvci_application_id
                            WHEN MATCHED THEN
                                UPDATE SET target.is_kra_required = source.is_kra_required,
                                        target.name_of_fvci_represntative = source.name_of_fvci_represntative,
                                        target.email_1 = source.email_1,
                                        target.email_2 = source.email_2,
                                        target.email_3 = source.email_3,
                                        target.phone_number = source.phone_number,
                                        target.updated_at = source.updated_at
                            WHEN NOT MATCHED THEN
                                INSERT (fvci_application_id, is_kra_required, name_of_fvci_represntative, email_1, email_2, email_3, phone_number, created_at, updated_at)
                                VALUES (source.fvci_application_id, source.is_kra_required, source.name_of_fvci_represntative, 
                                        source.email_1, source.email_2, source.email_3, source.phone_number, 
                                        source.created_at, source.updated_at);
                        END;

CREATE PROCEDURE UpsertFvciKycDetails
                        @FvciApplicationId NVARCHAR(255),
                        @Name NVARCHAR(255),
                        @HasOtherName BIT,
                        @OtherName NVARCHAR(255),
                        @DateOfIncorporation DATE,
                        @DateOfCommencement DATE,
                        @PlaceOfIncorporation NVARCHAR(255),
                        @CountryOfIncorporation NVARCHAR(255),
                        @IsdCountryCodeOfIncorporation NVARCHAR(50),
                        @LegalFormAndLawOfIncorporation NVARCHAR(500),
                        @LegalEntityIdentifier NVARCHAR(255),
                        @AddressOfCommunication NVARCHAR(500),
                        @HaveOfficeInIndia BIT,
                        @BenificialOwnershipHolding DECIMAL(10,2),
                        @DoesOtherPersonHolderOwnership BIT,
                        @IsPoliticallyExposed BIT,
                        @IsRelatedToPoliticallyExposed BIT,
                        @CreatedAt DATETIME,
                        @UpdatedAt DATETIME
                    AS
                    BEGIN
                        SET NOCOUNT ON;

                        MERGE INTO nsdl.draft_fvic_kyc_details AS target
                        USING (SELECT @FvciApplicationId AS fvci_application_id, 
                                    @Name AS name, 
                                    @HasOtherName AS has_other_name, 
                                    @OtherName AS other_name, 
                                    @DateOfIncorporation AS date_of_incorporation, 
                                    @DateOfCommencement AS date_of_commencement, 
                                    @PlaceOfIncorporation AS place_of_incorporation, 
                                    @CountryOfIncorporation AS country_of_incorporation, 
                                    @IsdCountryCodeOfIncorporation AS isd_country_code_of_incorportation, 
                                    @LegalFormAndLawOfIncorporation AS legal_form_and_law_of_incorporation, 
                                    @LegalEntityIdentifier AS legal_entity_identifier, 
                                    @AddressOfCommunication AS address_of_cummunication, 
                                    @HaveOfficeInIndia AS have_office_in_india, 
                                    @BenificialOwnershipHolding AS benificial_ownership_holding, 
                                    @DoesOtherPersonHolderOwnership AS does_other_person_holder_ownership, 
                                    @IsPoliticallyExposed AS is_politically_exposed, 
                                    @IsRelatedToPoliticallyExposed AS is_related_to_politically_exposed, 
                                    @CreatedAt AS created_at, 
                                    @UpdatedAt AS updated_at
                            ) AS source
                        ON target.fvci_application_id = source.fvci_application_id
                        WHEN MATCHED THEN
                            UPDATE SET target.name = source.name,
                                    target.has_other_name = source.has_other_name,
                                    target.other_name = source.other_name,
                                    target.date_of_incorporation = source.date_of_incorporation,
                                    target.date_of_commencement = source.date_of_commencement,
                                    target.place_of_incorporation = source.place_of_incorporation,
                                    target.country_of_incorporation = source.country_of_incorporation,
                                    target.isd_country_code_of_incorportation = source.isd_country_code_of_incorportation,
                                    target.legal_form_and_law_of_incorporation = source.legal_form_and_law_of_incorporation,
                   target.legal_entity_identifier = source.legal_entity_identifier,
                                    target.address_of_cummunication = source.address_of_cummunication,
                                    target.have_office_in_india = source.have_office_in_india,
                                    target.benificial_ownership_holding = source.benificial_ownership_holding,
                                    target.does_other_person_holder_ownership = source.does_other_person_holder_ownership,
                                    target.is_politically_exposed = source.is_politically_exposed,
                                    target.is_related_to_politically_exposed = source.is_related_to_politically_exposed,
                                    target.updated_at = source.updated_at
                        WHEN NOT MATCHED THEN
                            INSERT (fvci_application_id, name, has_other_name, other_name, date_of_incorporation, 
                                    date_of_commencement, place_of_incorporation, country_of_incorporation, 
                                    isd_country_code_of_incorportation, legal_form_and_law_of_incorporation, 
                                    legal_entity_identifier, address_of_cummunication, have_office_in_india, 
                                    benificial_ownership_holding, does_other_person_holder_ownership, 
                                    is_politically_exposed, is_related_to_politically_exposed, created_at, updated_at)
                            VALUES (source.fvci_application_id, source.name, source.has_other_name, source.other_name, 
                                    source.date_of_incorporation, source.date_of_commencement, source.place_of_incorporation, 
                                    source.country_of_incorporation, source.isd_country_code_of_incorportation, 
                                    source.legal_form_and_law_of_incorporation, source.legal_entity_identifier, 
                                    source.address_of_cummunication, source.have_office_in_india, source.benificial_ownership_holding, 
                                    source.does_other_person_holder_ownership, source.is_politically_exposed, 
                                    source.is_related_to_politically_exposed, source.created_at, source.updated_at);
                    END;

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

                            MERGE INTO nsdl.draft_fvci_kyc_documents AS target
                            USING (SELECT @FvciApplicationId AS fvci_application_id, 
                                        @DocumentType AS document_type, 
                                        @DocumentIdentifier AS document_identifier, 
                                        @DocumentPath AS document_path, 
                                        @Status AS status, 
                                        @CreatedAt AS created_at, 
                                        @UpdatedAt AS updated_at
                                ) AS source
                            ON target.fvci_application_id = source.fvci_application_id 
                            AND target.document_identifier = source.document_identifier -- Ensures unique document per application
                            WHEN MATCHED THEN
                                UPDATE SET target.document_path = source.document_path,
                                        target.status = source.status,
                                        target.updated_at = source.updated_at
                            WHEN NOT MATCHED THEN
                                INSERT (fvci_application_id, document_type, document_identifier, document_path, status, created_at, updated_at)
                                VALUES (source.fvci_application_id, source.document_type, source.document_identifier, 
                                        source.document_path, source.status, source.created_at, source.updated_at);
                    END;

CREATE PROCEDURE UpsertFvciKycLeiDetails
                        @FvciApplicationId NVARCHAR(255),
                        @TrcNumber NVARCHAR(255),
                        @CountryOfTaxResidence NVARCHAR(255),
                        @CreatedAt DATETIME,
                        @UpdatedAt DATETIME
                    AS
                    BEGIN
                        SET NOCOUNT ON;

                        MERGE INTO nsdl.draft_fvci_kyc_lei_details AS target
                        USING (SELECT @FvciApplicationId AS fvci_application_id, 
                                    @TrcNumber AS trc_number, 
                                    @CountryOfTaxResidence AS country_of_tax_residence, 
                                    @CreatedAt AS created_at, 
                                    @UpdatedAt AS updated_at
                            ) AS source
                        ON target.fvci_application_id = source.fvci_application_id 
                        AND (target.country_of_tax_residence = source.country_of_tax_residence
                        OR target.trc_number = source.trc_number)
                        WHEN MATCHED THEN
                            UPDATE SET target.trc_number = source.trc_number, 
                                    target.updated_at = source.updated_at
                        WHEN NOT MATCHED THEN
                            INSERT (fvci_application_id, trc_number, country_of_tax_residence, created_at, updated_at)
                            VALUES (source.fvci_application_id, source.trc_number, source.country_of_tax_residence, source.created_at, source.updated_at);
                    END;

CREATE PROCEDURE UpsertFvciOwnershipDetails
                        @FvciApplicationId NVARCHAR(255),
                        @IsNoEntityHoldingGt BIT,
                        @EntityHolding NVARCHAR(255),
                        @CreatedAt DATETIME,
                        @UpdatedAt DATETIME
                    AS
                    BEGIN
                        SET NOCOUNT ON;

                        MERGE INTO nsdl.draft_fvci_info_basic_of_ownership_details AS target
                        USING (SELECT @FvciApplicationId AS fvci_application_id, 
                                    @IsNoEntityHoldingGt AS is_no_entity_holding_gt, 
                                    @EntityHolding AS entity_holding, 
                                    @CreatedAt AS created_at, 
                                    @UpdatedAt AS updated_at
                            ) AS source
                        ON target.fvci_application_id = source.fvci_application_id
                        WHEN MATCHED THEN
                            UPDATE SET target.is_no_entity_holding_gt = source.is_no_entity_holding_gt,
                                    target.entity_holding = source.entity_holding,
                                    target.updated_at = source.updated_at
                        WHEN NOT MATCHED THEN
                            INSERT (fvci_application_id, is_no_entity_holding_gt, entity_holding, created_at, updated_at)
                            VALUES (source.fvci_application_id, source.is_no_entity_holding_gt, source.entity_holding, source.created_at, source.updated_at);
                    END;

CREATE PROCEDURE UpsertFvciRegistrationDetails
                        @FvciApplicationId NVARCHAR(255),
                        @TypeOfApplicant NVARCHAR(255),
                        @OtherTypeOfApplicant NVARCHAR(255),
                        @TypeOfEntity NVARCHAR(255),
                        @IsProvidedFactaCrsProvided BIT,
                        @IsComingFromGlobalCustodian BIT,
                        @DdpName NVARCHAR(255),
                        @DdpRegistrationNumber NVARCHAR(255),
                        @CustodianName NVARCHAR(255),
                        @CustodianRegistrationNumber NVARCHAR(255),
                        @DpName NVARCHAR(255),
                        @DpRegistrationNumber NVARCHAR(255),
                        @BankName NVARCHAR(255),
                        @BankAddress NVARCHAR(500),
                        @IsAssociatedWithSecuritiesMarket BIT,
                        @DetailsOfPriorAssociation NVARCHAR(255),
                        @DoesHoldPan BIT,
                        @PanNumber NVARCHAR(50),
                        @IsViolatedLaw BIT,
                        @CreatedAt DATETIME,
                        @UpdatedAt DATETIME
                    AS
                    BEGIN
                        SET NOCOUNT ON;

                        MERGE INTO nsdl.draft_fvic_registration_details AS target
                        USING (SELECT @FvciApplicationId AS fvci_application_id, 
                                    @TypeOfApplicant AS type_of_applicant, 
                                    @OtherTypeOfApplicant AS other_type_of_applicant, 
                                    @TypeOfEntity AS type_of_entity, 
                                    @IsProvidedFactaCrsProvided AS is_provided_facta_crs_provided, 
                                    @IsComingFromGlobalCustodian AS is_coming_from_global_custodian, 
                                    @DdpName AS ddp_name, 
                                    @DdpRegistrationNumber AS ddp_registration_number, 
                                    @CustodianName AS custodian_name, 
                                    @CustodianRegistrationNumber AS custodian_registration_number, 
                                    @DpName AS dp_name, 
                                    @DpRegistrationNumber AS dp_registration_number, 
                                    @BankName AS bank_name, 
                                    @BankAddress AS bank_address, 
                                    @IsAssociatedWithSecuritiesMarket AS is_associated_with_securities_market, 
                                    @DetailsOfPriorAssociation AS details_of_prior_association,
                                    @DoesHoldPan AS does_hold_pan, 
                                    @PanNumber AS pan_number, 
                                    @IsViolatedLaw AS is_violated_law, 
                                    @CreatedAt AS created_at, 
                                    @UpdatedAt AS updated_at
                            ) AS source
                        ON target.fvci_application_id = source.fvci_application_id
                        WHEN MATCHED THEN
                            UPDATE SET target.type_of_applicant = source.type_of_applicant,
                                    target.other_type_of_applicant = source.other_type_of_applicant,
                                    target.type_of_entity = source.type_of_entity,
                                    target.is_provided_facta_crs_provided = source.is_provided_facta_crs_provided,
                                    target.is_coming_from_global_custodian = source.is_coming_from_global_custodian,
                                    target.ddp_name = source.ddp_name,
                                    target.ddp_registration_number = source.ddp_registration_number,
                                    target.custodian_name = source.custodian_name,
         target.custodian_registration_number = source.custodian_registration_number,
                                    target.dp_name = source.dp_name,
                                    target.dp_registration_number = source.dp_registration_number,
                                    target.bank_name = source.bank_name,
                                    target.bank_address = source.bank_address,
                                    target.is_associated_with_securities_market = source.is_associated_with_securities_market,
                                    target.details_of_prior_association=source.details_of_prior_association,
                                    target.does_hold_pan = source.does_hold_pan,
                                    target.pan_number = source.pan_number,
                                    target.is_violated_law = source.is_violated_law,
                                    target.updated_at = source.updated_at
                        WHEN NOT MATCHED THEN
                            INSERT (fvci_application_id, type_of_applicant, other_type_of_applicant, type_of_entity, is_provided_facta_crs_provided, 
                                    is_coming_from_global_custodian, ddp_name, ddp_registration_number, custodian_name, custodian_registration_number, 
                                    dp_name, dp_registration_number, bank_name, bank_address, is_associated_with_securities_market, details_of_prior_association, does_hold_pan, 
                                    pan_number, is_violated_law, created_at, updated_at)
                            VALUES (source.fvci_application_id, source.type_of_applicant, source.other_type_of_applicant, source.type_of_entity, 
                                    source.is_provided_facta_crs_provided, source.is_coming_from_global_custodian, source.ddp_name, 
                                    source.ddp_registration_number, source.custodian_name, source.custodian_registration_number, source.dp_name, 
                                    source.dp_registration_number, source.bank_name, source.bank_address, source.is_associated_with_securities_market,
                                    source.details_of_prior_association, source.does_hold_pan, source.pan_number, source.is_violated_law, source.created_at, source.updated_at);
                    END;

CREATE PROCEDURE UpsertFvciRegulatoryAuthorityDetails
                        @FvciApplicationId NVARCHAR(255),
                        @RegulatoryAuthorityName NVARCHAR(255),
                        @RegulatoryAuthorityCountry NVARCHAR(255),
                        @RegulatoryAuthorityWebsite NVARCHAR(500),
                        @RegulatoryAuthorityRegNumber NVARCHAR(255),
                        @RegulatoryAuthorityCategory NVARCHAR(255),
                        @CreatedAt DATETIME,
                        @UpdatedAt DATETIME
                    AS
                    BEGIN
                        SET NOCOUNT ON;

                        MERGE INTO nsdl.draft_fvci_regulatory_authority_details AS target
                        USING (SELECT @FvciApplicationId AS fvci_application_id, 
                                    @RegulatoryAuthorityName AS regulatory_authority_name, 
                                    @RegulatoryAuthorityCountry AS regulatory_authority_country, 
                                    @RegulatoryAuthorityWebsite AS regulatory_authority_website, 
                                    @RegulatoryAuthorityRegNumber AS regulatory_authority_reg_number, 
                                    @RegulatoryAuthorityCategory AS regulatory_authority_category, 
                                    @CreatedAt AS created_at, 
                                    @UpdatedAt AS updated_at
                            ) AS source
                        ON target.fvci_application_id = source.fvci_application_id  -- Ensures only one authority per application
                        WHEN MATCHED THEN
                            UPDATE SET target.regulatory_authority_name = source.regulatory_authority_name,
                                    target.regulatory_authority_country = source.regulatory_authority_country,
                                    target.regulatory_authority_website = source.regulatory_authority_website,
                                    target.regulatory_authority_category = source.regulatory_authority_category,
                                    target.updated_at = source.updated_at
                        WHEN NOT MATCHED THEN
                            INSERT (fvci_application_id, regulatory_authority_name, regulatory_authority_country, 
                                    regulatory_authority_website, regulatory_authority_reg_number, regulatory_authority_category, 
                                    created_at, updated_at)
                            VALUES (source.fvci_application_id, source.regulatory_authority_name, source.regulatory_authority_country, 
                                    source.regulatory_authority_website, source.regulatory_authority_reg_number, 
                                    source.regulatory_authority_category, source.created_at, source.updated_at);
                    END;

CREATE PROCEDURE UpsertFvciSubClassBenificialOwnerDetails
                        @FvciSubClassDetailsId INT,
                        @Name NVARCHAR(500),
                        @RelationshipWithApplicant NVARCHAR(255),
                        @PAN NVARCHAR(50),
                        @Nationality NVARCHAR(255),
                        @DateOfBirth DATE,
                        @ResidentialAddress NVARCHAR(255),
                        @GovernmentDocIdentityNumber NVARCHAR(255),
                        @Status INT,
                        @CreatedAt DATETIME,
                        @UpdatedAt DATETIME
                    AS
                    BEGIN
                        SET NOCOUNT ON;

                        MERGE INTO nsdl.draft_fvci_sub_class_benificial_owner_details AS target
                        USING (
                            SELECT 
                                @FvciSubClassDetailsId AS fvci_sub_class_details_id,
                                @Name AS name,
                                @RelationshipWithApplicant AS relationship_with_applicant,
                                @PAN AS pan,
                                @Nationality AS nationality,
                                @DateOfBirth AS date_of_birth,
                                @ResidentialAddress AS residential_address,
                                @GovernmentDocIdentityNumber AS government_doc_identity_number,
                                @Status AS status,
                                @CreatedAt AS created_at,
                                @UpdatedAt AS updated_at
                        ) AS source
                        ON target.fvci_sub_class_details_id = source.fvci_sub_class_details_id
                        AND target.name = source.name
                        AND target.pan = source.pan
                        WHEN MATCHED THEN
                            UPDATE SET 
                                target.relationship_with_applicant = source.relationship_with_applicant,
                                target.nationality = source.nationality,
                                target.date_of_birth = source.date_of_birth,
                                target.residential_address = source.residential_address,
                                target.government_doc_identity_number = source.government_doc_identity_number,
                                target.status = source.status,
                                target.updated_at = source.updated_at
                        WHEN NOT MATCHED THEN
                            INSERT (
                                fvci_sub_class_details_id, 
                                name, 
                                relationship_with_applicant, 
                                pan, 
                                nationality, 
                                date_of_birth, 
                                residential_address, 
                                government_doc_identity_number, 
                                status, 
                                created_at, 
                                updated_at
                            )
                            VALUES (
                                source.fvci_sub_class_details_id, 
                                source.name, 
                                source.relationship_with_applicant, 
                                source.pan, 
                                source.nationality, 
                                source.date_of_birth, 
                                source.residential_address, 
                                source.government_doc_identity_number, 
                                source.status, 
                                source.created_at, 
                                source.updated_at
                            );
                    END;

CREATE PROCEDURE UpsertFvciSubClassDetails
                        @FvciApplicationId NVARCHAR(255),
                        @Name NVARCHAR(255),
                        @CreatedAt DATETIME,
                        @UpdatedAt DATETIME,
                        @FvciSubClassDetailsId INT OUTPUT
                    AS
                    BEGIN
                        SET NOCOUNT ON;

                        MERGE INTO nsdl.draft_fvci_sub_class_details AS target
                        USING (SELECT @FvciApplicationId AS fvci_application_id, 
                                    @Name AS name, 
                                    @CreatedAt AS created_at, 
                                    @UpdatedAt AS updated_at
                            ) AS source
                        ON target.fvci_application_id = source.fvci_application_id AND target.name = source.name
                        WHEN MATCHED THEN
                            UPDATE SET target.updated_at = source.updated_at
                        WHEN NOT MATCHED THEN
                            INSERT (fvci_application_id, name, created_at, updated_at)
                            VALUES (source.fvci_application_id, source.name, source.created_at, source.updated_at);

                        -- If an insert occurred, SCOPE_IDENTITY() will return a non-null value.
                        -- If no insert occurred, retrieve the existing record's id.
                        SET @FvciSubClassDetailsId = COALESCE(SCOPE_IDENTITY(), 
                            (SELECT TOP 1 id FROM nsdl.draft_fvci_sub_class_details 
                            WHERE fvci_application_id = @FvciApplicationId AND name = @Name));
                    END;

CREATE PROCEDURE UpsertFvciTelephoneNumberDetails
    @FvciApplicationId NVARCHAR(255),
    @CountryCode NVARCHAR(50),
    @StdCode NVARCHAR(50),
    @PhoneNumber NVARCHAR(50),
    @PhoneType NVARCHAR(50),
    @Status INT,
    @ContactType NVARCHAR(50),
    @CreatedAt DATETIME = NULL,
    @UpdatedAt DATETIME = NULL
AS
BEGIN
    SET NOCOUNT ON;

    -- Ensure timestamps are assigned properly
    SET @CreatedAt = COALESCE(@CreatedAt, GETDATE());
    SET @UpdatedAt = COALESCE(@UpdatedAt, GETDATE());

    MERGE INTO nsdl.draft_fvci_telephone_number_details AS target
    USING (SELECT @FvciApplicationId AS fvci_application_id, 
                 @CountryCode AS country_code, 
                 @StdCode AS std_code, 
                 @PhoneNumber AS phone_number, 
                 @PhoneType AS phone_type, 
                 @Status AS status, 
                 @CreatedAt AS created_at, 
                 @UpdatedAt AS updated_at,
                 @ContactType as contacttype
          ) AS source
    ON target.fvci_application_id = source.fvci_application_id 
    AND target.phone_type = source.phone_type and target.contacttype = source.contacttype 
    WHEN MATCHED THEN
        UPDATE SET 
            target.country_code = COALESCE(source.country_code, target.country_code), 
            target.std_code = COALESCE(source.std_code, target.std_code),
            target.phone_number = COALESCE(source.phone_number, target.phone_number),
            target.status = COALESCE(source.status, target.status),
            target.updated_at = source.updated_at
    WHEN NOT MATCHED THEN
        INSERT (fvci_application_id, country_code, std_code, phone_number, phone_type, status, created_at, updated_at,contacttype)
        VALUES (source.fvci_application_id, source.country_code, source.std_code, source.phone_number, 
                source.phone_type, source.status, source.created_at, source.updated_at,source.contacttype);
END;