USE [CentroSalud]
GO
/****** Object:  StoredProcedure [dbo].[up_ManPerfil]    Script Date: 07/09/2011 14:06:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[up_ManPerfil] (
@idPerfil			INT,
@nombre				VARCHAR(30),
@tipoPersonal		VARCHAR(15),
@xmlVentanas		TEXT,
@accion				INT --0: Insertar, 1: Modificar, 2: Eliminar, 3: Recuperar
)
AS

BEGIN
  BEGIN TRANSACTION
  --  IF @accion = 0
  --  BEGIN
		--INSERT INTO Especialidad (Nombre, Descripcion, Estado)
		--VALUES (@nombre, @descripcion, 'ACTIVO')
  --  END
    
  --  IF @accion = 1
  --  BEGIN
		--UPDATE Especialidad
		--SET Nombre = @nombre, Descripcion = @descripcion
		--WHERE Id_Especialidad = @idEspecialidad
  --  END
    
  --  IF @accion = 2
  --  BEGIN
		--UPDATE Especialidad
		--SET Estado = 'INACTIVO'
		--WHERE Id_Especialidad = @idEspecialidad
  --  END
    
  --  IF @accion = 3
  --  BEGIN
		--UPDATE Especialidad
		--SET Estado = 'ACTIVO'
		--WHERE Id_Especialidad = @idEspecialidad
  --  END
    
  IF @@ERROR <> 0
  BEGIN
    ROLLBACK TRANSACTION
	RETURN
  END
  COMMIT TRANSACTION
END