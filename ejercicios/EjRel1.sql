-- Ejercicio 1
create or replace TRIGGER Fecha_Contraro_Empleados
BEFORE INSERT ON EMPLOYEES FOR EACH ROW
BEGIN
    :new.hire_date := sysdate;
END;
/

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
/

-- Ejercicio 3
CREATE OR REPLACE TRIGGER Actualizar_Manager
AFTER UPDATE ON DEPARTMENTS FOR EACH ROW
WHEN (new.manager_id != old.manager_id)
DECLARE
    CURSOR cur_empleados IS SELECT * FROM EMPLOYEES WHERE DEPARTMENT_ID = :new.department_id FOR UPDATE;
BEGIN
    FOR v_empleado IN cur_empleados LOOP
        UPDATE employees SET manager_id = :new.manager_id WHERE CURRENT OF cur_empleados;
    END LOOP;
END;
/

-- Ejercicio 4
CREATE OR REPLACE TRIGGER Revision_Email
BEFORE INSERT ON EMPLOYEES FOR EACH ROW
BEGIN
    IF (INSTR(:new.email, '@') > 0)
        THEN RAISE_APPLICATION_ERROR(-20001, 'INVALID EMAIL');
    END IF;
END;
/

-- Ejercicio 5
CREATE OR REPLACE TRIGGER Format_Email
BEFORE INSERT ON EMPLOYEES FOR EACH ROW
DECLARE
    v_first_letter CHAR;
    v_count INT;
BEGIN
    v_first_letter := SUBSTR(:new.first_name, 1, 1);
    :new.email := v_first_letter || :new.last_name;
    SELECT COUNT(*) INTO v_count FROM EMPLOYEES WHERE first_name LIKE (v_first_letter || '%') AND last_name = :new.last_name;
    IF v_count > 0 THEN
        :new.email := :new.email || v_count;
    END IF;
END;
/

-- Ejercicio 6
CREATE OR REPLACE TRIGGER Check_Salary
BEFORE INSERT ON EMPLOYEES FOR EACH ROW
DECLARE
    type t_salary is record (min_salary JOBS.min_salary%type, max_salary JOBS.max_salary%type);
    v_salary_range t_salary;
BEGIN
    SELECT min_salary, max_salary INTO v_salary_range FROM JOBS WHERE :new.job_id = job_id;
    IF :new.salary < v_salary_range.min_salary THEN
        :new.salary := v_salary_range.min_salary;
    ELSIF :new.salary > v_salary_range.max_salary THEN
        :new.salary := v_salary_range.max_salary;
    END IF;
END;
/

create or replace TRIGGER Fecha_Contraro_Empleados
BEFORE INSERT ON EMPLOYEES FOR EACH ROW FOLLOWS Check_Salary
BEGIN
    :new.hire_date := sysdate;
END;
/

-- Ejercicio 7
CREATE OR REPLACE TRIGGER Update_Job_History
AFTER UPDATE OF job_id ON EMPLOYEES FOR EACH ROW
DECLARE
    v_previous_date JOB_HISTORY.end_date%type;
BEGIN
    SELECT MAX(end_date) into v_previous_date FROM JOB_HISTORY WHERE employee_id = :old.employee_id;
    IF v_previous_date IS NULL THEN
        v_previous_date := :old.hire_date;
    ELSE
        v_previous_date := v_previous_date + 1;
    END IF;
    INSERT INTO job_history(employee_id, start_date, end_date, job_id, department_id) VALUES (:old.employee_id, v_previous_date, sysdate, :old.job_id, :old.department_id);
END;
/