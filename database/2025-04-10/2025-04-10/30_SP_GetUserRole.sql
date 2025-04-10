ALTER PROCEDURE SP_GetUserRole
    @UserId INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT rm.role_id as role_id, rm.role_nm as role_code, rm.description as role_name , rm.visible as visible, rm.status as status
    FROM nsdlcaf.dbo.roles rm
    JOIN nsdlcaf.dbo.users u ON rm.role_id = u.role_id
    WHERE u.user_id = @UserId;
END;