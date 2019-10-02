--USE [RastreadorTeste]
--GO

/****** Criada por Fernando Guarany afim de trazer informações relevantes sobre os dados de movimentação
do veiculo. ******/

alter procedure [dbo].[Relat_Estatisticas]         
@DataIni datetime = null,        
@DataFin datetime = null,        
@Veiculo int = null
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

--cinsert na tabela temporaria com os dados convertidos.
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
WHERE c.CodigoVeiculo=@Veiculo AND c.DataHora>=ISNULL(@DataIni,DATEADD(day, -1, getdate())) AND c.DataHora<=ISNULL(@DataFin, getdate())        
AND convert(decimal, c.velocidade) >= 0;

DECLARE @codigo int, @carro varchar(50), @codigoveiculo int, @latitude varchar(25),
        @longitude varchar(25), @velocidade decimal, @velocidademaxima decimal, @datahora date,
		@tempoviagem decimal, @vel_nominal decimal 

SELECT @codigo = codigo, @carro = veiculo, @codigoveiculo = codigoveiculo, @latitude = latitude,
	   @longitude = longitude, @velocidade = velocidade, @velocidademaxima = max(velocidade),
	   @datahora = datahora, @tempoviagem = min(@tempoviagem) - max(TEMPO_VIAGEM), @vel_nominal = velocidade
FROM #Estatisticas
GROUP BY @codigo; --!!ERR!! Each GROUP BY expression must contain at least one column that is not an outer reference.

DROP TABLE #Estatisticas;
		
END

GO

Exec [Relat_Estatisticas] '2019/09/30 00:00:00', '2019/09/30 23:59:00',  3281
