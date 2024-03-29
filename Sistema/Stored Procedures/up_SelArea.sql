CREATE PROCEDURE [dbo].[up_SelArea] (
@idArea			INT,
@nombre			VARCHAR(30),
@tipoArea		VARCHAR(14),
@estado			VARCHAR(8),
@accion			INT --4: Seleccionar 1, 5: Seleccionar Todos, 6: Seleccionar por Criterios
)
AS
BEGIN
    IF @accion = 4
    BEGIN
		SELECT Id_Area, Nombre, Descripcion, TipoArea, Estado 
		FROM Area
		WHERE Id_Area = @idArea
	END
    
    IF @accion = 5
    BEGIN
		SELECT Id_Area, Nombre, Descripcion, TipoArea, Estado 
		FROM Area
	END
    
    IF @accion = 6
    BEGIN
		DECLARE @query VARCHAR(1000)
		SET @query = 'SELECT Id_Area, Nombre, Descripcion, TipoArea, Estado FROM Area WHERE Id_Area > 0 '
		
		IF @nombre <> ''
		BEGIN
			SET @query = @query + 'AND Nombre LIKE ''%' + @nombre + '%'''
		END
		
		IF @tipoArea <> 'TODOS'
		BEGIN
			SET @query = @query + 'AND TipoArea = ''' + @tipoArea + ''''
		END
		
		IF @estado <> 'TODOS'
		BEGIN
			SET @query = @query + 'AND Estado = ''' + @estado + ''''
		END	
		
		SET @query = @query + 'ORDER BY TipoArea'	
								
		EXEC(@query)
	END
END