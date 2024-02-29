DELIMITER //

CREATE PROCEDURE audit.clear_audit_database_triggers()
BEGIN
    DECLARE trigger_prefix VARCHAR(255);
    DECLARE drop_trigger_query TEXT;

    -- Based on prefix used in trigger creation procedures
    SET @trigger_prefix := 'after_'; 


    SET @sql_query := CONCAT(
        'SELECT GROUP_CONCAT(CONCAT("DROP TRIGGER IF EXISTS ", trigger_schema, ".", trigger_name, ";") SEPARATOR " ")
        INTO @drop_trigger_query
        FROM information_schema.triggers
        WHERE trigger_name LIKE "', @trigger_prefix, '%"'
    );

    PREPARE stmt FROM @sql_query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    SELECT @drop_trigger_query AS drop_trigger_statements;
END//

DELIMITER ;
