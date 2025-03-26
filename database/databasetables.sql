-- oneture_db.nsdl.ATS_MSTR_TBL definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.ATS_MSTR_TBL;

CREATE TABLE oneture_db.nsdl.ATS_MSTR_TBL (
	AMT_ASM_ID int NOT NULL,
	AMT_DDP_CODE int NULL,
	AMT_SIGN_REQD numeric(3,0) NULL,
	AMT_SIGN_NAME varchar(150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	AMT_SIGN_DSGN varchar(30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	AMT_DESG_RANK smallint NULL,
	Created_By int NULL,
	Created_dtm datetime NULL,
	Modified_By int NULL,
	Modified_dtm datetime NULL,
	Status varchar(1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	AMT_EmailID varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	contact_no varchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	address varchar(250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	SIGN_DATA varchar(4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	SIGN_DTTM datetime NULL,
	SIGN_CHUNK varchar(MAX) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	DSC_SERIAL_NO varchar(120) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	ISSUE_AUTH varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	EXP_DT datetime NULL,
	CERT_TYP int NULL,
	LOGIN_DATE datetime NULL,
	Login_Attempt tinyint NULL,
	last_pwd_change_DATE datetime NULL,
	IsForgetPassword bit NULL,
	ALLOW_OTP varchar(1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	OTP_CNT tinyint NULL,
	OTP_date datetime NULL,
	Password varchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	SIGNADD varchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	CONSTRAINT PK_ATS_MSTR_TBL_AMT_ASM_ID PRIMARY KEY (AMT_ASM_ID)
);


-- oneture_db.nsdl.Bnk_Mstr definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.Bnk_Mstr;

CREATE TABLE oneture_db.nsdl.Bnk_Mstr (
	BKM_ID int IDENTITY(1,1) NOT NULL,
	BKM_IFSC_Cd varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	BKM_MICR_Cd varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	BKM_Bnk_Id varchar(25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	BKM_Bnk_Nm varchar(250) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	BKM_Brnch_Nm varchar(250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	BKM_Addr_Ln_1 varchar(200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	BKM_Addr_Ln_2 varchar(200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	BKM_Addr_Ln_3 varchar(200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	BKM_Addr_Ln_4 varchar(200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	BKM_Pin_Cd varchar(15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	BKM_Ph_No varchar(15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	BKM_Fax_No varchar(15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	BKM_Stat int NOT NULL,
	BKM_Crt_DTM datetime NOT NULL,
	BKM_Crt_Usr varchar(15) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	BKM_Upd_DTM datetime NULL,
	BKM_Upd_Usr varchar(15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	CONSTRAINT PK_Bnk_Mstr PRIMARY KEY (BKM_ID)
);


-- oneture_db.nsdl.CAF_Applicant_Status_MSTR definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.CAF_Applicant_Status_MSTR;

CREATE TABLE oneture_db.nsdl.CAF_Applicant_Status_MSTR (
	Status_ID int IDENTITY(1,1) NOT NULL,
	Status_NM varchar(150) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	Status_CD varchar(1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	ISActive tinyint NOT NULL,
	Created_By int NULL,
	Created_DTM datetime NULL,
	Updated_By int NULL,
	Updated_DTM datetime NULL,
	CONSTRAINT PK_CAF_Applicant_Status_MSTR PRIMARY KEY (Status_ID)
);


-- oneture_db.nsdl.CAF_MASTER_APPLICANT_STATUS definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.CAF_MASTER_APPLICANT_STATUS;

CREATE TABLE oneture_db.nsdl.CAF_MASTER_APPLICANT_STATUS (
	APP_STATUS_CD varchar(1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	APP_STATUS_NM varchar(120) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	IS_ACTIVE int NULL,
	CREATED_BY varchar(150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	CREATED_DTM datetime NULL,
	MODIFIED_BY varchar(150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	MODIFIED_DTM datetime NULL,
	CONSTRAINT PK_CAF_MASTER_APPLICANT_STATUS PRIMARY KEY (APP_STATUS_CD)
);


-- oneture_db.nsdl.CAF_MASTER_BUS_PROF definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.CAF_MASTER_BUS_PROF;

CREATE TABLE oneture_db.nsdl.CAF_MASTER_BUS_PROF (
	BUS_ID int IDENTITY(1,1) NOT NULL,
	BUS_PROF_NM varchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	SRC_INCOMECD int NULL,
	IS_ACTIVE int NULL,
	CREATED_BY varchar(150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	CREATED_DTM datetime NULL,
	MODIFIED_BY varchar(150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	MODIFIED_DTM datetime NULL,
	order_by_seq int NULL,
	BUS_PROFCD varchar(5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	CONSTRAINT PK_CAF_MASTER_BUS_PROF PRIMARY KEY (BUS_ID)
);


-- oneture_db.nsdl.CAF_MASTER_POA_DOC definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.CAF_MASTER_POA_DOC;

CREATE TABLE oneture_db.nsdl.CAF_MASTER_POA_DOC (
	POA_DOC_CD varchar(3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	POA_DOC_NM varchar(500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	IS_INDV_NONINDV varchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	IS_WITH_DATE int NULL,
	IS_IDENTIFICATION_NO int NULL,
	IS_ACTIVE int NULL,
	CREATED_BY varchar(150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	CREATED_DTM datetime NULL,
	MODIFIED_BY varchar(150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	MODIFIED_DTM datetime NULL,
	STEP varchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
);


-- oneture_db.nsdl.CAF_MASTER_POI_DOC definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.CAF_MASTER_POI_DOC;

CREATE TABLE oneture_db.nsdl.CAF_MASTER_POI_DOC (
	POI_DOC_CD varchar(3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	POI_DOC_NM varchar(500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	IS_INDV_NONINDV varchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	IS_WITH_DATE int NULL,
	IS_IDENTIFICATION_NO int NULL,
	IS_ACTIVE int NULL,
	CREATED_BY varchar(150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	CREATED_DTM datetime NULL,
	MODIFIED_BY varchar(150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	MODIFIED_DTM datetime NULL,
	STEP varchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
);


-- oneture_db.nsdl.CAF_MASTER_SOI definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.CAF_MASTER_SOI;

CREATE TABLE oneture_db.nsdl.CAF_MASTER_SOI (
	SRC_INCOMECD int IDENTITY(1,1) NOT NULL,
	SRC_INCOME_NM varchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	IS_BUS_PROF_CD int NULL,
	IS_ACTIVE int NULL,
	CREATED_BY varchar(150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	CREATED_DTM datetime NULL,
	MODIFIED_BY varchar(150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	MODIFIED_DTM datetime NULL,
	order_by_seq int NULL,
	CONSTRAINT PK_CAF_MASTER_SOI PRIMARY KEY (SRC_INCOMECD)
);


-- oneture_db.nsdl.Country_Code_Master definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.Country_Code_Master;

CREATE TABLE oneture_db.nsdl.Country_Code_Master (
	RMC_SRNo int NOT NULL,
	RMC_TYPE varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	RMC_CODE_SHORT_NAME varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	RMC_CODE_NAME varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	RMC_CODE_ID varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	RMC_CRT_USER_ID varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	RMC_CRT_DT datetime NULL,
	RMC_UPDT_USER_ID varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	RMC_UPDT_DT datetime NULL,
	RMC_CODE_ISDCODE nvarchar(10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	IsActive tinyint NULL,
	PAN_Country_ID int NULL,
	DMT_ISD_CODE int NULL,
	DEMAT_COUNTRY_CODE varchar(3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	CONSTRAINT PK_CountryId PRIMARY KEY (RMC_SRNo)
);


-- oneture_db.nsdl.Custodian_MSTR_TBL definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.Custodian_MSTR_TBL;

CREATE TABLE oneture_db.nsdl.Custodian_MSTR_TBL (
	Cust_Id int IDENTITY(1,1) NOT NULL,
	Cust_Reg_No varchar(16) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	Cust_nm varchar(200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	Created_By int NULL,
	Created_dtm datetime NOT NULL,
	Modified_By int NULL,
	Modified_dtm datetime NULL,
	CONSTRAINT PK_Cust_Id PRIMARY KEY (Cust_Id)
);


-- oneture_db.nsdl.DDP_MSTR_TBL definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.DDP_MSTR_TBL;

CREATE TABLE oneture_db.nsdl.DDP_MSTR_TBL (
	DMT_DDP_NM_CD int NOT NULL,
	DMT_DDP_NM varchar(200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	DMT_DDP_NSDL_FL smallint NOT NULL,
	Created_By int NULL,
	Created_dtm datetime NOT NULL,
	Modified_By int NULL,
	Modified_dtm datetime NULL,
	DMT_PLACE_DESC varchar(36) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	custodian_dp_code varchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	SHORT_NAME varchar(10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	BANK_ID tinyint NULL,
	DP_ID int NULL,
	Is_Active int NULL,
	DDP_ID varchar(8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	CONSTRAINT PK_DDP_MSTR_TBL_DMT_DDP_NM_CD PRIMARY KEY (DMT_DDP_NM_CD)
);


-- oneture_db.nsdl.FVCI_MASTER_TYPE_OF_APPLICANT definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.FVCI_MASTER_TYPE_OF_APPLICANT;

CREATE TABLE oneture_db.nsdl.FVCI_MASTER_TYPE_OF_APPLICANT (
	id int IDENTITY(1,1) NOT NULL,
	code varchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	description varchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	created_dtm datetime DEFAULT getdate() NULL,
	modified_dtm datetime DEFAULT getdate() NULL
);


-- oneture_db.nsdl.FormA_Status_Master definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.FormA_Status_Master;

CREATE TABLE oneture_db.nsdl.FormA_Status_Master (
	Status_Id int IDENTITY(1,1) NOT NULL,
	Status_nm varchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Created_By int NULL,
	Created_dtm datetime NOT NULL,
	Modified_By int NULL,
	Modified_dtm datetime NULL,
	CONSTRAINT PK_Status_Id PRIMARY KEY (Status_Id)
);


-- oneture_db.nsdl.SELECTED_ATS_BYDDP definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.SELECTED_ATS_BYDDP;

CREATE TABLE oneture_db.nsdl.SELECTED_ATS_BYDDP (
	APPLICATION_ID int NOT NULL,
	AMT_ASM_ID int NOT NULL,
	AMT_SIGN_NAME varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	certificate_serial_no text COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	certificate_thumbprint text COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	certificate_name text COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	certificate_expdate text COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Created_dtm datetime DEFAULT getdate() NULL,
	AMT_SIGN_REQD int DEFAULT 0 NOT NULL,
	IS_VERIFY int DEFAULT 0 NOT NULL,
	Modified_dtm datetime DEFAULT getdate() NULL,
	CONSTRAINT PK__SELECTED__7D68AFC1EA3A99F0 PRIMARY KEY (APPLICATION_ID,AMT_ASM_ID)
);


-- oneture_db.nsdl.User_Registration1 definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.User_Registration1;

CREATE TABLE oneture_db.nsdl.User_Registration1 (
	ur_id int IDENTITY(1,1) NOT NULL,
	RollID int NULL,
	UserType varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	entity_name varchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Specify_reg varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	LEIRegNo varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	LEIDetails varchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	User_Name_FPIAPP varchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	GCName varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	GCregNo varchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	GCNameoffUser varchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	address1 varchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	address2 varchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	address3 varchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	city varchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	state varchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	pincode varchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Country varchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Countrycode varchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	areacode varchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	number varchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	UserName varchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	password varchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	ddp int NULL,
	create_dtm datetime NULL,
	Useras varchar(30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Verification_flag int NULL,
	Pending_ddp_flag int NULL,
	modified_dtm datetime NULL,
	SpecifyOther varchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	DOB date NULL,
	new_password varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	CONSTRAINT PK__User_Reg__B40F6A70BEAE1C49 PRIMARY KEY (ur_id)
);


-- oneture_db.nsdl.activities definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.activities;

CREATE TABLE oneture_db.nsdl.activities (
	activity_id int IDENTITY(1,1) NOT NULL,
	parent_activity_id int NULL,
	activity_code varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	activity_nm varchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	description varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	activity_url varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	is_menu tinyint DEFAULT 1 NOT NULL,
	status tinyint DEFAULT 1 NOT NULL,
	is_auth_req tinyint DEFAULT 1 NOT NULL,
	created_by int NULL,
	created_dtm datetime DEFAULT getdate() NOT NULL,
	modified_by int NULL,
	modified_dtm datetime NULL,
	CONSTRAINT PK__activiti__482FBD638D793169 PRIMARY KEY (activity_id),
	CONSTRAINT UQ__activiti__D9120E5315EC69C8 UNIQUE (activity_code),
	CONSTRAINT FK__activitie__paren__11D639FD FOREIGN KEY (parent_activity_id) REFERENCES oneture_db.nsdl.activities(activity_id)
);


-- oneture_db.nsdl.apilogs definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.apilogs;

CREATE TABLE oneture_db.nsdl.apilogs (
	Id int IDENTITY(1,1) NOT NULL,
	UserId nvarchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	RequestPath nvarchar(500) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	HttpMethod nvarchar(10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	QueryString nvarchar(MAX) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	RequestBody nvarchar(MAX) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	ResponseBody nvarchar(MAX) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	StatusCode int NOT NULL,
	ResponseTime bigint NOT NULL,
	[Timestamp] datetime DEFAULT getutcdate() NULL,
	CONSTRAINT PK__apilogs__3214EC072BD7698A PRIMARY KEY (Id)
);


-- oneture_db.nsdl.bank_master definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.bank_master;

CREATE TABLE oneture_db.nsdl.bank_master (
	bank_id int IDENTITY(1,1) NOT NULL,
	bank_name varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	bank_code varchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	created_dtm datetime DEFAULT getdate() NOT NULL,
	modified_dtm datetime NULL,
	CONSTRAINT PK__bank_mas__4076F7031B2C2793 PRIMARY KEY (bank_id),
	CONSTRAINT UQ__bank_mas__AEBE0980C1A8E2B4 UNIQUE (bank_name),
	CONSTRAINT UQ__bank_mas__C5B92242FF1B8FED UNIQUE (bank_code)
);
 CREATE NONCLUSTERED INDEX idx_bank_code ON oneture_db.nsdl.bank_master (  bank_code ASC  )  
	 WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  )
	 ON [PRIMARY ] ;


-- oneture_db.nsdl.code_of_business_master definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.code_of_business_master;

CREATE TABLE oneture_db.nsdl.code_of_business_master (
	id int IDENTITY(1,1) NOT NULL,
	code nvarchar(5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	value nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	CONSTRAINT UQ__code_of___357D4CF9DE4703C7 UNIQUE (code),
	CONSTRAINT UQ__code_of___40BBEA3A0D7C47A9 UNIQUE (value)
);


-- oneture_db.nsdl.countryflagmapping definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.countryflagmapping;

CREATE TABLE oneture_db.nsdl.countryflagmapping (
	countrycode varchar(3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	flagurl text COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	CONSTRAINT PK__countryf__C704728240766042 PRIMARY KEY (countrycode)
);


-- oneture_db.nsdl.custodian_master definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.custodian_master;

CREATE TABLE oneture_db.nsdl.custodian_master (
	cust_id int IDENTITY(1,1) NOT NULL,
	cust_reg_no varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	cust_nm varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	created_dtm datetime DEFAULT getdate() NOT NULL,
	modified_dtm datetime NULL,
	CONSTRAINT PK__custodia__A1B71F9080FAF438 PRIMARY KEY (cust_id),
	CONSTRAINT UQ__custodia__26F297EE9E395F16 UNIQUE (cust_reg_no),
	CONSTRAINT UQ__custodia__A1B7C0216C84FC92 UNIQUE (cust_nm)
);
 CREATE NONCLUSTERED INDEX idx_cust_reg_no ON oneture_db.nsdl.custodian_master (  cust_reg_no ASC  )  
	 WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  )
	 ON [PRIMARY ] ;


-- oneture_db.nsdl.ddp_master definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.ddp_master;

CREATE TABLE oneture_db.nsdl.ddp_master (
	ddp_id int IDENTITY(1,1) NOT NULL,
	ddp_name varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	sebi_registration_no varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	created_dtm datetime DEFAULT getdate() NOT NULL,
	modified_dtm datetime NULL,
	CONSTRAINT PK__ddp_mast__FD48AE9CB1128ABA PRIMARY KEY (ddp_id),
	CONSTRAINT UQ__ddp_mast__2086476E14FD7F1A UNIQUE (sebi_registration_no),
	CONSTRAINT UQ__ddp_mast__7997971A7B1FCE1A UNIQUE (ddp_name)
);
 CREATE NONCLUSTERED INDEX idx_ddp_sebi_reg ON oneture_db.nsdl.ddp_master (  sebi_registration_no ASC  )  
	 WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  )
	 ON [PRIMARY ] ;


-- oneture_db.nsdl.draft_fvci_applications definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.draft_fvci_applications;

CREATE TABLE oneture_db.nsdl.draft_fvci_applications (
	id int IDENTITY(1,1) NOT NULL,
	user_id int NULL,
	application_id nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS DEFAULT CONVERT([nvarchar],NEXT VALUE FOR [nsdl].[seq_application_id]) NOT NULL,
	fvci_registration_number nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	created_at datetime NOT NULL,
	updated_at datetime NOT NULL,
	status int NULL,
	CONSTRAINT PK_draft_fvci_applications PRIMARY KEY (id),
	CONSTRAINT UQ_draft_fvci_application_id UNIQUE (application_id)
);


-- oneture_db.nsdl.draft_fvci_address_details definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.draft_fvci_address_details;

CREATE TABLE oneture_db.nsdl.draft_fvci_address_details (
	id int IDENTITY(1,1) NOT NULL,
	fvci_application_id nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	flat_block_no nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	building_premises_village_name nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	road_street_lane_name nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	area_locality_subdivision varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	town_city_district varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	zip_code nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	state varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	countrycode varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	type_of_address varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	created_at datetime NOT NULL,
	updated_at datetime NOT NULL,
	CONSTRAINT PK_draft_fvci_address_details PRIMARY KEY (id),
	CONSTRAINT FK_fvci_address_application FOREIGN KEY (fvci_application_id) REFERENCES oneture_db.nsdl.draft_fvci_applications(application_id) ON DELETE CASCADE
);


-- oneture_db.nsdl.draft_fvci_benificial_ownership_by_control definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.draft_fvci_benificial_ownership_by_control;

CREATE TABLE oneture_db.nsdl.draft_fvci_benificial_ownership_by_control (
	id int IDENTITY(1,1) NOT NULL,
	fvci_application_id nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	is_no_entity_controls_through_voting bit NULL,
	created_at datetime DEFAULT getdate() NULL,
	updated_at datetime DEFAULT getdate() NULL,
	CONSTRAINT PK__draft_fv__3213E83F7E02465D PRIMARY KEY (id),
	CONSTRAINT fk_fvci_bo_control FOREIGN KEY (fvci_application_id) REFERENCES oneture_db.nsdl.draft_fvci_applications(application_id)
);


-- oneture_db.nsdl.draft_fvci_benificial_ownership_by_control_bo_details definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.draft_fvci_benificial_ownership_by_control_bo_details;

CREATE TABLE oneture_db.nsdl.draft_fvci_benificial_ownership_by_control_bo_details (
	id int IDENTITY(1,1) NOT NULL,
	fvci_application_id nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	name_of_bo nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	method_of_control nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	country nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	control_percentage float NULL,
	is_individual bit NULL,
	created_at datetime DEFAULT getdate() NULL,
	updated_at datetime DEFAULT getdate() NULL,
	CONSTRAINT PK__draft_fv__3213E83F32DDDAD5 PRIMARY KEY (id),
	CONSTRAINT fk_fvci_bo_control_details FOREIGN KEY (fvci_application_id) REFERENCES oneture_db.nsdl.draft_fvci_applications(application_id)
);


-- oneture_db.nsdl.draft_fvci_complaince_officer_details definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.draft_fvci_complaince_officer_details;

CREATE TABLE oneture_db.nsdl.draft_fvci_complaince_officer_details (
	id int IDENTITY(1,1) NOT NULL,
	fvci_application_id nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	name nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	job_title nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	phone_number nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	status int NULL,
	created_at datetime DEFAULT getdate() NULL,
	updated_at datetime DEFAULT getdate() NULL,
	fax_number nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	CONSTRAINT PK__draft_fv__3213E83FB9664AD3 PRIMARY KEY (id),
	CONSTRAINT UQ_fvci_application_compliance_officer UNIQUE (fvci_application_id),
	CONSTRAINT FK_draft_fvci_complaince_officer_fvci_application FOREIGN KEY (fvci_application_id) REFERENCES oneture_db.nsdl.draft_fvci_applications(application_id) ON DELETE CASCADE
);


-- oneture_db.nsdl.draft_fvci_complaince_officer_emails definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.draft_fvci_complaince_officer_emails;

CREATE TABLE oneture_db.nsdl.draft_fvci_complaince_officer_emails (
	id int IDENTITY(1,1) NOT NULL,
	fvci_application_id nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	email nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	status int NULL,
	created_at datetime DEFAULT getdate() NULL,
	updated_at datetime DEFAULT getdate() NULL,
	CONSTRAINT PK__draft_fv__3213E83FBEAF283E PRIMARY KEY (id),
	CONSTRAINT UQ__draft_fv__8E492405F880E3FB UNIQUE (fvci_application_id),
	CONSTRAINT FK_draft_fvci_complaince_officer_emails_fvci_application FOREIGN KEY (fvci_application_id) REFERENCES oneture_db.nsdl.draft_fvci_applications(application_id) ON DELETE CASCADE
);


-- oneture_db.nsdl.draft_fvci_declaration_undertaking_details definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.draft_fvci_declaration_undertaking_details;

CREATE TABLE oneture_db.nsdl.draft_fvci_declaration_undertaking_details (
	id int IDENTITY(1,1) NOT NULL,
	fvci_application_id nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	name nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	capacity nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[date] date NULL,
	place nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	name_of_signatory nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	designation_of_signatory nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	date_of_signature nvarchar(30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	signature nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	created_at datetime DEFAULT getdate() NULL,
	updated_at datetime DEFAULT getdate() NULL,
	CONSTRAINT PK__draft_fv__3213E83FE8B6FE53 PRIMARY KEY (id),
	CONSTRAINT UQ__draft_fv__8E49240540C48A27 UNIQUE (fvci_application_id),
	CONSTRAINT FK_fvci_declaration_undertaking_application FOREIGN KEY (fvci_application_id) REFERENCES oneture_db.nsdl.draft_fvci_applications(application_id) ON DELETE CASCADE
);



-- oneture_db.nsdl.draft_fvci_ekyc_benificial_owner_details definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.draft_fvci_ekyc_benificial_owner_details;

CREATE TABLE oneture_db.nsdl.draft_fvci_ekyc_benificial_owner_details (
	id int IDENTITY(1,1) NOT NULL,
	fvci_application_id nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	fvci_sub_class_details_id int NULL,
	name_address nvarchar(500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	date_of_birth date NULL,
	tax_residancy_juridication nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	natinality nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	acting_alonng_person_group_name_address nvarchar(500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	bo_ownership_in_fvci decimal(10,2) NULL,
	giverment_doc_identity_number nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	status nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	created_at datetime DEFAULT getdate() NULL,
	updated_at datetime DEFAULT getdate() NULL,
	CONSTRAINT PK_draft_fvci_ekyc_benificial_owner_details PRIMARY KEY (id)
);


-- oneture_db.nsdl.draft_fvci_ekyc_contact_details definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.draft_fvci_ekyc_contact_details;

CREATE TABLE oneture_db.nsdl.draft_fvci_ekyc_contact_details (
	id int IDENTITY(1,1) NOT NULL,
	fvci_application_id nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	fax_number nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	website nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	mobile_number nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	email_id nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	created_at datetime DEFAULT getdate() NULL,
	updated_at datetime DEFAULT getdate() NULL,
	CONSTRAINT PK__draft_fv__3213E83F652039F7 PRIMARY KEY (id),
	CONSTRAINT UQ_fdraft_vci_application_contact UNIQUE (fvci_application_id)
);


-- oneture_db.nsdl.draft_fvci_fax_number_details definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.draft_fvci_fax_number_details;

CREATE TABLE oneture_db.nsdl.draft_fvci_fax_number_details (
	id int IDENTITY(1,1) NOT NULL,
	fvci_application_id nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	country_code nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	std_code nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	fax_number nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	fax_type nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	status int NULL,
	created_at datetime DEFAULT getdate() NULL,
	updated_at datetime DEFAULT getdate() NULL,
	contacttype varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	CONSTRAINT PK_draft_fvci_fax_number_details PRIMARY KEY (id)
);


-- oneture_db.nsdl.draft_fvci_global_custodian_details definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.draft_fvci_global_custodian_details;

CREATE TABLE oneture_db.nsdl.draft_fvci_global_custodian_details (
	id int IDENTITY(1,1) NOT NULL,
	fvci_application_id nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	name nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	country nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	registration_number nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	address nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	created_at datetime DEFAULT getdate() NULL,
	updated_at datetime DEFAULT getdate() NULL,
	CONSTRAINT PK__draft_fv__3213E83F0A8FDE68 PRIMARY KEY (id),
	CONSTRAINT UQ__draft_fv__8E492405F6F1D220 UNIQUE (fvci_application_id)
);


-- oneture_db.nsdl.draft_fvci_incidents_of_law_voilation definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.draft_fvci_incidents_of_law_voilation;

CREATE TABLE oneture_db.nsdl.draft_fvci_incidents_of_law_voilation (
	id int IDENTITY(1,1) NOT NULL,
	fvci_application_id nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	description nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	created_at datetime DEFAULT getdate() NULL,
	updated_at datetime DEFAULT getdate() NULL,
	CONSTRAINT PK__draft_fv__3213E83FD06C6FBF PRIMARY KEY (id),
	CONSTRAINT UQ__draft_fv__8E4924059B7D4B68 UNIQUE (fvci_application_id)
);


-- oneture_db.nsdl.draft_fvci_income_details definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.draft_fvci_income_details;

CREATE TABLE oneture_db.nsdl.draft_fvci_income_details (
	id int IDENTITY(1,1) NOT NULL,
	fvci_application_id nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	source_of_income nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	code_of_business nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	gross_annual_income float NULL,
	net_worth float NULL,
	as_on_date date NULL,
	status int NULL,
	created_at datetime DEFAULT getdate() NULL,
	updated_at datetime DEFAULT getdate() NULL,
	CONSTRAINT PK__draft_fv__3213E83FA52F51D3 PRIMARY KEY (id),
	CONSTRAINT UQ_FvciApplication UNIQUE (fvci_application_id)
);


-- oneture_db.nsdl.draft_fvci_indian_market_associans definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.draft_fvci_indian_market_associans;

CREATE TABLE oneture_db.nsdl.draft_fvci_indian_market_associans (
	id int IDENTITY(1,1) NOT NULL,
	fvci_application_id nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	name nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	associated_as nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	registration_number nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	period_of_registration nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	created_at datetime DEFAULT getdate() NULL,
	updated_at datetime DEFAULT getdate() NULL,
	CONSTRAINT PK__draft_fv__3213E83F2D7FBC56 PRIMARY KEY (id),
	CONSTRAINT UQ__draft_fv__8E4924057C0B3617 UNIQUE (fvci_application_id)
);


-- oneture_db.nsdl.draft_fvci_info_basic_of_ownership_bo_details definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.draft_fvci_info_basic_of_ownership_bo_details;

CREATE TABLE oneture_db.nsdl.draft_fvci_info_basic_of_ownership_bo_details (
	id int IDENTITY(1,1) NOT NULL,
	fvci_application_id nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	name_of_bo nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	stake float NULL,
	name_of_entity nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	country nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	stake_percentage float NULL,
	is_individual bit NULL,
	created_at datetime DEFAULT getdate() NULL,
	updated_at datetime DEFAULT getdate() NULL,
	CONSTRAINT PK__draft_fv__3213E83FFBFD42D6 PRIMARY KEY (id)
);


-- oneture_db.nsdl.draft_fvci_ekyc_benificial_owner_details foreign keys

ALTER TABLE oneture_db.nsdl.draft_fvci_ekyc_benificial_owner_details ADD CONSTRAINT fk_fvci_application FOREIGN KEY (fvci_application_id) REFERENCES oneture_db.nsdl.draft_fvci_applications(application_id);
ALTER TABLE oneture_db.nsdl.draft_fvci_ekyc_benificial_owner_details ADD CONSTRAINT fk_fvci_sub_class_details FOREIGN KEY (fvci_sub_class_details_id) REFERENCES oneture_db.nsdl.fvci_sub_class_details(id);


-- oneture_db.nsdl.draft_fvci_ekyc_contact_details foreign keys

ALTER TABLE oneture_db.nsdl.draft_fvci_ekyc_contact_details ADD CONSTRAINT FK_draft_fvci_ekyc_contact_details_fvci_application FOREIGN KEY (fvci_application_id) REFERENCES oneture_db.nsdl.draft_fvci_applications(application_id) ON DELETE CASCADE;


-- oneture_db.nsdl.draft_fvci_fax_number_details foreign keys

ALTER TABLE oneture_db.nsdl.draft_fvci_fax_number_details ADD CONSTRAINT FK_draft_fvci_fax_number_details_fvci_application FOREIGN KEY (fvci_application_id) REFERENCES oneture_db.nsdl.draft_fvci_applications(application_id) ON DELETE CASCADE;


-- oneture_db.nsdl.draft_fvci_global_custodian_details foreign keys

ALTER TABLE oneture_db.nsdl.draft_fvci_global_custodian_details ADD CONSTRAINT FK_fvci_global_custodian_details_fvci_application FOREIGN KEY (fvci_application_id) REFERENCES oneture_db.nsdl.draft_fvci_applications(application_id) ON DELETE CASCADE;


-- oneture_db.nsdl.draft_fvci_incidents_of_law_voilation foreign keys

ALTER TABLE oneture_db.nsdl.draft_fvci_incidents_of_law_voilation ADD CONSTRAINT fk_fvci_law_voilation FOREIGN KEY (fvci_application_id) REFERENCES oneture_db.nsdl.draft_fvci_applications(application_id);


-- oneture_db.nsdl.draft_fvci_income_details foreign keys

ALTER TABLE oneture_db.nsdl.draft_fvci_income_details ADD CONSTRAINT fk_fvci_income FOREIGN KEY (fvci_application_id) REFERENCES oneture_db.nsdl.draft_fvci_applications(application_id);


-- oneture_db.nsdl.draft_fvci_indian_market_associans foreign keys

ALTER TABLE oneture_db.nsdl.draft_fvci_indian_market_associans ADD CONSTRAINT fk_fvci_indian_market FOREIGN KEY (fvci_application_id) REFERENCES oneture_db.nsdl.draft_fvci_applications(application_id);


-- oneture_db.nsdl.draft_fvci_info_basic_of_ownership_bo_details foreign keys

ALTER TABLE oneture_db.nsdl.draft_fvci_info_basic_of_ownership_bo_details ADD CONSTRAINT fk_fvci_bo_details FOREIGN KEY (fvci_application_id) REFERENCES oneture_db.nsdl.draft_fvci_applications(application_id);




-- oneture_db.nsdl.draft_fvci_info_basic_of_ownership_details definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.draft_fvci_info_basic_of_ownership_details;

CREATE TABLE oneture_db.nsdl.draft_fvci_info_basic_of_ownership_details (
	id int IDENTITY(1,1) NOT NULL,
	fvci_application_id nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	is_no_entity_holding_gt bit NOT NULL,
	entity_holding decimal(18,2) NOT NULL,
	created_at datetime DEFAULT getdate() NULL,
	updated_at datetime DEFAULT getdate() NULL,
	CONSTRAINT PK__draft_fv__3213E83F9B299FE0 PRIMARY KEY (id),
	CONSTRAINT UQ__draft_fv__8E4924055772D1EE UNIQUE (fvci_application_id)
);
ALTER TABLE oneture_db.nsdl.draft_fvci_info_basic_of_ownership_details WITH NOCHECK ADD CONSTRAINT CK__draft_fvc__entit__743A1EC7 CHECK (([entity_holding]>=(0) AND [entity_holding]<=(100)));


-- oneture_db.nsdl.draft_fvci_information_of_sa_sm_fvci_applicant definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.draft_fvci_information_of_sa_sm_fvci_applicant;

CREATE TABLE oneture_db.nsdl.draft_fvci_information_of_sa_sm_fvci_applicant (
	id int IDENTITY(1,1) NOT NULL,
	fvci_application_id nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	name nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	relationship_with_applicant nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	pan nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	country nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	date_of_birth nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	address nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	goverment_id nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	created_at datetime DEFAULT getdate() NULL,
	updated_at datetime DEFAULT getdate() NULL,
	CONSTRAINT PK__draft_fv__3213E83F0672C263 PRIMARY KEY (id)
);


-- oneture_db.nsdl.draft_fvci_investment_manager_details definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.draft_fvci_investment_manager_details;

CREATE TABLE oneture_db.nsdl.draft_fvci_investment_manager_details (
	id int IDENTITY(1,1) NOT NULL,
	fvci_application_id nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	name nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[type] nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	country nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	phone_number nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	fax_number nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	email nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	status int NULL,
	created_at datetime DEFAULT getdate() NULL,
	updated_at datetime DEFAULT getdate() NULL,
	CONSTRAINT PK__draft_fv__3213E83FFCA0CFD6 PRIMARY KEY (id)
);


-- oneture_db.nsdl.draft_fvci_is_bank definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.draft_fvci_is_bank;

CREATE TABLE oneture_db.nsdl.draft_fvci_is_bank (
	id int IDENTITY(1,1) NOT NULL,
	fvci_application_id nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	is_bank bit NOT NULL,
	name_of_bank nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	have_office_in_india bit NOT NULL,
	created_at datetime DEFAULT getdate() NULL,
	updated_at datetime DEFAULT getdate() NULL,
	CONSTRAINT PK__draft_fv__3213E83F04D6919D PRIMARY KEY (id),
	CONSTRAINT UQ__draft_fv__8E49240545255CA8 UNIQUE (fvci_application_id)
);


-- oneture_db.nsdl.draft_fvci_kra_for_permission_to_download_kyc_doc definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.draft_fvci_kra_for_permission_to_download_kyc_doc;

CREATE TABLE oneture_db.nsdl.draft_fvci_kra_for_permission_to_download_kyc_doc (
	id int IDENTITY(1,1) NOT NULL,
	fvci_application_id nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	is_kra_required bit NULL,
	name_of_fvci_represntative nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	email_1 nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	email_2 nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	email_3 nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	phone_number nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	created_at datetime DEFAULT getdate() NULL,
	updated_at datetime DEFAULT getdate() NULL,
	CONSTRAINT PK__draft_fv__3213E83F0521A9DD PRIMARY KEY (id),
	CONSTRAINT UQ__draft_fv__8E49240507798430 UNIQUE (fvci_application_id)
);


-- oneture_db.nsdl.draft_fvci_kyc_documents definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.draft_fvci_kyc_documents;

CREATE TABLE oneture_db.nsdl.draft_fvci_kyc_documents (
	id int IDENTITY(1,1) NOT NULL,
	fvci_application_id nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	document_type nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	document_identifier nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	document_path nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	status int NULL,
	created_at datetime DEFAULT getdate() NULL,
	updated_at datetime DEFAULT getdate() NULL,
	CONSTRAINT PK__draft_fv__3213E83F62939D58 PRIMARY KEY (id)
);


-- oneture_db.nsdl.draft_fvci_kyc_lei_details definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.draft_fvci_kyc_lei_details;

CREATE TABLE oneture_db.nsdl.draft_fvci_kyc_lei_details (
	id int IDENTITY(1,1) NOT NULL,
	fvci_application_id nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	trc_number nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	country_of_tax_residence nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	created_at datetime NOT NULL,
	updated_at datetime NOT NULL,
	CONSTRAINT PK_draft_fvci_kyc_lei_details PRIMARY KEY (id)
);
 CREATE NONCLUSTERED INDEX IDX_draft_fvci_kyc_lei_application ON oneture_db.nsdl.draft_fvci_kyc_lei_details (  fvci_application_id ASC  )  
	 WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  )
	 ON [PRIMARY ] ;


-- oneture_db.nsdl.draft_fvci_regulatory_authority_details definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.draft_fvci_regulatory_authority_details;

CREATE TABLE oneture_db.nsdl.draft_fvci_regulatory_authority_details (
	id int IDENTITY(1,1) NOT NULL,
	fvci_application_id nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	regulatory_authority_name nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	regulatory_authority_country nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	regulatory_authority_website nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	regulatory_authority_reg_number nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	regulatory_authority_category nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	created_at datetime DEFAULT getdate() NULL,
	updated_at datetime DEFAULT getdate() NULL,
	CONSTRAINT PK__draft_fv__3213E83FDD040E1A PRIMARY KEY (id)
);


-- oneture_db.nsdl.draft_fvci_sub_class_benificial_owner_details definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.draft_fvci_sub_class_benificial_owner_details;

CREATE TABLE oneture_db.nsdl.draft_fvci_sub_class_benificial_owner_details (
	id int IDENTITY(1,1) NOT NULL,
	fvci_sub_class_details_id int NULL,
	name nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	date_of_birth date NULL,
	nationality nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	government_doc_identity_number nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	status int NULL,
	created_at datetime DEFAULT getdate() NULL,
	updated_at datetime DEFAULT getdate() NULL,
	relationship_with_applicant nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	pan nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	residential_address nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	CONSTRAINT PK__draft_fv__3213E83FCB7F3484 PRIMARY KEY (id)
);


-- oneture_db.nsdl.draft_fvci_sub_class_details definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.draft_fvci_sub_class_details;

CREATE TABLE oneture_db.nsdl.draft_fvci_sub_class_details (
	id int IDENTITY(1,1) NOT NULL,
	fvci_application_id nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	name nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	created_at datetime DEFAULT getdate() NULL,
	updated_at datetime DEFAULT getdate() NULL,
	CONSTRAINT PK__draft_fv__3213E83F7BB74A49 PRIMARY KEY (id)
);


-- oneture_db.nsdl.draft_fvci_info_basic_of_ownership_details foreign keys

ALTER TABLE oneture_db.nsdl.draft_fvci_info_basic_of_ownership_details ADD CONSTRAINT FK_fvci_ownership_application FOREIGN KEY (fvci_application_id) REFERENCES oneture_db.nsdl.draft_fvci_applications(application_id) ON DELETE CASCADE;


-- oneture_db.nsdl.draft_fvci_information_of_sa_sm_fvci_applicant foreign keys

ALTER TABLE oneture_db.nsdl.draft_fvci_information_of_sa_sm_fvci_applicant ADD CONSTRAINT fk_fvci_sa_sm FOREIGN KEY (fvci_application_id) REFERENCES oneture_db.nsdl.draft_fvci_applications(application_id);


-- oneture_db.nsdl.draft_fvci_investment_manager_details foreign keys

ALTER TABLE oneture_db.nsdl.draft_fvci_investment_manager_details ADD CONSTRAINT FK_draft_fvci_investment_manager_fvci_application FOREIGN KEY (fvci_application_id) REFERENCES oneture_db.nsdl.draft_fvci_applications(application_id) ON DELETE CASCADE;


-- oneture_db.nsdl.draft_fvci_is_bank foreign keys

ALTER TABLE oneture_db.nsdl.draft_fvci_is_bank ADD CONSTRAINT FK_fvci_is_bank_application FOREIGN KEY (fvci_application_id) REFERENCES oneture_db.nsdl.draft_fvci_applications(application_id) ON DELETE CASCADE;


-- oneture_db.nsdl.draft_fvci_kra_for_permission_to_download_kyc_doc foreign keys

ALTER TABLE oneture_db.nsdl.draft_fvci_kra_for_permission_to_download_kyc_doc ADD CONSTRAINT FK_fvci_kra_application FOREIGN KEY (fvci_application_id) REFERENCES oneture_db.nsdl.draft_fvci_applications(application_id) ON DELETE CASCADE;


-- oneture_db.nsdl.draft_fvci_kyc_documents foreign keys

ALTER TABLE oneture_db.nsdl.draft_fvci_kyc_documents ADD CONSTRAINT FK_draft_fvci_kyc_documents_fvci_application FOREIGN KEY (fvci_application_id) REFERENCES oneture_db.nsdl.draft_fvci_applications(application_id) ON DELETE CASCADE;


-- oneture_db.nsdl.draft_fvci_kyc_lei_details foreign keys

ALTER TABLE oneture_db.nsdl.draft_fvci_kyc_lei_details ADD CONSTRAINT FK_fvci_kyc_lei_application FOREIGN KEY (fvci_application_id) REFERENCES oneture_db.nsdl.draft_fvci_applications(application_id) ON DELETE CASCADE;


-- oneture_db.nsdl.draft_fvci_regulatory_authority_details foreign keys

ALTER TABLE oneture_db.nsdl.draft_fvci_regulatory_authority_details ADD CONSTRAINT FK_draft_fvci_regulatory_authority_details_fvci_application FOREIGN KEY (fvci_application_id) REFERENCES oneture_db.nsdl.draft_fvci_applications(application_id) ON DELETE CASCADE;


-- oneture_db.nsdl.draft_fvci_sub_class_benificial_owner_details foreign keys

ALTER TABLE oneture_db.nsdl.draft_fvci_sub_class_benificial_owner_details ADD CONSTRAINT fk_fvci_sub_class_bo FOREIGN KEY (fvci_sub_class_details_id) REFERENCES oneture_db.nsdl.draft_fvci_sub_class_details(id);


-- oneture_db.nsdl.draft_fvci_sub_class_details foreign keys

ALTER TABLE oneture_db.nsdl.draft_fvci_sub_class_details ADD CONSTRAINT fk_fvci_sub_class FOREIGN KEY (fvci_application_id) REFERENCES oneture_db.nsdl.draft_fvci_applications(application_id);


-- oneture_db.nsdl.fvci_applications definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.fvci_applications;

CREATE TABLE oneture_db.nsdl.fvci_applications (
	id int IDENTITY(1,1) NOT NULL,
	user_id int NULL,
	application_id nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS DEFAULT CONVERT([nvarchar],NEXT VALUE FOR [nsdl].[seq_application_id]) NOT NULL,
	fvci_registration_number nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	created_at datetime NOT NULL,
	updated_at datetime NOT NULL,
	status int NULL,
	remarks varchar(MAX) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	serial_no int NULL,
	CONSTRAINT PK_fvci_applications PRIMARY KEY (id),
	CONSTRAINT UQ_fvci_application_id UNIQUE (application_id)
);


-- oneture_db.nsdl.fvci_address_details definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.fvci_address_details;

CREATE TABLE oneture_db.nsdl.fvci_address_details (
	id int IDENTITY(1,1) NOT NULL,
	fvci_application_id nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	flat_block_no nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	building_premises_village_name nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	road_street_lane_name nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	area_locality_subdivision varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	town_city_district varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	zip_code nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	state varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	countrycode varchar(4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	type_of_address varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	created_at datetime NOT NULL,
	updated_at datetime NOT NULL,
	CONSTRAINT PK_address_details PRIMARY KEY (id),
	CONSTRAINT FK_address_application FOREIGN KEY (fvci_application_id) REFERENCES oneture_db.nsdl.fvci_applications(application_id) ON DELETE CASCADE
);
 CREATE NONCLUSTERED INDEX IDX_fvci_address_country ON oneture_db.nsdl.fvci_address_details (  countrycode ASC  )  
	 WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  )
	 ON [PRIMARY ] ;


-- oneture_db.nsdl.fvci_benificial_ownership_by_control definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.fvci_benificial_ownership_by_control;

CREATE TABLE oneture_db.nsdl.fvci_benificial_ownership_by_control (
	id int IDENTITY(1,1) NOT NULL,
	fvci_application_id nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	is_no_entity_controls_through_voting bit NULL,
	created_at datetime DEFAULT getdate() NULL,
	updated_at datetime DEFAULT getdate() NULL,
	CONSTRAINT PK__fv__3213E83F7E02465D PRIMARY KEY (id),
	CONSTRAINT fk_bo_control FOREIGN KEY (fvci_application_id) REFERENCES oneture_db.nsdl.fvci_applications(application_id)
);


-- oneture_db.nsdl.fvci_benificial_ownership_by_control_bo_details definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.fvci_benificial_ownership_by_control_bo_details;

CREATE TABLE oneture_db.nsdl.fvci_benificial_ownership_by_control_bo_details (
	id int IDENTITY(1,1) NOT NULL,
	fvci_application_id nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	name_of_bo nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	method_of_control nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	country nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	control_percentage float NULL,
	is_individual bit NULL,
	created_at datetime DEFAULT getdate() NULL,
	updated_at datetime DEFAULT getdate() NULL,
	CONSTRAINT PK__fv__3213E83F32DDDAD5 PRIMARY KEY (id),
	CONSTRAINT fk__bo_control_details FOREIGN KEY (fvci_application_id) REFERENCES oneture_db.nsdl.fvci_applications(application_id)
);


-- oneture_db.nsdl.fvci_complaince_officer_details definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.fvci_complaince_officer_details;

CREATE TABLE oneture_db.nsdl.fvci_complaince_officer_details (
	id int IDENTITY(1,1) NOT NULL,
	fvci_application_id nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	name nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	job_title nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	phone_number nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	status int NULL,
	created_at datetime DEFAULT getdate() NULL,
	updated_at datetime DEFAULT getdate() NULL,
	CONSTRAINT PK__fv__3213E83FB9664AD3 PRIMARY KEY (id),
	CONSTRAINT UQ__application_compliance_officer UNIQUE (fvci_application_id),
	CONSTRAINT fk__complaince_officer_fvci_application FOREIGN KEY (fvci_application_id) REFERENCES oneture_db.nsdl.fvci_applications(application_id) ON DELETE CASCADE
);


-- oneture_db.nsdl.fvci_complaince_officer_emails definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.fvci_complaince_officer_emails;

CREATE TABLE oneture_db.nsdl.fvci_complaince_officer_emails (
	id int IDENTITY(1,1) NOT NULL,
	fvci_application_id nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	email nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	status int NULL,
	created_at datetime DEFAULT getdate() NULL,
	updated_at datetime DEFAULT getdate() NULL,
	CONSTRAINT PK__fv__3213E83FBEAF283E PRIMARY KEY (id),
	CONSTRAINT UQ__fv__8E492405F880E3FB UNIQUE (fvci_application_id),
	CONSTRAINT fk__complaince_officer_emails_fvci_application FOREIGN KEY (fvci_application_id) REFERENCES oneture_db.nsdl.fvci_applications(application_id) ON DELETE CASCADE
);


-- oneture_db.nsdl.fvci_declaration_undertaking_details definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.fvci_declaration_undertaking_details;

CREATE TABLE oneture_db.nsdl.fvci_declaration_undertaking_details (
	id int IDENTITY(1,1) NOT NULL,
	fvci_application_id nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	name nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	capacity nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[date] date NOT NULL,
	place nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	name_of_signatory nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	designation_of_signatory nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	created_at datetime DEFAULT getdate() NULL,
	updated_at datetime DEFAULT getdate() NULL,
	date_of_signature date NULL,
	signature varchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	CONSTRAINT PK__fv__3213E83FE8B6FE53 PRIMARY KEY (id),
	CONSTRAINT UQ__fv__8E49240540C48A27 UNIQUE (fvci_application_id),
	CONSTRAINT fk__declaration_undertaking_application FOREIGN KEY (fvci_application_id) REFERENCES oneture_db.nsdl.fvci_applications(application_id) ON DELETE CASCADE
);


-- oneture_db.nsdl.draft_fvci_telephone_number_details definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.draft_fvci_telephone_number_details;

CREATE TABLE oneture_db.nsdl.draft_fvci_telephone_number_details (
	id int IDENTITY(1,1) NOT NULL,
	fvci_application_id nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	country_code nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	std_code nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	phone_number nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	phone_type nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	status int NULL,
	created_at datetime DEFAULT getdate() NULL,
	updated_at datetime DEFAULT getdate() NULL,
	contacttype varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	CONSTRAINT PK__draft_fv__3213E83F5CE59C3F PRIMARY KEY (id)
);


-- oneture_db.nsdl.draft_fvic_kyc_details definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.draft_fvic_kyc_details;

CREATE TABLE oneture_db.nsdl.draft_fvic_kyc_details (
	id int IDENTITY(1,1) NOT NULL,
	fvci_application_id nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	name nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	has_other_name bit DEFAULT 0 NULL,
	other_name nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	date_of_incorporation date NULL,
	date_of_commencement date NULL,
	place_of_incorporation nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	country_of_incorporation nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	isd_country_code_of_incorportation nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	legal_form_and_law_of_incorporation nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	legal_entity_identifier nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	address_of_cummunication nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	have_office_in_india bit DEFAULT 0 NULL,
	benificial_ownership_holding float NULL,
	does_other_person_holder_ownership bit NULL,
	is_politically_exposed bit NULL,
	is_related_to_politically_exposed bit NULL,
	created_at datetime NOT NULL,
	updated_at datetime NOT NULL,
	email_id varchar(150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	mobile_number varchar(30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	website varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	CONSTRAINT PK_draft_fvic_kyc_details PRIMARY KEY (id)
);
 CREATE NONCLUSTERED INDEX IDX_draft_fvci_kyc_application ON oneture_db.nsdl.draft_fvic_kyc_details (  fvci_application_id ASC  )  
	 WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  )
	 ON [PRIMARY ] ;
 CREATE NONCLUSTERED INDEX IDX_draft_fvic_kyc_application ON oneture_db.nsdl.draft_fvic_kyc_details (  fvci_application_id ASC  )  
	 WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  )
	 ON [PRIMARY ] ;


-- oneture_db.nsdl.draft_fvic_registration_details definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.draft_fvic_registration_details;

CREATE TABLE oneture_db.nsdl.draft_fvic_registration_details (
	id int IDENTITY(1,1) NOT NULL,
	fvci_application_id nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	type_of_applicant nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	other_type_of_applicant nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	type_of_entity nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	is_provided_facta_crs_provided bit NULL,
	is_coming_from_global_custodian bit NULL,
	ddp_name nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	ddp_registration_number nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	custodian_name nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	custodian_registration_number nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	dp_name nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	dp_registration_number nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	bank_name nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	bank_address nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	is_associated_with_securities_market bit NULL,
	does_hold_pan bit NULL,
	pan_number nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	is_violated_law bit NULL,
	created_at datetime DEFAULT getdate() NULL,
	updated_at datetime DEFAULT getdate() NULL,
	details_of_prior_association nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	CONSTRAINT PK__draft_fv__3213E83FCFCE5176 PRIMARY KEY (id),
	CONSTRAINT UQ__draft_fv__8E492405385423F7 UNIQUE (fvci_application_id)
);


-- oneture_db.nsdl.draft_fvci_telephone_number_details foreign keys

ALTER TABLE oneture_db.nsdl.draft_fvci_telephone_number_details ADD CONSTRAINT FK_draft_fvci_telephone_number_details_fvci_application FOREIGN KEY (fvci_application_id) REFERENCES oneture_db.nsdl.draft_fvci_applications(application_id) ON DELETE CASCADE;


-- oneture_db.nsdl.draft_fvic_kyc_details foreign keys

ALTER TABLE oneture_db.nsdl.draft_fvic_kyc_details ADD CONSTRAINT FK_fvic_kyc_fvci_application FOREIGN KEY (fvci_application_id) REFERENCES oneture_db.nsdl.draft_fvci_applications(application_id) ON DELETE CASCADE;


-- oneture_db.nsdl.draft_fvic_registration_details foreign keys

ALTER TABLE oneture_db.nsdl.draft_fvic_registration_details ADD CONSTRAINT fk_fvic_registration FOREIGN KEY (fvci_application_id) REFERENCES oneture_db.nsdl.draft_fvci_applications(application_id);


-- oneture_db.nsdl.fvci_ekyc_benificial_owner_details definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.fvci_ekyc_benificial_owner_details;

CREATE TABLE oneture_db.nsdl.fvci_ekyc_benificial_owner_details (
	id int IDENTITY(1,1) NOT NULL,
	fvci_application_id nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	name_address nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	date_of_birth date NULL,
	tax_residancy_juridication nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	natinality nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	acting_alonng_person_group_name_address nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	bo_ownership_in_fvci float NULL,
	giverment_doc_identity_number nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	status int NULL,
	created_at datetime DEFAULT getdate() NULL,
	updated_at datetime DEFAULT getdate() NULL,
	CONSTRAINT PK__fv__3213E83F31E6D1B7 PRIMARY KEY (id)
);


-- oneture_db.nsdl.fvci_ekyc_contact_details definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.fvci_ekyc_contact_details;

CREATE TABLE oneture_db.nsdl.fvci_ekyc_contact_details (
	id int IDENTITY(1,1) NOT NULL,
	fvci_application_id nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	fax_number nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	website nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	mobile_number nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	email_id nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	created_at datetime DEFAULT getdate() NULL,
	updated_at datetime DEFAULT getdate() NULL,
	CONSTRAINT PK__fv__3213E83F652039F7 PRIMARY KEY (id),
	CONSTRAINT UQ__application_contact UNIQUE (fvci_application_id)
);


-- oneture_db.nsdl.fvci_global_custodian_details definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.fvci_global_custodian_details;

CREATE TABLE oneture_db.nsdl.fvci_global_custodian_details (
	id int IDENTITY(1,1) NOT NULL,
	fvci_application_id nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	name nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	country nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	registration_number nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	address nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	created_at datetime DEFAULT getdate() NULL,
	updated_at datetime DEFAULT getdate() NULL,
	CONSTRAINT PK__fv__3213E83F0A8FDE68 PRIMARY KEY (id),
	CONSTRAINT UQ__fv__8E492405F6F1D220 UNIQUE (fvci_application_id)
);


-- oneture_db.nsdl.fvci_incidents_of_law_voilation definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.fvci_incidents_of_law_voilation;

CREATE TABLE oneture_db.nsdl.fvci_incidents_of_law_voilation (
	id int IDENTITY(1,1) NOT NULL,
	fvci_application_id nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	description nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	created_at datetime DEFAULT getdate() NULL,
	updated_at datetime DEFAULT getdate() NULL,
	CONSTRAINT PK__fv__3213E83FD06C6FBF PRIMARY KEY (id),
	CONSTRAINT UQ__fv__8E4924059B7D4B68 UNIQUE (fvci_application_id)
);


-- oneture_db.nsdl.fvci_income_details definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.fvci_income_details;

CREATE TABLE oneture_db.nsdl.fvci_income_details (
	id int IDENTITY(1,1) NOT NULL,
	fvci_application_id nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	source_of_income nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	code_of_business nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	gross_annual_income float NULL,
	net_worth float NULL,
	as_on_date date NULL,
	status int NULL,
	created_at datetime DEFAULT getdate() NULL,
	updated_at datetime DEFAULT getdate() NULL,
	CONSTRAINT PK__fv__3213E83FA52F51D3 PRIMARY KEY (id)
);


-- oneture_db.nsdl.fvci_indian_market_associans definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.fvci_indian_market_associans;

CREATE TABLE oneture_db.nsdl.fvci_indian_market_associans (
	id int IDENTITY(1,1) NOT NULL,
	fvci_application_id nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	name nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	associated_as nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	registration_number nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	period_of_registration nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	created_at datetime DEFAULT getdate() NULL,
	updated_at datetime DEFAULT getdate() NULL,
	CONSTRAINT PK__fv__3213E83F2D7FBC56 PRIMARY KEY (id),
	CONSTRAINT UQ__fv__8E4924057C0B3617 UNIQUE (fvci_application_id)
);


-- oneture_db.nsdl.fvci_info_basic_of_ownership_bo_details definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.fvci_info_basic_of_ownership_bo_details;

CREATE TABLE oneture_db.nsdl.fvci_info_basic_of_ownership_bo_details (
	id int IDENTITY(1,1) NOT NULL,
	fvci_application_id nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	name_of_bo nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	stake float NULL,
	name_of_entity nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	country nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	stake_percentage float NULL,
	is_individual bit NULL,
	created_at datetime DEFAULT getdate() NULL,
	updated_at datetime DEFAULT getdate() NULL,
	CONSTRAINT PK__fv__3213E83FFBFD42D6 PRIMARY KEY (id)
);


-- oneture_db.nsdl.fvci_info_basic_of_ownership_details definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.fvci_info_basic_of_ownership_details;

CREATE TABLE oneture_db.nsdl.fvci_info_basic_of_ownership_details (
	id int IDENTITY(1,1) NOT NULL,
	fvci_application_id nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	is_no_entity_holding_gt bit NOT NULL,
	entity_holding decimal(18,2) NOT NULL,
	created_at datetime DEFAULT getdate() NULL,
	updated_at datetime DEFAULT getdate() NULL,
	CONSTRAINT PK__fv__3213E83F9B299FE0 PRIMARY KEY (id),
	CONSTRAINT UQ__fv__8E4924055772D1EE UNIQUE (fvci_application_id)
);
ALTER TABLE oneture_db.nsdl.fvci_info_basic_of_ownership_details WITH NOCHECK ADD CONSTRAINT CK__fvc__entit__743A1EC7 CHECK (([entity_holding]>=(0) AND [entity_holding]<=(100)));


-- oneture_db.nsdl.fvci_information_of_sa_sm_fvci_applicant definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.fvci_information_of_sa_sm_fvci_applicant;

CREATE TABLE oneture_db.nsdl.fvci_information_of_sa_sm_fvci_applicant (
	id int IDENTITY(1,1) NOT NULL,
	fvci_application_id nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	name nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	relationship_with_applicant nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	pan nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	country nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	date_of_birth nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	address nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	goverment_id nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	created_at datetime DEFAULT getdate() NULL,
	updated_at datetime DEFAULT getdate() NULL,
	CONSTRAINT PK__fv__3213E83F0672C263 PRIMARY KEY (id)
);


-- oneture_db.nsdl.fvci_investment_manager_details definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.fvci_investment_manager_details;

CREATE TABLE oneture_db.nsdl.fvci_investment_manager_details (
	id int IDENTITY(1,1) NOT NULL,
	fvci_application_id nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	name nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[type] nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	country nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	phone_number nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	fax_number nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	email nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	status int NULL,
	created_at datetime DEFAULT getdate() NULL,
	updated_at datetime DEFAULT getdate() NULL,
	CONSTRAINT PK__fv__3213E83FFCA0CFD6 PRIMARY KEY (id)
);


-- oneture_db.nsdl.fvci_ekyc_benificial_owner_details foreign keys

ALTER TABLE oneture_db.nsdl.fvci_ekyc_benificial_owner_details ADD CONSTRAINT fk__ekyc FOREIGN KEY (fvci_application_id) REFERENCES oneture_db.nsdl.fvci_applications(application_id);


-- oneture_db.nsdl.fvci_ekyc_contact_details foreign keys

ALTER TABLE oneture_db.nsdl.fvci_ekyc_contact_details ADD CONSTRAINT fk__ekyc_contact_details_fvci_application FOREIGN KEY (fvci_application_id) REFERENCES oneture_db.nsdl.fvci_applications(application_id) ON DELETE CASCADE;


-- oneture_db.nsdl.fvci_global_custodian_details foreign keys

ALTER TABLE oneture_db.nsdl.fvci_global_custodian_details ADD CONSTRAINT fk__global_custodian_details_fvci_application FOREIGN KEY (fvci_application_id) REFERENCES oneture_db.nsdl.fvci_applications(application_id) ON DELETE CASCADE;


-- oneture_db.nsdl.fvci_incidents_of_law_voilation foreign keys

ALTER TABLE oneture_db.nsdl.fvci_incidents_of_law_voilation ADD CONSTRAINT fk__law_voilation FOREIGN KEY (fvci_application_id) REFERENCES oneture_db.nsdl.fvci_applications(application_id);


-- oneture_db.nsdl.fvci_income_details foreign keys

ALTER TABLE oneture_db.nsdl.fvci_income_details ADD CONSTRAINT fk__income FOREIGN KEY (fvci_application_id) REFERENCES oneture_db.nsdl.fvci_applications(application_id);


-- oneture_db.nsdl.fvci_indian_market_associans foreign keys

ALTER TABLE oneture_db.nsdl.fvci_indian_market_associans ADD CONSTRAINT fk__indian_market FOREIGN KEY (fvci_application_id) REFERENCES oneture_db.nsdl.fvci_applications(application_id);


-- oneture_db.nsdl.fvci_info_basic_of_ownership_bo_details foreign keys

ALTER TABLE oneture_db.nsdl.fvci_info_basic_of_ownership_bo_details ADD CONSTRAINT fk__bo_details FOREIGN KEY (fvci_application_id) REFERENCES oneture_db.nsdl.fvci_applications(application_id);


-- oneture_db.nsdl.fvci_info_basic_of_ownership_details foreign keys

ALTER TABLE oneture_db.nsdl.fvci_info_basic_of_ownership_details ADD CONSTRAINT fk__ownership_application FOREIGN KEY (fvci_application_id) REFERENCES oneture_db.nsdl.fvci_applications(application_id) ON DELETE CASCADE;


-- oneture_db.nsdl.fvci_information_of_sa_sm_fvci_applicant foreign keys

ALTER TABLE oneture_db.nsdl.fvci_information_of_sa_sm_fvci_applicant ADD CONSTRAINT fk__sa_sm FOREIGN KEY (fvci_application_id) REFERENCES oneture_db.nsdl.fvci_applications(application_id);


-- oneture_db.nsdl.fvci_investment_manager_details foreign keys

ALTER TABLE oneture_db.nsdl.fvci_investment_manager_details ADD CONSTRAINT fk__investment_manager_fvci_application FOREIGN KEY (fvci_application_id) REFERENCES oneture_db.nsdl.fvci_applications(application_id) ON DELETE CASCADE;



-- oneture_db.nsdl.otp_master definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.otp_master;

CREATE TABLE oneture_db.nsdl.otp_master (
	srno int IDENTITY(1,1) NOT NULL,
	user_id int NULL,
	ur_id int NULL,
	otp_no varchar(10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	otp_dt datetime DEFAULT getdate() NOT NULL,
	module_nm varchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	used_yn char(1) COLLATE SQL_Latin1_General_CP1_CI_AS DEFAULT 'N' NOT NULL,
	oplog_no int NULL,
	oper1 varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	gresponse varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	gerrorcode varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	gdescription varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	CONSTRAINT PK__otp_mast__36B150C6F1CA875C PRIMARY KEY (srno)
);


-- oneture_db.nsdl.fvci_is_bank definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.fvci_is_bank;

CREATE TABLE oneture_db.nsdl.fvci_is_bank (
	id int IDENTITY(1,1) NOT NULL,
	fvci_application_id nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	is_bank bit NOT NULL,
	name_of_bank nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	have_office_in_india bit NOT NULL,
	created_at datetime DEFAULT getdate() NULL,
	updated_at datetime DEFAULT getdate() NULL,
	CONSTRAINT PK__fv__3213E83F04D6919D PRIMARY KEY (id),
	CONSTRAINT UQ__fv__8E49240545255CA8 UNIQUE (fvci_application_id)
);


-- oneture_db.nsdl.fvci_kra_for_permission_to_download_kyc_doc definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.fvci_kra_for_permission_to_download_kyc_doc;

CREATE TABLE oneture_db.nsdl.fvci_kra_for_permission_to_download_kyc_doc (
	id int IDENTITY(1,1) NOT NULL,
	fvci_application_id nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	is_kra_required bit NULL,
	name_of_fvci_represntative nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	email_1 nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	email_2 nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	email_3 nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	phone_number nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	created_at datetime DEFAULT getdate() NULL,
	updated_at datetime DEFAULT getdate() NULL,
	CONSTRAINT PK__fv__3213E83F0521A9DD PRIMARY KEY (id),
	CONSTRAINT UQ__fv__8E49240507798430 UNIQUE (fvci_application_id)
);


-- oneture_db.nsdl.fvci_kyc_documents definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.fvci_kyc_documents;

CREATE TABLE oneture_db.nsdl.fvci_kyc_documents (
	id int IDENTITY(1,1) NOT NULL,
	fvci_application_id nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	document_type nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	document_identifier nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	document_path nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	status int NULL,
	created_at datetime DEFAULT getdate() NULL,
	updated_at datetime DEFAULT getdate() NULL,
	CONSTRAINT PK__fv__3213E83F62939D58 PRIMARY KEY (id)
);


-- oneture_db.nsdl.fvci_kyc_lei_details definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.fvci_kyc_lei_details;

CREATE TABLE oneture_db.nsdl.fvci_kyc_lei_details (
	id int IDENTITY(1,1) NOT NULL,
	fvci_application_id nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	trc_number nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	country_of_tax_residence nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	created_at datetime NOT NULL,
	updated_at datetime NOT NULL,
	CONSTRAINT PK_fvci_kyc_lei_details PRIMARY KEY (id)
);
 CREATE NONCLUSTERED INDEX IDX_fvci_kyc_lei_application ON oneture_db.nsdl.fvci_kyc_lei_details (  fvci_application_id ASC  )  
	 WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  )
	 ON [PRIMARY ] ;


-- oneture_db.nsdl.fvci_regulatory_authority_details definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.fvci_regulatory_authority_details;

CREATE TABLE oneture_db.nsdl.fvci_regulatory_authority_details (
	id int IDENTITY(1,1) NOT NULL,
	fvci_application_id nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	regulatory_authority_name nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	regulatory_authority_country nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	regulatory_authority_website nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	regulatory_authority_reg_number nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	regulatory_authority_category nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	created_at datetime DEFAULT getdate() NULL,
	updated_at datetime DEFAULT getdate() NULL,
	CONSTRAINT PK__fv__3213E83FDD040E1A PRIMARY KEY (id)
);


-- oneture_db.nsdl.fvci_sub_class_benificial_owner_details definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.fvci_sub_class_benificial_owner_details;

CREATE TABLE oneture_db.nsdl.fvci_sub_class_benificial_owner_details (
	id int IDENTITY(1,1) NOT NULL,
	fvci_sub_class_details_id int NULL,
	name_address nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	date_of_birth date NULL,
	tax_residancy_juridication nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	natinality nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	acting_alonng_person_group_name_address nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	bo_ownership_in_fvci float NULL,
	giverment_doc_identity_number nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	status int NULL,
	created_at datetime DEFAULT getdate() NULL,
	updated_at datetime DEFAULT getdate() NULL,
	CONSTRAINT PK__fv__3213E83FCB7F3484 PRIMARY KEY (id),
	CONSTRAINT UQ__fv__FEBABBA9D27B7A7E UNIQUE (fvci_sub_class_details_id)
);


-- oneture_db.nsdl.fvci_sub_class_details definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.fvci_sub_class_details;

CREATE TABLE oneture_db.nsdl.fvci_sub_class_details (
	id int IDENTITY(1,1) NOT NULL,
	fvci_application_id nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	name nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	created_at datetime DEFAULT getdate() NULL,
	updated_at datetime DEFAULT getdate() NULL,
	CONSTRAINT PK__fv__3213E83F7BB74A49 PRIMARY KEY (id)
);


-- oneture_db.nsdl.fvci_telephone_number_details definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.fvci_telephone_number_details;

CREATE TABLE oneture_db.nsdl.fvci_telephone_number_details (
	id int IDENTITY(1,1) NOT NULL,
	fvci_application_id nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	country_code nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	std_code nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	phone_number nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	phone_type nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	status int NULL,
	created_at datetime DEFAULT getdate() NULL,
	updated_at datetime DEFAULT getdate() NULL,
	contacttype varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	CONSTRAINT PK__fv__3213E83F5CE59C3F PRIMARY KEY (id)
);


-- oneture_db.nsdl.fvic_kyc_details definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.fvic_kyc_details;

CREATE TABLE oneture_db.nsdl.fvic_kyc_details (
	id int IDENTITY(1,1) NOT NULL,
	fvci_application_id nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	name nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	has_other_name bit DEFAULT 0 NULL,
	other_name nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	date_of_incorporation date NULL,
	date_of_commencement date NULL,
	place_of_incorporation nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	country_of_incorporation nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	isd_country_code_of_incorportation nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	legal_form_and_law_of_incorporation nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	legal_entity_identifier nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	address_of_cummunication nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	have_office_in_india bit DEFAULT 0 NULL,
	benificial_ownership_holding float NULL,
	does_other_person_holder_ownership bit NULL,
	is_politically_exposed bit NULL,
	is_related_to_politically_exposed bit NULL,
	created_at datetime NOT NULL,
	updated_at datetime NOT NULL,
	CONSTRAINT PK_fvic_kyc_details PRIMARY KEY (id)
);
 CREATE NONCLUSTERED INDEX IDX_fvci_kyc_application ON oneture_db.nsdl.fvic_kyc_details (  fvci_application_id ASC  )  
	 WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  )
	 ON [PRIMARY ] ;


-- oneture_db.nsdl.fvic_registration_details definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.fvic_registration_details;

CREATE TABLE oneture_db.nsdl.fvic_registration_details (
	id int IDENTITY(1,1) NOT NULL,
	fvci_application_id nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	type_of_applicant nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	other_type_of_applicant nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	type_of_entity nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	is_provided_facta_crs_provided bit NULL,
	is_coming_from_global_custodian bit NULL,
	ddp_name nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	ddp_registration_number nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	custodian_name nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	custodian_registration_number nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	dp_name nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	dp_registration_number nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	bank_name nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	bank_address nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	is_associated_with_securities_market bit NULL,
	does_hold_pan bit NULL,
	pan_number nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	is_violated_law bit NULL,
	created_at datetime DEFAULT getdate() NULL,
	updated_at datetime DEFAULT getdate() NULL,
	details_of_prior_association nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	CONSTRAINT PK__fv__3213E83FCFCE5176 PRIMARY KEY (id),
	CONSTRAINT UQ__fv__8E492405385423F7 UNIQUE (fvci_application_id)
);


-- oneture_db.nsdl.fvci_is_bank foreign keys

ALTER TABLE oneture_db.nsdl.fvci_is_bank ADD CONSTRAINT fk__is_bank_application FOREIGN KEY (fvci_application_id) REFERENCES oneture_db.nsdl.fvci_applications(application_id) ON DELETE CASCADE;


-- oneture_db.nsdl.fvci_kra_for_permission_to_download_kyc_doc foreign keys

ALTER TABLE oneture_db.nsdl.fvci_kra_for_permission_to_download_kyc_doc ADD CONSTRAINT fk__kra_application FOREIGN KEY (fvci_application_id) REFERENCES oneture_db.nsdl.fvci_applications(application_id) ON DELETE CASCADE;


-- oneture_db.nsdl.fvci_kyc_documents foreign keys

ALTER TABLE oneture_db.nsdl.fvci_kyc_documents ADD CONSTRAINT fk__kyc_documents_fvci_application FOREIGN KEY (fvci_application_id) REFERENCES oneture_db.nsdl.fvci_applications(application_id) ON DELETE CASCADE;


-- oneture_db.nsdl.fvci_kyc_lei_details foreign keys

ALTER TABLE oneture_db.nsdl.fvci_kyc_lei_details ADD CONSTRAINT fk__kyc_lei_application FOREIGN KEY (fvci_application_id) REFERENCES oneture_db.nsdl.fvci_applications(application_id) ON DELETE CASCADE;


-- oneture_db.nsdl.fvci_regulatory_authority_details foreign keys

ALTER TABLE oneture_db.nsdl.fvci_regulatory_authority_details ADD CONSTRAINT fk__regulatory_authority_details_fvci_application FOREIGN KEY (fvci_application_id) REFERENCES oneture_db.nsdl.fvci_applications(application_id) ON DELETE CASCADE;


-- oneture_db.nsdl.fvci_sub_class_benificial_owner_details foreign keys

ALTER TABLE oneture_db.nsdl.fvci_sub_class_benificial_owner_details ADD CONSTRAINT fk__sub_class_bo FOREIGN KEY (fvci_sub_class_details_id) REFERENCES oneture_db.nsdl.fvci_sub_class_details(id);


-- oneture_db.nsdl.fvci_sub_class_details foreign keys

ALTER TABLE oneture_db.nsdl.fvci_sub_class_details ADD CONSTRAINT fk__sub_class FOREIGN KEY (fvci_application_id) REFERENCES oneture_db.nsdl.fvci_applications(application_id);


-- oneture_db.nsdl.fvci_telephone_number_details foreign keys

ALTER TABLE oneture_db.nsdl.fvci_telephone_number_details ADD CONSTRAINT fk__telephone_number_details_fvci_application FOREIGN KEY (fvci_application_id) REFERENCES oneture_db.nsdl.fvci_applications(application_id) ON DELETE CASCADE;


-- oneture_db.nsdl.fvic_kyc_details foreign keys

ALTER TABLE oneture_db.nsdl.fvic_kyc_details ADD CONSTRAINT FK_kyc_fvci_application FOREIGN KEY (fvci_application_id) REFERENCES oneture_db.nsdl.fvci_applications(application_id) ON DELETE CASCADE;


-- oneture_db.nsdl.fvic_registration_details foreign keys

ALTER TABLE oneture_db.nsdl.fvic_registration_details ADD CONSTRAINT fk_registration FOREIGN KEY (fvci_application_id) REFERENCES oneture_db.nsdl.fvci_applications(application_id);


-- oneture_db.nsdl.prior_association_master definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.prior_association_master;

CREATE TABLE oneture_db.nsdl.prior_association_master (
	association_id int IDENTITY(1,1) NOT NULL,
	entity varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	created_dtm datetime DEFAULT getdate() NOT NULL,
	modified_dtm datetime NULL,
	CONSTRAINT PK__prior_as__B71D4135BEE26C07 PRIMARY KEY (association_id),
	CONSTRAINT UQ__prior_as__3D2FDE39C52F8C49 UNIQUE (entity)
);


-- oneture_db.nsdl.proof_of_identity_address_master definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.proof_of_identity_address_master;

CREATE TABLE oneture_db.nsdl.proof_of_identity_address_master (
	id int IDENTITY(1,1) NOT NULL,
	code nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	value nvarchar(500) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	CONSTRAINT UQ__proof_of__357D4CF90553979C UNIQUE (code),
	CONSTRAINT UQ__proof_of__40BBEA3A71ED1457 UNIQUE (value)
);


-- oneture_db.nsdl.roles_master definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.roles_master;

CREATE TABLE oneture_db.nsdl.roles_master (
	role_id int IDENTITY(1,1) NOT NULL,
	role_code varchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	role_name varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	visible tinyint DEFAULT 1 NOT NULL,
	status tinyint DEFAULT 1 NOT NULL,
	created_by int NULL,
	created_dtm datetime DEFAULT getdate() NOT NULL,
	modified_by int NULL,
	modified_dtm datetime NULL,
	CONSTRAINT PK__roles_ma__760965CC18D9475D PRIMARY KEY (role_id),
	CONSTRAINT UQ__roles_ma__BAE63075C84BC867 UNIQUE (role_code)
);


-- oneture_db.nsdl.source_of_income_master definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.source_of_income_master;

CREATE TABLE oneture_db.nsdl.source_of_income_master (
	id int IDENTITY(1,1) NOT NULL,
	code nvarchar(5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	value nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	CONSTRAINT UQ__source_o__357D4CF9E3D5B594 UNIQUE (code),
	CONSTRAINT UQ__source_o__40BBEA3AA4B6B3CE UNIQUE (value)
);


-- oneture_db.nsdl.status_master definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.status_master;

CREATE TABLE oneture_db.nsdl.status_master (
	StatusID int IDENTITY(1,1) NOT NULL,
	StatusName varchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	StatusCode varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	CONSTRAINT UQ__status_ma__05E7698A70CF2D35 UNIQUE (StatusName),
	CONSTRAINT UQ__status_ma__6A7B44FCF96B60B4 UNIQUE (StatusCode)
);


-- oneture_db.nsdl.type_of_entity_master definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.type_of_entity_master;

CREATE TABLE oneture_db.nsdl.type_of_entity_master (
	id int IDENTITY(1,1) NOT NULL,
	code nvarchar(5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	value nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	CONSTRAINT UQ__type_of___357D4CF912361470 UNIQUE (code),
	CONSTRAINT UQ__type_of___40BBEA3A2D88F511 UNIQUE (value)
);


-- oneture_db.nsdl.user_registrations_Audit definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.user_registrations_Audit;

CREATE TABLE oneture_db.nsdl.user_registrations_Audit (
	Id int IDENTITY(1,1) NOT NULL,
	OperationType nvarchar(10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	OperationTime datetime DEFAULT getdate() NULL,
	ModifiedBy nvarchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	ur_id int NULL,
	role_id int NULL,
	user_type_id int NULL,
	entity_name varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	email_id varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	password varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	dob date NULL,
	specify_reg varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	specify_other varchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	lei_reg_no varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	lei_details varchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	user_name_fpi_app varchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	gc_name varchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	gc_reg_no varchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	gc_name_of_user varchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	address_1 varchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	address_2 varchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	address_3 varchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	city varchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	state varchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	pincode varchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	country_code varchar(10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	country varchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	area_code varchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	number varchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	user_as varchar(30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	ddp int NULL,
	pending_ddp_flag int NULL,
	verification_flag int DEFAULT 0 NOT NULL,
	created_dtm datetime DEFAULT getdate() NOT NULL,
	modified_dtm datetime NULL,
	CONSTRAINT PK__user_reg__3214EC0713F25B5F PRIMARY KEY (Id)
);


-- oneture_db.nsdl.user_types definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.user_types;

CREATE TABLE oneture_db.nsdl.user_types (
	id int IDENTITY(1,1) NOT NULL,
	type_name varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	CONSTRAINT PK__user_typ__3213E83F58FA5F93 PRIMARY KEY (id),
	CONSTRAINT UQ__user_typ__543C4FD96BBBF427 UNIQUE (type_name)
);


-- oneture_db.nsdl.users definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.users;

CREATE TABLE oneture_db.nsdl.users (
	user_id int IDENTITY(1,1) NOT NULL,
	user_nm varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	email_id varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	password varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	contact_no varchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	address varchar(500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	dp_id int NULL,
	role_id int NOT NULL,
	status int DEFAULT 1 NULL,
	failed_count int DEFAULT 0 NULL,
	created_dtm datetime DEFAULT getdate() NULL,
	created_by int NULL,
	modified_dtm datetime NULL,
	modified_by int NULL,
	login_dtm datetime NULL,
	last_pwd_change_dtm datetime NULL,
	user_type_id int NULL,
	is_forget_password bit DEFAULT 0 NULL,
	allow_otp bit DEFAULT 1 NOT NULL,
	otp_cnt tinyint DEFAULT 0 NOT NULL,
	otp_dtm datetime NULL,
	closed_dtm datetime NULL,
	ctg_type varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	app_type varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	tkn_no varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	pannumber varchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	dob date NULL,
	entity_nm nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	caf_logon_type nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	updatedby_aud int NULL,
	film_api_expdat datetime NULL,
	film_api_start_dt datetime NULL,
	registration_id int NULL,
	new_password varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	CONSTRAINT PK__users__B9BE370F17B96CF7 PRIMARY KEY (user_id),
	CONSTRAINT UQ__users__3FEF87672B00470B UNIQUE (email_id),
	CONSTRAINT users_email_idx UNIQUE (email_id)
);
 CREATE UNIQUE NONCLUSTERED INDEX IX_users_registration_id ON oneture_db.nsdl.users (  registration_id ASC  )  
	 WHERE  ([registration_id] IS NOT NULL)
	 WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  )
	 ON [PRIMARY ] ;


-- oneture_db.nsdl.users_Audit definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.users_Audit;

CREATE TABLE oneture_db.nsdl.users_Audit (
	Id int IDENTITY(1,1) NOT NULL,
	OperationType nvarchar(10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	OperationTime datetime DEFAULT getdate() NULL,
	ModifiedBy nvarchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	user_id int NULL,
	user_nm varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	email_id varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	password varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	contact_no varchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	address varchar(500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	dp_id int NULL,
	role_id int NOT NULL,
	status int DEFAULT 1 NULL,
	failed_count int DEFAULT 0 NULL,
	created_dtm datetime DEFAULT getdate() NULL,
	created_by int NULL,
	modified_dtm datetime NULL,
	modified_by int NULL,
	login_dtm datetime NULL,
	last_pwd_change_dtm datetime NULL,
	user_type_id int NULL,
	is_forget_password bit DEFAULT 0 NULL,
	allow_otp bit DEFAULT 1 NOT NULL,
	otp_cnt tinyint DEFAULT 0 NOT NULL,
	otp_dtm datetime NULL,
	closed_dtm datetime NULL,
	ctg_type varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	app_type varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	tkn_no varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	pannumber varchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	dob date NULL,
	entity_nm nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	caf_logon_type nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	updatedby_aud int NULL,
	film_api_expdat datetime NULL,
	film_api_start_dt datetime NULL,
	registration_id int NULL,
	CONSTRAINT PK__users_Au__3214EC070AD054B2 PRIMARY KEY (Id)
);


-- oneture_db.nsdl.verification_statuses definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.verification_statuses;

CREATE TABLE oneture_db.nsdl.verification_statuses (
	id int IDENTITY(1,1) NOT NULL,
	status_name varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	status_code varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	CONSTRAINT PK__verifica__3213E83F62DC6AA9 PRIMARY KEY (id),
	CONSTRAINT UQ__verifica__4157B02145544B08 UNIQUE (status_code),
	CONSTRAINT UQ__verifica__501B37530E24A458 UNIQUE (status_name)
);


-- oneture_db.nsdl.sessions definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.sessions;

CREATE TABLE oneture_db.nsdl.sessions (
	session_id uniqueidentifier DEFAULT newid() NOT NULL,
	user_id int NOT NULL,
	jwt_token nvarchar(MAX) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	is_active bit DEFAULT 1 NULL,
	created_at datetime DEFAULT getdate() NULL,
	expires_at datetime NOT NULL,
	CONSTRAINT PK__sessions__69B13FDCC48F9670 PRIMARY KEY (session_id),
	CONSTRAINT FK__sessions__user_i__3707BEAC FOREIGN KEY (user_id) REFERENCES oneture_db.nsdl.users(user_id) ON DELETE CASCADE
);


-- oneture_db.nsdl.user_registrations definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.user_registrations;

CREATE TABLE oneture_db.nsdl.user_registrations (
	ur_id int IDENTITY(1,1) NOT NULL,
	role_id int NULL,
	user_type_id int NULL,
	entity_name varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	email_id varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	password varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	dob date NULL,
	specify_reg varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	specify_other varchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	lei_reg_no varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	lei_details varchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	user_name_fpi_app varchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	gc_name varchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	gc_reg_no varchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	gc_name_of_user varchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	address_1 varchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	address_2 varchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	address_3 varchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	city varchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	state varchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	pincode varchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	country_code varchar(10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	country varchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	area_code varchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	number varchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	user_as varchar(30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	ddp int NULL,
	pending_ddp_flag int NULL,
	verification_flag int DEFAULT 0 NOT NULL,
	created_dtm datetime DEFAULT getdate() NOT NULL,
	modified_dtm datetime NULL,
	new_password varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	CONSTRAINT PK__user_reg__B40F6A70E8A7AA5A PRIMARY KEY (ur_id),
	CONSTRAINT UQ__user_reg__3FEF876786922869 UNIQUE (email_id),
	CONSTRAINT FK__user_regi__role___1B5FA437 FOREIGN KEY (role_id) REFERENCES oneture_db.nsdl.roles_master(role_id),
	CONSTRAINT FK__user_regi__user___1C53C870 FOREIGN KEY (user_type_id) REFERENCES oneture_db.nsdl.user_types(id)
);


-- oneture_db.nsdl.role_activity definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.role_activity;

CREATE TABLE oneture_db.nsdl.role_activity (
	role_id int NOT NULL,
	activity_id int NOT NULL,
	is_default tinyint DEFAULT 0 NOT NULL,
	created_by int NULL,
	created_dtm datetime DEFAULT getdate() NOT NULL,
	modified_by int NULL,
	modified_dtm datetime NULL,
	CONSTRAINT PK__role_act__528B9E1A687D7761 PRIMARY KEY (role_id,activity_id)
);


-- oneture_db.nsdl.role_permissions definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.role_permissions;

CREATE TABLE oneture_db.nsdl.role_permissions (
	id int IDENTITY(1,1) NOT NULL,
	role_id int NOT NULL,
	permission_id int NOT NULL,
	status tinyint DEFAULT 1 NOT NULL,
	created_by int NULL,
	created_at datetime DEFAULT getdate() NOT NULL,
	updated_by int NULL,
	updated_at datetime NULL,
	CONSTRAINT PK__role_per__3213E83FC45E6E6B PRIMARY KEY (id)
);


-- oneture_db.nsdl.role_activity foreign keys

ALTER TABLE oneture_db.nsdl.role_activity ADD CONSTRAINT FK__role_acti__activ__3EA8E074 FOREIGN KEY (activity_id) REFERENCES oneture_db.nsdl.activities(activity_id);
ALTER TABLE oneture_db.nsdl.role_activity ADD CONSTRAINT FK__role_acti__role___3DB4BC3B FOREIGN KEY (role_id) REFERENCES oneture_db.nsdl.roles_master(role_id);


-- oneture_db.nsdl.role_permissions foreign keys

ALTER TABLE oneture_db.nsdl.role_permissions ADD CONSTRAINT FK__role_perm__permi__178F1353 FOREIGN KEY (permission_id) REFERENCES oneture_db.nsdl.permissions(id) ON DELETE CASCADE;
ALTER TABLE oneture_db.nsdl.role_permissions ADD CONSTRAINT FK__role_perm__role___169AEF1A FOREIGN KEY (role_id) REFERENCES oneture_db.nsdl.roles_master(role_id) ON DELETE CASCADE;