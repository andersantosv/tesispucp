USE [CentroSalud]
GO
/****** Object:  StoredProcedure [dbo].[up_ManEmpleado]    Script Date: 09/06/2013 13:02:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[up_ManEmpleado]
(
	@IdEmpleado		INT,
	@Foto			VARCHAR(2000),
	@Usuario		VARCHAR(20),
	@Contrasena		VARCHAR(20),
	@TipoEmpleado	VARCHAR(14),
	@IdArea			INT,
	@IdPerfil		INT,
	@Estado			VARCHAR(8),
	@Accion			INT --0: INSERT, 1:UPDATE, 2:DELETE
)
AS
BEGIN
  BEGIN TRANSACTION
    IF @Accion = 0
    BEGIN
		INSERT INTO Empleado (IdEmpleado, Foto, Usuario, Contrasena, TipoEmpleado, IdArea, IdPerfil, Estado)
		VALUES (@IdEmpleado, @Foto, @Usuario, @Contrasena, @TipoEmpleado, @IdArea, @IdPerfil,'ACTIVO')
		
	END
    
    IF @Accion = 1
    BEGIN
		UPDATE Empleado SET Foto = @Foto, Usuario = @Usuario, Contrasena = @Contrasena, 
						    TipoEmpleado = @TipoEmpleado, IdArea =@IdArea, IdPerfil = @IdPerfil
		WHERE IdEmpleado = @IdEmpleado
		
	END
	
	IF @Accion = 2
	BEGIN
		UPDATE Empleado SET Estado = 'ACTIVO'
		WHERE IdEmpleado = @IdEmpleado
	END
	
	IF @Accion = 3
	BEGIN
		UPDATE Empleado SET Estado = 'INACTIVO'
		WHERE IdEmpleado = @IdEmpleado
	END
  IF @@ERROR <> 0
  BEGIN
    ROLLBACK TRANSACTION
	RETURN
  END
  
  COMMIT TRANSACTION
END