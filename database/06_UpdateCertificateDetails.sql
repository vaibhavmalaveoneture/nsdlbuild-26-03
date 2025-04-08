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
    FROM nsdlcaf.dbo.ATS_MSTR_TBL 
    WHERE AMT_EmailID = (
        SELECT email_id 
        FROM nsdlcaf.dbo.users 
        WHERE user_id = @userId
    );

        -- If no valid asm_id is found, return an error
    IF @asm_id IS NULL
    BEGIN
        SET @Success = 0;
        SET @ResponseMessage = 'ASM ID not found for the given user.';
        RETURN;
    END

    UPDATE nsdlcaf.dbo.SELECTED_ATS_BYDDP
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
END