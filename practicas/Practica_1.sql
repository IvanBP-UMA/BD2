-- Comando a ejecutar para poder visualizar el output de los comandos DBMS_OUTPUT.PUT_LINE
SET SERVEROUTPUT ON;

-- Ejercicio 1
DECLARE
    CURSOR cur_tablas IS SELECT TABLE_NAME FROM USER_TABLES;
BEGIN
    FOR v_tabla IN cur_tablas LOOP
        DBMS_OUTPUT.PUT_LINE('La tabla '||v_tabla.TABLE_NAME||' pertenece al esquema '||user);
    END LOOP;
END; 

describe ALL_TABLES;

-- Ejercicio 2
DECLARE
    CURSOR cur_tablas IS SELECT TABLE_NAME, OWNER FROM ALL_TABLES;
BEGIN
    FOR v_tabla IN cur_tablas LOOP
        DBMS_OUTPUT.PUT_LINE('La tabla '||v_tabla.TABLE_NAME||' pertenece al esquema '||v_tabla.OWNER);
    END LOOP;
END; 

-- Ejercicio 3
-- Además de modificar la vista de diccionario, he tenido que añadir el atributo owner a la definición del cursor

-- Ejercicio 4
DECLARE
    CURSOR cur_tablas IS SELECT TABLE_NAME, OWNER FROM ALL_TABLES WHERE OWNER = USER;
BEGIN
    FOR v_tabla IN cur_tablas LOOP
        DBMS_OUTPUT.PUT_LINE('La tabla '||v_tabla.TABLE_NAME||' pertenece al esquema '||v_tabla.OWNER);
    END LOOP;
END;


-- Ejercicio 5
CREATE OR REPLACE PROCEDURE RECORRE_TABLAS(P_MODE IN NUMBER) IS
BEGIN
    IF P_MODE IS NULL THEN DBMS_OUTPUT.PUT_LINE('Parametro nulo. Se debe introducir un 0 para ver todas las tablas accesibles o cualquier otro número para ver las tablas del usuario');
    ELSE
        DECLARE
            CURSOR cur_tablas IS SELECT TABLE_NAME, OWNER FROM ALL_TABLES WHERE OWNER = decode(P_MODE, 0, OWNER, user);
        BEGIN
            FOR v_tabla IN cur_tablas LOOP
                DBMS_OUTPUT.PUT_LINE('La tabla '||v_tabla.TABLE_NAME||' pertenece al esquema '||v_tabla.OWNER);
            END LOOP;
        END;
    END IF;
END;

EXEC RECORRE_TABLAS(0);
EXEC RECORRE_TABLAS(1);
EXEC RECORRE_TABLAS(null);