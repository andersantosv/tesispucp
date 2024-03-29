CREATE PROCEDURE [dbo].[up_ManPersonal] (
@idPersona		INT,
@usuario		VARCHAR(20),
@contrasena		VARCHAR(20),
@tipoPersonal	VARCHAR(14),
@idPerfil		INT,
@estado			VARCHAR(8),
@accion			INT --0: Insertar, 1: Modificar, 2: Eliminar, 3: Recuperar
)
AS

BEGIN
  BEGIN TRANSACTION
    IF @accion = 0
    BEGIN
		INSERT INTO Personal (Id_Personal, Usuario, Contrasena, TipoPersonal,Id_Perfil,Estado)
		VALUES (@idPersona, @usuario, @contrasena, @tipoPersonal,@idPerfil,@estado)
	END
    
    IF @accion = 1
    BEGIN
		UPDATE Personal
		--SET Usuario = @usuario, Contrasena = @contrasena, Id_Perfil = @idPerfil
		SET Id_Perfil = @idPerfil
		WHERE Id_Personal = @idPersona
    END
    
    IF @accion = 2
    BEGIN
		--UPDATE Personal SET Estado = @estado
		--WHERE Id_Personal = 'INACTIVO'
		UPDATE Personal
		SET Estado = 'INACTIVO'
		WHERE Id_Personal = @idPersona
    END
    
    IF @accion = 3
    BEGIN
		--UPDATE Personal SET Estado = @estado
		--WHERE Id_Personal = 'ACTIVO'
		UPDATE Personal
		SET Estado = 'ACTIVO'
		WHERE Id_Personal = @idPersona
    END
    
  IF @@ERROR <> 0
  BEGIN
    ROLLBACK TRANSACTION
	RETURN
  END
  COMMIT TRANSACTION
END