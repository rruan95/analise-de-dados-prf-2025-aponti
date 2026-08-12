-- PROJETO: Data Analytics com Dados Abertos da PRF — Acidentes 2025
-- Ruan Gualberto


-- 1) Verificar a versão do SQLite (garante compatibilidade de funções)

SELECT sqlite_version() AS versao_sqlite;



-- 2) Exibir a estrutura (colunas e tipos) da tabela importada

PRAGMA table_info(acidentes_prf_2025);



-- 3) Contar o número total de registros/ocorrências da base

SELECT COUNT(*) AS total_ocorrencias
FROM acidentes_prf_2025;



-- 4) Excluir a view base se ela já existir (evita erro de duplicidade)

DROP VIEW IF EXISTS vw_acidentes_base;



-- 5) Criar a view base com a flag acidente_fatal (1 se mortos >= 1)

CREATE VIEW vw_acidentes_base AS
SELECT
    *,
    CASE
        WHEN CAST(mortos AS INTEGER) >= 1 THEN 1
        ELSE 0
    END AS acidente_fatal
FROM acidentes_prf_2025;



-- 6) Métricas gerais: total de acidentes, total de fatais, % letalidade

SELECT
    COUNT(*) AS total_acidentes,
    SUM(acidente_fatal) AS acidentes_fatais,
    ROUND(100.0 * SUM(acidente_fatal) / COUNT(*), 2) AS perc_fatais
FROM vw_acidentes_base;



-- 7) Agregação por UF (Estado) 


SELECT
    uf,
    COUNT(*) AS total_acidentes,
    SUM(acidente_fatal) AS acidentes_fatais,
    SUM(CAST(mortos AS INTEGER)) AS total_mortos,
    ROUND(100.0 * SUM(acidente_fatal) / COUNT(*), 2) AS perc_fatais
FROM vw_acidentes_base
GROUP BY uf
HAVING COUNT(*) >= 100
ORDER BY perc_fatais DESC;



-- 8) Ranking das 30 rodovias (BR) mais letais em número absoluto de mortos


SELECT
    br,
    COUNT(*) AS total_acidentes,
    SUM(CAST(mortos AS INTEGER)) AS total_mortos,
    SUM(acidente_fatal) AS acidentes_fatais,
    ROUND(100.0 * SUM(acidente_fatal) / COUNT(*), 2) AS perc_fatais
FROM vw_acidentes_base
WHERE br IS NOT NULL AND br <> ''
GROUP BY br
HAVING COUNT(*) >= 100
ORDER BY total_mortos DESC
LIMIT 30;



-- 9) Evolução temporal por Ano e Mês 

SELECT
    CAST(strftime('%Y', data_inversa) AS INTEGER) AS ano,
    CAST(strftime('%m', data_inversa) AS INTEGER) AS mes,
    COUNT(*) AS total_acidentes,
    SUM(CAST(mortos AS INTEGER)) AS total_mortos,
    SUM(acidente_fatal) AS acidentes_fatais,
    ROUND(100.0 * SUM(acidente_fatal) / COUNT(*), 2) AS perc_fatais
FROM vw_acidentes_base
GROUP BY ano, mes
ORDER BY ano, mes;



-- 10) BIVARIADA — Tipo de Acidente x % de ocorrências fatais


SELECT
    tipo_acidente,
    COUNT(*) AS total_acidentes,
    SUM(acidente_fatal) AS acidentes_fatais,
    ROUND(100.0 * SUM(acidente_fatal) / COUNT(*), 2) AS perc_fatais
FROM vw_acidentes_base
GROUP BY tipo_acidente
HAVING COUNT(*) >= 100
ORDER BY perc_fatais DESC;



-- 11) BIVARIADA — 30 Principais Causas de Acidente por taxa de letalidade

SELECT
    causa_acidente,
    COUNT(*) AS total_acidentes,
    SUM(acidente_fatal) AS acidentes_fatais,
    ROUND(100.0 * SUM(acidente_fatal) / COUNT(*), 2) AS perc_fatais
FROM vw_acidentes_base
GROUP BY causa_acidente
HAVING COUNT(*) >= 100
ORDER BY perc_fatais DESC
LIMIT 30;



-- 12) BIVARIADA — Gravidade por Fase do Dia

SELECT
    fase_dia,
    COUNT(*) AS total_acidentes,
    SUM(acidente_fatal) AS acidentes_fatais,
    ROUND(100.0 * SUM(acidente_fatal) / COUNT(*), 2) AS perc_fatais
FROM vw_acidentes_base
GROUP BY fase_dia
HAVING COUNT(*) >= 100
ORDER BY perc_fatais DESC;



-- 13) BIVARIADA — Influência da Condição Meteorológica no % de fatais


SELECT
    condicao_metereologica AS condicao_meteorologica,
    COUNT(*) AS total_acidentes,
    SUM(acidente_fatal) AS acidentes_fatais,
    ROUND(100.0 * SUM(acidente_fatal) / COUNT(*), 2) AS perc_fatais
FROM vw_acidentes_base
GROUP BY condicao_metereologica
HAVING COUNT(*) >= 100
ORDER BY perc_fatais DESC;



-- 14) BIVARIADA — Letalidade por Tipo de Pista 


SELECT
    tipo_pista,
    COUNT(*) AS total_acidentes,
    SUM(acidente_fatal) AS acidentes_fatais,
    ROUND(100.0 * SUM(acidente_fatal) / COUNT(*), 2) AS perc_fatais
FROM vw_acidentes_base
GROUP BY tipo_pista
HAVING COUNT(*) >= 100
ORDER BY perc_fatais DESC;



-- 15) BIVARIADA COMBINADA — Tipo de Pista + Fase do Dia

SELECT
    tipo_pista,
    fase_dia,
    COUNT(*) AS total_acidentes,
    SUM(acidente_fatal) AS acidentes_fatais,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS cobertura_perc,
    ROUND(100.0 * SUM(acidente_fatal) / COUNT(*), 2) AS perc_fatais
FROM vw_acidentes_base
GROUP BY tipo_pista, fase_dia
HAVING COUNT(*) >= 100
ORDER BY perc_fatais DESC;



-- 16) TAXa — razão entre a taxa de letalidade do tipo de acidente e a  média geral da base. Lift > 1 = risco acima da média geral.

WITH taxa_global AS (
    SELECT 1.0 * SUM(acidente_fatal) / COUNT(*) AS taxa
    FROM vw_acidentes_base
)
SELECT
    tipo_acidente,
    COUNT(*) AS total_acidentes,
    SUM(acidente_fatal) AS acidentes_fatais,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS cobertura_perc,
    ROUND(1.0 * SUM(acidente_fatal) / COUNT(*), 4) AS confianca,
    ROUND((1.0 * SUM(acidente_fatal) / COUNT(*)) / taxa, 2) AS lift
FROM vw_acidentes_base
CROSS JOIN taxa_global
GROUP BY tipo_acidente, taxa
HAVING COUNT(*) >= 100
ORDER BY lift DESC;



-- 17) VIEW AGREGADA — Indicadores mensais 

DROP VIEW IF EXISTS vw_indicadores_mensais;

CREATE VIEW vw_indicadores_mensais AS
SELECT
    CAST(strftime('%Y', data_inversa) AS INTEGER) AS ano,
    CAST(strftime('%m', data_inversa) AS INTEGER) AS mes,
    COUNT(*) AS total_acidentes,
    SUM(CAST(mortos AS INTEGER)) AS total_mortos,
    SUM(acidente_fatal) AS acidentes_fatais,
    ROUND(100.0 * SUM(acidente_fatal) / COUNT(*), 2) AS perc_fatais
FROM vw_acidentes_base
GROUP BY ano, mes;

-- Consulta de conferência da view
SELECT * FROM vw_indicadores_mensais ORDER BY ano, mes;



-- 18) VIEW AGREGADA — Indicadores por UF e BR 
DROP VIEW IF EXISTS vw_indicadores_uf_br;

CREATE VIEW vw_indicadores_uf_br AS
SELECT
    uf,
    br,
    COUNT(*) AS total_acidentes,
    SUM(CAST(mortos AS INTEGER)) AS total_mortos,
    SUM(acidente_fatal) AS acidentes_fatais,
    ROUND(100.0 * SUM(acidente_fatal) / COUNT(*), 2) AS perc_fatais
FROM vw_acidentes_base
WHERE br IS NOT NULL AND br <> ''
GROUP BY uf, br;



SELECT * FROM vw_indicadores_uf_br ORDER BY total_mortos DESC;