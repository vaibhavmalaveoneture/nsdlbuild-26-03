CREATE PROCEDURE GetFVCITypeOfApplicantByCode
    @Code VARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT
        id,
        code,
        description,
        created_dtm,
        modified_dtm
    FROM
        nsdlcaf.dbo.FVCI_MASTER_TYPE_OF_APPLICANT
    WHERE
        code = @Code;
END;