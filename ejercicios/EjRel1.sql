-- Ejercicio 1
create or replace TRIGGER Fecha_Contraro_Empleados
BEFORE INSERT ON EMPLOYEES FOR EACH ROW
BEGIN
    :new.hire_date := sysdate;
END;

-- Ejercicio 2
CREATE OR REPLACE TRIGGER Actualizar_Sueldo
AFTER UPDATE ON JOBS FOR EACH ROW
DECLARE
    CURSOR cur_empleados IS SELECT * FROM employees WHERE job_id = :new.job_id AND salary < :new.MIN_SALARY FOR UPDATE;
BEGIN
    FOR v_emp IN cur_empleados LOOP
        UPDATE employees SET salary = :new.MIN_SALARY WHERE CURRENT OF cur_empleados;
    END LOOP;
END Actualizar_Sueldo;