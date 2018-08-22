# Scripts-SQL-salvos
--Script para buscar o nome de alguma tabela
USE [NomeBanco]
GO

/****** Object:  StoredProcedure [dbo].[JP_CADE]    Script Date: 22/08/2018 09:23:28 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[JP_CADE] @TEXTO VARCHAR(100)=NULL AS
	IF SUBSTRING(@TEXTO,1,1) <> '%'
		SELECT @TEXTO = '%'+@TEXTO
	IF SUBSTRING(@TEXTO,DATALENGTH(@TEXTO),1) <> '%'
		SELECT @TEXTO = @TEXTO+'%'
	SELECT * FROM SYSOBJECTS WHERE NAME LIKE @TEXTO AND TYPE = 'U'

GO

