-- =====================================================================
-- Projeto Integrador - Sistema de Eventos Acadêmicos
-- =====================================================================

CREATE TABLE participante (
    id_participante INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nome            VARCHAR(120) NOT NULL,
    email           VARCHAR(150) NOT NULL UNIQUE,
    telefone        VARCHAR(20),
    instituicao     VARCHAR(120)
);

CREATE TABLE evento (
    id_evento   INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nome        VARCHAR(150) NOT NULL,
    tipo        VARCHAR(30)  NOT NULL
                CHECK (tipo IN ('congresso', 'seminario', 'semana_academica')),
    descricao   TEXT,
    data_inicio DATE         NOT NULL,
    data_fim    DATE         NOT NULL,
    local       VARCHAR(120) NOT NULL,
    situacao    VARCHAR(20)  NOT NULL DEFAULT 'planejado'
                CHECK (situacao IN ('planejado', 'aberto', 'encerrado', 'cancelado')),
    CONSTRAINT ck_evento_periodo CHECK (data_fim >= data_inicio)
);

CREATE TABLE palestrante (
    id_palestrante INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nome           VARCHAR(120) NOT NULL,
    email          VARCHAR(150) NOT NULL UNIQUE,
    area_atuacao   VARCHAR(100),
    minicurriculo  TEXT
);

CREATE TABLE atividade (
    id_atividade INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_evento    INTEGER      NOT NULL
                 REFERENCES evento (id_evento) ON DELETE CASCADE,
    titulo       VARCHAR(150) NOT NULL,
    tipo         VARCHAR(30)  NOT NULL
                 CHECK (tipo IN ('palestra', 'minicurso', 'mesa_redonda', 'oficina')),
    data         DATE         NOT NULL,
    hora_inicio  TIME         NOT NULL,
    hora_fim     TIME         NOT NULL,
    local        VARCHAR(120) NOT NULL,
    vagas        INTEGER      NOT NULL,
    CONSTRAINT ck_atividade_horario CHECK (hora_fim > hora_inicio),
    CONSTRAINT ck_atividade_vagas   CHECK (vagas > 0)
);

CREATE TABLE atividade_palestrante (
    id_atividade   INTEGER NOT NULL
                   REFERENCES atividade (id_atividade) ON DELETE CASCADE,
    id_palestrante INTEGER NOT NULL
                   REFERENCES palestrante (id_palestrante) ON DELETE RESTRICT,
    PRIMARY KEY (id_atividade, id_palestrante)
);

CREATE TABLE inscricao (
    id_inscricao    INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_participante INTEGER NOT NULL
                    REFERENCES participante (id_participante) ON DELETE RESTRICT,
    id_evento       INTEGER NOT NULL
                    REFERENCES evento (id_evento) ON DELETE RESTRICT,
    data_inscricao  TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    situacao        VARCHAR(20) NOT NULL DEFAULT 'pendente'
                    CHECK (situacao IN ('pendente', 'confirmada', 'cancelada')),
    CONSTRAINT uq_inscricao_participante_evento
        UNIQUE (id_participante, id_evento)
);

CREATE TABLE inscricao_atividade (
    id_inscricao   INTEGER   NOT NULL
                   REFERENCES inscricao (id_inscricao) ON DELETE RESTRICT,
    id_atividade   INTEGER   NOT NULL
                   REFERENCES atividade (id_atividade) ON DELETE RESTRICT,
    data_inscricao TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_inscricao, id_atividade)
);

CREATE TABLE presenca (
    id_presenca        INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_inscricao       INTEGER   NOT NULL,
    id_atividade       INTEGER   NOT NULL,
    data_hora_registro TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_presenca_inscricao_atividade
        FOREIGN KEY (id_inscricao, id_atividade)
        REFERENCES inscricao_atividade (id_inscricao, id_atividade)
        ON DELETE RESTRICT,
    CONSTRAINT uq_presenca_inscricao_atividade
        UNIQUE (id_inscricao, id_atividade)
);

CREATE FUNCTION validar_inscricao_atividade()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM inscricao i
        JOIN atividade a ON a.id_evento = i.id_evento
        WHERE i.id_inscricao = NEW.id_inscricao
          AND a.id_atividade = NEW.id_atividade
          AND i.situacao = 'confirmada'
    ) THEN
        RAISE EXCEPTION 'Inscrição inválida: o participante precisa ter inscrição confirmada no evento da atividade.';
    END IF;

    IF (SELECT COUNT(*) FROM inscricao_atividade WHERE id_atividade = NEW.id_atividade)
       >= (SELECT vagas FROM atividade WHERE id_atividade = NEW.id_atividade) THEN
        RAISE EXCEPTION 'Atividade lotada: não há vagas disponíveis.';
    END IF;

    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_validar_inscricao_atividade
BEFORE INSERT ON inscricao_atividade
FOR EACH ROW
EXECUTE FUNCTION validar_inscricao_atividade();

CREATE INDEX idx_inscricao_evento ON inscricao (id_evento);
CREATE INDEX idx_inscricao_atividade_atividade ON inscricao_atividade (id_atividade);
CREATE INDEX idx_presenca_atividade ON presenca (id_atividade);
