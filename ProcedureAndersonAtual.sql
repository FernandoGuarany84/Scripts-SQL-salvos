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
TEMPO_VIAGEM DECIMAL,
VEL_NOMINAL DECIMAL
)

--insert na tabela temporaria com os dados convertidos.
INSERT INTO #Estatisticas(CODIGO,
VEICULO,
CODIGOVEICULO,
LATITUDE,
LONGITUDE,
VELOCIDADE,
VELOCIDADEMAXIMA,
DATAHORA,
TEMPO_VIAGEM,
VEL_NOMINAL
)          
select top 50 v.codigo,
concat(v.Pessoa, v.descricao) as Carro,
c.codigoveiculo, 
'-'+ dbo.FN_RemoveCaracteresNaoInteiros (c.latitude) as Latitude,
'-'+ dbo.FN_RemoveCaracteresNaoInteiros (c.Longitude) as Longitude,
c.Velocidade, 
dbo.FN_RemoveCaracteresNaoInteiros(convert(decimal, c.velocidade)) as VelocidadeMaxima,
c.DataHora,
dbo.FN_RemoveCaracteresNaoInteiros (convert(decimal, c.tempoviagem)) AS tempo_viagem,
dbo.FN_RemoveCaracteresNaoInteiros (convert(decimal, c.velocidade)) AS vel_nominal
FROM [checkpoint] c with(nolock)
INNER JOIN veiculo v 
ON v.codigo= c.codigoveiculo
AND v.ativo=1
WHERE c.CodigoVeiculo=v.codigo
--and convert(decimal, c.velocidade) >= 0


DECLARE @codigo int, @carro varchar(50), @codigoveiculo int, @latitude varchar(25),
        @longitude varchar(25), @velocidade decimal, @velocidademaxima decimal, @datahora date,
		@tempoviagem decimal, @vel_nominal decimal 

SELECT @codigo = codigo, @carro = veiculo, @codigoveiculo = codigoveiculo, @latitude = latitude,
	   @longitude = longitude, @velocidade = velocidade, @velocidademaxima = max(velocidade),
	   @datahora = datahora, @tempoviagem = min(tempo_viagem) - max(tempo_viagem), @vel_nominal = velocidade
FROM #Estatisticas

WHERE codigo = @codigo
AND CODIGOVEICULO = @codigoveiculo
AND DATAHORA = @datahora
GROUP BY @codigo, codigo;


DROP TABLE #Estatisticas;
		
END


GO

