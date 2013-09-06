USE [CentroSalud]
GO
/****** Object:  StoredProcedure [dbo].[up_SelCie10]    Script Date: 09/06/2013 13:07:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--exec up_SelCie10
ALTER PROCEDURE [dbo].[up_SelCie10]
AS
BEGIN
  --DECLARE @Query VARCHAR(500) 
  
  --SET @Query = 'SELECT Descripcion + ''|'' + Codigo + ''|'' + CONVERT(VARCHAR(5), IdCie10)  AS ''Descripcion''
		--		FROM Cie10
		--		ORDER BY Descripcion'
	
  --EXEC(@Query)
  
  SELECT IdCie10, Codigo, Descripcion
  FROM Cie10
  ORDER BY Descripcion
END