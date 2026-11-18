-- Projeto Integrador - Sistema de Eventos Acadêmicos
-- Testes de integridade - Semana 3

-- T01
BEGIN;
INSERT INTO participante (nome, email) VALUES ('Ana Teste', 't01@teste.com');
INSERT INTO participante (nome, email) VALUES ('Outra Ana', 't01@teste.com');
ROLLBACK;

-- T02
BEGIN;
INSERT INTO participante (nome, email) VALUES (NULL, 't02@teste.com');
ROLLBACK;

-- T03
BEGIN;
INSERT INTO evento (nome, tipo, data_inicio, data_fim, local)
VALUES ('Evento T03', 'congresso', '2026-12-10', '2026-12-05', 'Auditório');
ROLLBACK;

-- T04
BEGIN;
INSERT INTO evento (nome, tipo, data_inicio, data_fim, local)
VALUES ('Evento T04', 'festa', '2026-12-01', '2026-12-01', 'Auditório');
ROLLBACK;

-- T05
BEGIN;
INSERT INTO evento (nome, tipo, data_inicio, data_fim, local)
VALUES ('Evento T05', 'seminario', '2026-12-01', '2026-12-01', 'Auditório');
INSERT INTO atividade (id_evento, titulo, tipo, data, hora_inicio, hora_fim, local, vagas)
VALUES ((SELECT id_evento FROM evento WHERE nome = 'Evento T05'),
        'Palestra T05', 'palestra', '2026-12-01', '10:00', '09:00', 'Sala 1', 30);
ROLLBACK;

-- T06
BEGIN;
INSERT INTO atividade (id_evento, titulo, tipo, data, hora_inicio, hora_fim, local, vagas)
VALUES (999999, 'Palestra T06', 'palestra', '2026-12-01', '09:00', '10:00', 'Sala 1', 30);
ROLLBACK;

-- T07
BEGIN;
INSERT INTO participante (nome, email) VALUES ('Bruno Teste', 't07@teste.com');
INSERT INTO evento (nome, tipo, data_inicio, data_fim, local)
VALUES ('Evento T07', 'seminario', '2026-12-01', '2026-12-01', 'Auditório');
INSERT INTO inscricao (id_participante, id_evento)
VALUES ((SELECT id_participante FROM participante WHERE email = 't07@teste.com'),
        (SELECT id_evento FROM evento WHERE nome = 'Evento T07'));
INSERT INTO inscricao (id_participante, id_evento)
VALUES ((SELECT id_participante FROM participante WHERE email = 't07@teste.com'),
        (SELECT id_evento FROM evento WHERE nome = 'Evento T07'));
ROLLBACK;

-- T08
BEGIN;
INSERT INTO participante (nome, email) VALUES ('Carla Teste', 't08@teste.com');
INSERT INTO evento (nome, tipo, data_inicio, data_fim, local)
VALUES ('Evento T08', 'seminario', '2026-12-01', '2026-12-01', 'Auditório');
INSERT INTO inscricao (id_participante, id_evento, situacao)
VALUES ((SELECT id_participante FROM participante WHERE email = 't08@teste.com'),
        (SELECT id_evento FROM evento WHERE nome = 'Evento T08'),
        'aprovada');
ROLLBACK;

-- T09
BEGIN;
INSERT INTO participante (nome, email) VALUES ('Davi Teste', 't09@teste.com');
INSERT INTO evento (nome, tipo, data_inicio, data_fim, local)
VALUES ('Evento T09', 'seminario', '2026-12-01', '2026-12-01', 'Auditório');
INSERT INTO atividade (id_evento, titulo, tipo, data, hora_inicio, hora_fim, local, vagas)
VALUES ((SELECT id_evento FROM evento WHERE nome = 'Evento T09'),
        'Oficina T09', 'oficina', '2026-12-01', '09:00', '11:00', 'Lab 1', 20);
INSERT INTO inscricao (id_participante, id_evento)
VALUES ((SELECT id_participante FROM participante WHERE email = 't09@teste.com'),
        (SELECT id_evento FROM evento WHERE nome = 'Evento T09'));
INSERT INTO inscricao_atividade (id_inscricao, id_atividade)
VALUES ((SELECT id_inscricao FROM inscricao
          WHERE id_participante = (SELECT id_participante FROM participante WHERE email = 't09@teste.com')),
        (SELECT id_atividade FROM atividade WHERE titulo = 'Oficina T09'));
ROLLBACK;

-- T10
BEGIN;
INSERT INTO participante (nome, email) VALUES ('Eva Teste', 't10a@teste.com');
INSERT INTO participante (nome, email) VALUES ('Fabio Teste', 't10b@teste.com');
INSERT INTO evento (nome, tipo, data_inicio, data_fim, local)
VALUES ('Evento T10', 'seminario', '2026-12-01', '2026-12-01', 'Auditório');
INSERT INTO atividade (id_evento, titulo, tipo, data, hora_inicio, hora_fim, local, vagas)
VALUES ((SELECT id_evento FROM evento WHERE nome = 'Evento T10'),
        'Oficina T10', 'oficina', '2026-12-01', '09:00', '11:00', 'Lab 1', 1);
INSERT INTO inscricao (id_participante, id_evento, situacao)
VALUES ((SELECT id_participante FROM participante WHERE email = 't10a@teste.com'),
        (SELECT id_evento FROM evento WHERE nome = 'Evento T10'), 'confirmada');
INSERT INTO inscricao (id_participante, id_evento, situacao)
VALUES ((SELECT id_participante FROM participante WHERE email = 't10b@teste.com'),
        (SELECT id_evento FROM evento WHERE nome = 'Evento T10'), 'confirmada');
INSERT INTO inscricao_atividade (id_inscricao, id_atividade)
VALUES ((SELECT id_inscricao FROM inscricao
          WHERE id_participante = (SELECT id_participante FROM participante WHERE email = 't10a@teste.com')),
        (SELECT id_atividade FROM atividade WHERE titulo = 'Oficina T10'));
INSERT INTO inscricao_atividade (id_inscricao, id_atividade)
VALUES ((SELECT id_inscricao FROM inscricao
          WHERE id_participante = (SELECT id_participante FROM participante WHERE email = 't10b@teste.com')),
        (SELECT id_atividade FROM atividade WHERE titulo = 'Oficina T10'));
ROLLBACK;

-- T11
BEGIN;
INSERT INTO participante (nome, email) VALUES ('Gabi Teste', 't11@teste.com');
INSERT INTO evento (nome, tipo, data_inicio, data_fim, local)
VALUES ('Evento T11', 'seminario', '2026-12-01', '2026-12-01', 'Auditório');
INSERT INTO atividade (id_evento, titulo, tipo, data, hora_inicio, hora_fim, local, vagas)
VALUES ((SELECT id_evento FROM evento WHERE nome = 'Evento T11'),
        'Palestra T11', 'palestra', '2026-12-01', '09:00', '10:00', 'Sala 1', 50);
INSERT INTO inscricao (id_participante, id_evento, situacao)
VALUES ((SELECT id_participante FROM participante WHERE email = 't11@teste.com'),
        (SELECT id_evento FROM evento WHERE nome = 'Evento T11'), 'confirmada');
INSERT INTO presenca (id_inscricao, id_atividade)
VALUES ((SELECT id_inscricao FROM inscricao
          WHERE id_participante = (SELECT id_participante FROM participante WHERE email = 't11@teste.com')),
        (SELECT id_atividade FROM atividade WHERE titulo = 'Palestra T11'));
ROLLBACK;

-- T12
BEGIN;
INSERT INTO participante (nome, email) VALUES ('Hugo Teste', 't12@teste.com');
INSERT INTO evento (nome, tipo, data_inicio, data_fim, local)
VALUES ('Evento T12', 'seminario', '2026-12-01', '2026-12-01', 'Auditório');
INSERT INTO atividade (id_evento, titulo, tipo, data, hora_inicio, hora_fim, local, vagas)
VALUES ((SELECT id_evento FROM evento WHERE nome = 'Evento T12'),
        'Palestra T12', 'palestra', '2026-12-01', '09:00', '10:00', 'Sala 1', 50);
INSERT INTO inscricao (id_participante, id_evento, situacao)
VALUES ((SELECT id_participante FROM participante WHERE email = 't12@teste.com'),
        (SELECT id_evento FROM evento WHERE nome = 'Evento T12'), 'confirmada');
INSERT INTO inscricao_atividade (id_inscricao, id_atividade)
VALUES ((SELECT id_inscricao FROM inscricao
          WHERE id_participante = (SELECT id_participante FROM participante WHERE email = 't12@teste.com')),
        (SELECT id_atividade FROM atividade WHERE titulo = 'Palestra T12'));
INSERT INTO presenca (id_inscricao, id_atividade)
VALUES ((SELECT id_inscricao FROM inscricao
          WHERE id_participante = (SELECT id_participante FROM participante WHERE email = 't12@teste.com')),
        (SELECT id_atividade FROM atividade WHERE titulo = 'Palestra T12'));
INSERT INTO presenca (id_inscricao, id_atividade)
VALUES ((SELECT id_inscricao FROM inscricao
          WHERE id_participante = (SELECT id_participante FROM participante WHERE email = 't12@teste.com')),
        (SELECT id_atividade FROM atividade WHERE titulo = 'Palestra T12'));
ROLLBACK;

-- T13
BEGIN;
INSERT INTO participante (nome, email) VALUES ('Iara Teste', 't13@teste.com');
INSERT INTO evento (nome, tipo, data_inicio, data_fim, local)
VALUES ('Evento T13', 'seminario', '2026-12-01', '2026-12-01', 'Auditório');
INSERT INTO inscricao (id_participante, id_evento)
VALUES ((SELECT id_participante FROM participante WHERE email = 't13@teste.com'),
        (SELECT id_evento FROM evento WHERE nome = 'Evento T13'));
DELETE FROM evento WHERE nome = 'Evento T13';
ROLLBACK;

-- T14
BEGIN;
INSERT INTO evento (nome, tipo, data_inicio, data_fim, local)
VALUES ('Evento T14', 'semana_academica', '2026-12-01', '2026-12-03', 'Campus');
INSERT INTO palestrante (nome, email) VALUES ('Joana Teste', 't14@teste.com');
INSERT INTO atividade (id_evento, titulo, tipo, data, hora_inicio, hora_fim, local, vagas)
VALUES ((SELECT id_evento FROM evento WHERE nome = 'Evento T14'),
        'Mesa T14', 'mesa_redonda', '2026-12-02', '14:00', '16:00', 'Sala 2', 40);
INSERT INTO atividade_palestrante (id_atividade, id_palestrante)
VALUES ((SELECT id_atividade FROM atividade WHERE titulo = 'Mesa T14'),
        (SELECT id_palestrante FROM palestrante WHERE email = 't14@teste.com'));
DELETE FROM evento WHERE nome = 'Evento T14';
SELECT (SELECT COUNT(*) FROM atividade WHERE titulo = 'Mesa T14') AS atividades_restantes,
       (SELECT COUNT(*) FROM atividade_palestrante ap
          JOIN palestrante p ON p.id_palestrante = ap.id_palestrante
         WHERE p.email = 't14@teste.com') AS vinculos_restantes,
       (SELECT COUNT(*) FROM palestrante WHERE email = 't14@teste.com') AS palestrante_continua;
ROLLBACK;
