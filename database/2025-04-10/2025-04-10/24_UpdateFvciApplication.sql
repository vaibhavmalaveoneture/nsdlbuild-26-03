CREATE PROCEDURE UpdateFvciApplication
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
    IF EXISTS (SELECT 1 FROM nsdlcaf.dbo.fvci_applications WHERE application_id = @ApplicationId)
    BEGIN
		
		delete from nsdlcaf.dbo.TaxResidency where ApplicationId = @ApplicationId;
		
		delete from nsdlcaf.dbo.ContactInfo where ApplicationId = @ApplicationId;
		
		delete from nsdlcaf.dbo.ManagingOfficial where ApplicationId = @ApplicationId;
		
		delete from nsdlcaf.dbo.IncomeDetails where ApplicationId = @ApplicationId;
		
		delete from nsdlcaf.dbo.IncomeSource where ApplicationId = @ApplicationId;
		
		delete from nsdlcaf.dbo.PriorAssociationRow where ApplicationId = @ApplicationId;
		
		delete from nsdlcaf.dbo.Signatory where ApplicationId = @ApplicationId;
		
		delete from nsdlcaf.dbo.MaterialShareholder where ApplicationId = @ApplicationId;
		
		delete from nsdlcaf.dbo.BeneficialOwners where ApplicationId = @ApplicationId;
		
		delete from nsdlcaf.dbo.Managers where ApplicationId = @ApplicationId;

        UPDATE nsdlcaf.dbo.fvci_applications
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
