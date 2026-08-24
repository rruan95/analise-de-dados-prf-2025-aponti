# Aponti - Módulo 1: Análise de Dados PRF

## Sobre

Repositório com as atividades do Módulo 1 do curso de Análise de Dados da Aponti, usando a base pública de acidentes de trânsito da Polícia Rodoviária Federal (PRF) referente a 2025.

O objetivo é praticar todo o ciclo de análise de dados, da exploração inicial em planilhas até o tratamento em Python seguindo o CRISP-DM, passando por consultas SQL e a montagem de indicadores. O foco é entender os fatores associados aos acidentes, com destaque para gravidade e letalidade, e preparar bases limpas para EDA, Power BI e modelagem de árvore de decisão.

## Estrutura do projeto

- **atvd1/**: prévia inicial dos dados (`Dados PRF - Prévia.xlsx`)
- **atvd2/**: análise exploratória no Google Sheets
- **atvd3/**: análise em SQL, com views e indicadores de acidentes fatais
- **atvd4/**: preparação de dados (CRISP-DM) em Python e Jupyter, gerando as bases `base_analitica_prf_2025.csv` (EDA e Power BI) e `base_modelavel_prf_2025.csv` (modelagem, sem data leakage)
