CREATE PROCEDURE sp_geturllatestdetails
    @ApplicationId VARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;

	SELECT top 1 au.ApplicationId applicationId, au.URNNo urnId, au.created_at createdAt
	from nsdlcaf.dbo.fvci_applications fa 
	inner join nsdlcaf.dbo.ApplicationURNDetails au on fa.application_id =au.ApplicationId
	where fa.application_id = @ApplicationId
	order by au.created_at desc ;
END;