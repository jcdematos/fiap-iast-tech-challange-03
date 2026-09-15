# IAST FIAP - Tech Challenge 3

# Contexto do Problema
A alfabetização infantil é um indicador crucial para o desenvolvimento educacional e social do país, para a tomada de decisões estratégicas os gestores públicos necessitam de inteligência analítica baseada em Ciência de Dados para antecipar riscos e identificar regiões vulneráveis a fim de apoiar decisões estratégicas em um país tão diverso e com grande extensão geográfica como o Brasil.

## Objetivo analítico
O desafio endereçado aqui nesse projeto é construir um pipeline de Machine Learning (utilizando um modelos supervisionados) para prever se cada município **atingirá** ou **não atingirá** sua meta anual de alfabetização.

A referência utilizada será o Indicador Criança Alfabetizada, foi definido o ponto de corte de 743 pontos na escala de proficiência do Saeb, nível a partir do qual uma criança pode
ser considerada alfabetizada.

Cada município possui metas anuais até o ano de 2030, metas que começaram em 2024 e irão até 2030. A avaliação já registra o desempenho real de cada município desde 2023 e anualmente é atualizada.

A meta nacional é que, até 2030, todas as crianças brasileiras estejam alfabetizadas ao final do 2o ano do ensino fundamental.

Nosso objetivo analítico desse projeto é construir um modelo que faz a previsão do **ano seguinte** utilizando dados passados de meta e desempenho real de cada município.

## Descrição da base utilizada
* Foi utilizada nossa base Gold, modelada e transformada a partir dos dados do INEP de 2023, 2023 e 2025: https://basedosdados.org/dataset/073a39d4-89cf-4068-b1e8-34ed0d9c0b72?table=e1de7a6a-5038-4e81-89f0-a15f2cc12c9b que possuem dados por município (meta anual, taxa real de alfabetização, se atingiu ou não sua meta).
* Dados demográficos do IBGE (Censo 2022) (população por etnia, raça e sexo): https://basedosdados.org/dataset/08a1546e-251f-4546-9fe0-b1e6ab2b203d?table=707fd42e-95e0-4856-922f-fcbb55db913a e https://basedosdados.org/dataset/08a1546e-251f-4546-9fe0-b1e6ab2b203d?table=cf9537b5-6198-455f-a8b0-7c762e94d79c
* Dados econômicos do IBGE de geração de renda por município (PIB 2023): https://basedosdados.org/dataset/fcf025ca-8b19-4131-8e2d-5ddb12492347?table=fbbbe77e-d234-4113-8af5-98724a956943
* Dados socioeconômicos do IPEA 2010 com a renda média per capita por município: https://www.ipeadata.gov.br/Default.aspx (Renda per capita média de 2010 (seção social - tema renda - renda geral))
* Dados de desenvolvimento humano e qualidade de vida IDHM 2010: https://basedosdados.org/dataset/cbfc7253-089b-44e2-8825-755e1419efc8?table=ec5fb3d1-fa98-4ab3-8a02-4b9950048a83

## Etapas de modelagem



## Escolha do algoritmo


## Métricas de avaliação



## Estrutura do Repositório

```sh

📁 fiap-iast-tech-challange-03
│
├── 📁 data
├── 📁 notebooks
├── 📁 src
│ ├── preprocessing
│ ├── modeling
│ ├── evaluation
│ └── visualization
│
├── 📁 reports
├── 📁 images
├── requirements.txt
├── README.md
└── .gitignore
```

## Interpretação dos resultados
#### Análise Exploratória e Entendimento do Problema
- _Comportamento dos dados_: Pudemos observar a partir do EDA realizado que os dados trabalhados durante as explorações possuem pouquíssimas correlações lineares, e aquelas que foram encontradas apresentam índices baixos nas visões construídas utilizando matriz de correlação (matplotlib) e diagramas de dispersão (pairplot).   
  
* _Identificação de padrões, avaliação de distribuições e Detecção de correlações_: As correlações encontradas foram: 
  * Correlação positiva média entre PIB e Renda média per capita por município
  * Correlação linear positiva entre Total de Avaliados do Estado e Total Alfabetizados (quanto maior o número de avaliados maior o número total de alfabetizados)
  * Procuramos correlações entre taxa de alfabetização e dados de gênero, etnia e raça por municipio, assim como densidade demográfica, renda, pib, idhm porém não encontramos nada muito expressivo.

* _Hipóteses analíticas pré execução da modelagem_:
  * Supomos que alimentar o modelo com dados de vínculo com estado e município pode ajudar no treinamento do modelo já que percebemos que existem estados que possuem desempenho acima da média (CE, por exemplo), e estados que nem têm meta definida (DF não tem meta definida em 2024 e 2025 - em 2023 não se apresenta).
  * Supomos que, devido a pouca disponibilidade de dados, o modelo terá dificuldade para generalizar e atingir bons números de previsão. Até porque os números de renda, pib, idhm são possuem coleta anuais, ou seja, estão desatualizados com relação as taxas de alfabetização e metas, o que dificulta a utilização pra projeções

#### Modelagem supervisionada
* _Análise de variáveis relevantes_: Foram utilizadas as seguintes features X para chegar na predição y = status_meta:

  ```sh
     'lag_1', - Features de série temporal
    'diff_1', - Features de série temporal
    'rolling_mean_2',
    'total_avaliados',
    'media_alfa_uf',
    'sigla_uf',
    'idhm',
    'renda_media_per_capita_R$',
    'pib_per_capita_R$',
    'densidade_demografica'
`

OBS.: Desvio meta, meta ano e taxa de alfabetização real não foram utilizadas porque percebemos durante o processo que essas variáveis causavam data leakage, em que o modelo usava o futuro para treinar o passado.

## Insights encontrados
* Quais fatores mais impactam a alfabetização?
  * Utilizamos o SHAP para ajudar na explicabilidade do nosso modelo, e conforme hipótese levantada no EDA, os Estados tiveram grande influência na predição do atingimento da meta, mas as features de série temporal foram mais determinantes:
 <img width="790" height="940" alt="image" src="https://github.com/user-attachments/assets/73f8670b-5a42-4f95-bdbb-278600173d13" />

 Ou seja, o tempo é um fator relevante para determinar se o município atingirá ou não sua meta e sua localização também.
 
• Quais municípios apresentam maior risco educacional?
• Quais regiões possuem padrões semelhantes?
• Como prever municípios que podem não atingir metas futuras?
• Quais variáveis possuem maior influência nos modelos?


## Limitações do projeto


## Aplicação prática para políticas públicas


## Possíveis evoluções futuras

