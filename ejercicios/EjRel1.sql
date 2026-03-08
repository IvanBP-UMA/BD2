-- Ejercicio 1
create or replace TRIGGER Fecha_Contraro_Empleados
BEFORE INSERT ON EMPLOYEES FOR EACH ROW
BEGIN
    :new.hire_date := sysdate;
END;

-- Ejercicio 2
CREATE OR REPLACE TRIGGER Actualizar_Salarios
AFTER UPDATE ON JOBS FOR EACH ROW
BEGIN
    UPDATE EMPLOYEES SET salary = :new.MIN_SALARY;
END;