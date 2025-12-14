-- MariaDB / MySQL schema for helpdesk_db

CREATE DATABASE helpdesk_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE helpdesk_db;

CREATE TABLE users (
id INT AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(100) NOT NULL,
email VARCHAR(150) NOT NULL UNIQUE,
password_hash VARCHAR(255) NOT NULL,
role ENUM('ADMIN', 'AGENT', 'USER') NOT NULL DEFAULT 'USER',
created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE tickets (
id INT AUTO_INCREMENT PRIMARY KEY,
title VARCHAR(200) NOT NULL, 
description TEXT NOT NULL,
status ENUM('OPEN', 'IN_PROGRESS', 'RESOLVED') NOT NULL DEFAULT 'OPEN',
priority ENUM('LOW', 'MEDIUM', 'HIGH') NOT NULL DEFAULT 'MEDIUM',
created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
created_by INT NOT NULL,
assigned_to INT NULL,
CONSTRAINT fk_tickets_created_by FOREIGN KEY (created_by) REFERENCES users(id),
CONSTRAINT fk_tickets_assigned_to FOREIGN KEY (assigned_to) REFERENCES users(id)
);

CREATE TABLE ticket_comments (
id INT AUTO_INCREMENT PRIMARY KEY,
ticket_id INT NOT NULL,
user_id INT NOT NULL,
comment TEXT NOT NULL,
created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
CONSTRAINT fk_comments_ticket FOREIGN KEY (ticket_id) REFERENCES tickets(id),
CONSTRAINT fk_comments_user FOREIGN KEY (user_id) REFERENCES users(id)
);

-- Nota: Crear manualmente un admin al principio:
-- Reemplaza PASSWORD_HASH_AQUI con un hash generado por generate_admin_hash.py
-- Insertar usuarios con sus hashes generados
INSERT INTO users (name, email, password_hash, role, created_at) VALUES
('admin', 'admin@example.com', 'scrypt:32768:8:1$bIcRvccxu9FRbIhK$5fdda782fefb21f2e62f3ad4ae76a5480832ef93b87185519031f2941105ecbdc4dcce6a4c3c19a36c033dc4b41ba32500bfca5a0d0513cd5d6770cf79e42a36', 'ADMIN', NOW()),
('agent_john', 'agent@example.com', 'scrypt:32768:8:1$p3GjyZwI4fCvhSc0$99d9c711c8ed391cb4cc8c910711ecbb92d89d7972df5a6120bfee020df0aebbb8709940008d5a8d199a9a0742d5a5bec8d71dcf53fa92ace648c3f7ab1cee94', 'AGENT', NOW()),
('user_doe', 'user@example.com', 'scrypt:32768:8:1$uauBqmKqeDO8aulg$f436eeaa20c415601df2244b0e1273b9f26d38f32f35b1829ae3618594098d46d52e906fa5c1750f60aa7bdb2c6826573aeab9be35f1d9780f03064e223e97aa', 'USER', NOW());
DELETE FROM `users` WHERE `name`='user_doe' -- Elimina el usuario duplicado si existe

ALTER TABLE users AUTO_INCREMENT = 1;

SET FOREIGN_KEY_CHECKS = 0;
DELETE FROM users WHERE name = 'admin';
SET FOREIGN_KEY_CHECKS = 1;

SELECT DISTINCT status FROM tickets;

DROP DATABASE IF EXISTS helpdesk_db;


