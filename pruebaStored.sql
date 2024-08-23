USE [SIGE_TSC_INC]
GO

SELECT * FROM seg_cambio_movimiento
GO

-- Su codigo de usuario tambien puedes ser varchar, pensé que era solo int, viste?

select * from seg_cambio_movimiento ;
go
ALTER TABLE seg_cambio_movimiento ADD FEC_CREACION DATETIME
GO
ALTER TABLE seg_cambio_movimiento ADD COD_ESTACION_CREACION VARCHAR(30) DEFAULT '' WITH VALUES
GO
ALTER TABLE seg_cambio_movimiento ADD COD_USUARIO_CREACION VARCHAR(30) DEFAULT '' WITH VALUES
GO

ALTER TABLE seg_cambio_movimiento ADD COD_ESTACION_UPDATE VARCHAR(30) DEFAULT '' WITH VALUES
GO
ALTER TABLE seg_cambio_movimiento ADD COD_USUARIO_UPDATE VARCHAR(30) DEFAULT '' WITH VALUES
GO
ALTER TABLE seg_cambio_movimiento ADD FEC_ELIMINACION DATETIME
GO
ALTER TABLE seg_cambio_movimiento ADD COD_ESTACION_ELIMINACION VARCHAR(30) DEFAULT '' WITH VALUES
GO
ALTER TABLE seg_cambio_movimiento ADD COD_USUARIO_ELIMINACION VARCHAR(30) DEFAULT '' WITH VALUES
GO

-- CAMPOS PARA ACTIVACIÓN
ALTER TABLE seg_cambio_movimiento ADD FEC_ACTIVACION DATETIME
GO
ALTER TABLE seg_cambio_movimiento ADD COD_USUARIO_ACTIVACION VARCHAR(30) DEFAULT '' WITH VALUES
GO
ALTER TABLE seg_cambio_movimiento ADD COD_ESTACION_ACTIVACION VARCHAR(30) DEFAULT '' WITH VALUES
GO

ALTER PROCEDURE spu_cambio_movimiento
    @opcion             CHAR(1) = 'V',
    @cod_usuario        VARCHAR(30) = '',
    @codigoUsuarioC     VARCHAR(30) = '',
    @codigoEstacion     VARCHAR(30) = ''
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @MSG_ERROR VARCHAR(800);
	-- NOT IN => verificar si un valor no está presente en una lista de valores.
	IF @opcion NOT IN ('V', 'I', 'U', 'D', 'A')
	BEGIN
		-- Mensaje de error con la opción ingresada
		SET @MSG_ERROR = 'La opción [' + ISNULL(@opcion, 'NULL') + '] no existe. Favor de ingresar una opción correcta: V, I, U, D, A';
		RAISERROR(@MSG_ERROR, 16, 1);
		RETURN;
	END
    -- Validaciones
    IF @opcion != 'V'
    BEGIN
        -- Validar que se envían todos los parámetros requeridos para opciones distintas de 'V'
        IF @cod_usuario = '' 
        BEGIN
            SET @MSG_ERROR = 'FALTA EL CÓDIGO DE USUARIO';
            RAISERROR(@MSG_ERROR, 16, 1);
            RETURN;
        END
		IF @codigoUsuarioC = '' 
		BEGIN
            SET @MSG_ERROR = 'FALTA EL CÓDIGO DE USUARIO DE REGISTRO';
            RAISERROR(@MSG_ERROR, 16, 1);
            RETURN;
        END
		IF @codigoEstacion = ''
		BEGIN
            SET @MSG_ERROR = 'FALTA EL CÓDIGO DE ESTACIÓN DE REGISTRO';
            RAISERROR(@MSG_ERROR, 16, 1);
            RETURN;
        END

        IF @opcion = 'I'
        BEGIN
            IF EXISTS(SELECT 1 FROM seg_cambio_movimiento WHERE COD_USUARIO = @cod_usuario)
            BEGIN
                SET @MSG_ERROR = 'USUARIO YA EXISTE, FAVOR VALIDAR';
                RAISERROR(@MSG_ERROR, 16, 1);
                RETURN;
            END
        END

        IF @opcion = 'U'
        BEGIN
            IF NOT EXISTS (SELECT 1 FROM seg_cambio_movimiento WHERE cod_usuario = @cod_usuario AND FLG_ACTIVO = 0)
            BEGIN
                SET @MSG_ERROR = 'NO SE PUEDE MODIFICAR UN USUARIO QUE NO EXISTE';
                RAISERROR(@MSG_ERROR, 16, 1);
                RETURN;
            END
        END

		IF @opcion = 'D'
		BEGIN
			IF NOT EXISTS (SELECT 1 FROM seg_cambio_movimiento WHERE cod_usuario = @cod_usuario AND FLG_ACTIVO = 0)
            BEGIN
                SET @MSG_ERROR = 'USUARIO YA HA SIDO ELIMINADO O NO EXISTE';
                RAISERROR(@MSG_ERROR, 16, 1);
                RETURN;
            END
		END

		IF @opcion = 'A'
		BEGIN
			IF NOT EXISTS (SELECT 1 FROM seg_cambio_movimiento WHERE cod_usuario = @cod_usuario AND FLG_ACTIVO = 1)
			BEGIN
				SET @MSG_ERROR = 'USUARIO NO EXISTO O ESTÁ ACTIVO';
				RAISERROR(@MSG_ERROR,16,1);
				RETURN;
			END
		END
    END

	IF @opcion = 'V'
        BEGIN
            -- Para la opción 'V', simplemente listar los registros
            SELECT * 
            FROM seg_cambio_movimiento 
            WHERE FLG_ACTIVO = 0;
            RETURN;
        END

		-- Proceso
		BEGIN
			BEGIN TRANSACTION
			IF @opcion = 'I'
			BEGIN 
				INSERT INTO seg_cambio_movimiento (cod_usuario, 
					                               FEC_CREACION, 
						                           COD_ESTACION_CREACION, 
							                       COD_USUARIO_CREACION)
				VALUES (@cod_usuario, 
						GETDATE(), 
						@codigoUsuarioC,
						@codigoEstacion);

			END

			-- Modificación (opcion => 'U')
			IF @opcion = 'U'
			BEGIN
				UPDATE seg_cambio_movimiento
				SET
					FEC_UPDATE = GETDATE(),
					COD_USUARIO_UPDATE = @codigoUsuarioC,
					COD_ESTACION_UPDATE = @codigoEstacion
				WHERE 
					cod_usuario = @cod_usuario;
			END
    
			-- Eliminación (opcion => 'D')
			IF @opcion = 'D'
			BEGIN
				UPDATE seg_cambio_movimiento
				SET 
					COD_USUARIO_ELIMINACION = @codigoUsuarioC,
					COD_ESTACION_ELIMINACION = @codigoEstacion,
					FEC_ELIMINACION = GETDATE(),
					FLG_ACTIVO = 0
				WHERE 
					cod_usuario = @cod_usuario;
			END

			-- Activación de Usuarios (opcion => A)
			IF @opcion = 'A'
			BEGIN
				UPDATE seg_cambio_movimiento
				SET
					FLG_ACTIVO					= 1,
					FEC_ACTIVACION				= GETDATE(),
					COD_USUARIO_ACTIVACION		= @codigoUsuarioC,
					COD_ESTACION_ACTIVACION		= @codigoEstacion
				WHERE
					cod_usuario					= @cod_usuario;
			END
			COMMIT TRANSACTION;
		END
	END
GO


/*TRUNCATE TABLE seg_cambio_movimiento
GO*/

-- LISTADO
EXEC spu_cambio_movimiento 'V'
GO

-- INSERTAR
EXEC spu_cambio_movimiento 'I', 'COD-058', 'USU-01','EST-02'
GO

-- MODIFICAR
--EXEC spu_cambio_movimiento 'U', 'COD-021', 'US-62', 'EST-056'
GO 

-- ELIMINAR
EXEC spu_cambio_movimiento 'D', 'COD-021', 'USU-59', 'ESCT-26'
GO

-- ACTIVACION
EXEC spu_cambio_movimiento '', 'COD-021', 'USV-56', 'EST-559'
GO

SELECT * FROM seg_cambio_movimiento 


GO