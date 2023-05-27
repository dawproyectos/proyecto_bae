-- TABLAS HOSPITAL
--- Tabla paciente
CREATE TABLE paciente(
    id INT AUTO_INCREMENT PRIMARY KEY,
    documento VARCHAR(15) UNIQUE,
    nombre VARCHAR(50),
    apellido VARCHAR(50),
    fecha_nacimiento DATE,
    sexo ENUM('H','M'),
    teléfono VARCHAR(12)    
);
--- Tabla historial
CREATE TABLE historial(
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_cita INT,
    id_medico INT,
    fecha_hora DATETIME
);
--- Tabla planta
CREATE TABLE planta(
    id INT AUTO_INCREMENT PRIMARY KEY,
    numero INT
);
--- Tabla especialidad
CREATE TABLE especialidad(
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_planta INT,
    nombre VARCHAR(50),
    descripcion VARCHAR(150),
    FOREIGN KEY (id_planta) REFERENCES planta(id)
);
--- Tabla médico
CREATE TABLE medico(
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_especialidad INT,
    nombre VARCHAR(50),
    apellido VARCHAR(50),
    FOREIGN KEY (id_especialidad) REFERENCES especialidad(id)
);
--- Tabla cita
CREATE TABLE cita(
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_historial INT,
    id_medico INT,
    id_paciente INT,
    fecha_hora DATETIME,
    FOREIGN KEY (id_historial) REFERENCES historial(id),
    FOREIGN KEY (id_medico) REFERENCES medico(id)
);
--- Tabla examen_medico
CREATE TABLE examen_medico(
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_examen INT,
    diagnostico VARCHAR(150),
    FOREIGN KEY (id_examen) REFERENCES medico_examen(id_examen)
);
--- Tabla tratamiento
CREATE TABLE tratamiento(
    id INT AUTO_INCREMENT PRIMARY KEY,
    detalle VARCHAR(150)
);
--- Tabla medico_examen
CREATE TABLE medico_examen(
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_medico INT,
    id_examen INT,
    FOREIGN KEY (id_medico) REFERENCES medico(id)
);
--- Tabla examen_tratamiento
CREATE TABLE examen_tratamiento(
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_examen INT,
    id_tratamiento INT,
    FOREIGN KEY (id_examen) REFERENCES medico_examen(id),
    FOREIGN KEY (id_tratamiento) REFERENCES tratamiento(id)
);
-- TABLAS PARA INSERCIÓN DE DATOS
--- Tabla nombres
CREATE TABLE nombres (
  id INT PRIMARY KEY AUTO_INCREMENT,
  nombre VARCHAR(50),
  apellido VARCHAR(50)
);
-- Inserts sobre la tabla nombres
INSERT INTO nombres (nombre, apellido) VALUES
('Juan', 'Pérez'),
('María', 'Gómez'),
('Andrés', 'López'),
('Laura', 'Rodríguez'),
('Pedro', 'Martínez'),
('Ana', 'Hernández'),
('Carlos', 'García'),
('Sofia', 'Fernández'),
('Luis', 'Torres'),
('Gabriela', 'Díaz'),
('Alejandro', 'Morales'),
('Valentina', 'Cabrera'),
('Daniel', 'Ortega'),
('Camila', 'Silva'),
('Roberto', 'Rojas'),
('Carolina', 'Navarro'),
('Manuel', 'Guerrero'),
('Natalia', 'Cortés'),
('David', 'Vargas'),
('Alejandra', 'Castro'),
('Ricardo', 'Sánchez'),
('Isabel', 'Delgado'),
('Sergio', 'MENDoza'),
('Daniela', 'Luna'),
('Francisco', 'Ramírez'),
('Marta', 'Andrade'),
('Jorge', 'Fuentes'),
('Paula', 'Reyes'),
('Guillermo', 'Benítez'),
('Victoria', 'Paredes');
-- FUNCIONES
--- Función para generar fechas de manera aleatoria
DELIMITER //
DROP FUNCTION IF EXISTS fecha_aleatoria;
CREATE FUNCTION fecha_aleatoria() RETURNS DATE
DETERMINISTIC
BEGIN
    DECLARE fecha_inicial DATE;
    DECLARE fecha_final DATE;
    DECLARE num_dias INT;
    DECLARE dias_aleatorios INT;
    SET fecha_inicial = '1900-01-01';
    SET fecha_final = CURDATE();
    SET num_dias = DATEDIFF(fecha_final, fecha_inicial) + 1;
    SET dias_aleatorios = FLOOR(RAND() * num_dias);
    RETURN DATE_ADD(fecha_inicial, INTERVAL dias_aleatorios DAY);
END //
--- Función para generar teléfonos de manera aleatoria
DELIMITER //
DROP FUNCTION IF EXISTS telefono_aleatorio;
CREATE FUNCTION telefono_aleatorio() RETURNS VARCHAR(15) DETERMINISTIC
BEGIN
    DECLARE telefono VARCHAR(15);
    DECLARE digitos_aleatorios VARCHAR(10);
    SET digitos_aleatorios = LPAD(FLOOR(RAND() * 10000000000), 8, '0');
    SET telefono = CONCAT('6', digitos_aleatorios);
    RETURN telefono;
END //
DELIMITER ;
SELECT telefono_aleatorio();
-- PROCEDIMIENTOS
--- Procedimiento para insertar pacientes de forma aleatoria
DELIMITER //
DROP PROCEDURE IF EXISTS insertar_paciente;
CREATE PROCEDURE insertar_paciente(IN inserts INT)
BEGIN
    DECLARE ultimo_paciente INT;
    DECLARE _documento VARCHAR(9);
    DECLARE contador INT;
    DECLARE _nombre VARCHAR(55);
    DECLARE _apellido VARCHAR(55);
    DECLARE _sexo INT;
    DECLARE _date DATE;
    DECLARE _telefono INT;
    SET ultimo_paciente = (SELECT COUNT(*) FROM paciente);
    SET contador = 0;
    WHILE contador < inserts do
        SET contador = contador + 1;
        SET _nombre = (SELECT nombre FROM nombres ORDER BY RAND() LIMIT 1);
        SET _apellido = (SELECT apellido FROM nombres ORDER BY RAND() LIMIT 1);
        SET _sexo = ROUND(RAND() + 1);
        SET _date = (SELECT fecha_aleatoria());
        SET _telefono = (SELECT telefono_aleatorio());
        SET ultimo_paciente = ultimo_paciente + 1;
        SET _documento = LPAD(CONCAT(ultimo_paciente, 'A'), 9, 0);
        INSERT INTO paciente VALUES(ultimo_paciente, _documento, _nombre, _apellido, _date, _sexo, _telefono);
    END WHILE;
END 
//
DELIMITER ;
CALL insertar_paciente(5)
;
--- Procedimiento para insertar especialidades de forma aleatoria
DELIMITER //
DROP PROCEDURE IF EXISTS insertar_especialidad;
CREATE PROCEDURE insertar_especialidad(IN inserts INT)
BEGIN
    DECLARE contador INT;
    DECLARE ultima_especialidad INT;
    DECLARE _descripción VARCHAR(55);
    DECLARE nombre_especialidad VARCHAR(55);
    SET ultima_especialidad = (SELECT count(*) FROM especialidad);
    SET _descripción = "Esta especialidad se dedica a tratar a los pacientes";
    SET contador = 0;
    WHILE contador < inserts do
        SET contador = contador + 1;
        SET ultima_especialidad = ultima_especialidad + 1;
        SET nombre_especialidad = CONCAT('especialidad', ultima_especialidad);
        INSERT INTO especialidad(id_planta, nombre,descripcion) VALUES (contador, nombre_especialidad, _descripción);
    END WHILE;
END
//
DELIMITER ;
CALL insertar_especialidad(5)
;
--- Procedimiento para insertar médicos de forma aleatoria
DELIMITER //
DROP PROCEDURE IF EXISTS insertar_medico;
CREATE PROCEDURE insertar_medico(IN inserts INT)
BEGIN
    DECLARE especialidad INT;
    DECLARE nombre_medico VARCHAR(55);
    DECLARE apellido_medico VARCHAR(55);
    DECLARE contador INT;
    SET contador = 0;
    WHILE contador < inserts do
        SET contador = contador + 1;
        SET especialidad = (SELECT id from especialidad ORDER BY RAND() LIMIT 1);
        SET nombre_medico = (SELECT nombre FROM nombres ORDER BY RAND() LIMIT 1);
        SET apellido_medico = (SELECT apellido FROM nombres ORDER BY RAND() LIMIT 1);
        INSERT INTO medico(id_especialidad, nombre, apellido) VALUES (especialidad, nombre_medico, apellido_medico);
    END WHILE;
END
//
DELIMITER ;
CALL insertar_medico(5)
;
--- Procedimiento para insertar datos en medico_examen
DELIMITER //
DROP PROCEDURE IF EXISTS insertar_medico_examen;
CREATE PROCEDURE insertar_medico_examen(IN inserts INT)
BEGIN
    DECLARE medico INT;
    DECLARE examen INT;
    DECLARE contador INT;
    SET contador = 0;
    WHILE contador < inserts do
        SET contador = contador + 1;
        SET medico = (SELECT id FROM medico ORDER BY RAND() LIMIT 1);
        INSERT INTO medico_examen(id_medico, id_examen) VALUES (medico, contador);
    END WHILE;
END
//
DELIMITER ;
CALL insertar_medico_examen(5)
;
--- Procedimiento para insertar plantas de forma aleatoria
DELIMITER //
DROP PROCEDURE IF EXISTS insertar_planta;
CREATE PROCEDURE insertar_planta (in inserts INT)
BEGIN
    DECLARE ultima_planta INT;
    DECLARE contador INT;
    SET ultima_planta = (SELECT COUNT(*) FROM planta);
    SET contador = 0;
    WHILE contador < inserts do
        SET contador = contador + 1;
        SET ultima_planta = ultima_planta + 1;
        INSERT INTO planta(numero) VALUES (ultima_planta);
    END WHILE; 
END
//
DELIMITER ;
CALL insertar_planta(5)
;
--- Procedimiento para insertar citas de forma aleatoria
DELIMITER //
DROP PROCEDURE IF EXISTS insertar_cita;
CREATE PROCEDURE insertar_cita(IN inserts INT)
BEGIN
    DECLARE id_historial INT;
    DECLARE id_medico INT;
    DECLARE id_paciente INT;
    DECLARE contador INT;
    SET contador = 0;
    WHILE contador < inserts do
        SET contador = contador + 1;
        SET id_historial = (SELECT id from historial ORDER BY RAND() LIMIT 1);
        SET id_medico = (SELECT id from medico ORDER BY RAND() LIMIT 1);
        SET id_paciente = (SELECT id from paciente ORDER BY RAND() LIMIT 1);
        INSERT INTO cita(id_historial, id_medico, id_paciente, fecha_hora) VALUES (id_historial, id_medico, id_paciente, CURDATE());
    END WHILE; 
END
//
DELIMITER ;
CALL insertar_cita(5)
;
--- Procedimiento para insertar exámenes médicos de forma aleatoria
DELIMITER //
DROP PROCEDURE IF EXISTS insertar_examen_medico;
CREATE PROCEDURE insertar_examen_medico(IN inserts INT)
BEGIN
    DECLARE contador INT;
    DECLARE examen INT;
    DECLARE _diagnostico VARCHAR(150);
    SET contador = 0;
    SET _diagnostico = 'El diagnostico se ha realizado con éxito';
    WHILE contador < inserts do
        SET contador = contador + 1;
        SET examen = (SELECT id_examen from medico_examen ORDER BY RAND() LIMIT 1);
        INSERT INTO examen_medico(id_examen, diagnostico) VALUES (examen, _diagnostico);
    END WHILE; 
END
//
DELIMITER ;
CALL insertar_examen_medico(5)
;
--- Procedimiento para insertar tratamientos de forma aleatoria
DELIMITER //
DROP PROCEDURE IF EXISTS insertar_tratamiento;
CREATE PROCEDURE insertar_tratamiento(IN inserts INT)
BEGIN
    DECLARE contador INT;
    DECLARE _detalle VARCHAR(150);
    SET contador = 0;
    SET _detalle = 'Tratamiento con medicamentos';
    WHILE contador < inserts do
        SET contador = contador + 1;
        INSERT INTO tratamiento(detalle) VALUES (_detalle);
    END WHILE;
END
//
DELIMITER ;
CALL insertar_tratamiento(10)
;
--- Procedimiento para insertar datos en examen_tratamiento
DELIMITER //
DROP PROCEDURE IF EXISTS insertar_examen_tratamiento;
CREATE PROCEDURE insertar_examen_tratamiento(IN inserts INT)
BEGIN
    DECLARE contador INT;
    DECLARE examen INT;
    DECLARE tratamiento INT;
    SET contador = 0;
    WHILE contador < inserts do
        SET contador = contador + 1;
        SET examen = (SELECT id_examen FROM examen_medico ORDER BY RAND() LIMIT 1);
        SET tratamiento = (SELECT id FROM tratamiento ORDER BY RAND() LIMIT 1);
        INSERT INTO examen_tratamiento(id_examen, id_tratamiento) VALUES (examen, tratamiento);
    END WHILE;
END
//
DELIMITER ;
CALL insertar_examen_tratamiento(5)
;
-- INDICES
--- Indice para __
-- VISTAS
--- Vista de los examenes medicos realizados y la especialidad del médico que lo realizó, nombre y apellido
CREATE VIEW medico_examen_especialiad AS
SELECT medico_examen.id, especialidad.nombre, medico.nombre, medico.apellido
FROM medico_examen JOIN medico 
    ON medico_examen.id_medico = medico.id 
JOIN especialidad 
    ON medico.id_especialidad = especialidad.id;
--- Vista de todas la especialidades que tienen los médicos de la base de datos
CREATE VIEW especialidad_medico AS 
SELECT especialidad.id, especialidad.nombre FROM especialidad JOIN medico
    ON medico.id_especialidad = especialidad.id;
--- Vista de todos los documentos de pacientes que ha solicitado cita
CREATE VIEW documento_cita AS 
SELECT paciente.documento FROM paciente JOIN cita
ON paciente.id = cita.id_paciente;
-- TIGGERS
--- Trigger para insertar de manera automática los datos en la tabla historial
DELIMITER //
DROP TRIGGER IF EXISTS insertar_cita_historial;
CREATE TRIGGER insertar_cita_historial
AFTER INSERT ON cita
FOR EACH ROW
BEGIN
    DECLARE _id_cita INT;
    DECLARE _id_medico INT;
    DECLARE _fecha_hora DATETIME;
    SET _id_cita = (SELECT id FROM cita ORDER BY id DESC LIMIT 1);
    SET _id_medico = (SELECT id_medico FROM cita ORDER BY id DESC LIMIT 1);
    SET _fecha_hora = (SELECT fecha_hora FROM cita ORDER BY id DESC LIMIT 1);
    INSERT INTO historial(id_cita, id_medico, fecha_hora)
    VALUES (_id_cita, _id_medico, fecha_hora);
END//