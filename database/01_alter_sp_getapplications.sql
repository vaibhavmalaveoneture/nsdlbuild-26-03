CREATE PROCEDURE sp_getapplications
                            @rolecode NVARCHAR(50),
                            @userid INT
                        AS
                        BEGIN
                            SET NOCOUNT ON;
                            DECLARE @ddpid INT;

                            -- If rolecode is 'GCUST' or 'FVCIA', fetch from both tables
                            IF @rolecode IN ('GCUST', 'FVCIA')
                            BEGIN
                                WITH Combined AS (
								        -- Draft Applications
								        SELECT 
								            dfa.application_id AS ApplicationId,
								            dfa.user_id AS UserId,
								            dfkd.Name AS Name,
								            dfa.fvci_registration_number AS FvciRegistrationNumber,
								            dfa.created_at AS CreatedAt,
						            dfa.updated_at AS UpdatedAt,
						            sm.StatusName AS Status,
						            2 AS Priority  -- Lower priority for draft
						        FROM nsdlcaf.dbodraft_fvci_applications dfa 
						        INNER JOIN nsdlcaf.dbodraft_Ekyc dfkd 
						            ON dfa.application_id = dfkd.ApplicationId 
						        INNER JOIN nsdlcaf.dbostatus_master sm
						            ON sm.StatusID = dfa.status
						        WHERE dfa.user_id = @UserId
						
						        UNION ALL
						
						        -- Final Applications
						        SELECT 
						            fa.application_id AS ApplicationId,
						            fa.user_id AS UserId,
						            fkd.Name AS Name,
						            fa.fvci_registration_number AS FvciRegistrationNumber,
						            fa.created_at AS CreatedAt,
						            fa.updated_at AS UpdatedAt,
						            sm.StatusName AS Status,
						            1 AS Priority  -- Higher priority for final
						        FROM nsdlcaf.dbofvci_applications fa 
						        INNER JOIN nsdlcaf.dboEkyc fkd 
						            ON fa.application_id = fkd.ApplicationId
						        INNER JOIN nsdlcaf.dbostatus_master sm
						            ON sm.StatusID = fa.status
						        WHERE fa.user_id = @UserId
						    )
						
						    , Ranked AS (
						        SELECT *,
						               ROW_NUMBER() OVER (PARTITION BY ApplicationId ORDER BY Priority, CreatedAt DESC) AS RowNum
						        FROM Combined
						    )
						
						    SELECT 
						        UserId,
						        Name,
						        ApplicationId,
						        FvciRegistrationNumber,
						        CreatedAt,
						        UpdatedAt,
						        Status
						    FROM Ranked
						    WHERE RowNum = 1
						    ORDER BY CreatedAt DESC;
                            END
                            else if @rolecode = 'DDPAdmin'
                            begin
                                SELECT @ddpid = dp_id  
                                FROM nsdlcaf.dbousers 
                                WHERE user_id = @userid;
                                
                                SELECT 
                  fa.user_id AS UserId,
                                    fkd.Name AS Name,
                                    fa.application_id AS ApplicationId,
                                    fa.fvci_registration_number AS FvciRegistrationNumber,
                                    fa.created_at AS CreatedAt,
                                    fa.updated_at AS UpdatedAt,
                                    sm.StatusName AS Status
                                FROM nsdlcaf.dbofvci_applications fa 
                                INNER JOIN nsdlcaf.dboEkyc fkd 
                                    ON fa.application_id = fkd.ApplicationId
                                INNER JOIN nsdlcaf.dbousers u 
                                    on u.user_id = fa.user_id and u.dp_id = @ddpid
                                INNER JOIN nsdlcaf.dbostatus_master sm
                                    on sm.StatusID= fa.status
        ORDER BY fa.created_at DESC; 
                            end
                            else if @rolecode IN ('DDPMaker')
     begin
	     						SELECT @ddpid = dp_id  
                                FROM nsdlcaf.dbousers 
                                WHERE user_id = @userid;
                                SELECT 
                                    fa.user_id AS UserId,
                                    fkd.Name AS Name,
                                    fa.application_id AS ApplicationId,
                                    fa.fvci_registration_number AS FvciRegistrationNumber,
                                    fa.created_at AS CreatedAt,
                                    fa.updated_at AS UpdatedAt,
                                    sm.StatusName AS Status,
                                    sabd.IS_VERIFY as isVerify,
                                    atsmaster.AMT_EmailID as EmailId
                                FROM nsdlcaf.dbofvci_applications fa 
                                INNER JOIN nsdlcaf.dboEkyc fkd 
                                    ON fa.application_id = fkd.ApplicationId and fa.status >= 2
                                INNER JOIN nsdlcaf.dbousers u 
                                    on u.user_id = fa.user_id and u.dp_id = @ddpid
                                INNER JOIN nsdlcaf.dbostatus_master sm
                                    on sm.StatusID= fa.status
                                    left join nsdlcaf.dboSELECTED_ATS_BYDDP sabd on fa.application_id = sabd.APPLICATION_ID
                                    left join nsdlcaf.dboATS_MSTR_TBL atsmaster on sabd.AMT_ASM_ID  =  atsmaster.AMT_ASM_ID
                                ORDER BY fa.created_at DESC; 
                            end
                            -- If rolecode is anything else, return unauthorized message
                            ELSE if @rolecode IN ( 'DDPChecker')
     begin
	     						SELECT @ddpid = dp_id  
                                FROM nsdlcaf.dbousers 
                                WHERE user_id = @userid;
                                SELECT 
                                    fa.user_id AS UserId,
                                    fkd.Name AS Name,
                                    fa.application_id AS ApplicationId,
                                    fa.fvci_registration_number AS FvciRegistrationNumber,
                                    fa.created_at AS CreatedAt,
                                    fa.updated_at AS UpdatedAt,
                                    sm.StatusName AS Status,
                                    sabd.IS_VERIFY as isVerify,
                                    atsmaster.AMT_EmailID as EmailId
                                FROM nsdlcaf.dbofvci_applications fa 
                                INNER JOIN nsdlcaf.dboEkyc fkd 
                                    ON fa.application_id = fkd.ApplicationId and fa.status >= 3
                                INNER JOIN nsdlcaf.dbousers u 
                                    on u.user_id = fa.user_id and u.dp_id = @ddpid
                                INNER JOIN nsdlcaf.dbostatus_master sm
                                    on sm.StatusID= fa.status
                                    left join nsdlcaf.dboSELECTED_ATS_BYDDP sabd on fa.application_id = sabd.APPLICATION_ID
                                    left join nsdlcaf.dboATS_MSTR_TBL atsmaster on sabd.AMT_ASM_ID  =  atsmaster.AMT_ASM_ID
                                ORDER BY fa.created_at DESC; 
                            end
                            -- If rolecode is anything else, return unauthorized message
                            ELSE
          BEGIN
                                SELECT 'Unauthorized rolecode' AS Message;
                            END
                        END;