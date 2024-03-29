USE [CentroSalud]
GO
/****** Object:  StoredProcedure [dbo].[up_ManPaciente]    Script Date: 09/18/2013 16:04:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[up_ManPaciente]
(
	@IdPaciente					BIGINT,
	@Paterno					VARCHAR(30),
	@Materno					VARCHAR(30),
	@Nombres					VARCHAR(30),
	@Sexo						VARCHAR(9),
	@FechaNacimiento			DATETIME,
	@IdTipoDocumento			INT,
	@NumeroDocumento			VARCHAR(50),
	@EstadoCivil				VARCHAR(10),
	@Pais						VARCHAR(40),
	@DepartamentoNacimiento		VARCHAR(40),
	@ProvinciaNacimiento		VARCHAR(40),
	@DistritoNacimiento			VARCHAR(40),
	@DepartamentoDomicilio		VARCHAR(40),
	@ProvinciaDomicilio			VARCHAR(40),
	@DistritoDomicilio			VARCHAR(40),
	@Direccion					VARCHAR(100),
	@Telefono					VARCHAR(12),
	@Celular					VARCHAR(12),
	@CorreoElectronico			VARCHAR(100),
	@TipoPersona				VARCHAR(8),
	@IdOcupacion				INT,
	@IdEtnia					INT,
	@IdIdioma					INT,
	@IdReligion					INT,
	@GrupoSanguineo				VARCHAR(2),
	@FactorSanguineo			VARCHAR(3),
	@NumeroHistoriaClinica		VARCHAR(10),
	@IdEmpleado					INT,
	@IdEpisodio					INT,
	@IdModoIngreso				INT,
	@Accion						INT, --0:INSERT, 1:UPDATE, 4:SELECT, 5:SELECTALL, 6:SELECT CUSTOM
	@IdGenerado					INT OUTPUT
)
AS
BEGIN
  DECLARE @item AS VARCHAR(10)
  DECLARE @IdEspecialidad AS INT
  
  BEGIN TRANSACTION
	IF @Accion = 0
    BEGIN
		DECLARE @IdLugarNacimiento INT, @IdDomicilio INT, @IdHorario INT, @Output INT
		-- INSERTAMOS EN LA TABLA 'LugarNacimiento'
		INSERT INTO LugarNacimiento (Pais, Departamento, Provincia, Distrito)
		VALUES (@Pais, @DepartamentoNacimiento, @ProvinciaNacimiento, @DistritoNacimiento)
		
		SET @IdLugarNacimiento = SCOPE_IDENTITY()
		
		-- INSERTAMOS EN LA TABLA 'Domicilio'
		INSERT INTO Domicilio (Departamento, Provincia, Distrito, Direccion)
		VALUES (@DepartamentoDomicilio, @ProvinciaDomicilio, @DistritoDomicilio, @Direccion)
		
		SET @IdDomicilio = SCOPE_IDENTITY()
		
		-- INSERTAMOS EN LA TABLA 'Persona'
		INSERT INTO Persona (Paterno, Materno, Nombres, Sexo, FechaNacimiento,
							 NumeroDocumento, EstadoCivil, IdLugarNacimiento, IdDomicilio, Telefono,
							 Celular, CorreoElectronico, FechaRegistro, TipoPersona)
		VALUES (@Paterno, @Materno, @Nombres, @Sexo, @FechaNacimiento, @NumeroDocumento,
				@EstadoCivil, @IdLugarNacimiento, @IdDomicilio, @Telefono, @Celular, @CorreoElectronico,
				GETDATE(), @TipoPersona)
		
		SET @IdPaciente = SCOPE_IDENTITY()
		
		IF (@IdTipoDocumento <> 0)
		BEGIN
			UPDATE Persona 
			SET IdTipoDocumento = @IdTipoDocumento 
			WHERE IdPersona = @IdPaciente
		END
									   
		-- INSERTAMOS EN LA TABLA 'Paciente'
		INSERT INTO Paciente (IdPaciente, GrupoSanguineo, FactorSanguineo)
		VALUES (@IdPaciente, @GrupoSanguineo, @FactorSanguineo)
		
		IF @IdOcupacion <> 0
		BEGIN
			UPDATE Paciente 
			SET IdOcupacion = @IdOcupacion
			WHERE IdPaciente = @IdPaciente
		END
		
		IF @IdEtnia <> 0
		BEGIN
			UPDATE Paciente 
			SET IdEtnia = @IdEtnia
			WHERE IdPaciente = @IdPaciente
		END
		
		IF @IdIdioma <> 0
		BEGIN
			UPDATE Paciente 
			SET IdIdioma = @IdIdioma
			WHERE IdPaciente = @IdPaciente
		END
		
		IF @IdReligion <> 0
		BEGIN
			UPDATE Paciente 
			SET IdReligion = @IdReligion
			WHERE IdPaciente = @IdPaciente
		END
		
		-- INSERTAMOS EN LA TABAL 'Antecedentes'
		DECLARE @IdAntecedentes INT

		INSERT INTO Antecedentes (Otros) VALUES ('')
		
		SET @IdAntecedentes = SCOPE_IDENTITY()
		
		-- INSERTAMOS EN LA TABLA 'HistoriaClinica'
		IF @NumeroHistoriaClinica <> ''
		BEGIN
		  INSERT INTO HistoriaClinica (Numero, IdPaciente, IdAntecedentes, FechaRegistro, IdUsuarioCreacion)
		  VALUES (@NumeroHistoriaClinica, @IdPaciente, @IdAntecedentes, GETDATE(), @IdEmpleado)
		END
		ELSE
		BEGIN
		  INSERT INTO HistoriaClinica (Numero, IdPaciente, IdAntecedentes, FechaRegistro, IdUsuarioCreacion)
		  VALUES (@NumeroHistoriaClinica, @IdPaciente, @IdAntecedentes, GETDATE(), @IdEmpleado)	
		END
		
		SET @IdGenerado = @IdPaciente
    END
    
    IF @Accion = 1
    BEGIN
		SELECT @IdLugarNacimiento = IdLugarNacimiento, @IdDomicilio = IdDomicilio
		FROM Persona
		WHERE IdPersona = @IdPaciente
		
		-- MODIFICAMOS LA TABLA 'LugarNacimiento'
		UPDATE LugarNacimiento SET Pais = @Pais, Departamento = @DepartamentoNacimiento, 
								   Provincia = @ProvinciaNacimiento, Distrito = @DistritoNacimiento
		WHERE IdLugarNacimiento = @IdLugarNacimiento
								   
		-- MODIFICAMOS LA TABLA 'Domicilio'
		UPDATE Domicilio SET Departamento = @DepartamentoDomicilio, Provincia = @ProvinciaDomicilio, 
							Distrito = @DistritoDomicilio, Direccion = @Direccion
		WHERE IdDomicilio = @IdDomicilio
		
		-- MODIFICAMOS LA TABLA 'Persona'
		UPDATE Persona SET Paterno = @Paterno, Materno = @Materno, Nombres = @Nombres, Sexo = @Sexo, 
						   FechaNacimiento = @FechaNacimiento,
						   NumeroDocumento = @NumeroDocumento, EstadoCivil = @EstadoCivil, 
						   IdLugarNacimiento = @IdLugarNacimiento, IdDomicilio = @IdDomicilio, 
						   Telefono = @Telefono, Celular = @Celular, 
						   CorreoElectronico = @CorreoElectronico, TipoPersona = @TipoPersona
		WHERE IdPersona = @IdPaciente
		
		-- MODIFICAMOS LA TABLA 'Paciente'
		UPDATE Paciente
		SET GrupoSanguineo = @GrupoSanguineo, FactorSanguineo = @FactorSanguineo
		WHERE IdPaciente = @IdPaciente
		
		-- MODIFICAMOS LA TABLA 'HistoriaClinica'
		UPDATE HistoriaClinica
		SET Numero = @NumeroHistoriaClinica
		WHERE IdPaciente = @IdPaciente
		
		IF @IdOcupacion <> 0
		BEGIN
			UPDATE Paciente 
			SET IdOcupacion = @IdOcupacion
			WHERE IdPaciente = @IdPaciente
		END
		ELSE
		BEGIN
			UPDATE Paciente 
			SET IdOcupacion = NULL
			WHERE IdPaciente = @IdPaciente
		END
		
		IF @IdEtnia <> 0
		BEGIN
			UPDATE Paciente 
			SET IdEtnia = @IdEtnia
			WHERE IdPaciente = @IdPaciente
		END
		ELSE
		BEGIN
			UPDATE Paciente 
			SET IdEtnia = NULL
			WHERE IdPaciente = @IdPaciente
		END
		
		IF @IdIdioma <> 0
		BEGIN
			UPDATE Paciente 
			SET IdIdioma = @IdIdioma
			WHERE IdPaciente = @IdPaciente
		END
		ELSE
		BEGIN
			UPDATE Paciente 
			SET IdIdioma = NULL
			WHERE IdPaciente = @IdPaciente
		END
		
		IF @IdReligion <> 0
		BEGIN
			UPDATE Paciente 
			SET IdReligion = @IdReligion
			WHERE IdPaciente = @IdPaciente
		END
		ELSE
		BEGIN
			UPDATE Paciente 
			SET IdReligion = NULL
			WHERE IdPaciente = @IdPaciente
		END
		
		IF @IdEpisodio <> 0
		BEGIN
			IF @IdModoIngreso <> 0
			BEGIN
				UPDATE Episodio
				SET IdModoIngreso = @IdModoIngreso
				WHERE IdEpisodio = @IdEpisodio
			END
			ELSE
			BEGIN
				UPDATE Episodio
				SET IdModoIngreso = NULL
				WHERE IdEpisodio = @IdEpisodio
			END
		END
		
		SET @IdGenerado = 1
    END
    
    IF @Accion = 4
    BEGIN
		SELECT P.IdPersona, P.Paterno, P.Materno, P.Nombres, P.Sexo, P.FechaNacimiento, dbo.fn_Edad(P.FechaNacimiento, GETDATE()) AS 'Edad', 
			   ISNULL(P.IdTipoDocumento, 0) AS 'IdTipoDocumento',
			   ISNULL((SELECT Nombre FROM TipoDocumento WHERE P.IdTipoDocumento = IdTipoDocumento), '') AS 'TipoDocumento',
			   P.NumeroDocumento, P.EstadoCivil, P.IdLugarNacimiento,
			   ISNULL((SELECT Pais FROM LugarNacimiento WHERE P.IdLugarNacimiento = IdLugarNacimiento), '') AS 'Pais',
			   ISNULL((SELECT Departamento FROM LugarNacimiento WHERE P.IdLugarNacimiento = IdLugarNacimiento), '') AS 'Departamento',
			   ISNULL((SELECT Provincia FROM LugarNacimiento WHERE P.IdLugarNacimiento = IdLugarNacimiento), '') AS 'Provincia',
			   ISNULL((SELECT Distrito FROM LugarNacimiento WHERE P.IdLugarNacimiento = IdLugarNacimiento), '') AS 'Distrito',
			   ISNULL(P.IdDomicilio, 0) AS 'IdDomicilio',
			   ISNULL((SELECT Departamento FROM Domicilio WHERE P.IdDomicilio = IdDomicilio), '') AS 'DepartamentoDomicilio',
			   ISNULL((SELECT Provincia FROM Domicilio WHERE P.IdDomicilio = IdDomicilio), '') AS 'ProvinciaDomicilio',
			   ISNULL((SELECT Distrito FROM Domicilio WHERE P.IdDomicilio = IdDomicilio), '') AS 'DistritoDomicilio',
			   ISNULL((SELECT Direccion FROM Domicilio WHERE P.IdDomicilio = IdDomicilio), '') AS 'Direccion',
			   P.Telefono, P.Celular, P.CorreoElectronico,
			   ISNULL((SELECT IdEtnia FROM Paciente WHERE P.IdPersona = IdPaciente), 0) AS 'IdEtnia',
			   ISNULL((SELECT IdReligion FROM Paciente WHERE P.IdPersona = IdPaciente), 0) AS 'IdReligion',
			   ISNULL((SELECT IdOcupacion FROM Paciente WHERE P.IdPersona = IdPaciente), 0) AS 'IdOcupacion',
			   ISNULL((SELECT IdIdioma FROM Paciente WHERE P.IdPersona = IdPaciente), 0) AS 'IdIdioma',
			   ISNULL((SELECT GrupoSanguineo FROM Paciente WHERE P.IdPersona = IdPaciente), '') AS 'GrupoSanguineo',
			   ISNULL((SELECT FactorSanguineo FROM Paciente WHERE P.IdPersona = IdPaciente), '') AS 'FactorSanguineo',
			   ISNULL((SELECT IdHistoriaClinica FROM HistoriaClinica WHERE P.IdPersona = IdPaciente), 0) AS 'IdHistoriaClinica',
			   ISNULL((SELECT Numero FROM HistoriaClinica WHERE P.IdPersona = IdPaciente), 0) AS 'NumeroHistoriaClinica',
			   ISNULL((SELECT IdAntecedentes FROM HistoriaClinica WHERE P.IdPersona = IdPaciente), 0) AS 'IdAntecedentes'
		FROM Persona P 
		WHERE P.IdPersona = @IdPaciente
		ORDER BY P.Paterno, P.Materno, P.Nombres
    END
    
    IF @Accion = 5
    BEGIN
		SELECT P.IdPersona, P.Paterno, P.Materno, P.Nombres, P.Sexo, P.FechaNacimiento, dbo.fn_Edad(P.FechaNacimiento, GETDATE()) AS 'Edad', 
			   ISNULL(P.IdTipoDocumento, 0) AS 'IdTipoDocumento',
			   ISNULL((SELECT Nombre FROM TipoDocumento WHERE P.IdTipoDocumento = IdTipoDocumento), '') AS 'TipoDocumento',
			   P.NumeroDocumento, P.EstadoCivil, P.IdLugarNacimiento,
			   ISNULL((SELECT Pais FROM LugarNacimiento WHERE P.IdLugarNacimiento = IdLugarNacimiento), '') AS 'Pais',
			   ISNULL((SELECT Departamento FROM LugarNacimiento WHERE P.IdLugarNacimiento = IdLugarNacimiento), '') AS 'Departamento',
			   ISNULL((SELECT Provincia FROM LugarNacimiento WHERE P.IdLugarNacimiento = IdLugarNacimiento), '') AS 'Provincia',
			   ISNULL((SELECT Distrito FROM LugarNacimiento WHERE P.IdLugarNacimiento = IdLugarNacimiento), '') AS 'Distrito',
			   ISNULL(P.IdDomicilio, 0) AS 'IdDomicilio',
			   ISNULL((SELECT Departamento FROM Domicilio WHERE P.IdDomicilio = IdDomicilio), '') AS 'DepartamentoDomicilio',
			   ISNULL((SELECT Provincia FROM Domicilio WHERE P.IdDomicilio = IdDomicilio), '') AS 'ProvinciaDomicilio',
			   ISNULL((SELECT Distrito FROM Domicilio WHERE P.IdDomicilio = IdDomicilio), '') AS 'DistritoDomicilio',
			   ISNULL((SELECT Direccion FROM Domicilio WHERE P.IdDomicilio = IdDomicilio), '') AS 'Direccion',
			   P.Telefono, P.Celular, P.CorreoElectronico,
			   ISNULL((SELECT IdEtnia FROM Paciente WHERE P.IdPersona = IdPaciente), 0) AS 'IdEtnia',
			   ISNULL((SELECT IdReligion FROM Paciente WHERE P.IdPersona = IdPaciente), 0) AS 'IdReligion',
			   ISNULL((SELECT IdOcupacion FROM Paciente WHERE P.IdPersona = IdPaciente), 0) AS 'IdOcupacion',
			   ISNULL((SELECT IdIdioma FROM Paciente WHERE P.IdPersona = IdPaciente), 0) AS 'IdIdioma',
			   ISNULL((SELECT GrupoSanguineo FROM Paciente WHERE P.IdPersona = IdPaciente), '') AS 'GrupoSanguineo',
			   ISNULL((SELECT FactorSanguineo FROM Paciente WHERE P.IdPersona = IdPaciente), '') AS 'FactorSanguineo',
			   ISNULL((SELECT IdHistoriaClinica FROM HistoriaClinica WHERE P.IdPersona = IdPaciente), 0) AS 'IdHistoriaClinica',
			   ISNULL((SELECT Numero FROM HistoriaClinica WHERE P.IdPersona = IdPaciente), 0) AS 'NumeroHistoriaClinica',
			   ISNULL((SELECT IdAntecedentes FROM HistoriaClinica WHERE P.IdPersona = IdPaciente), 0) AS 'IdAntecedentes'
		FROM Persona P
		WHERE P.TipoPersona = 'PACIENTE'
		ORDER BY P.Paterno, P.Materno, P.Nombres
    END
    
    IF @Accion = 6
	BEGIN
		DECLARE @Query VARCHAR(MAX)
		SET @Query = 'SELECT P.IdPersona, P.Paterno, P.Materno, P.Nombres, P.Sexo, P.FechaNacimiento, dbo.fn_Edad(P.FechaNacimiento, GETDATE()) AS ''Edad'', 
							 ISNULL(P.IdTipoDocumento, 0) AS ''IdTipoDocumento'',
						     ISNULL((SELECT Nombre FROM TipoDocumento WHERE P.IdTipoDocumento = IdTipoDocumento), '''') AS ''TipoDocumento'',
						     P.NumeroDocumento, P.EstadoCivil, P.IdLugarNacimiento,
						     ISNULL((SELECT Pais FROM LugarNacimiento WHERE P.IdLugarNacimiento = IdLugarNacimiento), '''') AS ''Pais'',
						     ISNULL((SELECT Departamento FROM LugarNacimiento WHERE P.IdLugarNacimiento = IdLugarNacimiento), '''') AS ''Departamento'',
						     ISNULL((SELECT Provincia FROM LugarNacimiento WHERE P.IdLugarNacimiento = IdLugarNacimiento), '''') AS ''Provincia'',
						     ISNULL((SELECT Distrito FROM LugarNacimiento WHERE P.IdLugarNacimiento = IdLugarNacimiento), '''') AS ''Distrito'',
						     ISNULL(P.IdDomicilio, 0) AS ''IdDomicilio'',
						     ISNULL((SELECT Departamento FROM Domicilio WHERE P.IdDomicilio = IdDomicilio), '''') AS ''DepartamentoDomicilio'',
						     ISNULL((SELECT Provincia FROM Domicilio WHERE P.IdDomicilio = IdDomicilio), '''') AS ''ProvinciaDomicilio'',
						     ISNULL((SELECT Distrito FROM Domicilio WHERE P.IdDomicilio = IdDomicilio), '''') AS ''DistritoDomicilio'',
						     ISNULL((SELECT Direccion FROM Domicilio WHERE P.IdDomicilio = IdDomicilio), '''') AS ''Direccion'',
						     P.Telefono, P.Celular, P.CorreoElectronico,
						     ISNULL((SELECT IdEtnia FROM Paciente WHERE P.IdPersona = IdPaciente), 0) AS ''IdEtnia'',
						     ISNULL((SELECT IdReligion FROM Paciente WHERE P.IdPersona = IdPaciente), 0) AS ''IdReligion'',
						     ISNULL((SELECT IdOcupacion FROM Paciente WHERE P.IdPersona = IdPaciente), 0) AS ''IdOcupacion'',
						     ISNULL((SELECT IdIdioma FROM Paciente WHERE P.IdPersona = IdPaciente), 0) AS ''IdIdioma'',
						     ISNULL((SELECT GrupoSanguineo FROM Paciente WHERE P.IdPersona = IdPaciente), '''') AS ''GrupoSanguineo'',
						     ISNULL((SELECT FactorSanguineo FROM Paciente WHERE P.IdPersona = IdPaciente), '''') AS ''FactorSanguineo'',
						     ISNULL((SELECT IdHistoriaClinica FROM HistoriaClinica WHERE P.IdPersona = IdPaciente), 0) AS ''IdHistoriaClinica'',
						     ISNULL((SELECT Numero FROM HistoriaClinica WHERE P.IdPersona = IdPaciente), 0) AS ''NumeroHistoriaClinica'',
							 ISNULL((SELECT IdAntecedentes FROM HistoriaClinica WHERE P.IdPersona = IdPaciente), 0) AS ''IdAntecedentes''
					  FROM Persona P
					  WHERE P.TipoPersona = ''PACIENTE'''
						    
		IF @Paterno <> ''
		BEGIN
			SET @Query = @Query + ' AND (SOUNDEX(P.Paterno) = SOUNDEX(''' + @Paterno + ''') OR P.Paterno LIKE ''%' + @Paterno + '%'')'
		END
		
		IF @Materno <> ''
		BEGIN
			SET @Query = @Query + ' AND (SOUNDEX(P.Materno) = SOUNDEX(''' + @Materno + ''') OR P.Materno LIKE ''%' + @Materno + '%'')'
		END
		
		IF @Nombres <> ''
		BEGIN
			SET @Query = @Query + ' AND P.Nombres LIKE ''%' + @Nombres + '%'''
		END
		
		IF @NumeroHistoriaClinica <> ''
		BEGIN
			SET @Query = @Query + ' AND H.Numero = ''' + @NumeroHistoriaClinica + ''''
		END
		
		IF @IdTipoDocumento <> 0
		BEGIN
			SET @Query = @Query + ' AND P.IdTipoDocumento = ' + CONVERT(VARCHAR(2), @IdTipoDocumento) + ''
		END
		
		IF @NumeroDocumento <> ''
		BEGIN
			SET @Query = @Query + ' AND P.NumeroDocumento = ''' + @NumeroDocumento + ''''
		END
		
		IF @IdPaciente <> 0
		BEGIN
			SET @Query = @Query + ' AND P.IdPersona = ' + CONVERT(VARCHAR(2), @IdPaciente) + ''
		END
		
		SET @Query = @Query + ' ORDER BY P.Paterno, P.Materno, P.Nombres'	
						
		EXEC(@Query)
	END
  IF @@ERROR <> 0
  BEGIN
    ROLLBACK TRANSACTION
    
	SET @IdGenerado = 0
	
	RETURN @IdGenerado
  END
  
  COMMIT TRANSACTION
  
  RETURN @IdGenerado
END