ALTER PROCEDURE GetDraftFvciApplicationCount
    @ApplicationId INT,
    @UserId INT
AS
BEGIN
    -- Declare a variable to store the dp_id of the input @UserId
    DECLARE @UserDpId INT;

    -- Retrieve the dp_id for the provided @UserId
    SELECT @UserDpId = dp_id
    FROM nsdlcaf.dbo.users
    WHERE user_id = @UserId;

    -- Count the number of matching records in draft_fvci_applications
    SELECT COUNT(*) AS ApplicationCount
    FROM nsdlcaf.dbo.draft_fvci_applications dfa
    WHERE dfa.application_id = @ApplicationId
      AND (
          dfa.user_id = @UserId
          OR EXISTS (
              SELECT 1
              FROM nsdlcaf.dbo.users u
              WHERE u.user_id = dfa.user_id
                AND u.dp_id = @UserDpId
          )
      );
END;