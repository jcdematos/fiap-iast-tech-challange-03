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
* Foi utilizada nossa base Gold, modelada e transformada a partir dos dados do INEP de 2023, 2024 e 2025: https://basedosdados.org/dataset/073a39d4-89cf-4068-b1e8-34ed0d9c0b72?table=e1de7a6a-5038-4e81-89f0-a15f2cc12c9b que possuem dados por município (meta anual, taxa real de alfabetização, se atingiu ou não sua meta).
* Dados demográficos do IBGE (Censo 2022) (população por etnia, raça e sexo): https://basedosdados.org/dataset/08a1546e-251f-4546-9fe0-b1e6ab2b203d?table=707fd42e-95e0-4856-922f-fcbb55db913a e https://basedosdados.org/dataset/08a1546e-251f-4546-9fe0-b1e6ab2b203d?table=cf9537b5-6198-455f-a8b0-7c762e94d79c
* Dados econômicos do IBGE de geração de renda por município (PIB 2023): https://basedosdados.org/dataset/fcf025ca-8b19-4131-8e2d-5ddb12492347?table=fbbbe77e-d234-4113-8af5-98724a956943
* Dados socioeconômicos do IPEA 2010 com a renda média per capita por município: https://www.ipeadata.gov.br/Default.aspx (Renda per capita média de 2010 (seção social - tema renda - renda geral))
* Dados de desenvolvimento humano e qualidade de vida IDHM 2010: https://basedosdados.org/dataset/cbfc7253-089b-44e2-8825-755e1419efc8?table=ec5fb3d1-fa98-4ab3-8a02-4b9950048a83

## Etapas de modelagem
<img width="1024" height="436" alt="WhatsApp Image 2026-09-15 at 20 22 12" src="https://github.com/user-attachments/assets/502dd333-cecc-4d6d-b09b-29454b9497b6" />

Notebook 1: Fizemos a estratégia de backtesting no pipeline: *Modelo_Classificação_Regressao_Logistica_Fase3_Previsão 2025.ipynb*, para verificar a qualidade das estimativas - *Recomendamos começar por aqui!*

Notebook 2: A predição de 2026 encontra-se no *Modelo_Classificação_Regressao_Logistica_Fase3_Previsão 2026.ipynb* e será validada quando os dados estiverem disponíveis em 2027 (esse readme está sendo escrito em 15/09/2026). *Atenção: O script só rodará a partir das métricas de avaliação com os dados de 2026 disponíveis para teste.*

Notebook 3: Como as métricas de acurácia e f1 não está da maneira que gostaríamos por conta da base ser pequena (treino 2024 e teste 2025), apenas 69% de acurácia e números ainda menores em F1 Macro. Nosso modelo está acertando muito melhor “Atingiu a Meta” do que “Abaixo da Meta”. Para tentar outras possibildiade, fizemos um notebook com o treinamento de outros modelos para comparar a precisão, e os resultados não foram tão satisfatórios assim:
```sh
 Modelo  Accuracy  Precision Macro  Recall Macro  F1 Macro
  Gradient Boosting  0.705574         0.601546      0.578230  0.582570
           Ensemble  0.710251         0.603612      0.573809  0.577453
      Random Forest  0.710812         0.603693      0.572887  0.576323
Regressão Logística  0.683128         0.581280      0.571781  0.574624
```

Optamos por manter Regressão Logística porque as diferenças foram muito pequenas, acreditamos que a deficiência está mesmo na quantidade de informações que temos disponíveis para treino e teste já que tentamos estratégias de regularização (C), ajustes de mais hiperparâmetros, e conseguimos melhorias na casa 1% apenas.

## Escolha do algoritmo
Nossa variável resposta é categórica (status meta). Essa variável possui 3 categorias: "Sem Meta Definida", "Atingiu a Meta" e "Abaixo da Meta".

Portanto, nosso algoritmo será de *classificação*, dentro de *aprendizado supervisionado*.

Usamos _regressão logística_ porque pensamos na possibilidade de usar probabilidade (qual a probabilidade de que esse município atinja a meta em 2026, 2027, 2028, 2029 e 2030?), de forma que a explicabilidade fosse mais facilitada para a posterior utilização pelos gestores públicos. Como nosso dataset é pequeno, e com pouca dimensionalidade, optamos pro um modelo que utiliza poucos recursos computacionais.

## Métricas de avaliação

As métricas utilizadas são as de classificação para modelos supervisionados:
* Acurácia Geral: Percentual total de acertos do modelo considerando todas as classes (quantas previsões corretas ele fez sobre o total).
* Precisão: Das vezes em que o modelo previu uma classe positiva, o quanto ele realmente acertou (evita falsos alvos).
* Recall (Revocação): De todos os casos verdadeiramente positivos que existiam, o quanto o modelo conseguiu capturar (evita deixar passar casos reais).
* F1-Score: Média harmônica entre Precisão e Recall; serve para avaliar o equilíbrio entre ambos, especialmente útil em cenários com dados desbalanceados.

 Além disso, utilizamos Learning Curves para identificar se o modelo estava sofrendo de underfitting ou overfitting.

## Estrutura do Repositório

```sh

📁 fiap-iast-tech-challange-03
│
├── 📁 data
├── 📁 notebooks
├── 📁 reports
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

OBS.: Desvio meta, meta ano e taxa de alfabetização real não foram utilizadas porque percebemos durante o processo que essas variáveis causavam data leakage, em que o modelo usava o futuro para treinar o passado.

## Insights encontrados
* Quais fatores mais impactam a alfabetização?
  * Utilizamos o SHAP para ajudar na explicabilidade do nosso modelo, e conforme hipótese levantada no EDA, os Estados tiveram grande influência na predição do atingimento da meta.
 <img width="790" height="540" alt="image" src="https://github.com/user-attachments/assets/5e9021b8-2950-4179-8831-892d78547346" />

 Ou seja, o tempo é um fator relevante para determinar se o município atingirá ou não sua meta e sua localização também.
 
* Quais municípios apresentam maior risco educacional?
A maioria dos municípios que apresentam maior risco pertencem ao Top 5 Estados com médias mais baixas
<img width="239" height="208" alt="image" src="https://github.com/user-attachments/assets/7f8ffb23-dafe-4a50-9b7f-b47044878218" />
  
* Quais regiões possuem padrões semelhantes?
    Munícipios que estão no Estado do CE possuem taxas de alfabetização mais altas em média:
  <img width="1446" height="525" alt="newplot" src="https://github.com/user-attachments/assets/b8f8b37d-9a0b-41dc-a8fb-f55adc1818c1" />
    PR, GO e ES possuem médias bem parecidas.
  
* Como prever municípios que podem não atingir metas futuras?
No resultado do modelo gerado, extrair municípios que tiverem a predição "ABAIXO DA META" como variável y.


## Limitações do projeto
* Temos poucos anos disponíveis para treinar o modelo (apenas 2024 e 2025 porque 2023 não havia meta definida, ou seja, os dados era nulos e sem serventia para o modelo), supomos que com o passar dos anos até 2030, vamos ter mais precisão por possuirmos um histórico maior.
* Há poucas correlações entre as features de alfabetização, dados sociodemográficos, socioeconômicos e de qualidade e vida.
* Os dados de renda, PIB, densidade demográfica, IDHM não possuem a mesma frequência de atualização anual dos dados de alfabetização. O último CENSO foi em 2022, os dados de renda e IDHM são de 2010, por exemplo, isso dificulta as predições.

## Aplicação prática para políticas públicas
A partir das projeções anuais do modelo, os gestores públicos podem fazer um trabalho antecipado junto com as secretárias dos Municipios e Estado, a fim de viabilizar recursos e meios para que as metas sejam atingidas.

## Possíveis evoluções futuras
Existe muito espaço para evolução do modelo feito, como por exemplo a utilização da feature de taxa real de alfabetização como variável alvo em modelos de regressão baseados em árvores já que eles capturam relações não lineares, interações complexas entre variáveis e padrões empilhados sem precisar de proporcionalidade direta. Podemos também melhorar o feature engineering para acrescentar mais dados associados a dados sociodemográficos e do Censo Escolar, para melhorar a generalização do modelo.

