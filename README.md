# Aponti - Módulo 1: Análise de Dados PRF

## Sobre

Este repositório reúne as atividades do Módulo 1 do curso de Análise de Dados da Aponti, todas construídas em cima da base pública de acidentes de trânsito da Polícia Rodoviária Federal (PRF) referente a 2025.

O objetivo central é percorrer, na prática, todo o ciclo de trabalho de um analista de dados. Isso começa pela exploração inicial da base em planilha, passa por uma análise exploratória mais aprofundada no Google Sheets, avança para consultas SQL com criação de views e indicadores, e termina em um processo estruturado de preparação de dados em Python, seguindo a metodologia CRISP-DM. Ao longo dessas etapas, o foco recai sobre entender quais fatores estão associados à ocorrência e à gravidade dos acidentes, com atenção especial à letalidade, ou seja, aos casos em que houve pelo menos uma morte registrada.

O resultado final desse percurso são bases de dados tratadas e prontas para uso em análise exploratória, em ferramentas de visualização como Power BI e em modelagem preditiva, com o cuidado de separar claramente o que pode ser usado para explicar os dados do que pode ser usado para prever um desfecho sem incorrer em vazamento de informação (data leakage).

## Estrutura do projeto

O repositório está organizado dentro da pasta Módulo 1, dividida em quatro atividades sequenciais.

### Unidade 1
Contém a prévia inicial dos dados, no arquivo `Dados PRF - Prévia.xlsx`. Essa etapa serve como primeiro contato com a base, permitindo reconhecer colunas, tipos de dados e a qualidade geral das informações antes de qualquer tratamento.

### Unidade 2
Reúne a análise exploratória feita no Google Sheets, com o arquivo `atvd_02_excel_prf_ruan_gualberto.xlsx` e o link de acesso à planilha online, disponível em `link do sheets.txt`. Nessa fase são construídas tabelas dinâmicas e gráficos cobrindo distribuição espacial dos acidentes, relação entre causa e gravidade, e fatores de risco ambientais e temporais.

### Unidade 3
Traz a análise em SQL, no arquivo `atvd_analise_dados_ruan_gualberto.sql`, junto com os resultados exportados em `resultados.xlsx`. O script cria a view `vw_acidentes_base`, que adiciona a coluna `acidente_fatal` a partir da contagem de mortos, e a partir dela calcula métricas gerais como total de acidentes, total de acidentes fatais e percentual de letalidade.

### Unidade 4
Reúne a etapa de preparação de dados seguindo o CRISP-DM, feita em Python e Jupyter Notebook, com os notebooks `analise_prf_2025.ipynb` e `modulo4_prf.ipynb`. O objetivo dessa atividade é preparar os dados de acidentes da PRF de 2025 para análise exploratória, uso em Power BI e construção de uma árvore de decisão explicável.

A variável alvo criada é `acidente_fatal`, que recebe valor 1 quando `mortos` é maior ou igual a 1, e 0 caso contrário.

Como saída, essa etapa gera duas bases dentro da pasta `dados_tratados`. A primeira, `base_analitica_prf_2025.csv`, é a base completa, voltada para análise exploratória e Power BI. A segunda, `base_modelavel_prf_2025.csv`, é a base voltada para modelagem, da qual foram removidas as colunas mortos, feridos, total_vitimas, indice_gravidade e outras variáveis derivadas diretamente do desfecho, evitando assim o vazamento de informação no processo de modelagem.
