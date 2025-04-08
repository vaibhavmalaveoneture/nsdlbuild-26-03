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
    FROM nsdlcaf.dbo.SELECTED_ATS_BYDDP
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
    FROM nsdlcaf.dbo.fvci_applications
    WHERE fvci_registration_number LIKE 'INFVCI' + @financial_year + '%';
    -- Ensure numbering starts from 00001
    SET @new_serial_no = ISNULL(@last_serial_no, 0) + 1;
    -- Construct the new reg_no in the format INFVCI23240001
    SET @new_reg_no = 'INFVCI' + @financial_year + FORMAT(@new_serial_no, '0000');
    -- Update the record
    UPDATE nsdlcaf.dbo.fvci_applications
    SET fvci_registration_number = @new_reg_no, serial_no = @new_serial_no, status = 7
    WHERE application_id = @application_id;

    -- Return success response
    SET @Success = 1;
    SET @ResponseMessage = 'reg_no updated successfully: ' + @new_reg_no;
END