USE [CentroSalud]
GO
/****** Object:  StoredProcedure [dbo].[up_SelPais]    Script Date: 07/09/2011 14:08:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[up_SelPais]
AS
BEGIN
    SELECT Id_Pais, Nombre
    FROM Pais
END