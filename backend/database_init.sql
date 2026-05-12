CREATE DATABASE IF NOT EXISTS cor_falles
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE cor_falles;

CREATE TABLE IF NOT EXISTS usuarios (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(120) NOT NULL,
    email VARCHAR(190) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    rol ENUM('usuario', 'organizador', 'admin') NOT NULL DEFAULT 'usuario',
    idioma_pref VARCHAR(5) DEFAULT 'es',
    ubicacion VARCHAR(150) DEFAULT NULL,
    creado_en DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS eventos (
    id_evento INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(160) NOT NULL,
    descripcion TEXT,
    inicio_datetime DATETIME NOT NULL,
    fin_datetime DATETIME DEFAULT NULL,
    categoria VARCHAR(80) NOT NULL,
    ubicacion_texto VARCHAR(220) DEFAULT NULL,
    latitud DECIMAL(9,6) DEFAULT NULL,
    longitud DECIMAL(9,6) DEFAULT NULL,
    imagen_url VARCHAR(255) DEFAULT NULL,
    estado ENUM('borrador', 'publicado', 'eliminado') NOT NULL DEFAULT 'borrador',
    id_organizador INT NOT NULL,
    creado_en DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    actualizado_en DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_eventos_organizador
        FOREIGN KEY (id_organizador)
        REFERENCES usuarios(id_usuario)
        ON DELETE CASCADE
);

CREATE INDEX idx_eventos_estado ON eventos(estado);
CREATE INDEX idx_eventos_inicio ON eventos(inicio_datetime);
CREATE INDEX idx_eventos_categoria ON eventos(categoria);
CREATE INDEX idx_eventos_organizador ON eventos(id_organizador);