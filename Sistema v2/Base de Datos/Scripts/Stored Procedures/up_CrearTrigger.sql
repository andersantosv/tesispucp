USE [CentroSalud]
GO
/****** Object:  StoredProcedure [dbo].[up_CrearTrigger]    Script Date: 09/06/2013 13:00:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
	EXEC up_CrearTrigger 'Area', 1, 'UPDATE', 0
*/
ALTER PROCEDURE [dbo].[up_CrearTrigger]
(
	@NombreTabla		VARCHAR(100),
	@IdEmpleado			INT,
	@NombreEmpleado		VARCHAR(1),
	@IndFechaInicio		CHAR(1),
	@FechaInicio		DATETIME,
	@IndFechaFin		CHAR(1),
	@FechaFin			DATETIME,
	@Tipo				VARCHAR(6), --INSERT, UPDATE, DELETE
	@Accion				INT, --0:INSERT, 2:DELETE
	@Exito				INT	OUTPUT
)
AS
BEGIN
  BEGIN TRANSACTION
	DECLARE @SentenciaSQL VARCHAR(MAX)
	
	IF @Accion = 0
	BEGIN
		SET @SentenciaSQL = 'IF EXISTS (SELECT * FROM Sysobjects WHERE Xtype=''TR'' AND Name = ''tr_' + @NombreTabla + ''') ' +
							'DROP TRIGGER tr_' + @NombreTabla + '_' + SUBSTRING(@Tipo,1,1)
							
		EXEC(@SentenciaSQL)
		
		SET @SentenciaSQL = 'CREATE TRIGGER tr_' + @NombreTabla + '_' + SUBSTRING(@Tipo,1,1) + ' ' +
							'ON ' + @NombreTabla + ' FOR ' + @Tipo + ' AS '
		
		DECLARE @NombreColumna VARCHAR(100), @Posicion INT, @TipoDato VARCHAR(20), @Longitud VARCHAR(8)
	    
		DECLARE Cur CURSOR FOR 
		SELECT COLUMN_NAME, ORDINAL_POSITION, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH
		FROM INFORMATION_SCHEMA.COLUMNS
		WHERE TABLE_NAME = @NombreTabla AND DATA_TYPE NOT IN ('image','text','ntext')
		ORDER BY ORDINAL_POSITION

		OPEN Cur

		FETCH NEXT FROM Cur 
		INTO @NombreColumna, @Posicion, @TipoDato, @Longitud

		WHILE @@FETCH_STATUS = 0
		BEGIN
			IF @Tipo = 'INSERT'
			BEGIN
				SET @SentenciaSQL = @SentenciaSQL + ' ' +
				'INSERT INTO Auditoria(Tabla, Columna, AntiguoValor, NuevoValor, IdUsuario, Fecha, Tipo) ' +
				'VALUES (''' + @NombreTabla + ''', ''' + @NombreColumna + ''', '''', (SELECT ' + 
						@NombreColumna + ' FROM INSERTED), ' + CONVERT(VARCHAR(10), @IdEmpleado) + ', GETDATE(), ''' + SUBSTRING(@Tipo,1,1) + ''') '
			END
			
			IF @Tipo = 'UPDATE'
			BEGIN
				SET @SentenciaSQL = @SentenciaSQL + ' ' + 'DECLARE @' + @NombreColumna + '1 ' + @TipoDato
				IF @Longitud <> ''
					SET @SentenciaSQL = @SentenciaSQL + '(' + @Longitud + ')'
				SET @SentenciaSQL = @SentenciaSQL + ' ' + 'DECLARE @' + @NombreColumna + '2 ' + @TipoDato
				IF @Longitud <> ''
					SET @SentenciaSQL = @SentenciaSQL + '(' + @Longitud + ')'
				
				SET @SentenciaSQL = @SentenciaSQL + ' ' +
					'SELECT @' + @NombreColumna + '1 = ' + @NombreColumna + ' FROM INSERTED ' +
					'SELECT @' + @NombreColumna + '2 = ' + @NombreColumna + ' FROM DELETED ' +
					'IF @' + @NombreColumna + '1 <> @' + @NombreColumna +'2 ' +
					'INSERT INTO Auditoria(Tabla, Columna, AntiguoValor, NuevoValor, IdUsuario, Fecha, Tipo) ' +
					'VALUES (''' + @NombreTabla + ''', ''' + @NombreColumna + ''', @' + @NombreColumna + '2, @' + 
							@NombreColumna + '1, ' + CONVERT(VARCHAR(10), @IdEmpleado) + ', GETDATE(), ''' + SUBSTRING(@Tipo,1,1) + ''') '
			END
			
			IF @Tipo = 'DELETE'
			BEGIN
				SET @SentenciaSQL = @SentenciaSQL + ' ' +
				'INSERT INTO Auditoria(Tabla, Columna, AntiguoValor, NuevoValor, IdUsuario, Fecha, Tipo) ' +
				'VALUES (''' + @NombreTabla + ''', ''' + @NombreColumna + ''', (SELECT ' + 
						@NombreColumna + ' FROM DELETED), '''', ' + CONVERT(VARCHAR(10), @IdEmpleado) + ', GETDATE(), ''' + SUBSTRING(@Tipo,1,1) + ''') '
			END
			
			FETCH NEXT FROM Cur 
			INTO @NombreColumna, @Posicion, @TipoDato, @Longitud
		END 
		CLOSE Cur;
		DEALLOCATE Cur;
		
		--SELECT @SentenciaSQL
		EXEC(@SentenciaSQL)
		
		IF @Tipo = 'INSERT'
			UPDATE TablaAuditada SET IndAuditoria = 'X', Insertar = 'X' WHERE Tabla = @NombreTabla
		IF @Tipo = 'UPDATE'
			UPDATE TablaAuditada SET IndAuditoria = 'X', Actualizar = 'X' WHERE Tabla = @NombreTabla
		IF @Tipo = 'DELETE'
			UPDATE TablaAuditada SET IndAuditoria = 'X', Eliminar = 'X' WHERE Tabla = @NombreTabla
			
		SET @Exito = 1
	END
	IF @Accion = 2
	BEGIN
		SET @SentenciaSQL = 'IF EXISTS (SELECT * FROM Sysobjects WHERE Xtype=''TR'' AND Name = ''tr_' + @NombreTabla + '_' + SUBSTRING(@Tipo,1,1) + ''') ' +
							'DROP TRIGGER tr_' + @NombreTabla + '_' + SUBSTRING(@Tipo,1,1)
							
		EXEC(@SentenciaSQL)
		
		IF @Tipo = 'INSERT'
			UPDATE TablaAuditada SET Insertar = '' WHERE Tabla = @NombreTabla
		IF @Tipo = 'UPDATE'
			UPDATE TablaAuditada SET Actualizar = '' WHERE Tabla = @NombreTabla
		IF @Tipo = 'DELETE'
			UPDATE TablaAuditada SET Eliminar = '' WHERE Tabla = @NombreTabla
	
		DECLARE @Contador INT = 0
		SELECT @Contador = COUNT(*) 
		FROM TablaAuditada 
		WHERE Tabla = @NombreTabla AND Insertar='' AND Actualizar='' AND Eliminar=''
		
		IF @Contador <> 0 
			UPDATE TablaAuditada SET IndAuditoria = '' WHERE Tabla = @NombreTabla
		
		SET @Exito = 1
	END
  IF @@ERROR <> 0
  BEGIN
    ROLLBACK TRANSACTION
    
    SET @Exito = 0
    
    RETURN @Exito
  END
  
  COMMIT TRANSACTION
  
  RETURN @Exito
END