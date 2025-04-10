

CREATE TRIGGER nsdlcaf.dbo.trg_insert_fvci_applications_urn_details
ON nsdlcaf.dbo.fvci_applications
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO nsdlcaf.dbo.ApplicationURNDetails (ApplicationId, URNNo, Status, created_at,Remarks)
    SELECT 
        i.application_id,
        CONVERT(VARCHAR, NEXT VALUE FOR nsdlcaf.dbo.seq_urn_no), -- generate new URNNo
        i.status,
        GETDATE(),
        i.Remarks
    FROM inserted i;
END;