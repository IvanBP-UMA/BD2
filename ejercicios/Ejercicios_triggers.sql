-- Ejercicio 1
CREATE TABLE PIEZA (
    codigo NUMBER,
    nombre VARCHAR2(50),
    descripcion VARCHAR2(100),
    peso  NUMBER(5,2)
);

-- Ejercicio 2
CREATE OR REPLACE TRIGGER tr_peso_negativo
BEFORE INSERT OR UPDATE ON PIEZA FOR EACH ROW
BEGIN
    IF :new.peso < 0 THEN
        RAISE_APPLICATION_ERROR(-20007, 'PESO NEGATIVO');
    END IF;
END;
/

INSERT INTO PIEZA (peso) VALUES (-1);
INSERT INTO PIEZA (peso) VALUES (100);
UPDATE PIEZA SET peso = -1 WHERE pieza.peso = 100;

-- Ejercicio 3
CREATE OR REPLACE PROCEDURE PR_INSERTA_PIEZA (p_codigo IN NUMBER, p_nombre IN VARCHAR2, p_descripcion IN VARCHAR2, p_peso IN NUMBER) IS
peso_negativo EXCEPTION;
PRAGMA EXCEPTION_INIT(peso_negativo,-20007);
BEGIN
    IF p_peso = 0 THEN
        RAISE_APPLICATION_ERROR(-20008, 'PESO CERO INCORRECTO');
    END IF;
    INSERT INTO PIEZA VALUES (p_codigo, p_nombre, p_descripcion, p_peso);
EXCEPTION
    WHEN peso_negativo THEN
        INSERT INTO PIEZA VALUES (p_codigo, p_nombre, p_descripcion, p_peso * -1);
END;
/

EXEC PR_INSERTA_PIEZA(1, 'test', 'test_piece', 10);
SELECT * FROM PIEZA;

EXEC PR_INSERTA_PIEZA(1, 'test', 'test_piece', 0);
SELECT * FROM PIEZA;

EXEC PR_INSERTA_PIEZA(1, 'test', 'test_piece', -20);
SELECT * FROM PIEZA;