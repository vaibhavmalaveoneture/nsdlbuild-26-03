CREATE PROCEDURE sp_approverejectappliation
    @ApplicationId INT,
    @Status VARCHAR(50),
    @Remarks VARCHAR(255),
    @RoleCode VARCHAR(50),
    @ResultMessage NVARCHAR(255) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @StateSide VARCHAR(50);

    -- Determine Status ID
    IF @Status = 'Approved' AND @RoleCode = 'DDPMaker'
        SELECT @StateSide = StatusID FROM nsdlcaf.dbo.status_master WHERE statuscode = 'DDP_MAKER_APPROVE';
    ELSE IF @Status = 'Approved' AND @RoleCode = 'DDPChecker'
        SELECT @StateSide = StatusID FROM nsdlcaf.dbo.status_master WHERE statuscode = 'DDP_CHECKER_APPROVE';
    ELSE IF @Status = 'Rejected' AND @RoleCode = 'DDPMaker'
        SELECT @StateSide = StatusID FROM nsdlcaf.dbo.status_master WHERE statuscode = 'DDP_MAKER_REJECT';
    ELSE IF @Status = 'Rejected' AND @RoleCode = 'DDPChecker'
        SELECT @StateSide = StatusID FROM nsdlcaf.dbo.status_master WHERE statuscode = 'DDP_CHECKER_REJECT';
    ELSE IF @Status = 'Return to Applicant' AND @RoleCode = 'DDPMaker'
        SELECT @StateSide = StatusID FROM nsdlcaf.dbo.status_master WHERE statuscode = 'RETURN_TO_Applicant';
    ELSE IF @Status = 'Return to Maker' AND @RoleCode = 'DDPChecker'
        SELECT @StateSide = StatusID FROM nsdlcaf.dbo.status_master WHERE statuscode = 'RETURN_TO_MAKER';
       
    -- Update Application Status
    UPDATE nsdlcaf.dbo.fvci_applications
    SET 
        remarks = @Remarks,
        status = @StateSide,
        updated_at = GETDATE()
    WHERE application_id = @ApplicationId;

    -- Check if records were updated
    IF @@ROWCOUNT = 0
        SET @ResultMessage = 'No records updated. Application ID might not exist.';
    ELSE
        SET @ResultMessage = 'Application updated successfully.';

    -- Print the output message
    PRINT @ResultMessage;
END;