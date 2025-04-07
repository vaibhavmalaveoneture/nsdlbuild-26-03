ALTER PROCEDURE DeleteFvciKycDocuments
                            @FvciApplicationId NVARCHAR(255)
                        AS
                        BEGIN
                            SET NOCOUNT ON;

                            DELETE FROM nsdlcaf.dbo.draft_fvci_kyc_documents 
                            WHERE fvci_application_id = @FvciApplicationId;
                        END;