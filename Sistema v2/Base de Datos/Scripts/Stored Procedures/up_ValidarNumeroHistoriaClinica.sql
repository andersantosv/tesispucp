USE [CentroSalud]
GO
/****** Object:  StoredProcedure [dbo].[up_ValidarNumeroHistoriaClinica]    Script Date: 09/06/2013 13:09:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
DECLARE @contador INT
EXEC @contador = up_ValidarNumeroHistoriaClinica 3,0,0
PRINT(@contador)
*/
ALTER PROCEDURE [dbo].[up_ValidarNumeroHistoriaClinica]
(
	@IdPaciente					INT,
	@NumeroHistoriaClinica		VARCHAR(10),
	@Contador					INT	OUTPUT
)
AS
BEGIN
  IF @IdPaciente = 0
  BEGIN
	SELECT @Contador = COUNT(P.IdPaciente)
	FROM Paciente P, HistoriaClinica H
	WHERE H.IdPaciente = P.IdPaciente AND H.Numero = @NumeroHistoriaClinica
  END

  IF @IdPaciente <> 0
  BEGIN
	SELECT @Contador = COUNT(P.IdPaciente)
	FROM Paciente P, HistoriaClinica H
	WHERE H.IdPaciente = P.IdPaciente AND H.Numero = @NumeroHistoriaClinica AND NOT (P.IdPaciente = @IdPaciente)
  END
  
  RETURN @Contador
END