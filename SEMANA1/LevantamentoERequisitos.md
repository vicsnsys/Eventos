# Sistema de Eventos Acadêmicos

### Semana 1 — Levantamento de Requisitos

![Disciplina](https://img.shields.io/badge/Disciplina-Banco%20de%20Dados-blue?style=for-the-badge)
![Banco](https://img.shields.io/badge/PostgreSQL-Supabase-3ECF8E?style=for-the-badge&logo=postgresql&logoColor=white)
![Cenário](https://img.shields.io/badge/Cenário-4-orange?style=for-the-badge)
![Fase](https://img.shields.io/badge/Fase-Semana%201-purple?style=for-the-badge)

> **Projeto Integrador — Banco de Dados Ponta a Ponta**
> Um único lugar para eventos, inscrições e presença do *Instituto Horizonte de Educação Superior*.

---

## Sumário

1. [Identificação do grupo e cenário](#1--identificação-do-grupo-e-cenário)
2. [Contextualização e descrição do problema](#2--contextualização-e-descrição-do-problema)
3. [Requisitos funcionais](#3--requisitos-funcionais)
4. [Regras de negócio](#4--regras-de-negócio)
5. [Entidades e atributos](#5--lista-preliminar-de-entidades-e-atributos)
6. [Perguntas que o banco deverá responder](#6--perguntas-que-o-banco-deverá-responder)

---

## 1 · Identificação do grupo e cenário

O grupo escolheu o **Cenário 4 — Sistema de Eventos Acadêmicos**.

| Campo | Informação |
|---|---|
| **Disciplina** | Banco de Dados |
| **Professor** | Gustavo Prado |
| **Projeto** | Projeto Integrador — Banco de Dados Ponta a Ponta |
| **Cenário** | Cenário 4 — Sistema de Eventos Acadêmicos |
| **Integrantes** | Felipe Nogueira, Alfredo Vicente, Lorrane Yamada, Victor Hugo, Gabriel Soares |
| **Tecnologias** | PostgreSQL no Supabase; DrawDB ou BRModelo para o DER |

---

## 2 · Contextualização e descrição do problema

O banco de dados centralizará **eventos, inscrições e presença** da organização fictícia **Instituto Horizonte de Educação Superior**.

O instituto promove congressos, seminários e semanas acadêmicas ao longo do ano. Cada evento reúne atividades, como palestras, minicursos e mesas-redondas, conduzidas por um ou mais palestrantes.

### Situação atual

Hoje, cada coordenação controla inscrições em **planilhas** e presença em **listas de papel**. Isso gera os seguintes problemas:

| Problema | Descrição |
|---|---|
| **Dados duplicados e inconsistentes** | O mesmo participante aparece com informações diferentes em cada planilha. |
| **Controle frágil de presença** | É difícil confirmar se quem assinou a lista estava inscrito no evento. |
| **Relatórios lentos** | Calcular frequência e contar participantes exige conferência manual. |
| **Superlotação** | O aluno acha que estar inscrito no evento dá direito de entrar em qualquer sala. |

### Solução proposta

O sistema deverá registrar esses dados em um só lugar, aplicar as regras de inscrição e presença e responder às perguntas da coordenação por **consultas SQL**.

**Informações a armazenar:**

- Dados de participantes e palestrantes
- Eventos, atividades, suas datas e locais
- Inscrições e suas situações
- Presença em cada atividade

---

## 3 · Requisitos funcionais

Os oito requisitos abaixo definem **o que o sistema deverá permitir fazer**.

| Código | Requisito |
|:-:|---|
| **RF01** | Cadastrar, consultar e atualizar **participantes**. |
| **RF02** | Cadastrar **eventos** com nome, tipo, período, local e situação. |
| **RF03** | Cadastrar as **atividades** de cada evento, com tipo, data, horário e local. |
| **RF04** | Cadastrar **palestrantes** e vinculá-los às atividades. |
| **RF05** | Registrar a **inscrição** de um participante em um evento. |
| **RF06** | Alterar a **situação** de uma inscrição. |
| **RF07** | Registrar a **presença** de um participante inscrito em uma atividade. |
| **RF08** | Consultar **relatórios** de inscritos por evento, participação por atividade e frequência dos participantes. |

---

## 4 · Regras de negócio

As dez regras abaixo delimitam **quais dados e operações são válidos**.

### Unicidade e integridade

| Código | Regra |
|:-:|---|
| **RN01** | Todo participante deve ter **e-mail único** no sistema. |
| **RN04** | Um participante só pode ter **uma inscrição em cada evento**. |
| **RN10** | Um participante só pode ter **um registro de presença em cada atividade**. |

### Relacionamentos

| Código | Regra |
|:-:|---|
| **RN02** | Um evento pode possuir várias atividades, mas cada atividade pertence a **um único evento**. |
| **RN03** | Um participante pode se inscrever em vários eventos, e um evento pode receber vários participantes. *(N:N)* |
| **RN06** | Uma atividade pode ter vários palestrantes, e um palestrante pode atuar em várias atividades. *(N:N)* |

### Validações

| Código | Regra |
|:-:|---|
| **RN05** | Toda inscrição deve ter uma situação definida: `pendente`, `confirmada` ou `cancelada`. |
| **RN07** | A data de término de um evento **não pode ser anterior** à data de início. |
| **RN08** | O horário de término de uma atividade deve ser **posterior** ao horário de início. |
| **RN09** | A presença só pode ser registrada para participante com **inscrição confirmada** no evento da atividade. |

---

## 5 · Lista preliminar de entidades e atributos

A lista preliminar tem **sete entidades**, sendo `Atividade_Palestrante` a **associativa** entre Atividade e Palestrante.

| Entidade | Principais atributos |
|---|---|
| **Participante** | `id_participante`, `nome`, `email`, `telefone`, `instituicao` |
| **Evento** | `id_evento`, `nome`, `atividade`, `descricao`, `data_inicio`, `data_fim`, `local`, `situacao` |
| **Atividade** | `id_atividade`, `id_evento`, `titulo`, `tipo`, `data`, `hora_inicio`, `hora_fim`, `local` |
| **Palestrante** | `id_palestrante`, `nome`, `email`, `area_atuacao`, `minicurriculo` |
| **Atividade_Palestrante** | `id_atividade`, `id_palestrante` |
| **Inscricao** | `id_inscricao`, `id_participante`, `id_evento`, `data_inscricao`, `situacao` |
| **Presenca** | `id_presenca`, `id_inscricao`, `id_atividade`, `data_hora_registro` |

> **Decisão de modelagem:** `Presenca` aponta para a **inscrição**, e não diretamente para o participante, para facilitar o vínculo exigido pela **RN09**. Essa decisão será detalhada na Semana 2.

## 6 · Perguntas que o banco deverá responder

As cinco perguntas abaixo serão respondidas por **consultas SQL na Semana 4**.

1. Quantos participantes estão inscritos em cada evento?
2. Quais atividades possuem maior participação?
3. Quais participantes atingiram determinada frequência em um evento?
4. Quais inscrições estão pendentes ou canceladas em cada evento?
5. Quais palestrantes conduziram mais atividades?

---

<p align="center">
  <sub> Projeto Integrador · Banco de Dados · Prof. Gustavo Prado · Instituto Horizonte de Educação Superior (fictício)</sub>
</p>
