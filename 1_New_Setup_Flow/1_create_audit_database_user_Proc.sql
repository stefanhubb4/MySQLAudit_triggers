-- Create audit database, user and grants
-- Need to manually drop the procedure once completed


DELIMITER //

CREATE PROCEDURE create_audit_database_user()
BEGIN
    DECLARE db_name VARCHAR(255);
    DECLARE username VARCHAR(255);
    DECLARE password VARCHAR(255);

    -- Get user inputs for database name, username, and password
    SET @db_name := 'audit';
    SET @username := 'auditmgr';
    SET @password := 'Aud!tMgr#45big';

    -- Create database
    SET @sql_query := CONCAT('CREATE DATABASE ', @db_name);
    PREPARE stmt FROM @sql_query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    -- Create user
    SET @sql_query := CONCAT('CREATE USER ''', @username, '''@''%'' IDENTIFIED BY ''', @password, '''');
    PREPARE stmt FROM @sql_query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    -- Grant privileges
    SET @sql_query := CONCAT('GRANT ALL ON ', @db_name, '.* TO ''', @username, '''@''%'' WITH GRANT OPTION');
    PREPARE stmt FROM @sql_query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    -- Flush privileges
    FLUSH PRIVILEGES;

    SELECT 'Database, user, and privileges created successfully.';
END//

DELIMITER ;