USE [CentroSalud]
GO
/****** Object:  StoredProcedure [dbo].[up_ValidarCambioCuenta]    Script Date: 09/06/2013 13:08:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
DECLARE @exito INT = 0
EXEC @exito = up_ValidarCambioCuenta 5,'wchicana','1234',0
PRINT(@exito)
SELECT * FROM Empleado
*/
ALTER PROCEDURE [dbo].[up_ValidarCambioCuenta]
(
	@IdEmpleado		INT,
	@Usuario		VARCHAR(20),
	@Contrasena		VARCHAR(20),
	@Exito			INT	OUTPUT	--0: ERROR, 1: OK
)
AS
BEGIN
  DECLARE @contadorUsuario INT = 0
  BEGIN TRANSACTION
	SELECT @contadorUsuario = COUNT(IdEmpleado) 
	FROM Empleado
	WHERE Estado = 'ACTIVO' AND Usuario = @Usuario AND NOT(IdEmpleado = @IdEmpleado)
	
	IF @contadorUsuario = 0 
	BEGIN
		UPDATE Empleado
		SET Usuario = @Usuario, Contrasena = @Contrasena
		WHERE Estado = 'ACTIVO' AND IdEmpleado = @IdEmpleado
		
		SET @Exito = 1
	END
	ELSE
	BEGIN
		SET @Exito = 0
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