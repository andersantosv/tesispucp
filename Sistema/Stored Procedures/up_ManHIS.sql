CREATE PROCEDURE [dbo].[up_ManHIS] (

@fechaRegistro				DATETIME,
@numeroHC					INT,
@codDistritoProcedencia		VARCHAR(18),
@edad						INT,
@sexo						CHAR(1),
@id_Cie10					INT,
@tipoDiagnostico			CHAR(1),
@establecimiento			CHAR(1),
@servicio					CHAR(1),
@accion						INT --0: Insertar
)
AS

BEGIN
  BEGIN TRANSACTION
    IF @accion = 0
    BEGIN
		INSERT INTO FormularioHIS (Fecha, NumeroHC, CodDistritoProcedencia, Edad,Sexo,Id_Cie10,TipoDiagnostico,Establecimiento,Servicio)
		VALUES (@fechaRegistro, @numeroHC, @codDistritoProcedencia, @edad, @sexo, @id_Cie10, @tipoDiagnostico, @establecimiento, @servicio)				
    END
    
  IF @@ERROR <> 0
  BEGIN
    ROLLBACK TRANSACTION
	RETURN
  END
  COMMIT TRANSACTION
END