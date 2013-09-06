USE [CentroSalud]
GO
/****** Object:  StoredProcedure [dbo].[up_SelProvincia]    Script Date: 09/06/2013 13:08:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[up_SelProvincia]
(
	@CodDepartamento	CHAR(2)
)
AS
BEGIN	
	SELECT IdUbigeo, CodDepartamento, CodProvincia, CodDistrito, Descripcion
	FROM Ubigeo
	WHERE CodDepartamento = @CodDepartamento AND CodProvincia <> '00' AND CodDistrito = '00'
END
