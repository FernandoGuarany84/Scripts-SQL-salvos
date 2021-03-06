USE [RastreadorTeste]
GO

/****** Criada por Fernando Guarany afim de trazer informações relevantes sobre os dados de movimentação
do veiculo. ******/



CREATE procedure [dbo].[Relat_Estatisticas]         

as         
begin  
--criando a tabela temporaria para converter os dados varchar em decimal
CREATE TABLE #Estatisticas(
CODIGO INT NOT NULL,
VEICULO VARCHAR(50),
CODIGOVEICULO INT,
LATITUDE VARCHAR(25),
LONGITUDE VARCHAR(25),
VELOCIDADE DECIMAL,
VELOCIDADEMAXIMA DECIMAL,
DATAHORA DATETIME,
TEMPO_VIAGEM DECIMAL
)

--cinsert na tabela temporaria com os dados convertidos.
INSERT INTO #Estatisticas(CODIGO,
VEICULO,
CODIGOVEICULO,
LATITUDE,
LONGITUDE,
VELOCIDADE,
VELOCIDADEMAXIMA,
DATAHORA,
TEMPO_VIAGEM
)          
select v.codigo,
concat(v.Pessoa, v.descricao) as Carro,
c.codigoveiculo, 
'-'+ dbo.FN_RemoveCaracteresNaoInteiros (c.latitude) as Latitude,
'-'+ dbo.FN_RemoveCaracteresNaoInteiros (c.Longitude) as Longitude,
c.Velocidade, 
dbo.FN_RemoveCaracteresNaoInteiros(convert(decimal, c.velocidade)) as VelocidadeMaxima,
c.DataHora,
dbo.FN_RemoveCaracteresNaoInteiros (convert(decimal, tempoviagem)) AS tempo_viagem

FROM [checkpoint] c with(nolock)
INNER JOIN veiculo v 
ON v.codigo= c.codigoveiculo
AND v.ativo=1
WHERE c.CodigoVeiculo=v.codigo
and convert(decimal, c.velocidade) >= 0
c.

DECLARE @codigo int, @carro varchar(50), @codigoveiculo int, @latitude varchar(25),
        @longitude varchar(25), @velocidade decimal, @velocidademaxima decimal, @datahora date,
		@tempoviagem decimal, @velnominal decimal, 

SELECT @codigo = codigo, @carro = veiculo, @codigoveiculo = codigoveiculo, @latitude = latitude,
	   @longitude = longitude, @velocidade = velocidade, @velocidademaxima = max(velocidade),
	   @datahora = datahora, @tempoviagem = min(@tempoviagem) - max(tempoviagem),
	   CASE 
	   WHEN AVG(@velnominal) > 0 THEN 'Tempo em movimento'
	   WHEN (@velnominal) = 0 THEN 'Tempo Parado'
	   END
FROM #Estatisticas

WHERE codigo = @codigo
AND CODIGOVEICULO = @codigoveiculo
AND DATAHORA = @datahora
GROUP BY @codigo;


DROP TABLE #Estatisticas;
		
END


GO

