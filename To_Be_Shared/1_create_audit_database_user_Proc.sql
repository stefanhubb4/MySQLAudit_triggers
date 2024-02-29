-- Function -->
-- Create audit database, table, user and grants

-- Run Instructions -->
-- Run as root user within mysql database (Other DB can also be used, as procedure can be removed post setup)
-- Call the procedure without any parameters, use decaled/hard-coded parameters to change any names

-- Post run Instructions
-- Need to manually drop the procedure once completed, included in step 6


DELIMITER //

CREATE PROCEDURE mysql.create_audit_database_user()
BEGIN
    DECLARE db_name VARCHAR(255);
    DECLARE username VARCHAR(255);
    DECLARE password VARCHAR(255);

    -- Get user inputs for database name, username, and password
    SET @db_name := 'audit';
    SET @username := 'auditmgr';
    SET @password := 'Aud!tMgr#45big';

    -- Create database
    SET @sql_query := CONCAT('CREATE DATABASE IF NOT EXISTS ', @db_name);
    PREPARE stmt FROM @sql_query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    -- Create user
    SET @sql_query := CONCAT('CREATE USER IF NOT EXISTS ''', @username, '''@''%'' IDENTIFIED BY ''', @password, '''');
    PREPARE stmt FROM @sql_query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    -- Grant privileges
    SET @sql_query := CONCAT('GRANT SELECT ON ', @db_name, '.* TO ''', @username, '''@''%'' WITH GRANT OPTION');
    PREPARE stmt FROM @sql_query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    -- Flush privileges
    FLUSH PRIVILEGES;

    -- Create audit_meta_data table
    SET @sql_query := '
    CREATE TABLE IF NOT EXISTS audit.audit_meta_data (
        id INT AUTO_INCREMENT PRIMARY KEY,
        table_schema VARCHAR(255),
        table_name VARCHAR(255),
        added_date DATETIME,
        is_insert TINYINT(1),
        is_delete TINYINT(1),
        is_update TINYINT(1),
        status_time DATETIME
    )';
    PREPARE stmt FROM @sql_query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    SELECT 'Database, user, and privileges created successfully.';
END//

DELIMITER ;


call mysql.create_audit_database_user();