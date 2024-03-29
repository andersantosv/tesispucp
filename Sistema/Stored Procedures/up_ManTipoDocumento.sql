CREATE PROCEDURE [dbo].[up_ManTipoDocumento] (
@idTipoDocumento		INT,
@nombre					VARCHAR(40),
@descripcion			VARCHAR(40),
@numerodigitos			VARCHAR(40),
@estado					VARCHAR(40),
@accion					INT, --0: Insertar, 1: Modificar
@idGenerado				INT		OUTPUT
)
AS

BEGIN
  BEGIN TRANSACTION
    IF @accion = 0
    BEGIN
		INSERT INTO TipoDocumento (Nombre, Descripcion, NumeroDigitos, Estado)
		VALUES (@nombre, @descripcion, @numerodigitos, 'ACTIVO')
		
		SET @idGenerado = SCOPE_IDENTITY()
		
		RETURN @idGenerado
	END
    
    IF @accion = 1
    BEGIN
		UPDATE TipoDocumento
		SET Nombre = @nombre, Descripcion = @descripcion, NumeroDigitos = @numerodigitos, Estado = @estado
		WHERE Id_TipoDocumento = @idTipoDocumento
		
		SET @idGenerado = 0
		
		RETURn @idGenerado	
	END
    
  IF @@ERROR <> 0
  BEGIN
    ROLLBACK TRANSACTION
	RETURN
  END
  COMMIT TRANSACTION
END