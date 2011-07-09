USE [CentroSalud]
GO
/****** Object:  StoredProcedure [dbo].[up_SelVentanas]    Script Date: 07/09/2011 14:09:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[up_SelVentanas] (
@idPerfil		INT
)
AS
BEGIN
	SELECT V.Nombre
	FROM VentanasxPerfil X, Ventana V
	WHERE X.Id_Ventana = V.Id_Ventana AND X.Id_Perfil = @idPerfil
END