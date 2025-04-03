CREATE PROCEDURE SP_GetMasterTables
    @Type VARCHAR(50) = '' -- Default to empty string for all tables
AS
BEGIN
    SET NOCOUNT ON;

    IF @Type = '' OR @Type = 'ATS'
    BEGIN
        SELECT * FROM ATS_MSTR_TBL;
    END

    IF @Type = '' OR @Type = 'bank'
    BEGIN
        SELECT BKM_ID bank_id,BKM_Bnk_Id bank_code,BKM_Bnk_Nm bank_name,BKM_Crt_DTM created_dtm,BKM_Upd_DTM modified_dtm, CONCAT(' ', BKM_Addr_Ln_1,BKM_Addr_Ln_2,BKM_Addr_Ln_3,BKM_Addr_Ln_4,BKM_Pin_Cd, BKM_Pin_Cd) as  address FROM Bnk_Mstr;
    END

    IF @Type = '' OR @Type = 'CAFApplicantStatus'
    BEGIN
        SELECT * FROM CAF_Applicant_Status_MSTR;
    END

    IF @Type = '' OR @Type = 'CAFMasterApplicantStatus'
    BEGIN
        SELECT * FROM CAF_MASTER_APPLICANT_STATUS;
    END

    IF @Type = '' OR @Type = 'CAFMasterBusProf'
    BEGIN
        SELECT * FROM CAF_MASTER_BUS_PROF;
    END

    IF @Type = '' OR @Type = 'proof_of_address'
    BEGIN
        SELECT POA_DOC_CD code,POA_DOC_NM name FROM CAF_MASTER_POA_DOC;
    END

    IF @Type = '' OR @Type = 'proof_of_identity'
    BEGIN
        SELECT POI_DOC_CD code,POI_DOC_NM name FROM CAF_MASTER_POI_DOC;
    END

    IF @Type = '' OR @Type = 'source_of_income'
    BEGIN
        SELECT SRC_INCOMECD code,SRC_INCOME_NM name FROM CAF_MASTER_SOI;
    END

    IF @Type = '' OR @Type = 'country' -- or CountryCodeFinal depending on which one is correct.
    BEGIN
        SELECT RMC_SRNo country_id, RMC_CODE_NAME country_name, RMC_CODE_ISDCODE country_code, RMC_CODE_ID country_short_code, RMC_CRT_DT created_dtm,RMC_UPDT_DT modified_dtm FROM Country_Code_Master; -- or Country_Code_Master depending on the correct table name.
    END
    
    IF @Type = '' OR @Type = 'country_pan' -- or CountryCodeFinal depending on which one is correct.
    BEGIN
        SELECT  COUNTRY_Name country_name, COUNTRY_ID country_code, Country_CODE country_short_code, Country_ISD country_isd_code FROM PAN_Country_Code_Master; -- or Country_Code_Master depending on the correct table name.
    END

    IF @Type = '' OR @Type = 'custodian'
    BEGIN
        SELECT Cust_Id cust_id,Cust_Reg_No cust_reg_no,Cust_nm cust_nm,Created_dtm created_dtm,Modified_dtm modified_dtm FROM Custodian_MSTR_TBL;
    END
    IF @Type = '' OR @Type = 'ddp'
    BEGIN
        SELECT DDP_ID sebi_registration_no,Created_dtm created_dtm,Modified_dtm modified_dtm,DMT_DDP_NM_CD ddp_id,DMT_DDP_NM ddp_name FROM DDP_MSTR_TBL;
    END

    IF @Type = '' OR @Type = 'FormAStatus'
    BEGIN
        SELECT * FROM FormA_Status_Master;
    END
    
    IF @Type = '' OR @Type = 'prior_associations'
    BEGIN
        SELECT * FROM prior_association_master pam;
    END
    
    IF @Type = '' OR @Type = 'type_of_entity'
    BEGIN
        SELECT * FROM type_of_entity_master toem;
    END
    
    IF @Type = '' OR @Type = 'code_of_business'
    BEGIN
        SELECT * FROM code_of_business_master cobm ;
    END
    IF @Type = '' OR @Type = 'type_of_applicant'
    BEGIN
        SELECT * FROM FVCI_MASTER_TYPE_OF_APPLICANT ta ;
    END
    IF @Type = '' OR @Type = 'regulatory_authority'
     BEGIN
        SELECT Repository_nm regulatory_name, Country_Name country_name, Reg_Auth_Website website FROM TBL_Repository_MSTR rm ;
    END
END;