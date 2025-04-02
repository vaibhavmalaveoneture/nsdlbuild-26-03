-- oneture_db.nsdl.audit_Ekyc definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.audit_Ekyc;

CREATE TABLE oneture_db.nsdl.audit_Ekyc (
	ApplicationId nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	Name nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	DateOfIncorporation datetime NULL,
	DateOfCommencement datetime NULL,
	PlaceOfIncorporation nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	CountryOfIncorporation varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	CountryCodeOfIncorporation varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	LegalForm nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	LEI nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	SameAsAbove bit NULL,
	CommunicationAddress nvarchar(500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	UltimateBeneficialOwner nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	UltimateBeneficialOwnerHolding nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	BeneficialOwnership nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	ProofOfIdentity nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	ProofOfAddress nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Date] datetime NULL,
	TypeOfEntity nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	SelectedCity nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	PoliticallyExposed nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	RelatedToPoliticallyExposed nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	CreatedAt datetime DEFAULT getutcdate() NULL,
	UpdatedAt datetime DEFAULT getutcdate() NULL,
	AuditTimestamp datetime DEFAULT getdate() NULL
);


-- oneture_db.nsdl.Ekyc definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.Ekyc;

CREATE TABLE oneture_db.nsdl.Ekyc (
	ApplicationId nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	Name nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	DateOfIncorporation datetime NULL,
	DateOfCommencement datetime NULL,
	PlaceOfIncorporation nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	CountryOfIncorporation varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	CountryCodeOfIncorporation varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	LegalForm nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	LEI nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	SameAsAbove bit NULL,
	CommunicationAddress nvarchar(500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	UltimateBeneficialOwner nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	UltimateBeneficialOwnerHolding nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	BeneficialOwnership nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	ProofOfIdentity nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	ProofOfAddress nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Date] datetime NULL,
	TypeOfEntity nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	SelectedCity nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	PoliticallyExposed nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	RelatedToPoliticallyExposed nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	CreatedAt datetime DEFAULT getutcdate() NULL,
	UpdatedAt datetime DEFAULT getutcdate() NULL,
	CONSTRAINT PK__Ek__C93A4C99EB5743D6 PRIMARY KEY (ApplicationId)
);


-- oneture_db.nsdl.draft_Ekyc definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.draft_Ekyc;

CREATE TABLE oneture_db.nsdl.draft_Ekyc (
	ApplicationId nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	Name nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	DateOfIncorporation datetime NULL,
	DateOfCommencement datetime NULL,
	PlaceOfIncorporation nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	CountryOfIncorporation varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	CountryCodeOfIncorporation varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	LegalForm nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	LEI nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	SameAsAbove bit NULL,
	CommunicationAddress nvarchar(500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	UltimateBeneficialOwner nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	UltimateBeneficialOwnerHolding nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	BeneficialOwnership nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	ProofOfIdentity nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	ProofOfAddress nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Date] datetime NULL,
	TypeOfEntity nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	SelectedCity nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	PoliticallyExposed nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	RelatedToPoliticallyExposed nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	CreatedAt datetime DEFAULT getutcdate() NULL,
	UpdatedAt datetime DEFAULT getutcdate() NULL,
	CONSTRAINT PK__draft_Ek__C93A4C99EB5743D6 PRIMARY KEY (ApplicationId)
);


-- Drop table

-- DROP TABLE oneture_db.nsdl.audit_ApplicantOtherName;

CREATE TABLE oneture_db.nsdl.audit_ApplicantOtherName (
	Id int IDENTITY(1,1) NOT NULL,
	ApplicationId nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	OtherNameRadio bit NULL,
	OtherNameField nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	CreatedAt datetime DEFAULT getutcdate() NULL,
	UpdatedAt datetime DEFAULT getutcdate() NULL,
	AuditTimestamp datetime DEFAULT getutcdate() NULL,
	CONSTRAINT PK_Audit_ApplicantOtherName PRIMARY KEY (Id)
);


-- oneture_db.nsdl.ApplicantOtherName definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.ApplicantOtherName;

CREATE TABLE oneture_db.nsdl.ApplicantOtherName (
	Id int IDENTITY(1,1) NOT NULL,
	ApplicationId nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	OtherNameRadio bit NULL,
	OtherNameField nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	CreatedAt datetime DEFAULT getutcdate() NULL,
	UpdatedAt datetime DEFAULT getutcdate() NULL,
	CONSTRAINT PK__Ap__3214EC07495D860D PRIMARY KEY (Id)
);


-- oneture_db.nsdl.draft_ApplicantOtherName definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.draft_ApplicantOtherName;

CREATE TABLE oneture_db.nsdl.draft_ApplicantOtherName (
	Id int IDENTITY(1,1) NOT NULL,
	ApplicationId nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	OtherNameRadio bit NULL,
	OtherNameField nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	CreatedAt datetime DEFAULT getutcdate() NULL,
	UpdatedAt datetime DEFAULT getutcdate() NULL,
	CONSTRAINT PK__draft_Ap__3214EC07495D860D PRIMARY KEY (Id)
);


-- Drop table

-- DROP TABLE oneture_db.nsdl.audit_TaxResidency;

CREATE TABLE oneture_db.nsdl.audit_TaxResidency (
	Id int IDENTITY(1,1) NOT NULL,
	ApplicationId nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	TRCNo nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	CountryCode varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	CreatedAt datetime DEFAULT getutcdate() NULL,
	UpdatedAt datetime DEFAULT getutcdate() NULL,
	AuditTimestamp datetime DEFAULT getutcdate() NULL,
	CONSTRAINT PK_Audit_TaxResidency PRIMARY KEY (Id)
);


-- oneture_db.nsdl.TaxResidency definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.TaxResidency;

CREATE TABLE oneture_db.nsdl.TaxResidency (
	Id int IDENTITY(1,1) NOT NULL,
	ApplicationId nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	TRCNo nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	CountryCode varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	CreatedAt datetime DEFAULT getutcdate() NULL,
	UpdatedAt datetime DEFAULT getutcdate() NULL,
	CONSTRAINT PK__Ta__3214EC07C9850C2D PRIMARY KEY (Id)
);


-- oneture_db.nsdl.draft_TaxResidency definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.draft_TaxResidency;

CREATE TABLE oneture_db.nsdl.draft_TaxResidency (
	Id int IDENTITY(1,1) NOT NULL,
	ApplicationId nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	TRCNo nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	CountryCode varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	CreatedAt datetime DEFAULT getutcdate() NULL,
	UpdatedAt datetime DEFAULT getutcdate() NULL,
	CONSTRAINT PK__draft_Ta__3214EC07C9850C2D PRIMARY KEY (Id)
);



-- oneture_db.nsdl.audit_RegisteredOffice definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.audit_RegisteredOffice;

CREATE TABLE oneture_db.nsdl.audit_RegisteredOffice (
	Id int IDENTITY(1,1) NOT NULL,
	ApplicationId nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	RegisteredFlatNum nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	RegisteredBuildingName nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	RegisteredCountryCode varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	RegisteredRoadName nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	RegisteredAreaName nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	RegisteredTownName nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	RegisteredZipName nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	RegisteredStateName nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	NotApplicableResidence bit DEFAULT 0 NULL,
	CreatedAt datetime DEFAULT getutcdate() NULL,
	UpdatedAt datetime DEFAULT getutcdate() NULL,
	AuditTimestamp datetime DEFAULT getutcdate() NULL,
	CONSTRAINT PK_Audit_RegisteredOffice PRIMARY KEY (Id)
);


-- oneture_db.nsdl.RegisteredOffice definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.RegisteredOffice;

CREATE TABLE oneture_db.nsdl.RegisteredOffice (
	Id int IDENTITY(1,1) NOT NULL,
	ApplicationId nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	RegisteredFlatNum nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	RegisteredBuildingName nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	RegisteredCountryCode varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	RegisteredRoadName nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	RegisteredAreaName nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	RegisteredTownName nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	RegisteredZipName nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	RegisteredStateName nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	NotApplicableResidence bit DEFAULT 0 NULL,
	CreatedAt datetime DEFAULT getutcdate() NULL,
	UpdatedAt datetime DEFAULT getutcdate() NULL,
	CONSTRAINT PK__Re__3214EC07FC509E1A PRIMARY KEY (Id)
);


-- oneture_db.nsdl.draft_RegisteredOffice definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.draft_RegisteredOffice;

CREATE TABLE oneture_db.nsdl.draft_RegisteredOffice (
	Id int IDENTITY(1,1) NOT NULL,
	ApplicationId nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	RegisteredFlatNum nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	RegisteredBuildingName nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	RegisteredCountryCode varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	RegisteredRoadName nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	RegisteredAreaName nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	RegisteredTownName nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	RegisteredZipName nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	RegisteredStateName nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	NotApplicableResidence bit DEFAULT 0 NULL,
	CreatedAt datetime DEFAULT getutcdate() NULL,
	UpdatedAt datetime DEFAULT getutcdate() NULL,
	CONSTRAINT PK__draft_Re__3214EC07FC509E1A PRIMARY KEY (Id)
);



-- Drop table

-- DROP TABLE oneture_db.nsdl.audit_ForeignOffice;

CREATE TABLE oneture_db.nsdl.audit_ForeignOffice (
	Id int IDENTITY(1,1) NOT NULL,
	ApplicationId nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	ForeignFlatNum nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	ForeignBuildingName nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	ForeignCountryCode varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	ForeignRoadName nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	ForeignAreaName nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	ForeignTownName nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	ForeignZipName nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	ForeignStateName nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	NotApplicableForeignOffice bit DEFAULT 0 NULL,
	CreatedAt datetime DEFAULT getutcdate() NULL,
	UpdatedAt datetime DEFAULT getutcdate() NULL,
	AuditTimestamp datetime DEFAULT getutcdate() NULL,
	CONSTRAINT PK_Audit_ForeignOffice PRIMARY KEY (Id)
);


-- oneture_db.nsdl.ForeignOffice definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.ForeignOffice;

CREATE TABLE oneture_db.nsdl.ForeignOffice (
	Id int IDENTITY(1,1) NOT NULL,
	ApplicationId nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	ForeignFlatNum nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	ForeignBuildingName nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	ForeignCountryCode varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	ForeignRoadName nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	ForeignAreaName nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	ForeignTownName nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	ForeignZipName nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	ForeignStateName nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	NotApplicableForeignOffice bit DEFAULT 0 NULL,
	CreatedAt datetime DEFAULT getutcdate() NULL,
	UpdatedAt datetime DEFAULT getutcdate() NULL,
	CONSTRAINT PK__Fo__3214EC07492D2BBA PRIMARY KEY (Id)
);


-- oneture_db.nsdl.draft_ForeignOffice definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.draft_ForeignOffice;

CREATE TABLE oneture_db.nsdl.draft_ForeignOffice (
	Id int IDENTITY(1,1) NOT NULL,
	ApplicationId nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	ForeignFlatNum nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	ForeignBuildingName nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	ForeignCountryCode varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	ForeignRoadName nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	ForeignAreaName nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	ForeignTownName nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	ForeignZipName nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	ForeignStateName nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	NotApplicableForeignOffice bit DEFAULT 0 NULL,
	CreatedAt datetime DEFAULT getutcdate() NULL,
	UpdatedAt datetime DEFAULT getutcdate() NULL,
	CONSTRAINT PK__draft_Fo__3214EC07492D2BBA PRIMARY KEY (Id)
);


-- oneture_db.nsdl.audit_OfficeInIndia definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.audit_OfficeInIndia;

CREATE TABLE oneture_db.nsdl.audit_OfficeInIndia (
	Id int IDENTITY(1,1) NOT NULL,
	ApplicationId nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	OfficeInIndiaRadio bit NULL,
	IndianFlatNum nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	IndianBuildingName nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	IndianCountryCode varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	IndianRoadName nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	IndianAreaName nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	IndianTownName nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	IndianZipName nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	IndianStateName nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	NotApplicableIndOffice bit DEFAULT 0 NULL,
	CreatedAt datetime DEFAULT getutcdate() NULL,
	UpdatedAt datetime DEFAULT getutcdate() NULL,
	AuditTimestamp datetime DEFAULT getutcdate() NULL,
	CONSTRAINT PK_Audit_OfficeInIndia PRIMARY KEY (Id)
);


-- oneture_db.nsdl.OfficeInIndia definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.OfficeInIndia;

CREATE TABLE oneture_db.nsdl.OfficeInIndia (
	Id int IDENTITY(1,1) NOT NULL,
	ApplicationId nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	OfficeInIndiaRadio bit NULL,
	IndianFlatNum nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	IndianBuildingName nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	IndianCountryCode varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	IndianRoadName nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	IndianAreaName nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	IndianTownName nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	IndianZipName nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	IndianStateName nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	NotApplicableIndOffice bit DEFAULT 0 NULL,
	CreatedAt datetime DEFAULT getutcdate() NULL,
	UpdatedAt datetime DEFAULT getutcdate() NULL,
	CONSTRAINT PK__Of__3214EC078459C9A0 PRIMARY KEY (Id)
);


-- oneture_db.nsdl.draft_OfficeInIndia definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.draft_OfficeInIndia;

CREATE TABLE oneture_db.nsdl.draft_OfficeInIndia (
	Id int IDENTITY(1,1) NOT NULL,
	ApplicationId nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	OfficeInIndiaRadio bit NULL,
	IndianFlatNum nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	IndianBuildingName nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	IndianCountryCode varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	IndianRoadName nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	IndianAreaName nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	IndianTownName nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	IndianZipName nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	IndianStateName nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	NotApplicableIndOffice bit DEFAULT 0 NULL,
	CreatedAt datetime DEFAULT getutcdate() NULL,
	UpdatedAt datetime DEFAULT getutcdate() NULL,
	CONSTRAINT PK__draft_Of__3214EC078459C9A0 PRIMARY KEY (Id)
);


-- oneture_db.nsdl.OfficeInIndia foreign keys

-- oneture_db.nsdl.audit_ContactDetails definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.audit_ContactDetails;

CREATE TABLE oneture_db.nsdl.audit_ContactDetails (
	Id int IDENTITY(1,1) NOT NULL,
	ApplicationId nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	MobileNumber nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	EmailId nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Website nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	CreatedAt datetime DEFAULT getutcdate() NULL,
	UpdatedAt datetime DEFAULT getutcdate() NULL,
	AuditTimestamp datetime DEFAULT getutcdate() NULL,
	CONSTRAINT PK_Audit_ContactDetails PRIMARY KEY (Id)
);


-- oneture_db.nsdl.audit_ContactInfo definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.audit_ContactInfo;

CREATE TABLE oneture_db.nsdl.audit_ContactInfo (
	Id int IDENTITY(1,1) NOT NULL,
	ApplicationId nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Type] nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	CountryCode varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	AreaCode nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Number nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	CreatedAt datetime DEFAULT getutcdate() NULL,
	UpdatedAt datetime DEFAULT getutcdate() NULL,
	AuditTimestamp datetime DEFAULT getutcdate() NULL,
	CONSTRAINT PK_Audit_ContactInfo PRIMARY KEY (Id)
);


-- oneture_db.nsdl.ContactDetails definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.ContactDetails;

CREATE TABLE oneture_db.nsdl.ContactDetails (
	Id int IDENTITY(1,1) NOT NULL,
	ApplicationId nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	MobileNumber nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	EmailId nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Website nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	CreatedAt datetime DEFAULT getutcdate() NULL,
	UpdatedAt datetime DEFAULT getutcdate() NULL,
	CONSTRAINT PK__Co__3214EC07C70CCAB8 PRIMARY KEY (Id)
);


-- oneture_db.nsdl.ContactInfo definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.ContactInfo;

CREATE TABLE oneture_db.nsdl.ContactInfo (
	Id int IDENTITY(1,1) NOT NULL,
	ApplicationId nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Type] nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	CountryCode varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	AreaCode nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Number nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	CreatedAt datetime DEFAULT getutcdate() NULL,
	UpdatedAt datetime DEFAULT getutcdate() NULL,
	CONSTRAINT PK__Co__3214EC07ABB4C846 PRIMARY KEY (Id)
);


-- oneture_db.nsdl.draft_ContactDetails definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.draft_ContactDetails;

CREATE TABLE oneture_db.nsdl.draft_ContactDetails (
	Id int IDENTITY(1,1) NOT NULL,
	ApplicationId nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	MobileNumber nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	EmailId nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Website nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	CreatedAt datetime DEFAULT getutcdate() NULL,
	UpdatedAt datetime DEFAULT getutcdate() NULL,
	CONSTRAINT PK__draft_Co__3214EC07C70CCAB8 PRIMARY KEY (Id)
);


-- oneture_db.nsdl.draft_ContactInfo definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.draft_ContactInfo;

CREATE TABLE oneture_db.nsdl.draft_ContactInfo (
	Id int IDENTITY(1,1) NOT NULL,
	ApplicationId nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Type] nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	CountryCode varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	AreaCode nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Number nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	CreatedAt datetime DEFAULT getutcdate() NULL,
	UpdatedAt datetime DEFAULT getutcdate() NULL,
	CONSTRAINT PK__draft_Co__3214EC07ABB4C846 PRIMARY KEY (Id)
);




-- Drop table

-- DROP TABLE oneture_db.nsdl.InvestmentManager;

CREATE TABLE oneture_db.nsdl.InvestmentManager (
	Id int IDENTITY(1,1) NOT NULL,
	ApplicationId nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	NameOfEntity nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	TypeOfEntity nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	CountryCode varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	TelephoneNumber nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	FaxNumber nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	EmailId nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	CreatedAt datetime DEFAULT getutcdate() NULL,
	UpdatedAt datetime DEFAULT getutcdate() NULL,
	CONSTRAINT PK__In__3214EC079E0D16D5 PRIMARY KEY (Id)
);


-- oneture_db.nsdl.draft_InvestmentManager definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.draft_InvestmentManager;

CREATE TABLE oneture_db.nsdl.draft_InvestmentManager (
	Id int IDENTITY(1,1) NOT NULL,
	ApplicationId nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	NameOfEntity nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	TypeOfEntity nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	CountryCode varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	TelephoneNumber nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	FaxNumber nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	EmailId nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	CreatedAt datetime DEFAULT getutcdate() NULL,
	UpdatedAt datetime DEFAULT getutcdate() NULL,
	CONSTRAINT PK__draft_In__3214EC079E0D16D5 PRIMARY KEY (Id)
);


-- oneture_db.nsdl.InvestmentManager foreign keys


-- oneture_db.nsdl.audit_ComplianceOfficerInfo definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.audit_ComplianceOfficerInfo;

CREATE TABLE oneture_db.nsdl.audit_ComplianceOfficerInfo (
	Id int IDENTITY(1,1) NOT NULL,
	ApplicationId nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	ComplianceOfficerInfoName nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	ComplianceOfficerInfoJob nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	ComplianceOfficerInfoMobile nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	ComplianceOfficerInfoFax nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	ComplianceOfficerInfoEmail nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	CreatedAt datetime DEFAULT getutcdate() NULL,
	UpdatedAt datetime DEFAULT getutcdate() NULL,
	AuditTimestamp datetime DEFAULT getutcdate() NULL,
	CONSTRAINT PK_Audit_ComplianceOfficerInfo PRIMARY KEY (Id)
);


-- oneture_db.nsdl.ComplianceOfficerInfo definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.ComplianceOfficerInfo;

CREATE TABLE oneture_db.nsdl.ComplianceOfficerInfo (
	Id int IDENTITY(1,1) NOT NULL,
	ApplicationId nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	ComplianceOfficerInfoName nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	ComplianceOfficerInfoJob nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	ComplianceOfficerInfoMobile nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	ComplianceOfficerInfoFax nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	ComplianceOfficerInfoEmail nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	CreatedAt datetime DEFAULT getutcdate() NULL,
	UpdatedAt datetime DEFAULT getutcdate() NULL,
	CONSTRAINT PK__Co__3214EC07433C3D08 PRIMARY KEY (Id)
);


-- oneture_db.nsdl.draft_ComplianceOfficerInfo definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.draft_ComplianceOfficerInfo;

CREATE TABLE oneture_db.nsdl.draft_ComplianceOfficerInfo (
	Id int IDENTITY(1,1) NOT NULL,
	ApplicationId nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	ComplianceOfficerInfoName nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	ComplianceOfficerInfoJob nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	ComplianceOfficerInfoMobile nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	ComplianceOfficerInfoFax nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	ComplianceOfficerInfoEmail nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	CreatedAt datetime DEFAULT getutcdate() NULL,
	UpdatedAt datetime DEFAULT getutcdate() NULL,
	CONSTRAINT PK__draft_Co__3214EC07433C3D08 PRIMARY KEY (Id)
);


-- oneture_db.nsdl.audit_ManagingOfficial definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.audit_ManagingOfficial;

CREATE TABLE oneture_db.nsdl.audit_ManagingOfficial (
	Id int IDENTITY(1,1) NOT NULL,
	ApplicationId nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	GovernmentIdNumber nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	NameAndAddress nvarchar(500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	DateOfBirth datetime NULL,
	TaxResidencyJurisdiction varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Nationality varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	ActingAsGroupDetails nvarchar(500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	BoGroupShareholding nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	CreatedAt datetime DEFAULT getutcdate() NULL,
	UpdatedAt datetime DEFAULT getutcdate() NULL,
	AuditTimestamp datetime DEFAULT getutcdate() NULL,
	CONSTRAINT PK_Audit_ManagingOfficial PRIMARY KEY (Id)
);


-- oneture_db.nsdl.ManagingOfficial definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.ManagingOfficial;

CREATE TABLE oneture_db.nsdl.ManagingOfficial (
	Id int IDENTITY(1,1) NOT NULL,
	ApplicationId nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	GovernmentIdNumber nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	NameAndAddress nvarchar(500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	DateOfBirth datetime NULL,
	TaxResidencyJurisdiction varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Nationality varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	ActingAsGroupDetails nvarchar(500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	BoGroupShareholding nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	CreatedAt datetime DEFAULT getutcdate() NULL,
	UpdatedAt datetime DEFAULT getutcdate() NULL,
	CONSTRAINT PK__Ma__3214EC07687AB19A PRIMARY KEY (Id),
	CONSTRAINT UQ_ManagingOfficial_main UNIQUE (ApplicationId,GovernmentIdNumber)
);


-- oneture_db.nsdl.draft_ManagingOfficial definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.draft_ManagingOfficial;

CREATE TABLE oneture_db.nsdl.draft_ManagingOfficial (
	Id int IDENTITY(1,1) NOT NULL,
	ApplicationId nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	GovernmentIdNumber nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	NameAndAddress nvarchar(500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	DateOfBirth datetime NULL,
	TaxResidencyJurisdiction varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Nationality varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	ActingAsGroupDetails nvarchar(500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	BoGroupShareholding nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	CreatedAt datetime DEFAULT getutcdate() NULL,
	UpdatedAt datetime DEFAULT getutcdate() NULL,
	CONSTRAINT PK__draft_Ma__3214EC07687AB19A PRIMARY KEY (Id),
	CONSTRAINT UQ_ManagingOfficial UNIQUE (ApplicationId,GovernmentIdNumber)
);


-- oneture_db.nsdl.ManagingOfficial foreign keys


-- oneture_db.nsdl.audit_IncomeDetails definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.audit_IncomeDetails;

CREATE TABLE oneture_db.nsdl.audit_IncomeDetails (
	Id int IDENTITY(1,1) NOT NULL,
	ApplicationId nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	BusinessCode nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	AnnualIncome nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	AssetLess nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	AsOnDate datetime NULL,
	CreatedAt datetime DEFAULT getutcdate() NULL,
	UpdatedAt datetime DEFAULT getutcdate() NULL,
	AuditTimestamp datetime DEFAULT getutcdate() NULL,
	CONSTRAINT PK_Audit_IncomeDetails PRIMARY KEY (Id)
);


-- oneture_db.nsdl.audit_IncomeSource definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.audit_IncomeSource;

CREATE TABLE oneture_db.nsdl.audit_IncomeSource (
	Id int IDENTITY(1,1) NOT NULL,
	ApplicationId nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	IncomeSourceType int NOT NULL,
	CreatedAt datetime DEFAULT getutcdate() NULL,
	AuditTimestamp datetime DEFAULT getutcdate() NULL,
	CONSTRAINT PK_Audit_IncomeSource PRIMARY KEY (Id)
);


-- oneture_db.nsdl.IncomeDetails definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.IncomeDetails;

CREATE TABLE oneture_db.nsdl.IncomeDetails (
	Id int IDENTITY(1,1) NOT NULL,
	ApplicationId nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	BusinessCode nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	AnnualIncome nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	AssetLess nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	AsOnDate datetime NULL,
	CreatedAt datetime DEFAULT getutcdate() NULL,
	UpdatedAt datetime DEFAULT getutcdate() NULL,
	CONSTRAINT PK__In__3214EC07EC17CB5B PRIMARY KEY (Id),
	CONSTRAINT UQ__In__C93A4C982E552240 UNIQUE (ApplicationId)
);


-- oneture_db.nsdl.IncomeSource definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.IncomeSource;

CREATE TABLE oneture_db.nsdl.IncomeSource (
	Id int IDENTITY(1,1) NOT NULL,
	ApplicationId nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	IncomeSourceType int NOT NULL,
	CreatedAt datetime DEFAULT getutcdate() NULL,
	CONSTRAINT PK__In__3214EC079FA1EA46 PRIMARY KEY (Id)
);


-- oneture_db.nsdl.draft_IncomeDetails definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.draft_IncomeDetails;

CREATE TABLE oneture_db.nsdl.draft_IncomeDetails (
	Id int IDENTITY(1,1) NOT NULL,
	ApplicationId nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	BusinessCode nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	AnnualIncome nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	AssetLess nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	AsOnDate datetime NULL,
	CreatedAt datetime DEFAULT getutcdate() NULL,
	UpdatedAt datetime DEFAULT getutcdate() NULL,
	CONSTRAINT PK__draft_In__3214EC07EC17CB5B PRIMARY KEY (Id),
	CONSTRAINT UQ__draft_In__C93A4C982E552240 UNIQUE (ApplicationId)
);


-- oneture_db.nsdl.draft_IncomeSource definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.draft_IncomeSource;

CREATE TABLE oneture_db.nsdl.draft_IncomeSource (
	Id int IDENTITY(1,1) NOT NULL,
	ApplicationId nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	IncomeSourceType int NOT NULL,
	CreatedAt datetime DEFAULT getutcdate() NULL,
	CONSTRAINT PK__draft_In__3214EC079FA1EA46 PRIMARY KEY (Id)
);




-- oneture_db.nsdl.audit_ApplicantType definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.audit_ApplicantType;

CREATE TABLE oneture_db.nsdl.audit_ApplicantType (
	Id int IDENTITY(1,1) NOT NULL,
	ApplicationId nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	ApplicantTypeName nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	ApplicantTypeOtherEntity nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	CreatedAt datetime DEFAULT getutcdate() NULL,
	UpdatedAt datetime DEFAULT getutcdate() NULL,
	AuditTimestamp datetime DEFAULT getutcdate() NULL,
	CONSTRAINT PK_Audit_ApplicantType PRIMARY KEY (Id)
);


-- oneture_db.nsdl.ApplicantType definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.ApplicantType;

CREATE TABLE oneture_db.nsdl.ApplicantType (
	Id int IDENTITY(1,1) NOT NULL,
	ApplicationId nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	ApplicantTypeName nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	ApplicantTypeOtherEntity nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	CreatedAt datetime DEFAULT getutcdate() NULL,
	UpdatedAt datetime DEFAULT getutcdate() NULL,
	CONSTRAINT PK__Ap__3214EC07FB5EBE43 PRIMARY KEY (Id)
);


-- oneture_db.nsdl.draft_ApplicantType definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.draft_ApplicantType;

CREATE TABLE oneture_db.nsdl.draft_ApplicantType (
	Id int IDENTITY(1,1) NOT NULL,
	ApplicationId nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	ApplicantTypeName nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	ApplicantTypeOtherEntity nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	CreatedAt datetime DEFAULT getutcdate() NULL,
	UpdatedAt datetime DEFAULT getutcdate() NULL,
	CONSTRAINT PK__draft_Ap__3214EC07FB5EBE43 PRIMARY KEY (Id)
);




-- DROP TABLE oneture_db.nsdl.RegistrationForm;

CREATE TABLE oneture_db.nsdl.RegistrationForm (
	ApplicationId varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	ProvidedValidForm bit NULL,
	RegulatoryAuthorityName nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	RegulatoryAuthorityCountry nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	RegulatoryAuthorityWebsite nvarchar(500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	RegulatoryAuthorityRegNumber nvarchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	RegulatoryAuthorityCategory nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	DdpRegistrationNumber int NULL,
	CustodianRegistrationNumber int NULL,
	DpRegistrationNumber int NULL,
	SelectedCity nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	HasOtherEntity bit NULL,
	OtherEntityDetails nvarchar(MAX) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	CreatedAt datetime DEFAULT getdate() NULL,
	UpdatedAt datetime DEFAULT getdate() NULL,
	CONSTRAINT PK__Registra__C93A4C9979E7A181 PRIMARY KEY (ApplicationId)
);


-- oneture_db.nsdl.audit_RegistrationForm definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.audit_RegistrationForm;

CREATE TABLE oneture_db.nsdl.audit_RegistrationForm (
	AuditId int IDENTITY(1,1) NOT NULL,
	ApplicationId varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	ProvidedValidForm bit NULL,
	RegulatoryAuthorityName nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	RegulatoryAuthorityCountry nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	RegulatoryAuthorityWebsite nvarchar(500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	RegulatoryAuthorityRegNumber nvarchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	RegulatoryAuthorityCategory nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	DdpRegistrationNumber int NULL,
	CustodianRegistrationNumber int NULL,
	DpRegistrationNumber int NULL,
	SelectedCity nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	HasOtherEntity bit NULL,
	OtherEntityDetails nvarchar(MAX) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	CreatedAt datetime DEFAULT getdate() NULL,
	UpdatedAt datetime DEFAULT getdate() NULL,
	AuditTimestamp datetime DEFAULT getdate() NULL,
	CONSTRAINT PK__audit_Re__A17F23989D753245 PRIMARY KEY (AuditId)
);


-- oneture_db.nsdl.draft_RegistrationForm definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.draft_RegistrationForm;

CREATE TABLE oneture_db.nsdl.draft_RegistrationForm (
	ApplicationId varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	ProvidedValidForm bit NULL,
	RegulatoryAuthorityName nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	RegulatoryAuthorityCountry nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	RegulatoryAuthorityWebsite nvarchar(500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	RegulatoryAuthorityRegNumber nvarchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	RegulatoryAuthorityCategory nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	DdpRegistrationNumber int NULL,
	CustodianRegistrationNumber int NULL,
	DpRegistrationNumber int NULL,
	SelectedCity nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	HasOtherEntity bit NULL,
	OtherEntityDetails nvarchar(MAX) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	CreatedAt datetime DEFAULT getdate() NULL,
	UpdatedAt datetime DEFAULT getdate() NULL,
	CONSTRAINT PK__draft_Re__C93A4C9912FD8CD1 PRIMARY KEY (ApplicationId)
);


-- oneture_db.nsdl.ThroughGlobalCustodian definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.ThroughGlobalCustodian;

CREATE TABLE oneture_db.nsdl.ThroughGlobalCustodian (
	ApplicationId int NOT NULL,
	ThroughGlobalCustodianRadio nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	ThroughGlobalCustodianName nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	ThroughGlobalCustodianAddress nvarchar(500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	ThroughGlobalCustodianRegistration nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	ThroughGlobalCustodianCountry nvarchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	CreatedAt datetime DEFAULT getdate() NULL,
	UpdatedAt datetime DEFAULT getdate() NULL,
	CONSTRAINT PK__ThroughG__C93A4C99D2C9806E PRIMARY KEY (ApplicationId)
);


-- oneture_db.nsdl.audit_ThroughGlobalCustodian definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.audit_ThroughGlobalCustodian;

CREATE TABLE oneture_db.nsdl.audit_ThroughGlobalCustodian (
	AuditId int IDENTITY(1,1) NOT NULL,
	ApplicationId int NULL,
	ThroughGlobalCustodianRadio nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	ThroughGlobalCustodianName nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	ThroughGlobalCustodianAddress nvarchar(500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	ThroughGlobalCustodianRegistration nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	ThroughGlobalCustodianCountry nvarchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	CreatedAt datetime DEFAULT getdate() NULL,
	UpdatedAt datetime DEFAULT getdate() NULL,
	AuditTimestamp datetime DEFAULT getdate() NULL,
	CONSTRAINT PK__audit_Th__A17F2398E5A91A49 PRIMARY KEY (AuditId)
);


-- oneture_db.nsdl.draft_ThroughGlobalCustodian definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.draft_ThroughGlobalCustodian;

CREATE TABLE oneture_db.nsdl.draft_ThroughGlobalCustodian (
	ApplicationId int NOT NULL,
	ThroughGlobalCustodianRadio nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	ThroughGlobalCustodianName nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	ThroughGlobalCustodianAddress nvarchar(500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	ThroughGlobalCustodianRegistration nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	ThroughGlobalCustodianCountry nvarchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	CreatedAt datetime DEFAULT getdate() NULL,
	UpdatedAt datetime DEFAULT getdate() NULL,
	CONSTRAINT PK__draft_Th__C93A4C99C3B2D079 PRIMARY KEY (ApplicationId)
);

-- oneture_db.nsdl.DesignatedBank definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.DesignatedBank;

CREATE TABLE oneture_db.nsdl.DesignatedBank (
	ApplicationId varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	DesignatedBankAddress nvarchar(500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	CreatedAt datetime DEFAULT getdate() NULL,
	UpdatedAt datetime DEFAULT getdate() NULL,
	CONSTRAINT PK__Designat__C93A4C996F2776EC PRIMARY KEY (ApplicationId)
);


-- oneture_db.nsdl.DesignatedBankName definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.DesignatedBankName;

CREATE TABLE oneture_db.nsdl.DesignatedBankName (
	Id int IDENTITY(1,1) NOT NULL,
	ApplicationId varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Name nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Value int NULL,
	Address nvarchar(500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	CreatedAt datetime DEFAULT getdate() NULL,
	UpdatedAt datetime DEFAULT getdate() NULL,
	CONSTRAINT PK__Designat__3214EC071AFB0D2E PRIMARY KEY (Id)
);


-- oneture_db.nsdl.audit_DesignatedBank definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.audit_DesignatedBank;

CREATE TABLE oneture_db.nsdl.audit_DesignatedBank (
	AuditId int IDENTITY(1,1) NOT NULL,
	ApplicationId varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	DesignatedBankAddress nvarchar(500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	CreatedAt datetime DEFAULT getdate() NULL,
	UpdatedAt datetime DEFAULT getdate() NULL,
	AuditTimestamp datetime DEFAULT getdate() NULL,
	CONSTRAINT PK__audit_De__A17F2398790AF65D PRIMARY KEY (AuditId)
);


-- oneture_db.nsdl.audit_DesignatedBankName definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.audit_DesignatedBankName;

CREATE TABLE oneture_db.nsdl.audit_DesignatedBankName (
	AuditId int IDENTITY(1,1) NOT NULL,
	Id int NULL,
	ApplicationId varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Name nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Value int NULL,
	Address nvarchar(500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	CreatedAt datetime DEFAULT getdate() NULL,
	UpdatedAt datetime DEFAULT getdate() NULL,
	AuditTimestamp datetime DEFAULT getdate() NULL,
	CONSTRAINT PK__audit_De__A17F2398F8E109F3 PRIMARY KEY (AuditId)
);


-- oneture_db.nsdl.draft_DesignatedBank definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.draft_DesignatedBank;

CREATE TABLE oneture_db.nsdl.draft_DesignatedBank (
	ApplicationId varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	DesignatedBankAddress nvarchar(500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	CreatedAt datetime DEFAULT getdate() NULL,
	UpdatedAt datetime DEFAULT getdate() NULL,
	CONSTRAINT PK__draft_De__C93A4C99C7912E43 PRIMARY KEY (ApplicationId)
);


-- oneture_db.nsdl.draft_DesignatedBankName definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.draft_DesignatedBankName;

CREATE TABLE oneture_db.nsdl.draft_DesignatedBankName (
	Id int IDENTITY(1,1) NOT NULL,
	ApplicationId varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Name nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Value int NULL,
	Address nvarchar(500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	CreatedAt datetime DEFAULT getdate() NULL,
	UpdatedAt datetime DEFAULT getdate() NULL,
	CONSTRAINT PK__draft_De__3214EC0768A0964B PRIMARY KEY (Id)
);

-- oneture_db.nsdl.PriorAssociation definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.PriorAssociation;

CREATE TABLE oneture_db.nsdl.PriorAssociation (
	ApplicationId int NOT NULL,
	PriorAssociationRadio bit NOT NULL,
	CreatedAt datetime DEFAULT getdate() NULL,
	UpdatedAt datetime DEFAULT getdate() NULL,
	CONSTRAINT PK__PriorAss__C93A4C99A55FA6D1 PRIMARY KEY (ApplicationId)
);


-- oneture_db.nsdl.PriorAssociationRow definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.PriorAssociationRow;

CREATE TABLE oneture_db.nsdl.PriorAssociationRow (
	ApplicationId int NOT NULL,
	SebiRegNumber nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	EntityName nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	RegistrationType nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	RegistrationStart datetime NOT NULL,
	RegistrationEnd datetime NOT NULL,
	CreatedAt datetime DEFAULT getdate() NULL,
	UpdatedAt datetime DEFAULT getdate() NULL,
	CONSTRAINT PK__PriorAss__4DD9F5E0B146FA9F PRIMARY KEY (ApplicationId,SebiRegNumber,RegistrationStart)
);


-- oneture_db.nsdl.audit_PriorAssociation definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.audit_PriorAssociation;

CREATE TABLE oneture_db.nsdl.audit_PriorAssociation (
	AuditId int IDENTITY(1,1) NOT NULL,
	ApplicationId int NULL,
	PriorAssociationRadio bit NOT NULL,
	CreatedAt datetime DEFAULT getdate() NULL,
	UpdatedAt datetime DEFAULT getdate() NULL,
	AuditTimestamp datetime DEFAULT getdate() NULL,
	CONSTRAINT PK__audit_Pr__A17F239885D52424 PRIMARY KEY (AuditId)
);


-- oneture_db.nsdl.audit_PriorAssociationRow definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.audit_PriorAssociationRow;

CREATE TABLE oneture_db.nsdl.audit_PriorAssociationRow (
	AuditId int IDENTITY(1,1) NOT NULL,
	ApplicationId int NULL,
	SebiRegNumber nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	EntityName nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	RegistrationType nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	RegistrationStart datetime NULL,
	RegistrationEnd datetime NULL,
	CreatedAt datetime DEFAULT getdate() NULL,
	UpdatedAt datetime DEFAULT getdate() NULL,
	AuditTimestamp datetime DEFAULT getdate() NULL,
	CONSTRAINT PK__audit_Pr__A17F23981E8857E5 PRIMARY KEY (AuditId)
);


-- oneture_db.nsdl.draft_PriorAssociation definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.draft_PriorAssociation;

CREATE TABLE oneture_db.nsdl.draft_PriorAssociation (
	ApplicationId int NOT NULL,
	PriorAssociationRadio bit NOT NULL,
	CreatedAt datetime DEFAULT getdate() NULL,
	UpdatedAt datetime DEFAULT getdate() NULL,
	CONSTRAINT PK__draft_Pr__C93A4C9916C919A2 PRIMARY KEY (ApplicationId)
);


-- oneture_db.nsdl.draft_PriorAssociationRow definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.draft_PriorAssociationRow;

CREATE TABLE oneture_db.nsdl.draft_PriorAssociationRow (
	ApplicationId int NOT NULL,
	SebiRegNumber nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	EntityName nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	RegistrationType nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	RegistrationStart datetime NOT NULL,
	RegistrationEnd datetime NOT NULL,
	CreatedAt datetime DEFAULT getdate() NULL,
	UpdatedAt datetime DEFAULT getdate() NULL,
	CONSTRAINT PK__draft_Pr__4DD9F5E009CFAC99 PRIMARY KEY (ApplicationId,SebiRegNumber,RegistrationStart)
);

-- oneture_db.nsdl.HasPan definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.HasPan;

CREATE TABLE oneture_db.nsdl.HasPan (
	ApplicationId int NOT NULL,
	HasPanRadio bit NOT NULL,
	HasPanNumber nvarchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	CreatedAt datetime DEFAULT getdate() NULL,
	UpdatedAt datetime DEFAULT getdate() NULL,
	CONSTRAINT PK__HasPan__C93A4C99637E18E1 PRIMARY KEY (ApplicationId)
);


-- oneture_db.nsdl.audit_HasPan definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.audit_HasPan;

CREATE TABLE oneture_db.nsdl.audit_HasPan (
	AuditId int IDENTITY(1,1) NOT NULL,
	ApplicationId int NULL,
	HasPanRadio bit NOT NULL,
	HasPanNumber nvarchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	CreatedAt datetime DEFAULT getdate() NULL,
	UpdatedAt datetime DEFAULT getdate() NULL,
	AuditTimestamp datetime DEFAULT getdate() NULL,
	CONSTRAINT PK__audit_Ha__A17F2398D8532B82 PRIMARY KEY (AuditId)
);


-- oneture_db.nsdl.draft_HasPan definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.draft_HasPan;

CREATE TABLE oneture_db.nsdl.draft_HasPan (
	ApplicationId int NOT NULL,
	HasPanRadio bit NOT NULL,
	HasPanNumber nvarchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	CreatedAt datetime DEFAULT getdate() NULL,
	UpdatedAt datetime DEFAULT getdate() NULL,
	CONSTRAINT PK__draft_Ha__C93A4C99069B5062 PRIMARY KEY (ApplicationId)
);

-- oneture_db.nsdl.DisciplinaryHistory definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.DisciplinaryHistory;

CREATE TABLE oneture_db.nsdl.DisciplinaryHistory (
	ApplicationId varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	DisciplinaryHistoryRadio bit NOT NULL,
	DisciplinaryHistoryText nvarchar(1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	CreatedAt datetime DEFAULT getdate() NULL,
	UpdatedAt datetime DEFAULT getdate() NULL,
	CONSTRAINT PK__Discipli__C93A4C9980C5B4AE PRIMARY KEY (ApplicationId)
);


-- oneture_db.nsdl.audit_DisciplinaryHistory definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.audit_DisciplinaryHistory;

CREATE TABLE oneture_db.nsdl.audit_DisciplinaryHistory (
	AuditId int IDENTITY(1,1) NOT NULL,
	ApplicationId varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	DisciplinaryHistoryRadio bit NOT NULL,
	DisciplinaryHistoryText nvarchar(1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	CreatedAt datetime DEFAULT getdate() NULL,
	UpdatedAt datetime DEFAULT getdate() NULL,
	AuditTimestamp datetime DEFAULT getdate() NULL,
	CONSTRAINT PK__audit_Di__A17F23980D28ACCD PRIMARY KEY (AuditId)
);


-- oneture_db.nsdl.draft_DisciplinaryHistory definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.draft_DisciplinaryHistory;

CREATE TABLE oneture_db.nsdl.draft_DisciplinaryHistory (
	ApplicationId varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	DisciplinaryHistoryRadio bit NOT NULL,
	DisciplinaryHistoryText nvarchar(1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	CreatedAt datetime DEFAULT getdate() NULL,
	UpdatedAt datetime DEFAULT getdate() NULL,
	CONSTRAINT PK__draft_Di__C93A4C99EE748B6C PRIMARY KEY (ApplicationId)
);

-- oneture_db.nsdl.DdpInfo definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.DdpInfo;

CREATE TABLE oneture_db.nsdl.DdpInfo (
	ApplicationId varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	Name nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Value int NULL,
	RegistrationNumber nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	DdpId int NULL,
	CreatedAt datetime DEFAULT getdate() NULL,
	UpdatedAt datetime DEFAULT getdate() NULL,
	CONSTRAINT PK__DdpInfo__C93A4C99977F5E4C PRIMARY KEY (ApplicationId)
);


-- oneture_db.nsdl.DpInfo definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.DpInfo;

CREATE TABLE oneture_db.nsdl.DpInfo (
	ApplicationId varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	Name nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Value int NOT NULL,
	RegistrationNumber nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	DdpId int NULL,
	CreatedAt datetime DEFAULT getdate() NULL,
	UpdatedAt datetime DEFAULT getdate() NULL,
	CONSTRAINT PK__DpInfo__C93A4C997C5EFCF4 PRIMARY KEY (ApplicationId)
);


-- oneture_db.nsdl.audit_DdpInfo definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.audit_DdpInfo;

CREATE TABLE oneture_db.nsdl.audit_DdpInfo (
	AuditId int IDENTITY(1,1) NOT NULL,
	ApplicationId varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Name nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Value int NULL,
	RegistrationNumber nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	DdpId int NULL,
	CreatedAt datetime DEFAULT getdate() NULL,
	UpdatedAt datetime DEFAULT getdate() NULL,
	AuditTimestamp datetime DEFAULT getdate() NULL,
	CONSTRAINT PK__audit_Dd__A17F2398B3829D61 PRIMARY KEY (AuditId)
);


-- oneture_db.nsdl.audit_DpInfo definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.audit_DpInfo;

CREATE TABLE oneture_db.nsdl.audit_DpInfo (
	AuditId int IDENTITY(1,1) NOT NULL,
	ApplicationId varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Name nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Value int NOT NULL,
	RegistrationNumber nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	DdpId int NULL,
	CreatedAt datetime DEFAULT getdate() NULL,
	UpdatedAt datetime DEFAULT getdate() NULL,
	AuditTimestamp datetime DEFAULT getdate() NULL,
	CONSTRAINT PK__audit_Dp__A17F2398856E0A61 PRIMARY KEY (AuditId)
);


-- oneture_db.nsdl.draft_DdpInfo definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.draft_DdpInfo;

CREATE TABLE oneture_db.nsdl.draft_DdpInfo (
	ApplicationId varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	Name nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Value int NULL,
	RegistrationNumber nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	DdpId int NULL,
	CreatedAt datetime DEFAULT getdate() NULL,
	UpdatedAt datetime DEFAULT getdate() NULL,
	CONSTRAINT PK__draft_Dd__C93A4C99A071EF7F PRIMARY KEY (ApplicationId)
);


-- oneture_db.nsdl.draft_DpInfo definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.draft_DpInfo;

CREATE TABLE oneture_db.nsdl.draft_DpInfo (
	ApplicationId varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	Name nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Value int NOT NULL,
	RegistrationNumber nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	DdpId int NULL,
	CreatedAt datetime DEFAULT getdate() NULL,
	UpdatedAt datetime DEFAULT getdate() NULL,
	CONSTRAINT PK__draft_Dp__C93A4C99C5C456CD PRIMARY KEY (ApplicationId)
);

-- oneture_db.nsdl.CustodianInfo definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.CustodianInfo;

CREATE TABLE oneture_db.nsdl.CustodianInfo (
	ApplicationId varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	Name nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Value int NULL,
	RegistrationNumber nvarchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	CreatedAt datetime DEFAULT getdate() NULL,
	UpdatedAt datetime DEFAULT getdate() NULL,
	CONSTRAINT PK__Custodia__C93A4C99F87E0D31 PRIMARY KEY (ApplicationId)
);


-- oneture_db.nsdl.audit_CustodianInfo definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.audit_CustodianInfo;

CREATE TABLE oneture_db.nsdl.audit_CustodianInfo (
	AuditId int IDENTITY(1,1) NOT NULL,
	ApplicationId varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Name nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Value int NULL,
	RegistrationNumber nvarchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	CreatedAt datetime DEFAULT getdate() NULL,
	UpdatedAt datetime DEFAULT getdate() NULL,
	AuditTimestamp datetime DEFAULT getdate() NULL,
	CONSTRAINT PK__audit_Cu__A17F2398C4F50F0F PRIMARY KEY (AuditId)
);


-- oneture_db.nsdl.draft_CustodianInfo definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.draft_CustodianInfo;

CREATE TABLE oneture_db.nsdl.draft_CustodianInfo (
	ApplicationId varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	Name nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Value int NULL,
	RegistrationNumber nvarchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	CreatedAt datetime DEFAULT getdate() NULL,
	UpdatedAt datetime DEFAULT getdate() NULL,
	CONSTRAINT PK__draft_Cu__C93A4C99E2A3142E PRIMARY KEY (ApplicationId)
);

-- oneture_db.nsdl.DeclarationAndUndertakingForm definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.DeclarationAndUndertakingForm;

CREATE TABLE oneture_db.nsdl.DeclarationAndUndertakingForm (
	ApplicationId int NOT NULL,
	Name nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	Capacity nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	Place nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Date] datetime NOT NULL,
	NameOfSignatory nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	DesignationOfSignatory nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	DateOfSignature datetime NULL,
	Signature varbinary(MAX) NULL,
	CreatedAt datetime DEFAULT getdate() NULL,
	UpdatedAt datetime DEFAULT getdate() NULL,
	CONSTRAINT PK__Declarat__C93A4C992B254049 PRIMARY KEY (ApplicationId)
);


-- oneture_db.nsdl.draft_DeclarationAndUndertakingForm definition

-- Drop table

-- DROP TABLE oneture_db.nsdl.draft_DeclarationAndUndertakingForm;

CREATE TABLE oneture_db.nsdl.draft_DeclarationAndUndertakingForm (
	ApplicationId int NOT NULL,
	Name nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	Capacity nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	Place nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Date] datetime NOT NULL,
	NameOfSignatory nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	DesignationOfSignatory nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	DateOfSignature datetime NULL,
	Signature varbinary(MAX) NULL,
	CreatedAt datetime DEFAULT getdate() NULL,
	UpdatedAt datetime DEFAULT getdate() NULL,
	CONSTRAINT PK__Declarat__C93A4C992B254049_draft PRIMARY KEY (ApplicationId)
);

-- Main table: AnextureForm
CREATE TABLE nsdl.audit_AnextureForm (
    ApplicationId VARCHAR(255) ,
    IntermediateMaterial BIT,
    EntityHolding INT,
    NoEntityHolding INT NULL,
    BeneficialOwnership BIT,
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE(),
    AuditTimestamp datetime DEFAULT getutcdate() NULL
);

-- Segregated Portfolio Table
CREATE TABLE nsdl.audit_SegregatedPortfolio (
    ApplicationId VARCHAR(255) ,
    SeggregatedPortfolioRadio BIT,
    SeggregatedPortfolioText VARCHAR(255),
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE(),
    AuditTimestamp datetime DEFAULT getutcdate() NULL
);

-- Bank Declaration Table
CREATE TABLE nsdl.audit_BankDeclaration (
    ApplicationId VARCHAR(255) ,
    BankDeclarationRadio VARCHAR(50),
    BankDeclarationText VARCHAR(255),
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE(),
    AuditTimestamp datetime DEFAULT getutcdate() NULL
);

-- Consent Intermediary Table
CREATE TABLE nsdl.audit_ConsentIntermediary (
    ApplicationId VARCHAR(255) ,
    ConsentIntermediaryRadio BIT,
    ConsentIntermediaryName VARCHAR(255),
    ConsentIntermediaryEmail1 VARCHAR(255),
    ConsentIntermediaryEmail2 VARCHAR(255),
    ConsentIntermediaryEmail3 VARCHAR(255),
    ConsentIntermediaryMobile VARCHAR(255),
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE(),
    AuditTimestamp datetime DEFAULT getutcdate() NULL
);

-- Information of SA/SM/FVCI Applicant
CREATE TABLE nsdl.audit_InformationOfSaSmFvciApplicant (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    ApplicationId VARCHAR(255) ,
    Name VARCHAR(255),
    RelationWithApplicant VARCHAR(255),
    Pan VARCHAR(10),
    NationalityCode VARCHAR(10),
    DateOfBirth DATE,
    ResidentialAddress VARCHAR(500),
    IdentityDocNumber VARCHAR(255),
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE(),
    AuditTimestamp datetime DEFAULT getutcdate() NULL
);

-- Signatory Table
CREATE TABLE nsdl.audit_Signatory (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    ApplicationId VARCHAR(255) ,
    Details VARCHAR(500),
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE(),
    AuditTimestamp datetime DEFAULT getutcdate() NULL
);

-- Owner Details Table (For Signatories)
CREATE TABLE nsdl.audit_OwnerDetails (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    SignatoryId INT ,
    NameAddressOfBo VARCHAR(255),
    DateOfBirthOfBo DATE,
    TaxResidencyJuridictionCode VARCHAR(10),
    NationalityCode VARCHAR(10),
    ActingAloneOrMoreNaturalPerson VARCHAR(50),
    BoGroupPercentageShareHolding VARCHAR(10),
    IdentityDocument VARCHAR(255),
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE(),
    AuditTimestamp datetime DEFAULT getutcdate() NULL
);

-- Material Shareholder Table
CREATE TABLE nsdl.audit_MaterialShareholder (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    ApplicationId VARCHAR(255) ,
    NameOfBeneficialOwner VARCHAR(255),
    DirectIndirectStake VARCHAR(255),
    NameOfEntities VARCHAR(255),
    CountryOfIncorporationOrNationalityCode VARCHAR(10),
    PercentageStakeHeld INT,
    IndividualOrNonIndividual VARCHAR(50),
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE(),
    AuditTimestamp datetime DEFAULT getutcdate() NULL
);

-- Beneficial Owners Table
CREATE TABLE nsdl.audit_BeneficialOwners (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    ApplicationId VARCHAR(255) ,
    NameOfBeneficialOwner VARCHAR(255),
    MethodOfControl VARCHAR(255),
    CountryOfIncorporationCode VARCHAR(10),
    PercentageStakeHeld INT,
    IndividualOrNonIndividual VARCHAR(50),
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE(),
    AuditTimestamp datetime DEFAULT getutcdate() NULL
);

-- Managers Table
CREATE TABLE nsdl.audit_Managers (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    ApplicationId VARCHAR(255) ,
    NameOfEntity VARCHAR(255),
    TypeOfEntity VARCHAR(255),
    CountryCode VARCHAR(10),
    TelephoneNumber VARCHAR(50),
    FaxNumber VARCHAR(50),
    EmailId VARCHAR(255),
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE(),
    AuditTimestamp datetime DEFAULT getutcdate() NULL
);


-- Main table: AnextureForm
CREATE TABLE nsdl.AnextureForm (
    ApplicationId VARCHAR(255) ,
    IntermediateMaterial BIT,
    EntityHolding INT,
    NoEntityHolding INT NULL,
    BeneficialOwnership BIT,
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE() 
);

-- Segregated Portfolio Table
CREATE TABLE nsdl.SegregatedPortfolio (
    ApplicationId VARCHAR(255) ,
    SeggregatedPortfolioRadio BIT,
    SeggregatedPortfolioText VARCHAR(255),
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE() 
);

-- Bank Declaration Table
CREATE TABLE nsdl.BankDeclaration (
    ApplicationId VARCHAR(255) ,
    BankDeclarationRadio VARCHAR(50),
    BankDeclarationText VARCHAR(255),
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE() 
);

-- Consent Intermediary Table
CREATE TABLE nsdl.ConsentIntermediary (
    ApplicationId VARCHAR(255) ,
    ConsentIntermediaryRadio BIT,
    ConsentIntermediaryName VARCHAR(255),
    ConsentIntermediaryEmail1 VARCHAR(255),
    ConsentIntermediaryEmail2 VARCHAR(255),
    ConsentIntermediaryEmail3 VARCHAR(255),
    ConsentIntermediaryMobile VARCHAR(255),
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE() 
);

-- Information of SA/SM/FVCI Applicant
CREATE TABLE nsdl.InformationOfSaSmFvciApplicant (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    ApplicationId VARCHAR(255) ,
    Name VARCHAR(255),
    RelationWithApplicant VARCHAR(255),
    Pan VARCHAR(10),
    NationalityCode VARCHAR(10),
    DateOfBirth DATE,
    ResidentialAddress VARCHAR(500),
    IdentityDocNumber VARCHAR(255),
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE() 
);

-- Signatory Table
CREATE TABLE nsdl.Signatory (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    ApplicationId VARCHAR(255) ,
    Details VARCHAR(500),
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE() 
);

-- Owner Details Table (For Signatories)
CREATE TABLE nsdl.OwnerDetails (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    SignatoryId INT ,
    NameAddressOfBo VARCHAR(255),
    DateOfBirthOfBo DATE,
    TaxResidencyJuridictionCode VARCHAR(10),
    NationalityCode VARCHAR(10),
    ActingAloneOrMoreNaturalPerson VARCHAR(50),
    BoGroupPercentageShareHolding VARCHAR(10),
    IdentityDocument VARCHAR(255),
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE() 
);

-- Material Shareholder Table
CREATE TABLE nsdl.MaterialShareholder (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    ApplicationId VARCHAR(255) ,
    NameOfBeneficialOwner VARCHAR(255),
    DirectIndirectStake VARCHAR(255),
    NameOfEntities VARCHAR(255),
    CountryOfIncorporationOrNationalityCode VARCHAR(10),
    PercentageStakeHeld INT,
    IndividualOrNonIndividual VARCHAR(50),
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE() 
);

-- Beneficial Owners Table
CREATE TABLE nsdl.BeneficialOwners (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    ApplicationId VARCHAR(255) ,
    NameOfBeneficialOwner VARCHAR(255),
    MethodOfControl VARCHAR(255),
    CountryOfIncorporationCode VARCHAR(10),
    PercentageStakeHeld INT,
    IndividualOrNonIndividual VARCHAR(50),
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE() 
);

-- Managers Table
CREATE TABLE nsdl.Managers (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    ApplicationId VARCHAR(255) ,
    NameOfEntity VARCHAR(255),
    TypeOfEntity VARCHAR(255),
    CountryCode VARCHAR(10),
    TelephoneNumber VARCHAR(50),
    FaxNumber VARCHAR(50),
    EmailId VARCHAR(255),
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE() 
);


-- Main table: AnextureForm
CREATE TABLE nsdl.draft_AnextureForm (
    ApplicationId VARCHAR(255) ,
    IntermediateMaterial BIT,
    EntityHolding INT,
    NoEntityHolding INT NULL,
    BeneficialOwnership BIT,
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE() 
);

-- Segregated Portfolio Table
CREATE TABLE nsdl.draft_SegregatedPortfolio (
    ApplicationId VARCHAR(255) ,
    SeggregatedPortfolioRadio BIT,
    SeggregatedPortfolioText VARCHAR(255),
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE() 
);

-- Bank Declaration Table
CREATE TABLE nsdl.draft_BankDeclaration (
    ApplicationId VARCHAR(255) ,
    BankDeclarationRadio VARCHAR(50),
    BankDeclarationText VARCHAR(255),
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE() 
);

-- Consent Intermediary Table
CREATE TABLE nsdl.draft_ConsentIntermediary (
    ApplicationId VARCHAR(255) ,
    ConsentIntermediaryRadio BIT,
    ConsentIntermediaryName VARCHAR(255),
    ConsentIntermediaryEmail1 VARCHAR(255),
    ConsentIntermediaryEmail2 VARCHAR(255),
    ConsentIntermediaryEmail3 VARCHAR(255),
    ConsentIntermediaryMobile VARCHAR(255),
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE() 
);

-- Information of SA/SM/FVCI Applicant
CREATE TABLE nsdl.draft_InformationOfSaSmFvciApplicant (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    ApplicationId VARCHAR(255) ,
    Name VARCHAR(255),
    RelationWithApplicant VARCHAR(255),
    Pan VARCHAR(10),
    NationalityCode VARCHAR(10),
    DateOfBirth DATE,
    ResidentialAddress VARCHAR(500),
    IdentityDocNumber VARCHAR(255),
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE() 
);

-- Signatory Table
CREATE TABLE nsdl.draft_Signatory (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    ApplicationId VARCHAR(255) ,
    Details VARCHAR(500),
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE() 
);

-- Owner Details Table (For Signatories)
CREATE TABLE nsdl.draft_OwnerDetails (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    SignatoryId INT ,
    NameAddressOfBo VARCHAR(255),
    DateOfBirthOfBo DATE,
    TaxResidencyJuridictionCode VARCHAR(10),
    NationalityCode VARCHAR(10),
    ActingAloneOrMoreNaturalPerson VARCHAR(50),
    BoGroupPercentageShareHolding VARCHAR(10),
    IdentityDocument VARCHAR(255),
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE() 
);

-- Material Shareholder Table
CREATE TABLE nsdl.draft_MaterialShareholder (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    ApplicationId VARCHAR(255) ,
    NameOfBeneficialOwner VARCHAR(255),
    DirectIndirectStake VARCHAR(255),
    NameOfEntities VARCHAR(255),
    CountryOfIncorporationOrNationalityCode VARCHAR(10),
    PercentageStakeHeld INT,
    IndividualOrNonIndividual VARCHAR(50),
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE() 
);

-- Beneficial Owners Table
CREATE TABLE nsdl.draft_BeneficialOwners (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    ApplicationId VARCHAR(255) ,
    NameOfBeneficialOwner VARCHAR(255),
    MethodOfControl VARCHAR(255),
    CountryOfIncorporationCode VARCHAR(10),
    PercentageStakeHeld INT,
    IndividualOrNonIndividual VARCHAR(50),
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE() 
);

-- Managers Table
CREATE TABLE nsdl.draft_Managers (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    ApplicationId VARCHAR(255) ,
    NameOfEntity VARCHAR(255),
    TypeOfEntity VARCHAR(255),
    CountryCode VARCHAR(10),
    TelephoneNumber VARCHAR(50),
    FaxNumber VARCHAR(50),
    EmailId VARCHAR(255),
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE() 
);


ALTER TABLE oneture_db.nsdl.draft_ContactInfo ALTER COLUMN CountryCode varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL;
ALTER TABLE oneture_db.nsdl.draft_ContactInfo ALTER COLUMN Number nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL;
ALTER TABLE oneture_db.nsdl.draft_ContactInfo ALTER COLUMN [Type] nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL;
ALTER TABLE oneture_db.nsdl.draft_DisciplinaryHistory ALTER COLUMN DisciplinaryHistoryRadio bit NULL;
ALTER TABLE oneture_db.nsdl.draft_HasPan ALTER COLUMN HasPanRadio bit NULL;
ALTER TABLE oneture_db.nsdl.draft_PriorAssociation ALTER COLUMN PriorAssociationRadio bit NULL;
ALTER TABLE oneture_db.nsdl.draft_PriorAssociationRow ALTER COLUMN SebiRegNumber nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL;
ALTER TABLE oneture_db.nsdl.draft_PriorAssociationRow ALTER COLUMN RegistrationEnd datetime NULL;
ALTER TABLE oneture_db.nsdl.draft_PriorAssociationRow ALTER COLUMN RegistrationStart datetime NULL;







