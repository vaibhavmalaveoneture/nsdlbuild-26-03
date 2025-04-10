ALTER PROCEDURE SP_GetPermissionsByRoleId
    @RoleId INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT p.id AS PermissionId, p.permission_code AS PermissionCode, p.permission AS PermissionName
    FROM nsdlcaf.dbo.permissions p
    JOIN nsdlcaf.dbo.role_permissions rp ON rp.permission_id = p.id
    WHERE rp.role_id = @RoleId AND p.status = 1;
END;