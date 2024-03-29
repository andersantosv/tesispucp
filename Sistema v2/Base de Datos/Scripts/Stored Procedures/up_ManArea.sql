USE [CentroSalud]
GO
/****** Object:  StoredProcedure [dbo].[up_ManArea]    Script Date: 09/06/2013 13:00:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--EXEC up_ManArea 1,'','','','',4,0
ALTER PROCEDURE [dbo].[up_ManArea]
(
	@IdArea			INT,
	@Nombre			VARCHAR(50),
	@Descripcion	VARCHAR(500),
	@TipoArea		VARCHAR(14),
	@Estado			VARCHAR(8),
	@Accion			INT, --0:INSERT, 1:UPDATE, 2:DELETE, 3:RECOVER, 4:SELECT, 5:SELECTALL, 6:SELECT CUSTOM
	@IdGenerado		INT	OUTPUT 
)
AS
BEGIN
  BEGIN TRANSACTION
    IF @Accion = 0
    BEGIN
		INSERT INTO Area(Nombre, Descripcion, TipoArea, Estado)
		VALUES (@Nombre, @Descripcion, @TipoArea, 'ACTIVO')
		
		SET @IdGenerado = SCOPE_IDENTITY()
    END
    
    IF @Accion = 1
    BEGIN
		UPDATE Area SET Nombre = @Nombre, Descripcion = @Descripcion, TipoArea = @TipoArea
		WHERE IdArea = @IdArea
							
		SET @IdGenerado = 1
    END
    IF @Accion = 2
    BEGIN
		UPDATE Area SET Estado = 'INACTIVO'
		WHERE IdArea = @IdArea
		
		SET @IdGenerado = 1
    END
    IF @Accion = 3
    BEGIN
		UPDATE Area SET Estado = 'ACTIVO'
		WHERE IdArea = @IdArea
		
		SET @IdGenerado = 1
    END
    IF @Accion = 4
    BEGIN
		SELECT IdArea, Nombre, Descripcion, TipoArea, Estado 
		FROM Area
		WHERE IdArea = @IdArea
		ORDER BY TipoArea, Nombre
	END
    IF @Accion = 5
    BEGIN
		SELECT IdArea, Nombre, Descripcion, TipoArea, Estado 
		FROM Area
		ORDER BY TipoArea, Nombre
	END
	IF @Accion = 6
	BEGIN
		DECLARE @Query VARCHAR(1000)
		SET @Query = 'SELECT IdArea, Nombre, Descripcion, TipoArea, Estado FROM Area WHERE IdArea > 0'
		
		IF @Nombre <> ''
		BEGIN
			SET @Query = @Query + ' AND Nombre LIKE ''%' + @Nombre + '%'''
		END
		
		IF @TipoArea <> 'TODAS'
		BEGIN
			SET @Query = @Query  + ' AND TipoArea = ''' + @TipoArea + ''''
		END
		
		IF @Estado <> 'TODOS'
		BEGIN
			SET @Query = @Query + ' AND Estado = ''' + @Estado + ''''
		END	
		
		SET @Query = @Query + ' ORDER BY TipoArea, Nombre'	
						
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