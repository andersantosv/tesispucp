USE [CentroSalud]
GO
/****** Object:  StoredProcedure [dbo].[up_ManTipoDocumento]    Script Date: 09/06/2013 13:06:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[up_ManTipoDocumento]
(
	@IdTipoDocumento		INT,
	@Nombre					VARCHAR(50),
	@Descripcion			VARCHAR(500),
	@NumeroDigitos			VARCHAR(2),
	@Estado					VARCHAR(8),
	@Accion					INT,
	@IdGenerado				INT	OUTPUT --0:INSERT, 1:UPDATE, 2:DELETE, 3:RECOVER, 4:SELECT, 5:SELECTALL, 6:SELECT CUSTOM
)
AS
BEGIN
  BEGIN TRANSACTION
    IF @Accion = 0
    BEGIN
		INSERT INTO TipoDocumento(Nombre, Descripcion, NumeroDigitos, Estado)
		VALUES (@Nombre, @Descripcion, @NumeroDigitos, 'ACTIVO')
		
		SET @IdGenerado = SCOPE_IDENTITY()
    END
    
    IF @Accion = 1
    BEGIN
		UPDATE TipoDocumento SET Nombre = @Nombre, Descripcion = @Descripcion, NumeroDigitos = @NumeroDigitos
		WHERE IdTipoDocumento = @IdTipoDocumento
							
		SET @IdGenerado = 1
    END
    IF @Accion = 2
    BEGIN
		UPDATE TipoDocumento SET Estado = 'INACTIVO'
		WHERE IdTipoDocumento = @IdTipoDocumento
		
		SET @IdGenerado = 1
    END
    IF @Accion = 3
    BEGIN
		UPDATE TipoDocumento SET Estado = 'ACTIVO'
		WHERE IdTipoDocumento = @IdTipoDocumento
		
		SET @IdGenerado = 1
    END
    IF @Accion = 4
    BEGIN
		SELECT IdTipoDocumento, Nombre, Descripcion, NumeroDigitos, Estado 
		FROM TipoDocumento
		WHERE IdTipoDocumento = @IdTipoDocumento
		ORDER BY Nombre
	END
    IF @Accion = 5
    BEGIN
		SELECT IdTipoDocumento, Nombre, Descripcion, NumeroDigitos, Estado 
		FROM TipoDocumento
		ORDER BY Nombre
	END
	IF @Accion = 6
	BEGIN
		DECLARE @Query VARCHAR(1000)
		SET @Query = 'SELECT IdTipoDocumento, Nombre, Descripcion, NumeroDigitos, Estado FROM TipoDocumento WHERE IdTipoDocumento > 0'
		
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