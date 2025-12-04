-- Script para crear la base de datos y tabla de usuarios

-- Crear la base de datos
CREATE DATABASE persistencia_local_db;

-- Conectarse a la base de datos
\c persistencia_local_db;

-- Crear tabla de usuarios
CREATE TABLE IF NOT EXISTS usuarios (
  id SERIAL PRIMARY KEY,
  username VARCHAR(100) UNIQUE NOT NULL,
  email VARCHAR(255) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  telefono VARCHAR(20),
  codigo_verificacion VARCHAR(6),
  email_verificado BOOLEAN DEFAULT FALSE,
  token_sesion VARCHAR(255),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Crear índices para mejorar el rendimiento
CREATE INDEX idx_usuarios_email ON usuarios(email);
CREATE INDEX idx_usuarios_username ON usuarios(username);
CREATE INDEX idx_usuarios_token ON usuarios(token_sesion);

-- Función para actualizar updated_at automáticamente
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
   NEW.updated_at = CURRENT_TIMESTAMP;
   RETURN NEW;
END;
$$ language 'plpgsql';

-- Trigger para actualizar updated_at
CREATE TRIGGER update_usuarios_updated_at
BEFORE UPDATE ON usuarios
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

-- Insertar usuario de prueba (opcional)
-- Contraseña: test123 (hash simplificado para demostración)
INSERT INTO usuarios (username, email, password_hash, telefono, email_verificado)
VALUES ('admin', 'admin@test.com', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', '+593999999999', true)
ON CONFLICT DO NOTHING;
