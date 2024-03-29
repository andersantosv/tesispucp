USE [CentroSalud]
GO
/****** Object:  StoredProcedure [dbo].[up_SelColumnas]    Script Date: 09/06/2013 13:07:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
EXEC up_SelColumnas 'Area',0,'','','01-01-2012','','12-01-2012','TODAS',6
*/
ALTER PROCEDURE [dbo].[up_SelColumnas]
(
	@NombreTabla		VARCHAR(100),
	@IdEmpleado			INT,
	@NombreEmpleado		VARCHAR(100),
	@IndFechaInicio		CHAR(1),
	@FechaInicio		DATETIME,
	@IndFechaFin		CHAR(1),
	@FechaFin			DATETIME,
	@Tipo				VARCHAR(6), --INSERT, UPDATE, DELETE
	@Accion				INT --5:SELECTALL, 6:SELECT CUSTOM
)
AS
BEGIN
  IF @Accion = 5 
  BEGIN
	SELECT A.IdAuditoria, A.Tabla, A.Columna, A.AntiguoValor, A.NuevoValor, A.IdUsuario, P.Paterno + ' ' + P.Materno +  ' ' + P.Nombres AS 'Empleado', A.Fecha, A.Tipo
	FROM Auditoria A, Persona P
	WHERE P.IdPersona = A.IdUsuario AND Tabla = @NombreTabla
  END
  IF @Accion = 6
  BEGIN
	DECLARE @Query VARCHAR(4000)
	SET @Query = 'SELECT A.IdAuditoria, A.Tabla, A.Columna, A.AntiguoValor, A.NuevoValor, A.IdUsuario, P.Paterno + '' '' + P.Materno +  '' '' + P.Nombres AS ''Empleado'', A.Fecha, A.Tipo FROM Auditoria A, Persona P WHERE P.IdPersona = A.IdUsuario AND A.Tabla = ''' + @NombreTabla + ''''
	
	IF @NombreEmpleado <> ''
	BEGIN
		SET @Query = @Query + ' AND (P.Paterno LIKE ''%' + @NombreEmpleado + '%'' OR P.Materno LIKE ''%' + @NombreEmpleado + '%'' OR P.Nombres LIKE ''%' + @NombreEmpleado + '%'')'
	END
	
	IF @IndFechaInicio = 'X'
	BEGIN
		SET @Query = @Query + ' AND A.Fecha > ''' + CONVERT(VARCHAR(50), @FechaInicio) + ''''
	END
	
	IF @IndFechaFin = 'X'
	BEGIN
		SET @Query = @Query + ' AND A.Fecha < ''' + CONVERT(VARCHAR(50), @FechaFin) + ''''
	END
	
	IF @Tipo <> 'TODAS'
	BEGIN
		SET @Query = @Query + ' AND A.Tipo = ''' + SUBSTRING(@Tipo,1,1) + ''''
	END

	SET @Query = @Query + ' ORDER BY A.Fecha'	
					
	EXEC(@Query)
  END
END