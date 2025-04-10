ALTER PROCEDURE SP_GetUserRolePermission
    @UserID INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT u.user_id as user_id, r.role_nm as role_code, STRING_AGG(p.permissioncode, ',') AS permissioncode
    FROM nsdlcaf.dbo.users u
    INNER JOIN nsdlcaf.dbo.roles r ON u.role_id = r.role_id
    INNER JOIN nsdlcaf.dbo.rolepermissionmapping p ON r.role_code = p.role_code
    WHERE u.user_id = @UserID
    GROUP BY u.user_id, r.role_code;
END;