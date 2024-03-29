USE [CentroSalud]
GO
/****** Object:  StoredProcedure [dbo].[up_ManPerfil]    Script Date: 09/06/2013 13:05:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[up_ManPerfil]
(
	@IdPerfil			INT,
	@Nombre				VARCHAR(50),
	@TipoEmpleado		VARCHAR(14),
	@Estado				VARCHAR(8),
	@ListaMenus			VARCHAR(2000),
	@Accion				INT,
	@IdGenerado			INT	OUTPUT --0:INSERT, 1:UPDATE, 2:DELETE, 3:RECOVER, 4:SELECT, 5:SELECTALL, 6:SELECT CUSTOM
)
AS
BEGIN
  DECLARE @item AS VARCHAR(50)
  
  BEGIN TRANSACTION
    IF @Accion = 0
    BEGIN
		INSERT INTO Perfil(Nombre, TipoEmpleado, Estado)
		VALUES (@Nombre, @TipoEmpleado, 'ACTIVO')
		
		SET @IdGenerado = SCOPE_IDENTITY()
		
		SET @IdPerfil = @IdGenerado
		
		-- INSERTAMOS EN LA TABLA 'MenusxPerfil'
		DECLARE cur CURSOR FOR
		(
		   SELECT Item FROM fn_Split(@ListaMenus, ',') 
		)

		OPEN cur
		FETCH NEXT FROM cur INTO @item

		WHILE @@FETCH_STATUS = 0 
		BEGIN
			INSERT INTO MenusxPerfil(IdPerfil, Menu)
			VALUES (@IdPerfil, @item)
			
			FETCH NEXT FROM cur INTO @item
		END

		CLOSE cur
		DEALLOCATE cur
    END
    
    IF @Accion = 1
    BEGIN
		UPDATE Perfil SET Nombre = @Nombre, TipoEmpleado = @TipoEmpleado
		WHERE IdPerfil = @IdPerfil
		
		-- ELIMINAMOS LOS MENUS
		DELETE FROM MenusxPerfil WHERE IdPerfil = @IdPerfil
		
		-- INSERTAMOS EN LA TABLA 'MenusxPerfil'
		DECLARE cur CURSOR FOR
		(
		   SELECT Item FROM fn_Split(@ListaMenus, ',') 
		)

		OPEN cur
		FETCH NEXT FROM cur INTO @item

		WHILE @@FETCH_STATUS = 0 
		BEGIN
			INSERT INTO MenusxPerfil(IdPerfil, Menu)
			VALUES (@IdPerfil, @item)
			
			FETCH NEXT FROM cur INTO @item
		END

		CLOSE cur
		DEALLOCATE cur
							
		SET @IdGenerado = 1
    END
    IF @Accion = 2
    BEGIN
		UPDATE Perfil SET Estado = 'INACTIVO'
		WHERE IdPerfil = @IdPerfil
		
		SET @IdGenerado = 1
    END
    IF @Accion = 3
    BEGIN
		UPDATE Perfil SET Estado = 'ACTIVO'
		WHERE IdPerfil = @IdPerfil
		
		SET @IdGenerado = 1
    END
    IF @Accion = 4
    BEGIN
		SELECT IdPerfil, Nombre, TipoEmpleado, Estado 
		FROM Perfil
		WHERE IdPerfil = @IdPerfil
		ORDER BY Nombre, TipoEmpleado
		
		SELECT Menu
		FROM MenusxPerfil
		WHERE IdPerfil = @IdPerfil
		ORDER BY Menu
	END
    IF @Accion = 5
    BEGIN
		SELECT IdPerfil, Nombre, TipoEmpleado, Estado 
		FROM Perfil
		ORDER BY Nombre, TipoEmpleado
	END
	IF @Accion = 6
	BEGIN
		DECLARE @Query VARCHAR(1000)
		SET @Query = 'SELECT IdPerfil, Nombre, TipoEmpleado, Estado FROM Perfil WHERE IdPerfil > 0'
		
		IF @Nombre <> ''
		BEGIN
			SET @Query = @Query + ' AND Nombre LIKE ''%' + @Nombre + '%'''
		END
		
		IF @TipoEmpleado <> 'TODOS'
		BEGIN
			SET @Query = @Query  + ' AND TipoEmpleado = ''' + @TipoEmpleado + ''''
		END
		
		IF @Estado <> 'TODOS'
		BEGIN
			SET @Query = @Query + ' AND Estado = ''' + @Estado + ''''
		END	
		
		SET @Query = @Query + ' ORDER BY Nombre, TipoEmpleado'	
						
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