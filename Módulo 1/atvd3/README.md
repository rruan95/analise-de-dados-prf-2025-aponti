# Projeto PRF 2025 — Análise em SQL

## Objetivo
Analisar a base de acidentes da PRF em SQL (SQLite), criando views e indicadores de letalidade a partir da flag `acidente_fatal` (1 quando `mortos >= 1`).

## Arquivos
- `atvd_analise_dados_ruan_gualberto.sql`: script com a criação das views e as consultas de análise.
- `resultados.xlsx`: resultados exportados das consultas.

## Etapas do script
1. Verificação da versão do SQLite e da estrutura da tabela importada.
2. Criação da view base `vw_acidentes_base` com a flag `acidente_fatal`.
3. Métricas gerais de letalidade (total de acidentes, fatais e % de letalidade).
4. Agregações por UF, BR (rodovia) e evolução temporal (ano/mês).
5. Análises bivariadas: tipo de acidente, causa, fase do dia, condição meteorológica e tipo de pista x letalidade, incluindo uma combinação tipo de pista + fase do dia.
6. Indicador de lift (razão entre a taxa de letalidade de um tipo de acidente e a média geral da base).
7. Views agregadas de indicadores mensais e por UF/BR.

## Observação metodológica
Todas as taxas de letalidade são calculadas como `SUM(acidente_fatal) / COUNT(*)`, com filtro de volume mínimo (`HAVING COUNT(*) >= 100`) para evitar distorções em grupos pequenos.
