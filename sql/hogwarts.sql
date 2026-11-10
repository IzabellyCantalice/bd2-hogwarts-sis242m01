-- ============================================================================
-- ESCOLA DE MAGIA DE HOGWARTS - BD2 (SIS242M01)
-- Atividade Prática: Escola de Magia de Hogwarts
-- Disciplina: Manipulação de Dados / Banco de Dados II (SIS242M01)
-- Professor: Aguinaldo Neto
-- Aluno: Izabelly Cantalice
-- Matrícula: 2421950
-- ============================================================================

DROP DATABASE IF EXISTS hogwarts;
CREATE DATABASE hogwarts;
USE hogwarts;

SET SQL_SAFE_UPDATES = 0;

-- ============================================================================
-- SEÇÃO 1: DDL e Carga Inicial ( PREPARAÇÃO DO AMBIENTE (DDL)
-- ============================================================================

CREATE TABLE casa (
    id_casa INT AUTO_INCREMENT PRIMARY KEY,
    nome_casa VARCHAR(30) NOT NULL UNIQUE,
    fundador VARCHAR(60),
    pontos INT DEFAULT 0
);

CREATE TABLE professor (
    id_prof INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    salario DECIMAL(10,2) CHECK (salario > 0),
    data_contratacao DATE,
    id_casa INT,
    CONSTRAINT fk_professor_casa FOREIGN KEY (id_casa) REFERENCES casa(id_casa)
);

CREATE TABLE disciplina (
    id_disc INT AUTO_INCREMENT PRIMARY KEY,
    nome_disc VARCHAR(60) NOT NULL UNIQUE,
    ano_minimo INT CHECK (ano_minimo BETWEEN 1 AND 7),
    id_prof INT,
    CONSTRAINT fk_disciplina_professor FOREIGN KEY (id_prof) REFERENCES professor(id_prof)
);

CREATE TABLE aluno (
    id_aluno INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    ano_escolar INT CHECK (ano_escolar BETWEEN 1 AND 7),
    id_casa INT,
    saldo_galeoes DECIMAL(10,2) DEFAULT 0 CHECK (saldo_galeoes >= 0),
    CONSTRAINT fk_aluno_casa FOREIGN KEY (id_casa) REFERENCES casa(id_casa)
);

CREATE TABLE matricula (
    id_aluno INT,
    id_disc INT,
    nota DECIMAL(4,2) CHECK (nota BETWEEN 0 AND 10),
    PRIMARY KEY (id_aluno, id_disc),
    CONSTRAINT fk_matricula_aluno FOREIGN KEY (id_aluno) REFERENCES aluno(id_aluno),
    CONSTRAINT fk_matricula_disciplina FOREIGN KEY (id_disc) REFERENCES disciplina(id_disc)
);

CREATE TABLE registro_pontos (
    id_registro INT AUTO_INCREMENT PRIMARY KEY,
    id_aluno INT NOT NULL,
    id_prof INT NOT NULL,
    pontos INT NOT NULL,
    motivo VARCHAR(150),
    data_registro DATE NOT NULL,
    CONSTRAINT fk_registro_aluno FOREIGN KEY (id_aluno) REFERENCES aluno(id_aluno),
    CONSTRAINT fk_registro_professor FOREIGN KEY (id_prof) REFERENCES professor(id_prof)
);

CREATE TABLE produto (
    id_produto INT AUTO_INCREMENT PRIMARY KEY,
    nome_produto VARCHAR(100) NOT NULL,
    loja VARCHAR(50) NOT NULL,
    preco DECIMAL(10,2) CHECK (preco > 0),
    estoque INT DEFAULT 0 CHECK (estoque >= 0)
);

CREATE TABLE compra (
    id_compra INT AUTO_INCREMENT PRIMARY KEY,
    id_aluno INT,
    id_produto INT,
    quantidade INT CHECK (quantidade > 0),
    valor_total DECIMAL(10,2),
    data_compra DATE NOT NULL,
    CONSTRAINT fk_compra_aluno FOREIGN KEY (id_aluno) REFERENCES aluno(id_aluno),
    CONSTRAINT fk_compra_produto FOREIGN KEY (id_produto) REFERENCES produto(id_produto)
);

CREATE TABLE log_auditoria (
    id_log INT AUTO_INCREMENT PRIMARY KEY,
    tabela VARCHAR(30),
    operacao VARCHAR(10),
    descricao VARCHAR(255),
    data_hora DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Pergunta para pensar (Seção 1):
-- A tabela matricula usa chave primária composta (id_aluno, id_disc) para garantir que um mesmo aluno
-- não possa ser matriculado mais de uma vez na mesma disciplina. Se ela tivesse apenas um id_matricula
-- auto_increment como chave primária (sem restrição UNIQUE em id_aluno + id_disc), o mesmo aluno
-- poderia ser inserido várias vezes na mesma disciplina, gerando duplicidade de notas no boletim.

-- 1.1. Carga Inicial de Dados (DML)

INSERT INTO casa (nome_casa, fundador) VALUES
('Grifinória', 'Godric Gryffindor'),   -- 1
('Sonserina',  'Salazar Slytherin'),   -- 2
('Corvinal',   'Rowena Ravenclaw'),    -- 3
('Lufa-Lufa',  'Helga Hufflepuff');    -- 4

INSERT INTO professor (nome, salario, data_contratacao, id_casa) VALUES
('Minerva McGonagall', 9500.00, '1956-12-01', 1),    -- 1
('Severo Snape',       8800.00, '1981-09-01', 2),    -- 2
('Fílio Flitwick',     8200.00, '1974-09-01', 3),    -- 3
('Pomona Sprout',      7900.00, '1972-09-01', 4),    -- 4
('Rúbeo Hagrid',       4500.00, '1993-09-01', NULL), -- 5
('Remo Lupin',         6200.00, '1993-09-01', NULL), -- 6
('Sibila Trelawney',   5100.00, '1980-09-01', NULL), -- 7
('Gilderoy Lockhart',  7000.00, '1992-09-01', NULL), -- 8
('Horácio Slughorn',   8000.00, '1996-09-01', NULL); -- 9

INSERT INTO disciplina (nome_disc, ano_minimo, id_prof) VALUES
('Transfiguração',                    1, 1),    -- 1
('Poções',                            1, 2),    -- 2
('Feitiços',                          1, 3),    -- 3
('Herbologia',                        1, 4),    -- 4
('Trato das Criaturas Mágicas',       3, 5),    -- 5
('Defesa Contra as Artes das Trevas', 1, 6),    -- 6
('Adivinhação',                       3, 7),    -- 7
('Estudo dos Trouxas',                3, NULL), -- 8
('Runas Antigas',                     3, NULL); -- 9

INSERT INTO aluno (nome, ano_escolar, id_casa, saldo_galeoes) VALUES
('Harry Potter',       5, 1, 120.00), -- 1
('Hermione Granger',   5, 1,  85.00), -- 2
('Rony Weasley',       5, 1,  12.00), -- 3
('Neville Longbottom', 5, 1,  30.00), -- 4
('Draco Malfoy',       5, 2, 500.00), -- 5
('Pansy Parkinson',    5, 2, 150.00), -- 6
('Vicente Crabbe',     5, 2,  40.00), -- 7
('Luna Lovegood',      4, 3,  45.00), -- 8
('Cho Chang',          6, 3, 200.00), -- 9
('Padma Patil',        5, 3,  60.00), -- 10
('Cedrico Diggory',    7, 4, 180.00), -- 11
('Ana Abbott',         5, 4,  25.00), -- 12
('Ernesto Macmillan',  5, 4,  70.00), -- 13
('Teddy Lupin',        1, NULL, 0.00); -- 14 (ainda não passou pelo Chapéu Seletor)

INSERT INTO matricula (id_aluno, id_disc, nota) VALUES
(1,1,7.5),(1,2,5.0),(1,6,9.8),(1,5,8.0),
(2,1,10.0),(2,2,9.5),(2,3,10.0),(2,5,9.0),(2,9,9.5),
(3,1,6.0),(3,2,4.5),(3,7,5.5),
(4,2,3.0),(4,4,10.0),(4,6,7.0),
(5,2,9.0),(5,1,7.0),(5,5,4.0),
(6,2,7.5),(6,7,6.5),
(7,2,3.5),(7,6,2.0),
(8,5,8.5),(8,3,8.0),(8,4,9.0),
(9,3,8.5),(9,6,7.5),
(10,3,9.0),(10,7,6.0),
(11,4,8.5),(11,6,9.0),(11,1,8.0),
(12,4,8.0),
(13,4,7.0),(13,3,7.5);

INSERT INTO produto (nome_produto, loja, preco, estoque) VALUES
('Varinha de Azevinho',              'Olivaras',             7.00,  10), -- 1
('Vassoura Nimbus 2001',             'Artigos de Quadribol', 300.00, 3), -- 2
('Sapo de Chocolate',                'Dedosdemel',           2.00, 200), -- 3
('Feijõezinhos de Todos os Sabores', 'Dedosdemel',           1.50, 150), -- 4
('Livro Monstruoso dos Monstros',    'Floreios e Borrões',  12.00,  20), -- 5
('Caldeirão de Estanho',             'Caldeirões Potage',    9.00,   0), -- 6
('Kit de Logros',                    'Gemialidades Weasley', 25.00, 40), -- 7
('Pena de Repetição Rápida',         'Escribbulus',         15.00,   5); -- 8

-- ============================================================================
-- SEÇÃO 2: ALTER TABLE e UPDATE (Questões 1 a 12)
-- ============================================================================

-- Q1:
ALTER TABLE aluno ADD COLUMN email VARCHAR(100);

-- Q2:
ALTER TABLE matricula ADD COLUMN situacao VARCHAR(20) DEFAULT 'Cursando';

-- Q3:
ALTER TABLE produto ADD COLUMN ativo CHAR(1) DEFAULT 'S';

-- Q4:
ALTER TABLE casa MODIFY COLUMN fundador VARCHAR(100);

-- Q5:
ALTER TABLE professor RENAME COLUMN data_contratacao TO data_admissao;

-- Q6:
UPDATE aluno
SET email = CONCAT(LOWER(REPLACE(nome, ' ', '.')), '@hogwarts.edu');

-- Q7:
ALTER TABLE aluno ADD CONSTRAINT uq_aluno_email UNIQUE (email);

-- Q8:
UPDATE matricula
SET nota = LEAST(10.00, nota + 0.5)
WHERE id_disc IN (
    SELECT id_disc
    FROM disciplina
    WHERE id_prof IN (
        SELECT id_prof
        FROM professor
        WHERE nome = 'Remo Lupin'
    )
);

-- Q9:
UPDATE matricula
SET situacao = CASE
    WHEN nota >= 6.0 THEN 'Aprovado'
    ELSE 'Reprovado'
END;

-- Q10:
UPDATE professor
SET salario = salario * 1.10
WHERE id_casa IS NOT NULL
  AND data_admissao < '1980-01-01';

-- Q11:
UPDATE produto
SET ativo = 'N'
WHERE estoque = 0;

-- Q12:
UPDATE produto
SET preco = preco * 0.80
WHERE loja = 'Dedosdemel';


-- ============================================================================
-- SEÇÃO 3: DELETE e Testes de Restrições (Questões 13 a 19)
-- Lembre-se: comandos que FALHAM devem ser COMENTADOS com o erro explicado!
-- ============================================================================

-- Q13:
-- DELETE FROM casa WHERE nome_casa = 'Sonserina';
-- Erro 1451 (23000): Cannot delete or update a parent row: a foreign key constraint fails (`hogwarts`.`professor`, CONSTRAINT `fk_professor_casa` FOREIGN KEY (`id_casa`) REFERENCES `casa` (`id_casa`)).
-- Explicação: O banco recusa a exclusão porque a casa Sonserina (id_casa = 2) possui registros filhos vinculados por chave estrangeira nas tabelas `professor` (Severo Snape) e `aluno` (Draco, Pansy e Vicente).

-- Q14:
-- INSERT INTO aluno (nome, ano_escolar, id_casa) VALUES ('Dobby', 8, 1);
-- Erro 3819 (HY000): Check constraint 'aluno_chk_1' is violated.
-- Explicação: A tabela `aluno` possui uma restrição CHECK (`ano_escolar BETWEEN 1 AND 7`) que impede o cadastro de alunos em anos escolares fora do intervalo de 1 a 7.

-- Q15:
-- INSERT INTO aluno (nome, ano_escolar, id_casa, email) VALUES ('Harry Potter (Polissuco)', 5, 1, 'harry.potter@hogwarts.edu');
-- Erro 1062 (23000): Duplicate entry 'harry.potter@hogwarts.edu' for key 'aluno.uq_aluno_email'.
-- Explicação: A restrição UNIQUE `uq_aluno_email` criada na questão 7 impede que dois registros na tabela `aluno` possuam o mesmo endereço de e-mail.

-- Q16:
-- DELETE FROM professor WHERE nome = 'Severo Snape';
-- Erro 1451 (23000): Cannot delete or update a parent row: a foreign key constraint fails (`hogwarts`.`disciplina`, CONSTRAINT `fk_disciplina_professor` FOREIGN KEY (`id_prof`) REFERENCES `professor` (`id_prof`)).
-- Explicação: O professor Severo Snape (id_prof = 2) está referenciado como chave estrangeira na tabela `disciplina` (Poções), impedindo sua remoção enquanto o vínculo existir.

-- Q17:
DELETE FROM professor WHERE nome = 'Gilderoy Lockhart';
-- Explicação: Este DELETE funciona porque Gilderoy Lockhart (id_prof = 8) não ministra nenhuma disciplina na tabela `disciplina` e não possui registros dependentes em `registro_pontos`.

-- Q18:
DELETE FROM matricula
WHERE id_aluno IN (
    SELECT id_aluno FROM aluno WHERE nome = 'Vicente Crabbe'
);

DELETE FROM aluno
WHERE nome = 'Vicente Crabbe';

-- Q19:
DELETE FROM disciplina
WHERE id_disc NOT IN (
    SELECT DISTINCT id_disc FROM matricula
);

