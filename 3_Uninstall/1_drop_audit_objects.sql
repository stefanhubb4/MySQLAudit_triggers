-- Drop audit database, meta data tables, user and grants

DELIMITER //

CREATE PROCEDURE clear_audit_database_user()
BEGIN
    DECLARE db_name VARCHAR(255);
    DECLARE username VARCHAR(255);

    -- Set database and username
    SET @db_name := 'audit';
    SET @username := 'auditmgr';

    -- Drop the table
    SET @sql_query := 'DROP TABLE IF EXISTS audit.audit_meta_data';
    PREPARE stmt FROM @sql_query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    -- Drop the database
    SET @sql_query := CONCAT('DROP DATABASE IF EXISTS ', @db_name);
    PREPARE stmt FROM @sql_query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    -- Drop the user
    SET @sql_query := CONCAT('DROP USER IF EXISTS ''', @username, '''@''%''');
    PREPARE stmt FROM @sql_query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    -- Flush privileges
    FLUSH PRIVILEGES;

    SELECT 'Database, table, and user cleared successfully.';
END//

DELIMITER ;
