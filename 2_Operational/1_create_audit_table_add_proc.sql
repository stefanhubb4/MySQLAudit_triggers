-- Function -->
-- Add tables being audited to meta data table

-- Run Instructions -->
-- Run as root user within audit database created during setup
-- Call the procedure with full table name to add it to auditing along with audit database name e.g --> call create_audit_table('audit' , 'hr.salary');

-- Post run Instructions -->
-- 


DELIMITER //

CREATE PROCEDURE create_audit_table(IN db_name VARCHAR(255), IN full_table_name VARCHAR(255))
BEGIN
    DECLARE table_name VARCHAR(255);
    DECLARE meta_db_name VARCHAR(255);
    DECLARE meta_table_name VARCHAR(255);
    DECLARE audit_table_name VARCHAR(255);
    DECLARE sql_query VARCHAR(1000);
    DECLARE random_suffix VARCHAR(3);
    DECLARE current_datetime DATETIME;

    -- Set current datetime
    SET current_datetime = NOW();

    -- Extract db_name and table_name from full_table_name
    SET @dot_position = LOCATE('.', full_table_name);
    SET meta_db_name = SUBSTRING(full_table_name, 1, @dot_position - 1);
    SET meta_table_name = SUBSTRING(full_table_name, @dot_position + 1);

    -- Drop the audit table if it exists
    SET audit_table_name = CONCAT(db_name, '.audit_', meta_table_name);
    SET @drop_query = CONCAT('DROP TABLE IF EXISTS ', audit_table_name);
    PREPARE stmt FROM @drop_query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    -- Create the audit table
    SET @create_query = CONCAT('CREATE TABLE ', audit_table_name, ' AS SELECT * FROM ', full_table_name, ' WHERE 1=0');
    PREPARE stmt FROM @create_query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    -- Add additional columns
    SET random_suffix = LPAD(FLOOR(RAND() * 1000), 3, '0');

    SET @alter_query = CONCAT('ALTER TABLE ', audit_table_name, '
        ADD COLUMN id_', random_suffix, ' INT AUTO_INCREMENT PRIMARY KEY,
        ADD COLUMN `datetime_', random_suffix, '` DATETIME,
        ADD COLUMN `user_', random_suffix, '` VARCHAR(255),
        ADD COLUMN `host_', random_suffix, '` VARCHAR(255),
		ADD COLUMN `audit_type_', random_suffix, '` VARCHAR(255)');
    PREPARE stmt FROM @alter_query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    -- Insert details into audit_meta_data table
    SET @insert_query = CONCAT('INSERT INTO audit.audit_meta_data (table_schema, table_name, added_date, is_insert, is_delete, is_update)
        VALUES (''', meta_db_name, ''', ''', meta_table_name, ''', ''', current_datetime, ''', 0, 0, 0)');
    PREPARE stmt FROM @insert_query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

END //

DELIMITER ;

-- ###

-- CALL create_audit_table('audit', 'test.product');

-- ###

