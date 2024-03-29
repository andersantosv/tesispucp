USE [CentroSalud]
GO
/****** Object:  StoredProcedure [dbo].[up_ValidarCMP]    Script Date: 09/06/2013 13:08:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
DECLARE @i INT
EXEC @i = up_ValidarCMP 2,'12345',0
PRINT(@i)
*/
ALTER PROCEDURE [dbo].[up_ValidarCMP]
(
	@IdDoctor	INT,
	@CMP		VARCHAR(5),
	@Contador	INT	OUTPUT
)
AS
BEGIN
  IF @IdDoctor = 0
  BEGIN
	SELECT @Contador = COUNT(IdDoctor)
	FROM Doctor
	WHERE CMP = @CMP
  END

  IF @IdDoctor <> 0
  BEGIN
	SELECT @Contador = COUNT(IdDoctor)
	FROM Doctor
	WHERE CMP = @CMP AND NOT (IdDoctor = @IdDoctor)
  END
  
  RETURN @Contador
END