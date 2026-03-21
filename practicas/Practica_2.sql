-- Ejercicio 1
CREATE TABLE TB_OBJETOS (NOMBRE VARCHAR(128), CODIGO NUMBER, FECHA_CREACION DATE, FECHA_MODIFICACION DATE, TIPO VARCHAR(23), ESQUEMA_ORIGINAL VARCHAR(128));

DECLARE
    CURSOR cur_objects IS SELECT * FROM ALL_OBJECTS;
BEGIN
    FOR v_object IN cur_objects LOOP
        INSERT INTO TB_OBJETOS VALUES (v_object.object_name, v_object.object_id, v_object.created, v_object.last_ddl_time, v_object.object_type, v_object.owner);
    END LOOP;
END;
/

-- Ejercicio 2
CREATE TABLE TB_ESTILO (TIPO_OBJETO VARCHAR(23), PREFIJO VARCHAR(20));
INSERT INTO tb_estilo VALUES ('PROCEDURE', 'PR_');

-- Ejercicio 3
ALTER TABLE TB_OBJETOS ADD ESTADO VARCHAR(10) ADD NOMBRE_CORRECTO VARCHAR(128);


CREATE OR REPLACE PROCEDURE PR_COMPROBAR(ESQUEMA IN VARCHAR2) IS
    CURSOR cur_objs IS SELECT * FROM TB_OBJETOS WHERE ESQUEMA_ORIGINAL = NVL(ESQUEMA, ESQUEMA_ORIGINAL) FOR UPDATE;
    v_prefijo TB_ESTILO.prefijo%type;
BEGIN
    FOR v_obj IN cur_objs LOOP
        BEGIN
            SELECT prefijo INTO v_prefijo FROM TB_ESTILO WHERE tipo_objeto = v_obj.tipo;
            IF v_prefijo IS NOT NULL THEN
                IF v_obj.nombre LIKE (v_prefijo || '%') THEN
                    UPDATE TB_OBJETOS SET estado = 'CORRECTO' WHERE CURRENT OF cur_objs;
                ELSE
                    UPDATE TB_OBJETOS SET estado = 'INCORRECTO', nombre_correcto = (v_prefijo || nombre) WHERE CURRENT OF cur_objs;
                END IF;
            END IF;
        EXCEPTION 
            WHEN NO_DATA_FOUND THEN 
                NULL;
        END;
    END LOOP;
END;
/

EXEC PR_COMPROBAR(null);

