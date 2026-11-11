# Sistema de Eventos Acadêmicos

### Semana 2 — DER e Modelo Lógico Relacional

![Disciplina](https://img.shields.io/badge/Disciplina-Banco%20de%20Dados-blue?style=for-the-badge)
![Banco](https://img.shields.io/badge/PostgreSQL-Supabase-3ECF8E?style=for-the-badge&logo=postgresql&logoColor=white)
![Fase](https://img.shields.io/badge/Fase-Semana%202-purple?style=for-the-badge)
![Normalização](https://img.shields.io/badge/Normalização-3FN-success?style=for-the-badge)

> **Projeto Integrador — Banco de Dados Ponta a Ponta**
> O modelo passou de 7 para **8 tabelas**: entrou `inscricao_atividade`, que resolve o problema de superlotação descrito na contextualização.

---

## Sumário

1. [Revisão das entidades e ajustes desde a Semana 1](#1--revisão-das-entidades-e-ajustes-desde-a-semana-1)
2. [Modelo lógico relacional](#2--modelo-lógico-relacional)
3. [DER](#3--der)
4. [Cardinalidades e obrigatoriedades](#4--cardinalidades-e-obrigatoriedades)
5. [Resolução dos relacionamentos N:N](#5--resolução-dos-relacionamentos-nn)
6. [Normalização até a 3ª Forma Normal](#6--normalização-até-a-3ª-forma-normal)

---

## 1 · Revisão das entidades e ajustes desde a Semana 1

O modelo passou de **7 para 8 tabelas**: entrou `inscricao_atividade`, que resolve o problema de superlotação descrito na contextualização.

| Item | Semana 1 | Semana 2 | Motivo |
|---|---|---|---|
| **Vagas da atividade** | Atividade sem limite de público | Atributo `vagas` em `atividade` | Controlar a lotação de cada sala |
| **Inscrição em atividade** | Inscrição apenas no evento | Nova tabela `inscricao_atividade` | Só tem direito à sala quem reservou vaga na atividade |
| **Presença** | Ligada a `id_inscricao` e `id_atividade` separadamente | Ligada a uma vaga de `inscricao_atividade` | Presença só de quem reservou vaga naquela atividade |
| **Domínios** | Tipo e situação sem valores definidos | Listas fechadas de valores | Padronizar os dados e evitar grafias diferentes |
| **Regras** | 8 requisitos e 10 regras | RF09, RN11 e RN12 novos; RN09 reescrita | Cobrir a regra de vagas |

### Requisito e regras incluídos ou alterados

| Código | Descrição |
|:-:|---|
| **RF09** | O sistema deverá permitir inscrever um participante, já inscrito no evento, nas atividades que deseja frequentar. |
| **RN09** *(reescrita)* | A presença só pode ser registrada para participante **inscrito naquela atividade**. |
| **RN11** | Cada atividade tem um número de vagas, e as inscrições na atividade **não podem ultrapassar** esse número. |
| **RN12** | O participante só pode se inscrever em atividades do evento em que tem **inscrição confirmada**. |

### Domínios definidos

| Campo | Valores permitidos |
|---|---|
| `evento.tipo` | congresso, seminário ou semana acadêmica |
| `evento.situacao` | planejado, aberto, encerrado ou cancelado |
| `atividade.tipo` | palestra, minicurso, mesa-redonda ou oficina |
| `inscricao.situacao` | pendente, confirmada ou cancelada |

---

## 2 · Modelo lógico relacional

O esquema relacional tem **8 tabelas**; toda tabela tem chave primária e as ligações são feitas por chaves estrangeiras.

| Tabela | Colunas |
|---|---|
| **participante** | `id_participante` PK · `nome` · `email` (único) · `telefone` · `instituicao` |
| **evento** | `id_evento` PK · `nome` · `tipo` · `descricao` · `data_inicio` · `data_fim` · `local` · `situacao` |
| **palestrante** | `id_palestrante` PK · `nome` · `email` (único) · `area_atuacao` · `minicurriculo` |
| **atividade** | `id_atividade` PK · `id_evento` FK → evento · `titulo` · `tipo` · `data` · `hora_inicio` · `hora_fim` · `local` · `vagas` |
| **atividade_palestrante** | `id_atividade` PK/FK → atividade · `id_palestrante` PK/FK → palestrante |
| **inscricao** | `id_inscricao` PK · `id_participante` FK → participante · `id_evento` FK → evento · `data_inscricao` · `situacao` · (`id_participante`, `id_evento`) único |
| **inscricao_atividade** | `id_inscricao` PK/FK → inscricao · `id_atividade` PK/FK → atividade · `data_inscricao` |
| **presenca** | `id_presenca` PK · (`id_inscricao`, `id_atividade`) FK → inscricao_atividade, único · `data_hora_registro` |

**Tabelas associativas:** `atividade_palestrante` e `inscricao_atividade` usam chave primária composta pelas duas FKs. Em `presenca`, a FK é **composta** porque aponta para a chave composta de `inscricao_atividade`.

**Domínios gravados no banco:**

- `evento.tipo` ∈ { `congresso`, `seminario`, `semana_academica` }
- `evento.situacao` ∈ { `planejado`, `aberto`, `encerrado`, `cancelado` }
- `atividade.tipo` ∈ { `palestra`, `minicurso`, `mesa_redonda`, `oficina` }
- `inscricao.situacao` ∈ { `pendente`, `confirmada`, `cancelada` }

---

## 3 · DER

<img width="5476" height="2984" alt="DER (1)" src="https://github.com/user-attachments/assets/67c497b3-76db-445c-9dd1-657d47dfbaca" />


## 4 · Cardinalidades e obrigatoriedades

Cada relacionamento é lido nos dois sentidos: o par **(mínimo, máximo)** indica quantas vezes cada lado participa.

| Relacionamento | Cardinalidade | Leitura |
|---|---|---|
| **Evento — Atividade** | 1:N — Evento (1,1) : Atividade (0,N) | Toda atividade pertence a exatamente um evento; um evento pode ainda não ter atividades (RN02) |
| **Participante — Inscrição** | 1:N — Participante (1,1) : Inscrição (0,N) | Toda inscrição é de um participante; um participante pode ter várias inscrições (RN03) |
| **Evento — Inscrição** | 1:N — Evento (1,1) : Inscrição (0,N) | Toda inscrição é em um evento; um evento pode receber várias (RN03) |
| **Atividade — Atividade_Palestrante** | 1:N — Atividade (1,1) : Atividade_Palestrante (0,N) | Uma atividade pode ter vários palestrantes (RN06) |
| **Palestrante — Atividade_Palestrante** | 1:N — Palestrante (1,1) : Atividade_Palestrante (0,N) | Um palestrante pode atuar em várias atividades (RN06) |
| **Inscrição — Inscricao_Atividade** | 1:N — Inscrição (1,1) : Inscricao_Atividade (0,N) | Um inscrito no evento pode reservar vaga em várias atividades (RF09) |
| **Atividade — Inscricao_Atividade** | 1:N — Atividade (1,1) : Inscricao_Atividade (0,N) | Uma atividade recebe reservas até o limite de vagas (RN11) |
| **Inscricao_Atividade — Presença** | 1:1 — Inscricao_Atividade (1,1) : Presença (0,1) | Cada vaga reservada gera no máximo uma presença (RN09 e RN10) |

> O mínimo **(1,1)** do lado "um" vira FK com `NOT NULL`; o mínimo **0** do lado "muitos" significa que o registro pode existir sem filhos.
>
> O limite máximo de vagas (**RN11**) e a regra de inscrição confirmada no mesmo evento (**RN12**) não aparecem na cardinalidade e serão garantidos na implementação (**Semana 3**).

---

## 5 · Resolução dos relacionamentos N:N

O modelo conceitual tem **três relacionamentos N:N**, e cada um virou uma tabela associativa no modelo relacional.

Um N:N não pode ser implementado com uma FK simples: em qualquer lado que a FK ficasse, ela só guardaria um valor por linha. O processo de transformação foi o mesmo nos três casos:

1. Criar uma **tabela nova** entre as duas entidades.
2. Colocar nela **uma FK para cada** entidade original.
3. Definir a chave: as duas FKs juntas como **PK composta** ou, quando a ligação tem identidade própria, um `id` com `UNIQUE` nas duas FKs.
4. **Mover** para a nova tabela os atributos que pertencem à ligação, e não a um dos lados.

O N:N original vira **dois relacionamentos 1:N**, com a tabela associativa no lado "muitos" dos dois.

| N:N conceitual | Tabela associativa | Chave | Atributos da ligação |
|---|---|---|---|
| Participante (0,N) : Evento (0,N) | `inscricao` | `id_inscricao` + UNIQUE (`id_participante`, `id_evento`) | `data_inscricao`, `situacao` |
| Atividade (0,N) : Palestrante (0,N) | `atividade_palestrante` | PK composta (`id_atividade`, `id_palestrante`) | nenhum |
| Inscrição (0,N) : Atividade (0,N) | `inscricao_atividade` | PK composta (`id_inscricao`, `id_atividade`) | `data_inscricao` |

### Decisões de cada caso

- **`inscricao`**: recebeu id próprio porque é referenciada por outra tabela (`inscricao_atividade`) e tem atributos próprios. O `UNIQUE` no par garante a **RN04**: um participante não se inscreve duas vezes no mesmo evento.
- **`atividade_palestrante`**: a PK composta já impede repetir o mesmo palestrante na mesma atividade, e a ligação não tem atributos.
- **`inscricao_atividade`**: liga Atividade à **inscrição**, e não ao participante, para que só quem está inscrito no evento possa reservar vaga. A data da reserva fica aqui porque descreve a ligação, não a inscrição nem a atividade.

> **A presença não é um quarto N:N.** Ela aponta para uma vaga de `inscricao_atividade`, em relação 1:1. Assim, a própria FK impede registrar presença de quem não reservou vaga naquela atividade (**RN09**).

---

## 6 · Normalização até a 3ª Forma Normal

As 8 tabelas estão na **3ª Forma Normal**: os valores são atômicos, nenhum atributo depende de só parte de uma chave composta e nenhum depende de outro atributo não chave.

| Forma normal | Exigência | Como o modelo atende |
|:-:|---|---|
| **1FN** | Valores atômicos, sem listas nem grupos repetidos | Os palestrantes de uma atividade não ficam numa lista dentro de `atividade`: cada par vira uma linha de `atividade_palestrante`. O mesmo vale para inscrições e vagas |
| **2FN** | Estar na 1FN e nenhum atributo depender só de parte de uma chave composta | Só `atividade_palestrante` e `inscricao_atividade` têm PK composta. A primeira não tem outros atributos; na segunda, `data_inscricao` depende do par inteiro (a data em que aquela inscrição reservou aquela atividade) |
| **3FN** | Estar na 2FN e nenhum atributo depender de outro atributo não chave | Nenhuma tabela repete dados de outra: `atividade` guarda `id_evento`, e não o nome do evento; `inscricao` guarda `id_participante`, e não nome ou e-mail |

### Decisões que evitaram anomalias de atualização

- **Dados do participante num só lugar:** nome e e-mail ficam apenas em `participante`. Antes, nas planilhas, uma mudança de e-mail precisava ser feita em cada evento; agora é feita uma vez.
- **Presença sem `id_participante` e `id_evento`:** esses dados já são alcançados pela inscrição. Repeti-los em `presenca` criaria uma dependência transitiva (`id_inscricao` → `id_evento`) e permitiria gravar um evento diferente do da inscrição.
- **Vagas ocupadas não são armazenadas:** o número de vagas ocupadas é calculado contando as linhas de `inscricao_atividade`. Guardar esse total em `atividade` criaria um dado derivado que pode ficar desatualizado.
- **Local como texto:** `local` continua sendo atributo de `evento` e de `atividade`. Os requisitos não pedem dados das salas (capacidade, prédio), então criar uma tabela Local não eliminaria nenhuma anomalia. Normalizar não é eliminar toda repetição de texto, e sim as dependências que causam inconsistência.

---

<p align="center">
  <sub>Projeto Integrador · Banco de Dados · Prof. Gustavo Prado · Instituto Horizonte de Educação Superior (fictício)</sub>
</p>
