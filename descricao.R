# Setando ambiente --------------------------------------------------------

options(scipen=999)
gc()
set.seed(1)

# Pacotes -----------------------------------------------------------------

library(readr)
library(readxl)
library(xlsx)
library(tidyverse)

# Bases --------------------------------------------------------------
plano_de_contas <- read_excel("bases/plano_de_contas.xlsx")
contas <- read_excel("bases/visao_competencia_2024_05.xlsx")


# Analise -----------------------------------------------------------------
contas$cod_flux_op <- substr(contas$`Categoria 1`, 1, 7) 
base <- merge(plano_de_contas,contas, by = "cod_flux_op", all = T)
analise <- subset(base, !is.na(tipo_2))
analise <- analise %>%
	group_by(fluxo_op, tipo_1,tipo_2) %>%
	summarise(valor = sum(`Valor (R$)`, na.rm = T))
analise <- subset(analise, valor < 0)

write.csv2(analise, 'analise_maio.csv')
