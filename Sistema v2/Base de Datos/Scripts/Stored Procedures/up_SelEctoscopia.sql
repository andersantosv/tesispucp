USE [CentroSalud]
GO
/****** Object:  StoredProcedure [dbo].[up_SelEctoscopia]    Script Date: 09/20/2013 16:22:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[up_SelEctoscopia]
(
	@IdHistoriaClinica		INT
)
AS
BEGIN
  SELECT IdEpisodio, FechaRegistro, ISNULL(Ectoscopia, '') As 'Ectoscopia'
  FROM Episodio
  WHERE IdHistoriaClinica = @IdHistoriaClinica
  ORDER BY FechaRegistro DESC
END