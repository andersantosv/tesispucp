USE [CentroSalud]
GO
/****** Object:  StoredProcedure [dbo].[up_ManPabellon]    Script Date: 09/06/2013 13:04:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[up_ManPabellon]
(
	@IdPabellon		INT,
	@Nombre			VARCHAR(50),
	@Descripcion	VARCHAR(500),
	@Estado			VARCHAR(8),
	@Accion			INT,
	@IdGenerado		INT	OUTPUT --0:INSERT, 1:UPDATE, 2:DELETE, 3:RECOVER, 4:SELECT, 5:SELECTALL, 6:SELECT CUSTOM
)
AS
BEGIN
  BEGIN TRANSACTION
    IF @Accion = 0
    BEGIN
		INSERT INTO Pabellon(Nombre, Descripcion, Estado)
		VALUES (@Nombre, @Descripcion, 'ACTIVO')
		
		SET @IdGenerado = SCOPE_IDENTITY()
    END
    
    IF @Accion = 1
    BEGIN
		UPDATE Pabellon SET Nombre = @Nombre, Descripcion = @Descripcion
		WHERE IdPabellon = @IdPabellon
							
		SET @IdGenerado = 1
    END
    IF @Accion = 2
    BEGIN
		UPDATE Pabellon SET Estado = 'INACTIVO'
		WHERE IdPabellon = @IdPabellon
		
		SET @IdGenerado = 1
    END
    IF @Accion = 3
    BEGIN
		UPDATE Pabellon SET Estado = 'ACTIVO'
		WHERE IdPabellon = @IdPabellon
		
		SET @IdGenerado = 1
    END
    IF @Accion = 4
    BEGIN
		SELECT IdPabellon, Nombre, Descripcion, Estado 
		FROM Pabellon
		WHERE IdPabellon = @IdPabellon
		ORDER BY Nombre
	END
    IF @Accion = 5
    BEGIN
		SELECT IdPabellon, Nombre, Descripcion, Estado 
		FROM Pabellon
		ORDER BY Nombre
	END
	IF @Accion = 6
	BEGIN
		DECLARE @Query VARCHAR(1000)
		SET @Query = 'SELECT IdPabellon, Nombre, Descripcion, Estado FROM Pabellon WHERE IdPabellon > 0'
		
		IF @Nombre <> ''
		BEGIN
			SET @Query = @Query + ' AND Nombre LIKE ''%' + @Nombre + '%'''
		END
		
		IF @Estado <> 'TODOS'
		BEGIN
			SET @Query = @Query + ' AND Estado = ''' + @Estado + ''''
		END	
		
		SET @Query = @Query + ' ORDER BY Nombre'	
						
		EXEC(@Query)
	END
  IF @@ERROR <> 0
  BEGIN
    ROLLBACK TRANSACTION
    
    SET @IdGenerado = 0
	
	RETURN @IdGenerado
  END
  
  COMMIT TRANSACTION
  
  RETURN @IdGenerado
END