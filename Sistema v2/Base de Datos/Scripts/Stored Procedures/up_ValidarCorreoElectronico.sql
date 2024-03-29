USE [CentroSalud]
GO
/****** Object:  StoredProcedure [dbo].[up_ValidarCorreoElectronico]    Script Date: 09/06/2013 13:09:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
DECLARE @i INT
EXEC @i = up_ValidarCorreoElectronico 1,'wilder_young@hotmail.com',0
PRINT(@i)
*/
ALTER PROCEDURE [dbo].[up_ValidarCorreoElectronico]
(
	@IdPersona				INT,
	@CorreoElectronico		VARCHAR(100),
	@Contador				INT	OUTPUT
)
AS
BEGIN
  IF @IdPersona = 0
  BEGIN
	SELECT @Contador = COUNT(IdPersona)
	FROM Persona
	WHERE CorreoElectronico = @CorreoElectronico
  END

  IF @IdPersona <> 0
  BEGIN
	SELECT @Contador = COUNT(IdPersona)
	FROM Persona
	WHERE CorreoElectronico = @CorreoElectronico AND NOT (IdPersona = @IdPersona)
  END
  
  RETURN @Contador
END