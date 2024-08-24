CREATE OR REPLACE PROCEDURE listar_yorghet
AS
    CURSOR c_usuarios IS
        SELECT 
            CODUSU, NOMUSU, ESTADO
        FROM 
            AUDITEX.USUARIO
        WHERE 
            ESTADO = 'I';
            
    v_codusu AUDITEX.USUARIO.CODUSU%TYPE;
    v_nomusu AUDITEX.USUARIO.NOMUSU%TYPE;
    v_estado AUDITEX.USUARIO.ESTADO%TYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Iniciando el procedimiento listar_yorghet');
    
    OPEN c_usuarios;
    
    LOOP
        FETCH c_usuarios INTO v_codusu, v_nomusu, v_estado;
        EXIT WHEN c_usuarios%NOTFOUND;
        
        -- Imprimir los resultados
        DBMS_OUTPUT.PUT_LINE('CODUSU: ' || v_codusu || ', NOMUSU: ' || v_nomusu || ', ESTADO: ' || v_estado);
    END LOOP;
    
    CLOSE c_usuarios;
    
    DBMS_OUTPUT.PUT_LINE('Procedimiento listar_yorghet finalizado');
END listar_yorghet;
/

BEGIN
    listar_yorghet;
END;
/


SELECT * FROM AUDITEX.USUARIO;