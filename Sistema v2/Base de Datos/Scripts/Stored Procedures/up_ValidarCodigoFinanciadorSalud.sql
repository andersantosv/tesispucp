USE [CentroSalud]
GO
/****** Object:  StoredProcedure [dbo].[up_ValidarCodigoFinanciadorSalud]    Script Date: 09/06/2013 13:09:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[up_ValidarCodigoFinanciadorSalud]
(
	@IdFinanciadorSalud			INT,
	@CodigoFinanciadorSalud		VARCHAR(5),
	@Contador					INT	OUTPUT
)
AS
BEGIN
  IF @IdFinanciadorSalud = 0
  BEGIN
	SELECT @Contador = COUNT(IdFinanciadorSalud)
	FROM FinanciadorSalud
	WHERE Codigo = @CodigoFinanciadorSalud
  END

  IF @IdFinanciadorSalud <> 0
  BEGIN
	SELECT @Contador = COUNT(IdFinanciadorSalud)
	FROM FinanciadorSalud
	WHERE Codigo = @CodigoFinanciadorSalud AND NOT (IdFinanciadorSalud = @IdFinanciadorSalud)
  END
  
  RETURN @Contador
END