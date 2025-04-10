
CREATE TRIGGER trg_fvci_applications_urn_details
ON nsdlcaf.dbo.fvci_applications
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO nsdlcaf.dbo.ApplicationURNDetails (ApplicationId, URNNo, Status, created_at,Remarks)
    SELECT 
        i.application_id,
        CONVERT(VARCHAR, NEXT VALUE FOR nsdl.seq_urn_no), -- generate new URNNo
        i.status,
        GETDATE(),
        i.Remarks
    FROM inserted i
    JOIN deleted d ON i.id = d.id
    WHERE ISNULL(i.status, -1) <> ISNULL(d.status, -1);
END;