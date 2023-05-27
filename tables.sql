--- Procedimiento de inserción masiva de datos en tabla paciente
DELIMITER //
create procedure insertar_pacientes(IN inserts int)
BEGIN
    DECLARE ultimo_paciente INT;
    DECLARE _documento VARCHAR(9);
    DECLARE contador INT;
    DECLARE _nombre VARCHAR(55);
    DECLARE _apellido VARCHAR(55);
    DECLARE _sexo INT;
    DECLARE _date VARCHAR(55);
    DECLARE _telefono INT;
    SET ultimo_paciente = (SELECT COUNT(*) FROM paciente);
    SET contador = 0;
    SET _nombre = (SELECT nombre FROM nombres ORDER BY RAND() LIMIT 1);
    SET _apellido = (SELECT apellido FROM nombres ORDER BY RAND() LIMIT 1);
    SET _sexo = ROUND(RAND() + 1);
    SET _date = STR_TO_DATE(CONCAT(FLOOR(1 + (RAND() + 11)), '-', FLOOR(1 + (RAND() + 27)), '-', FLOOR(1900 + (RAND() + 123))), '%m-%d-%Y');
    while contador < inserts do
        SET _telefono = RPAD(ultimo_paciente, 9, 0);
        SET ultimo_paciente = ultimo_paciente + 1;
        SET _documento = LPAD(CONCAT(ultimo_paciente, 'A'), 9, 0);
        INSERT INTO paciente values(_documento, _nombre, _apellido, _date, _sexo, _telefono);
        set contador = contador + 1;
    end while;
END 
//


--- Procedimiento para insertar medicos de forma aleatoriaDELIMITER //
DELIMITER //
create procedure insertar_medico(IN inserts int)
BEGIN
    DECLARE especialidad_medico int;
    DECLARE nombre_medico VARCHAR(55);
    DECLARE apellido_medico VARCHAR(55);
    DECLARE contador int;
    set contador = 0;
    set especialidad_medico = (SELECT id from especialidad ORDER BY RAND() LIMIT 1);
    SET nombre_medico = (SELECT nombre FROM nombres ORDER BY RAND() LIMIT 1);
    SET apellido_medico = (SELECT apellido FROM nombres ORDER BY RAND() LIMIT 1);
    while contador < inserts do
        INSERT INTO medico(especialidad, nombre, apellido) values (especialidad_medico, nombre_medico, apellido_medico);
        set contador = contador + 1;
    end while;
end
//

---Procedimiento para insertar plantas de forma aleatoria
DELIMITER //
create procedure insertar_planta (in inserts int)
BEGIN
    DECLARE ultima_planta INT;
    DECLARE contador INT;
    SET ultima_planta = (SELECT COUNT(*) FROM planta);
    SET contador = 0;
    while contador < inserts do
        set ultima_planta = ultima_planta + 1;
        INSERT INTO planta(numero) values (ultima_planta);
        set contador = contador + 1;
    end while; 
END
//

---Procedimiento para insertar citas de forma aleatoria
DELIMITER //
create procedure insertar_citas(IN inserts int)
BEGIN
    DECLARE id_historial int;
    DECLARE id_medico int;
    DECLARE contador int;
    set id_historial = (SELECT id from historial ORDER BY RAND() LIMIT 1);
    set id_medico = (SELECT id from medico ORDER BY RAND() LIMIT 1);
    set contador = 0;
    while contador < inserts do
        INSERT INTO cita(historial, medico, fecha_hora) values (id_historial, id_medico, CURDATE());
        set contador = contador + 1;
    end while; 
end
//

---Procedimiento para insertar especialidades de forma aleatoria:
DELIMITER //
create procedure insertar_especialidad(IN inserts int)
BEGIN
    DECLARE contador int;
    DECLARE ultima_especialidad int;
    DECLARE _descripción VARCHAR(55);
    DECLARE nombre_especialidad VARCHAR(55);
    set ultima_especialidad = (select count(*) from especialidad);
    set _descripción = "Esta especialidad se dedica a tratar a los pacientes";
    set contador = 0;
    while contador < inserts do
        set ultima_especialidad = ultima_especialidad + 1;
        set nombre_especialidad = CONCAT('especialidad', ultima_especialidad);
        INSERT INTO especialidad(nombre,descripcion) values(nombre_especialidad, _descripción);
        set contador = contador + 1;
    end while;
end
//
