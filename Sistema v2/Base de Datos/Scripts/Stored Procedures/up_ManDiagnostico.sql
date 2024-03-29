USE [CentroSalud]
GO
/****** Object:  StoredProcedure [dbo].[up_ManDiagnostico]    Script Date: 09/06/2013 13:01:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[up_ManDiagnostico]
(
	@IdDiagnostico		INT,
	@IdCie10			INT,
	@Descripcion		VARCHAR(4000),
	@Accion				INT, --0:INSERT, 1:UPDATE, 4:SELECT, 5:SELECTALL
	@IdGenerado			INT	OUTPUT
)
AS
BEGIN
  BEGIN TRANSACTION
    IF @Accion = 0
    BEGIN
		INSERT INTO Diagnostico(IdCie10, Descripcion)
		VALUES(@IdCie10, @Descripcion)
		
		SET @IdGenerado = SCOPE_IDENTITY()
    END
    
    IF @Accion = 1
    BEGIN
		UPDATE Diagnostico 
		SET IdCie10 = @IdCie10, Descripcion = @Descripcion
		WHERE IdDiagnostico = @IdDiagnostico
							
		SET @IdGenerado = 1
    END
    
    IF @Accion = 4
    BEGIN
		SELECT IdDiagnostico, IdCie10, Descripcion
		FROM Diagnostico
		WHERE IdDiagnostico = @IdDiagnostico
	END
	
    IF @Accion = 5
    BEGIN
		SELECT IdDiagnostico, IdCie10, Descripcion
		FROM Diagnostico
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