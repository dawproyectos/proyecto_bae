-- TABLAS HOSPITAL
--- Tabla paciente
CREATE TABLE paciente(
    documento VARCHAR(15) PRIMARY KEY,
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
--- Tabla especialidad
CREATE TABLE especialidad(
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50),
    descripcion VARCHAR(150)
);
--- Tabla medico
CREATE TABLE medico(
    id INT AUTO_INCREMENT PRIMARY KEY,
    medico_especialidad INT,
    nombre VARCHAR(50),
    apellido VARCHAR(50),
    FOREIGN KEY (medico_especialidad) REFERENCES especialidad(id)
);
--- Tabla cita
CREATE TABLE cita(
    id INT AUTO_INCREMENT PRIMARY KEY,
    cita_historial INT,
    cita_medico INT,
    fecha_hora DATETIME,
    FOREIGN KEY (cita_historial) REFERENCES historial(id),
    FOREIGN KEY (cita_medico) REFERENCES medico(id)
);
--- Tabla planta
CREATE TABLE planta(
    id INT AUTO_INCREMENT PRIMARY KEY,
    numero INT
);
--- Tabla examen_medico
CREATE TABLE examen_medico(
    id INT AUTO_INCREMENT PRIMARY KEY,
    diagnostico VARCHAR(150)
);
--- Tabla tratamiento
CREATE TABLE tratamiento(
    id INT AUTO_INCREMENT PRIMARY KEY,
    detalle VARCHAR(150)
);
--- Tabla paciente_cita
CREATE TABLE paciente_cita(
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_paciente VARCHAR(15),
    id_cita INT,
    FOREIGN KEY (id_paciente) REFERENCES paciente(documento),
    FOREIGN KEY (id_cita) REFERENCES cita(id)
);
-- TABLAS PARA INSERCIÓN DE DATOS
--- Tabla nombres
CREATE TABLE nombres (
  id INT PRIMARY KEY AUTO_INCREMENT,
  nombre VARCHAR(50),
  apellido VARCHAR(50)
);
-- Insertar los nombres en la tabla
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
-- PROCEDIMIENTOS
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
--- Procedimiento de inserción masiva de datos en tabla paciente
DELIMITER //
DROP PROCEDURE IF EXISTS insertar_pacientes;
CREATE PROCEDURE insertar_pacientes(IN inserts int)
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
        SET _nombre = (SELECT nombre FROM nombres ORDER BY RAND() LIMIT 1);
        SET _apellido = (SELECT apellido FROM nombres ORDER BY RAND() LIMIT 1);
        SET _sexo = ROUND(RAND() + 1);
        SET _date = (SELECT fecha_aleatoria());
        SET _telefono = (SELECT telefono_aleatorio());
        SET ultimo_paciente = ultimo_paciente + 1;
        SET _documento = LPAD(CONCAT(ultimo_paciente, 'A'), 9, 0);
        INSERT INTO paciente values(_documento, _nombre, _apellido, _date, _sexo, _telefono);
        SET contador = contador + 1;
    END WHILE;
END 
//
DELIMITER ;
CALL insertar_pacientes(30)
;
--- Procedimiento para insertar especialidades de forma aleatoria:
DELIMITER //
DROP PROCEDURE IF EXISTS insertar_especialidad;
CREATE PROCEDURE insertar_especialidad(IN inserts int)
BEGIN
    DECLARE contador int;
    DECLARE ultima_especialidad int;
    DECLARE _descripción VARCHAR(55);
    DECLARE nombre_especialidad VARCHAR(55);
    SET ultima_especialidad = (select count(*) from especialidad);
    SET _descripción = "Esta especialidad se dedica a tratar a los pacientes";
    SET contador = 0;
    WHILE contador < inserts do
        SET ultima_especialidad = ultima_especialidad + 1;
        SET nombre_especialidad = CONCAT('especialidad', ultima_especialidad);
        INSERT INTO especialidad(nombre,descripcion) values(nombre_especialidad, _descripción);
        SET contador = contador + 1;
    END WHILE;
END
//
DELIMITER ;
CALL insertar_especialidad(5)
;
--- Procedimiento para insertar medicos de forma aleatoria
DELIMITER //
DROP PROCEDURE IF EXISTS insertar_medico;
CREATE PROCEDURE insertar_medico(IN inserts int)
BEGIN
    DECLARE especialidad int;
    DECLARE nombre_medico VARCHAR(55);
    DECLARE apellido_medico VARCHAR(55);
    DECLARE contador int;
    SET contador = 0;
    WHILE contador < inserts do
        SET especialidad = (SELECT id from especialidad ORDER BY RAND() LIMIT 1);
        SET nombre_medico = (SELECT nombre FROM nombres ORDER BY RAND() LIMIT 1);
        SET apellido_medico = (SELECT apellido FROM nombres ORDER BY RAND() LIMIT 1);
        INSERT INTO medico(medico_especialidad, nombre, apellido) values (especialidad, nombre_medico, apellido_medico);
        SET contador = contador + 1;
    END WHILE;
END
//
DELIMITER ;
CALL insertar_medico(5)
;
--- Procedimiento para insertar plantas de forma aleatoria
DELIMITER //
DROP PROCEDURE IF EXISTS insertar_planta;
CREATE PROCEDURE insertar_planta (in inserts int)
BEGIN
    DECLARE ultima_planta INT;
    DECLARE contador INT;
    SET ultima_planta = (SELECT COUNT(*) FROM planta);
    SET contador = 0;
    WHILE contador < inserts do
        SET ultima_planta = ultima_planta + 1;
        INSERT INTO planta(numero) values (ultima_planta);
        SET contador = contador + 1;
    END WHILE; 
END
//
DELIMITER ;
CALL insertar_planta(5)
;
--- Procedimiento para insertar citas de forma aleatoria
DELIMITER //
DROP PROCEDURE IF EXISTS insertar_citas;
CREATE PROCEDURE insertar_citas(IN inserts int)
BEGIN
    DECLARE id_historial int;
    DECLARE id_medico int;
    DECLARE contador int;
    SET contador = 0;
    WHILE contador < inserts do
        SET id_historial = (SELECT id from historial ORDER BY RAND() LIMIT 1);
        SET id_medico = (SELECT id from medico ORDER BY RAND() LIMIT 1);
        INSERT INTO cita(cita_historial, cita_medico, fecha_hora) values (id_historial, id_medico, CURDATE());
        SET contador = contador + 1;
    END WHILE; 
END
//
DELIMITER ;
CALL insertar_citas(10)
;
--- Procedimiento para insertar exámenes médicos:
DELIMITER //
CREATE PROCEDURE insertar_examen_medico (IN inserts int)
BEGIN
    DECLARE contador int;
    DECLARE _diagnostico VARCHAR(150);
    SET contador = 0;
    SET _diagnostico = 'El diagnostico se ha realizado con éxito'
    WHILE contador < inserts do
        INSERT INTO examen_medico(diagnostico) values (_diagnostico);
        SET contador = contador + 1;
    END WHILE; 
END
//
--- Procedimiento para insertar tratamientos:
DELIMITER //
CREATE PROCEDURE insertar_tratamiento (IN inserts int)
BEGIN
    DECLARE contador int;
    DECLARE _detalle VARCHAR(150);
    SET contador = 0;
    SET _detalle = 'Tratamiento con medicamentos'
    WHILE contador < inserts do
        INSERT INTO Tratamiento(_detalle) values (_detalle);
        SET contador = contador + 1;
    END WHILE;
END
//