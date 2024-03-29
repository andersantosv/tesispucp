CREATE PROCEDURE [dbo].[up_ManArea] (
@idArea			INT,
@nombre			VARCHAR(30),
@descripcion	VARCHAR(200),
@tipoArea		VARCHAR(14),
@accion			INT --0: Insertar, 1: Modificar, 2: Eliminar, 3: Recuperar
)
AS

BEGIN
  BEGIN TRANSACTION
    IF @accion = 0
    BEGIN
		INSERT INTO Area (Nombre, Descripcion, TipoArea, Estado)
		VALUES (@nombre, @descripcion, @tipoArea, 'ACTIVO')
		
		DECLARE @id INT
		SELECT @id = SCOPE_IDENTITY()
		
		IF @tipoArea = 'Administrativa'
		BEGIN
		  INSERT INTO AreaAdministrativa (Id_AreaAdministrativa)
		  VALUES (@id)
		END
		ELSE
		BEGIN
		  INSERT INTO AreaMedica (Id_AreaMedica)
		  VALUES (@id)
		END
    END
    
    IF @accion = 1
    BEGIN
		UPDATE Area
		SET Nombre = @nombre, Descripcion = @descripcion, TipoArea = @tipoArea
		WHERE Id_Area = @idArea
    END
    
    IF @accion = 2
    BEGIN
		UPDATE Area
		SET Estado = 'INACTIVO'
		WHERE Id_Area = @idArea
    END
    
    IF @accion = 3
    BEGIN
		UPDATE Area
		SET Estado = 'ACTIVO'
		WHERE Id_Area = @idArea
    END
    
  IF @@ERROR <> 0
  BEGIN
    ROLLBACK TRANSACTION
	RETURN
  END
  COMMIT TRANSACTION
END