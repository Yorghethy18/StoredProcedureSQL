SELECT * FROM AUDITEX.USUARIO WHERE ALIUSU = 'JAMORETTIA';


INSERT INTO AUDITEX.USUARIO (CODUSU, NOMUSU, ALIUSU, EMAILUSU, DNIUSU, ESTADO, PASSWORDUSU)
                     VALUES ('10825','HERNANDEZ YEREN YORGHET FERNANDA', 'YHERNANDEZY', 'yhernandez@tsc.com.pe', '72159736', 'A', '123456');
                     
                     
CREATE OR REPLACE PROCEDURE listar_yorghet(
    O_CURSOR OUT SYS_REFCURSOR
)
AS
BEGIN
    -- abrir cursor para la consulta deseada
    OPEN O_CURSOR FOR
    SELECT
        CODUSU,NOMUSU, ALIUSU
        FROM 
            AUDITEX.USUARIO 
            WHERE ESTADO = 'A';
END listar_yorghet;



-- BEGIN
    EXEC listar_yorghet(:rc);
-- END;



SELECT * FROM AUDITEX.TSC_ACCESOS;


CREATE OR REPLACE PROCEDURE LISTAR_YORGHET_NIVELES_AUDITEX
    (
        I_OPCION            NUMBER      DEFAULT NULL,
        I_FILTRO            NUMBER      DEFAULT NULL,
        O_CURSOR            OUT         SYS_REFCURSOR
    )AS
    BEGIN
    
        IF I_OPCION = 1 THEN
            
            OPEN O_CURSOR FOR
            SELECT
                CODUSU,NOMUSU, ALIUSU
                FROM 
                    AUDITEX.USUARIO 
                    WHERE 
                        ESTADO = 'A';    
        END IF;   
        
        IF I_OPCION = 2 THEN
            
            OPEN O_CURSOR FOR
            SELECT
                CODN5,
                NIVEL5
                FROM AUDITEX.TSC_NIVEL5;
            
        END IF;
        
        IF I_OPCION = 3 THEN
        
            OPEN O_CURSOR FOR
                SELECT
                   AC.COD_USU,
                   AC.CODN5,
                   N5.NIVEL5
                 FROM AUDITEX.TSC_ACCESOS AC
                 INNER JOIN AUDITEX.TSC_NIVEL5 N5 ON N5.CODN5 = AC.CODN5
                 WHERE AC.COD_USU = I_FILTRO;
        END IF;          
    END LISTAR_YORGHET_NIVELES_AUDITEX;
    

-- BEGIN
    EXEC LISTAR_YORGHET_NIVELES_AUDITEX(3, 123,:rc);
-- END;
    
 SELECT * FROM AUDITEX.TSC_NIVEL5;
 
 SELECT * FROM AUDITEX.TSC_ACCESOS;
 
 -- ACCESOS TIENE RELACION CON LA TABLA NIVEL5 Y USUARIO
 
SELECT SYSDATE FROM dual;

