CREATE PROCEDURE sp_InsertSelectedAtsByDdp
    @ApplicationId INT,
    @SignRequired INT,
    @AtsUser NVARCHAR(MAX) -- JSON format: '[{"ats_name": "tarun sing", "asm_id": 2}, {"ats_name": "amit sing", "asm_id": 3}]'
AS
BEGIN
    SET NOCOUNT ON;
    -- Declare a table variable to hold parsed JSON data
    DECLARE @AtsUserTable TABLE (
        AMT_ASM_ID INT,
        AMT_SIGN_NAME VARCHAR(255)
    );
    -- Parse JSON data and insert into table variable
    INSERT INTO @AtsUserTable (AMT_ASM_ID, AMT_SIGN_NAME)
    SELECT
        JSON_VALUE(ats.value, '$.asm_id') AS AMT_ASM_ID,
        JSON_VALUE(ats.value, '$.ats_name') AS AMT_SIGN_NAME
    FROM OPENJSON(@AtsUser) AS ats;
    -- Insert data into main table
    INSERT INTO nsdlcaf.dbo.SELECTED_ATS_BYDDP (
        APPLICATION_ID,
        AMT_ASM_ID,
        AMT_SIGN_NAME,
        AMT_SIGN_REQD
    )
    SELECT
        @ApplicationId AS APPLICATION_ID,
        AMT_ASM_ID,
        AMT_SIGN_NAME,
        @SignRequired AS AMT_SIGN_REQD
    FROM @AtsUserTable;
END;