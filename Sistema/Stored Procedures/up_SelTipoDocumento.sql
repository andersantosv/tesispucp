USE [CentroSalud]
GO
/****** Object:  StoredProcedure [dbo].[up_SelTipoDocumento]    Script Date: 07/09/2011 14:09:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[up_SelTipoDocumento]
AS
BEGIN
    SELECT Id_TipoDocumento, Nombre, Descripcion, NumeroDigitos, Estado
    FROM TipoDocumento
END