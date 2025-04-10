CREATE PROCEDURE sp_getatsapplications
                            @rolecode NVARCHAR(50),
                            @userid INT
                        AS
                        BEGIN
                            SET NOCOUNT ON;
							DECLARE @roleid INT;
							SELECT
							    @roleid = role_id
							FROM nsdlcaf.dbo.users
							WHERE user_id = @userid;
                            -- If rolecode is 'GCUST' or 'FVCIA', fetch from both tables
                            IF @roleid IN (5, 6, 64)
                            BEGIN
                                   SELECT distinct fa.user_id AS UserId,
                                    fkd.Name AS Name,
                                    fa.application_id AS ApplicationId,
                                    fa.fvci_registration_number AS FvciRegistrationNumber,
                                    fa.created_at AS CreatedAt,
                                    fa.updated_at AS UpdatedAt,
                                    sm.StatusName AS Status,
                                    s.IS_VERIFY as isVerify,
                                    amt.AMT_EmailID as EmailId
							      FROM nsdlcaf.dbo.SELECTED_ATS_BYDDP S
							      INNER JOIN nsdlcaf.dbo.ATS_MSTR_TBL amt on s.AMT_ASM_ID  = amt.AMT_ASM_ID
							      inner join nsdlcaf.dbo.users u on u.email_id = amt.AMT_EmailID
							      inner  join nsdlcaf.dbo.fvci_applications fa on fa.application_id = s.APPLICATION_ID
							      INNER JOIN nsdlcaf.dbo.Ekyc fkd ON fa.application_id = fkd.ApplicationId and fa.status >= 3
							      INNER JOIN nsdlcaf.dbo.status_master sm on sm.StatusID= fa.status
							      where u.user_id = @userid;
                            end
                            ELSE
          BEGIN
                                SELECT 'Unauthorized rolecode' AS Message;
                            END
                        END;
