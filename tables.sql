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
    DECLARE _date VARCHAR();
    SET ultimo_paciente = (SELECT COUNT(*) FROM paciente);
    SET contador = 0;
    SET _nombre = (SELECT nombre FROM nombres ORDER BY RAND());
    SET _apellido = (SELECT apellido FROM nombres ORDER BY RAND());
    SET _sexo = ROUND(RAND() + 1);
    SET _date = CONCAT(ROUND(1 + (RAND() + 28)), '/', ROUND(1 + (RAND() + 28)), '/', ROUND(1900 + (RAND() + 2023)))
    while contador < inserts do
        SET _telefono = RPAD(ultimo_paciente, 12, 0)
        SET ultimo_paciente = ultimo_paciente + 1;
        SET _documento = LPAD(CONCAT(ultimo_paciente, 'A'), 9, 0);
        INSERT INTO paciente(documento, nombre, apellido, _date, _sexo, _telefono);
        set contador = contador + 1;
    end while;
END 
//


CREATE TRIGGER añadir_a_historico AFTER INSERT ON cita
BEGIN
    INSERT INTO historial(New.nombre, New.apellido)