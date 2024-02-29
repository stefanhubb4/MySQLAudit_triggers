DELIMITER //

DROP PROCEDURE IF EXISTS audit.proc_create_after_delete_trigger //

CREATE PROCEDURE audit.proc_create_after_delete_trigger(IN full_original_table_name VARCHAR(255), IN full_audit_table_name VARCHAR(255))
BEGIN
    DECLARE original_done INT DEFAULT FALSE;
    DECLARE audit_done INT DEFAULT FALSE;
    DECLARE original_column_name VARCHAR(255);
    DECLARE audit_column_name VARCHAR(255);
    DECLARE stmt VARCHAR(2000);
    DECLARE insert_columns VARCHAR(1000);
    DECLARE select_old VARCHAR(1000);

    SET @audit_id = FLOOR(RAND() * 99999999) + 10000000;

    SET @original_db_name = SUBSTRING_INDEX(full_original_table_name, '.', 1);
    SET @original_table_name = SUBSTRING_INDEX(SUBSTRING_INDEX(full_original_table_name, '.', 2), '.', -1);

    SET @audit_db_name = SUBSTRING_INDEX(full_audit_table_name, '.', 1);
    SET @audit_table_name = SUBSTRING_INDEX(SUBSTRING_INDEX(full_audit_table_name, '.', 2), '.', -1);

    SELECT GROUP_CONCAT(COLUMN_NAME) INTO insert_columns
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_SCHEMA = @original_db_name AND TABLE_NAME = @original_table_name;

    SELECT GROUP_CONCAT(CONCAT('OLD.', COLUMN_NAME)) INTO select_old
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_SCHEMA = @original_db_name AND TABLE_NAME = @original_table_name;

    SET stmt = CONCAT('DELIMITER //\n',
                      'CREATE TRIGGER ', @original_db_name, '.after_delete_', @original_table_name,
                      ' AFTER DELETE ON ', @original_db_name, '.', @original_table_name,
                      ' FOR EACH ROW\n',
                      'BEGIN\n',
                      '    INSERT INTO ', @audit_db_name, '.', @audit_table_name, ' (', insert_columns, ', id_trigtrack, datetime_trigtrack, user_trigtrack, host_trigtrack, audit_type_trigtrack)\n',
                      '    VALUES (', select_old, ', NULL, NOW(), USER(), @@hostname, ''DELETE'');\n',
                      'END//\n',
                      'DELIMITER ;');

    SELECT stmt;
END //

DELIMITER ;
