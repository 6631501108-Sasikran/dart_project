-- สร้าง Database
CREATE DATABASE IF NOT EXISTS expenses
  CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE expenses;

SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS expense;
DROP TABLE IF EXISTS users;

-- สร้าง Table user
CREATE TABLE users (
  id        SMALLINT(5) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  username  VARCHAR(20) NOT NULL UNIQUE,
  password  VARCHAR(60) NOT NULL
);

-- สร้าง Table expense
CREATE TABLE expense (
  id       SMALLINT(5)  UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  user_id  SMALLINT(8)  UNSIGNED NOT NULL,
  item     VARCHAR(50)  NOT NULL,
  paid     MEDIUMINT(9) NOT NULL,
  date     DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_expense_user
    FOREIGN KEY (user_id) REFERENCES users(id)
    ON DELETE CASCADE
    ON UPDATE RESTRICT
);

-- User 2 คน Lisa กับ Tom 
INSERT INTO users (username, password) VALUES
('Lisa', '$2b$10$sVTd.WSdzttE/9gOycQOdeOSwtW1JQzJLFNAoO3d4py2k8zY5KFYW'),
('Tom',  '$2b$10$OatWXeTjF9T/TOlbnl4jfeMGcw5Pr3kZflNkQt1.srwNewZSdMtmq');

-- ข้อมูล
INSERT INTO expense (user_id, item, paid, date) VALUES
(1,'lunch',  70,'2025-08-20 12:07:33'),
(1,'coffee', 45,'2025-08-20 13:07:33'),
(1,'rent', 1600,'2025-08-01 07:26:53'),
(2,'lunch',  50,'2025-08-20 13:27:39'),
(2,'bun',    20,'2025-08-28 21:02:36');

SET FOREIGN_KEY_CHECKS = 1;