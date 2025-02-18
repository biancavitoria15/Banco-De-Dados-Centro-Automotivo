// Turma - 1TDSPM
// Bianca Vitoria - RM 556270

DROP TABLE funcionario CASCADE CONSTRAINTS;
DROP TABLE cargo CASCADE CONSTRAINTS;
DROP TABLE oficina CASCADE CONSTRAINTS;
DROP TABLE cliente CASCADE CONSTRAINTS;
DROP TABLE veiculo CASCADE CONSTRAINTS;
DROP TABLE diagnostico CASCADE CONSTRAINTS;
DROP TABLE orcamento CASCADE CONSTRAINTS;
DROP TABLE peca CASCADE CONSTRAINTS;
DROP TABLE fornecedor CASCADE CONSTRAINTS;
DROP TABLE estoque_peca CASCADE CONSTRAINTS;
DROP TABLE pgto CASCADE CONSTRAINTS;
DROP TABLE pgto_orcamento CASCADE CONSTRAINTS;
DROP TABLE servico_online CASCADE CONSTRAINTS;



CREATE TABLE funcionario (
    nm_func      VARCHAR2(50 CHAR),
    id_func      INTEGER NOT NULL,
    salario_func NUMBER(4) NOT NULL,
    funcao_func  VARCHAR2(50 CHAR) NOT NULL,
    CONSTRAINT funcionario_pk PRIMARY KEY (id_func),
    CONSTRAINT salario_func_ck CHECK (salario_func > 0)
);


CREATE TABLE cargo (
    nm_cargo            VARCHAR2(30 CHAR) NOT NULL,
    salario_base        NUMBER(4) NOT NULL,
    dta_adm             DATE NOT NULL,
    beneficio           VARCHAR2(30 CHAR),
    funcionario_id_func INTEGER NOT NULL,
    CONSTRAINT cargo_pk PRIMARY KEY (nm_cargo, funcionario_id_func),
    CONSTRAINT salario_base_ck CHECK (salario_base > 0)
);  


CREATE TABLE oficina (
    endereco_of         VARCHAR2(30 CHAR) NOT NULL,
    telefone_of         VARCHAR2(15 CHAR) NOT NULL,
    cnpj_of             CHAR(14 CHAR) NOT NULL,
    nome                VARCHAR2(50 CHAR),
    funcionario_id_func INTEGER,
    CONSTRAINT oficina_pk PRIMARY KEY (cnpj_of),
    CONSTRAINT telefone_of_unique UNIQUE (telefone_of)
);


CREATE TABLE cliente (
    email_cl    VARCHAR2(50 CHAR) NOT NULL,
    cpf_cl      CHAR(11 CHAR) NOT NULL,
    telefone_cl VARCHAR2(15 CHAR) NOT NULL,
    nm_cl       VARCHAR2(50 CHAR),
    CONSTRAINT cliente_pk PRIMARY KEY (cpf_cl),
    CONSTRAINT email_cl_unique UNIQUE (email_cl),
    CONSTRAINT telefone_cl_unique UNIQUE (telefone_cl)
);



CREATE TABLE veiculo (
    modelo_vl      VARCHAR2(30 CHAR) NOT NULL,
    marca_vl       VARCHAR2(30 CHAR) NOT NULL,
    ano_fabricacao INTEGER NOT NULL,
    placa_vl       VARCHAR2(7 CHAR) NOT NULL,
    cliente_cpf_cl CHAR(11 CHAR) NOT NULL, 
    CONSTRAINT veiculo_pk PRIMARY KEY (placa_vl),
    CONSTRAINT ano_fabricacao_ck CHECK (ano_fabricacao > 1900)
);


CREATE TABLE diagnostico (
    id_diagnostico INTEGER NOT NULL,
    resultado_vl   VARCHAR2(50 CHAR),
    problema_vl    VARCHAR2(50 CHAR) NOT NULL,
    orcamento_vl   NUMBER(5) NOT NULL,
    CONSTRAINT diagnostico_pk PRIMARY KEY (id_diagnostico),
    CONSTRAINT orcamento_vl_ck CHECK (orcamento_vl >= 0)
);


CREATE TABLE orcamento (
    valor_servico              NUMBER(5) NOT NULL,
    descricao_servico          VARCHAR2(100 CHAR),
    dt_entrega                 DATE NOT NULL,
    id_orcamento               INTEGER NOT NULL,
    diagnostico_id_diagnostico INTEGER NOT NULL,
    CONSTRAINT orcamento_pk PRIMARY KEY (id_orcamento),
    CONSTRAINT valor_servico_ck CHECK (valor_servico > 0)
);


CREATE TABLE peca (
    id_peca    INTEGER NOT NULL,
    preco_peca NUMBER(5) NOT NULL,
    qtd_peca   INTEGER NOT NULL,
    nm_peca    VARCHAR2(50 CHAR) NOT NULL,
    CONSTRAINT peca_pk PRIMARY KEY (id_peca),
    CONSTRAINT preco_peca_ck CHECK (preco_peca >= 0), 
    CONSTRAINT qtd_peca_ck CHECK (qtd_peca >= 0)
);


CREATE TABLE fornecedor (
    id_fornecedor  INTEGER NOT NULL,
    endereco_forne VARCHAR2(30 CHAR) NOT NULL,
    telefone_forne VARCHAR2(15 CHAR) NOT NULL,
    cnpj_forne     CHAR(14 CHAR) NOT NULL,
    CONSTRAINT fornecedor_pk PRIMARY KEY (id_fornecedor),
    CONSTRAINT cnpj_forne_unique UNIQUE (cnpj_forne)
);


CREATE TABLE estoque_peca (
    id_estoque               INTEGER NOT NULL,
    dta_entrada              DATE NOT NULL,
    dta_saida                DATE NOT NULL,
    fornecedor               VARCHAR2(50 CHAR),
    fornecedor_id_fornecedor INTEGER NOT NULL,
    peca_id_peca             INTEGER NOT NULL,
    CONSTRAINT estoque_peca_pk PRIMARY KEY (id_estoque),
    CONSTRAINT dta_saida_ck CHECK (dta_saida >= dta_entrada), 
    CONSTRAINT fornecedor_unique UNIQUE (fornecedor)
);


CREATE UNIQUE INDEX estoque_peca__idx ON estoque_peca (peca_id_peca ASC);


CREATE TABLE pgto (
    id_pagamento  INTEGER NOT NULL,
    metodo_pgto   VARCHAR2(30 CHAR) NOT NULL,
    condicao_pgto VARCHAR2(50 CHAR) NOT NULL,
    taxa_pgto     NUMBER(5, 2),
    CONSTRAINT pgto_pk PRIMARY KEY (id_pagamento)
);


CREATE TABLE pgto_orcamento (
    orcamento_id_orcamento INTEGER NOT NULL,
    pgto_id_pagamento      INTEGER NOT NULL,
    CONSTRAINT pgto_orcamento_pk PRIMARY KEY (orcamento_id_orcamento, pgto_id_pagamento)
);   


CREATE TABLE servico_online (
    tipo_conteudo              VARCHAR2(100 CHAR) NOT NULL,
    peca_id_peca               INTEGER,
    interface_principal        VARCHAR2(100 CHAR) NOT NULL,
    comunicacao_cl             VARCHAR2(100 CHAR) NOT NULL,
    oficina_cnpj_of            CHAR(14 CHAR) NOT NULL,
    cliente_cpf_cl             CHAR(11 CHAR) NOT NULL,
    diagnostico_id_diagnostico INTEGER,
    id_cl                      INTEGER NOT NULL,
    CONSTRAINT servico_online_pk PRIMARY KEY (id_cl)
);


ALTER TABLE cargo
    ADD CONSTRAINT cargo_funcionario_fk FOREIGN KEY (funcionario_id_func)
        REFERENCES funcionario (id_func);

ALTER TABLE veiculo
    ADD CONSTRAINT veiculo_cliente_fk FOREIGN KEY (cliente_cpf_cl)
        REFERENCES cliente (cpf_cl);

ALTER TABLE estoque_peca
    ADD CONSTRAINT estoque_peca_fornecedor_fk FOREIGN KEY (fornecedor_id_fornecedor)
        REFERENCES fornecedor (id_fornecedor);

ALTER TABLE estoque_peca
    ADD CONSTRAINT estoque_peca_peca_fk FOREIGN KEY (peca_id_peca)
        REFERENCES peca (id_peca);

ALTER TABLE oficina
    ADD CONSTRAINT oficina_funcionario_fk FOREIGN KEY (funcionario_id_func)
        REFERENCES funcionario (id_func);

ALTER TABLE orcamento
    ADD CONSTRAINT orcamento_diagnostico_fk FOREIGN KEY (diagnostico_id_diagnostico)
        REFERENCES diagnostico (id_diagnostico);

ALTER TABLE pgto_orcamento
    ADD CONSTRAINT pgto_orcamento_orcamento_fk FOREIGN KEY (orcamento_id_orcamento)
        REFERENCES orcamento (id_orcamento);

ALTER TABLE pgto_orcamento
    ADD CONSTRAINT pgto_orcamento_pgto_fk FOREIGN KEY (pgto_id_pagamento)
        REFERENCES pgto (id_pagamento);

ALTER TABLE servico_online
    ADD CONSTRAINT servico_online_cliente_fk FOREIGN KEY (cliente_cpf_cl)
        REFERENCES cliente (cpf_cl);

ALTER TABLE servico_online
    ADD CONSTRAINT servico_online_diagnostico_fk FOREIGN KEY (diagnostico_id_diagnostico)
        REFERENCES diagnostico (id_diagnostico);

ALTER TABLE servico_online
    ADD CONSTRAINT servico_online_oficina_fk FOREIGN KEY (oficina_cnpj_of)
        REFERENCES oficina (cnpj_of);

ALTER TABLE servico_online
    ADD CONSTRAINT servico_online_peca_fk FOREIGN KEY (peca_id_peca)
        REFERENCES peca (id_peca);
        
        
ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD'        


INSERT INTO funcionario VALUES  ('Carlos Silva', 1, 3000, 'Mecanico');
INSERT INTO funcionario VALUES  ('Ana Souza', 2, 4500, 'Gerente');
INSERT INTO funcionario VALUES  ('Marcos Lima', 3, 3200, 'Mecanico');
INSERT INTO funcionario VALUES  ('Joana Martins', 4, 2900, 'Assistente');
INSERT INTO funcionario VALUES  ('Fernando Costa', 5, 2800, 'Mecanico');
INSERT INTO funcionario VALUES  ('Beatriz Santos', 6, 5000, 'Supervisora');
INSERT INTO funcionario VALUES  ('Rafael Pereira', 7, 3100, 'Mecanico');
INSERT INTO funcionario VALUES  ('Sofia Castro', 8, 2700, 'Atendente');
INSERT INTO funcionario VALUES  ('Gabriel Almeida', 9, 3600, 'Mecanico');
INSERT INTO funcionario VALUES  ('Patricia Rocha', 10, 4200, 'Gerente');
  
    
INSERT INTO cargo VALUES  ('Mecânico', 3000, ('2022-01-01'), 'Vale Transporte', 1);
INSERT INTO cargo VALUES  ('Gerente', 4500, ('2021-06-15'), 'Plano de Saúde', 2);
INSERT INTO cargo VALUES  ('Mecânico', 3200, ('2021-10-20'), 'Vale Refeição', 3);
INSERT INTO cargo VALUES  ('Assistente', 2900, ('2022-03-05'), 'Vale Transporte', 4);
INSERT INTO cargo VALUES  ('Mecânico', 2800, ('2021-12-12'), 'Vale Refeição', 5);
INSERT INTO cargo VALUES  ('Supervisora', 5000, ('2020-08-14'), 'Plano de Saúde', 6);
INSERT INTO cargo VALUES  ('Mecânico', 3100,('2022-02-25'), 'Vale Refeição', 7);
INSERT INTO cargo VALUES  ('Atendente', 2700,('2021-11-30'), 'Vale Transporte', 8);
INSERT INTO cargo VALUES  ('Mecânico', 3600,('2020-07-10'), 'Vale Transporte', 9);
INSERT INTO cargo VALUES  ('Gerente', 4200,('2021-09-18'), 'Plano de Saúde', 10);

         
INSERT INTO oficina VALUES ('Rua das Flores, 123', '11987654321', '12345678000123', 'Oficina Central', 1);
INSERT INTO oficina VALUES ('Avenida Brasil, 456', '11912345678', '32659874521546', 'Oficina Norte', 2);
INSERT INTO oficina VALUES ('Rua da Liberdade, 789', '11955554444', '11223344000100', 'Oficina Sul', 3);
INSERT INTO oficina VALUES ('Avenida Paulista, 1000', '11966667777', '22334455000111', 'Oficina Paulista', 4);
INSERT INTO oficina VALUES ('Rua das Palmeiras, 222', '11977778888', '33445566000122', 'Oficina Leste', 5);
INSERT INTO oficina VALUES ('Rua dos Pinheiros, 333', '11988889999', '44556677000133', 'Oficina Oeste', 6);
INSERT INTO oficina VALUES ('Avenida Ibirapuera, 999', '11999990000', '55667788000144', 'Oficina Ibirapuera', 7);
INSERT INTO oficina VALUES ('Rua do Comércio, 777', '11911112222', '66778899000155', 'Oficina Centro', 8);
INSERT INTO oficina VALUES ('Avenida Santos, 444', '11922223333', '77889900000166', 'Oficina Santos', 9);
INSERT INTO oficina VALUES ('Rua do Porto, 555', '11933334444', '88990011000177', 'Oficina Porto', 10);       


INSERT INTO cliente VALUES ('joao.almeida@example.com', '12345678901', '11987654321', 'João Almeida');
INSERT INTO cliente VALUES ('maria.oliveira@example.com', '10987654321', '11912345678', 'Maria Oliveira');
INSERT INTO cliente VALUES ('pedro.santos@example.com', '98765432109', '11933334444', 'Pedro Santos');
INSERT INTO cliente VALUES ('carla.melo@example.com', '87654321098', '11944445555', 'Carla Melo');
INSERT INTO cliente VALUES ('andre.souza@example.com', '76543210987', '11955556666', 'André Souza');
INSERT INTO cliente VALUES ('fernanda.lima@example.com', '65432109876', '11966667777', 'Fernanda Lima');
INSERT INTO cliente VALUES ('luiz.silva@example.com', '54321098765', '11977778888', 'Luiz Silva');
INSERT INTO cliente VALUES ('paula.martins@example.com', '43210987654', '11988889999', 'Paula Martins');
INSERT INTO cliente VALUES ('diego.ferreira@example.com', '32109876543', '11999990000', 'Diego Ferreira');
INSERT INTO cliente VALUES ('amanda.rodrigues@example.com', '21098765432', '11911112222', 'Amanda Rodrigues');


INSERT INTO veiculo VALUES ('Civic', 'Honda', 2020, 'ABC1234', '12345678901');
INSERT INTO veiculo VALUES ('Corolla', 'Toyota', 2021, 'XYZ5678', '10987654321');
INSERT INTO veiculo VALUES ('Gol', 'Volkswagen', 2018, 'JKL3456', '98765432109');
INSERT INTO veiculo VALUES ('Uno', 'Fiat', 2017, 'MNO6789', '87654321098');
INSERT INTO veiculo VALUES ('HB20', 'Hyundai', 2019, 'PQR1234', '76543210987');
INSERT INTO veiculo VALUES ('Fiesta', 'Ford', 2020, 'STU5678', '65432109876');
INSERT INTO veiculo VALUES ('Onix', 'Chevrolet', 2019, 'VWX3456', '54321098765');
INSERT INTO veiculo VALUES ('Palio', 'Fiat', 2018, 'YZA6789', '43210987654');
INSERT INTO veiculo VALUES ('Sandero', 'Renault', 2020, 'BCD1234', '32109876543');
INSERT INTO veiculo VALUES ('Spin', 'Chevrolet', 2021, 'EFG5678', '21098765432');


INSERT INTO diagnostico VALUES (1, 'Correção realizada', 'Troca de óleo', 250);
INSERT INTO diagnostico VALUES (2, 'Correção pendente', 'Troca de pastilhas de freio', 400);
INSERT INTO diagnostico VALUES (3, 'Correção realizada', 'Alinhamento', 300);
INSERT INTO diagnostico VALUES (4, 'Correção pendente', 'Troca de amortecedores', 1200);
INSERT INTO diagnostico VALUES (5, 'Correção realizada', 'Revisão geral', 800);
INSERT INTO diagnostico VALUES (6, 'Correção pendente', 'Substituição de bateria', 450);
INSERT INTO diagnostico VALUES (7, 'Correção realizada', 'Troca de correia dentada', 600);
INSERT INTO diagnostico VALUES (8, 'Correção pendente', 'Troca de velas', 200);
INSERT INTO diagnostico VALUES (9, 'Correção realizada', 'Troca de filtro de ar', 150);
INSERT INTO diagnostico VALUES (10, 'Correção pendente', 'Troca de escapamento', 700);


INSERT INTO orcamento VALUES (250, 'Troca de óleo e filtro',('2023-01-15'), 1, 1);
INSERT INTO orcamento VALUES (400, 'Troca de pastilhas de freio',('2023-02-20'), 2, 2);
INSERT INTO orcamento VALUES (300, 'Alinhamento completo',('2023-03-10'), 3, 3);
INSERT INTO orcamento VALUES (1200, 'Troca de amortecedores',('2023-04-05'), 4, 4);
INSERT INTO orcamento VALUES (800, 'Revisão geral',('2023-05-12'), 5, 5);
INSERT INTO orcamento VALUES (450, 'Substituição de bateria',('2023-06-18'), 6, 6);
INSERT INTO orcamento VALUES (600, 'Troca de correia dentada',('2023-07-22'), 7, 7);
INSERT INTO orcamento VALUES (200, 'Troca de velas',('2023-08-11'), 8, 8);
INSERT INTO orcamento VALUES (150, 'Troca de filtro de ar',('2023-09-14'), 9, 9);
INSERT INTO orcamento VALUES (700, 'Troca de escapamento',('2023-10-09'), 10, 10);


INSERT INTO peca VALUES (1, 100, 50, 'Filtro de óleo');
INSERT INTO peca VALUES (2, 150, 30, 'Pastilhas de freio');
INSERT INTO peca VALUES (3, 80, 40, 'Amortecedores');
INSERT INTO peca VALUES (4, 60, 60, 'Correia dentada');
INSERT INTO peca VALUES (5, 50, 70, 'Filtro de ar');
INSERT INTO peca VALUES (6, 200, 20, 'Bateria');
INSERT INTO peca VALUES (7, 300, 15, 'Escapamento');
INSERT INTO peca VALUES (8, 120, 35, 'Velas de ignição');
INSERT INTO peca VALUES (9, 110, 25, 'Filtro de combustível');
INSERT INTO peca VALUES (10, 90, 45, 'Parafuso de roda');
       

INSERT INTO fornecedor VALUES (1, 'Rua das Peças, 123', '11987654321', '12345678000123');
INSERT INTO fornecedor VALUES (2, 'Avenida dos Freios, 456', '11976543210', '98765432000198');
INSERT INTO fornecedor VALUES (3, 'Estrada dos Amortecedores, 789', '11876543219', '11223344000100');
INSERT INTO fornecedor VALUES (4, 'Alameda das Correias, 101', '11765432198', '22334455000111');
INSERT INTO fornecedor VALUES (5, 'Travessa dos Filtros, 202', '11654321987', '33445566000122');
INSERT INTO fornecedor VALUES (6, 'Rodovia das Baterias, 303', '11543219876', '44556677000133');
INSERT INTO fornecedor VALUES (7, 'Rua dos Escapamentos, 404', '11432198765', '55667788000144');
INSERT INTO fornecedor VALUES (8, 'Avenida das Velas, 505', '11321987654', '66778899000155');
INSERT INTO fornecedor VALUES (9, 'Estrada dos Filtros, 606', '11219876543', '77889900000166');
INSERT INTO fornecedor VALUES (10, 'Alameda das Peças, 707', '11198765432', '88990011000177');


INSERT INTO estoque_peca VALUES (1, ('2023-01-01'),('2023-01-10'), 'Auto Peças Ltda', 1, 1);
INSERT INTO estoque_peca VALUES (2, ('2023-02-01'),('2023-02-10'), 'Freios Brasil', 2, 2);
INSERT INTO estoque_peca VALUES (3, ('2023-03-01'),('2023-03-10'), 'Amortecedores SA', 3, 3);
INSERT INTO estoque_peca VALUES (4, ('2023-04-01'),('2023-04-10'), 'Correias Import', 4, 4);
INSERT INTO estoque_peca VALUES (5, ('2023-05-01'),('2023-05-10'), 'Filtros LTDA', 5, 5);
INSERT INTO estoque_peca VALUES (6, ('2023-06-01'),('2023-06-10'), 'Baterias Ltda', 6, 6);
INSERT INTO estoque_peca VALUES (7, ('2023-07-01'),('2023-07-10'), 'Auto Escapamentos', 7, 7);
INSERT INTO estoque_peca VALUES (8, ('2023-08-01'),('2023-08-10'), 'Peças de Velas SA', 8, 8);
INSERT INTO estoque_peca VALUES (9, ('2023-09-01'),('2023-09-10'), 'Filtros Auto', 9, 9);
INSERT INTO estoque_peca VALUES (10,('2023-10-01'),('2023-10-10'), 'Morais Peça', 10, 10);
     
   
INSERT INTO pgto VALUES (1, 'Cartão de Crédito', 'À vista', 5.5);
INSERT INTO pgto VALUES (2, 'Boleto', 'À vista', 0.0);
INSERT INTO pgto VALUES (3, 'Cartão de Débito', 'À vista', 0.0);
INSERT INTO pgto VALUES (4, 'Transferência', 'À vista', 0.0);
INSERT INTO pgto VALUES (5, 'Pix', 'À vista', 0.0);
INSERT INTO pgto VALUES (6, 'Cartão de Crédito', 'Parcelado', 10.0);
INSERT INTO pgto VALUES (7, 'Boleto', 'Parcelado', 0.0);
INSERT INTO pgto VALUES (8, 'Cartão de Débito', 'À vista', 0.0);
INSERT INTO pgto VALUES (9, 'Transferência', 'Parcelado', 0.0);
INSERT INTO pgto VALUES (10, 'Pix', 'Parcelado', 0.0);       
       

INSERT INTO pgto_orcamento VALUES (1, 1);
INSERT INTO pgto_orcamento VALUES (2, 2);
INSERT INTO pgto_orcamento VALUES (3, 3);
INSERT INTO pgto_orcamento VALUES (4, 4);
INSERT INTO pgto_orcamento VALUES (5, 5);
INSERT INTO pgto_orcamento VALUES (6, 6);
INSERT INTO pgto_orcamento VALUES (7, 7);
INSERT INTO pgto_orcamento VALUES (8, 8);
INSERT INTO pgto_orcamento VALUES (9, 9);
INSERT INTO pgto_orcamento VALUES (10, 10);
INSERT INTO pgto_orcamento VALUES (1, 2);
INSERT INTO pgto_orcamento VALUES (2, 3);
INSERT INTO pgto_orcamento VALUES (3, 4);
INSERT INTO pgto_orcamento VALUES (4, 5);
INSERT INTO pgto_orcamento VALUES (5, 6);
INSERT INTO pgto_orcamento VALUES (6, 7);
INSERT INTO pgto_orcamento VALUES (7, 8);
INSERT INTO pgto_orcamento VALUES (8, 9);
INSERT INTO pgto_orcamento VALUES (9, 10);
INSERT INTO pgto_orcamento VALUES (10, 1);       


INSERT INTO servico_online VALUES ('Diagnóstico Automático de Problemas', 1, 'Web', 'Site', '12345678000123', '12345678901', 1, 1);
INSERT INTO servico_online VALUES ('Cadastro de Veículos para Diagnóstico', 2, 'Web', 'Telefone', '32659874521546', '10987654321', 2, 2);
INSERT INTO servico_online VALUES ('Relatório de Diagnóstico Completo', 3, 'Mobile', 'Site', '11223344000100', '98765432109', 3, 3);
INSERT INTO servico_online VALUES ('Consulta de Peças Disponíveis', 4, 'Web', 'Site', '22334455000111', '87654321098', 4, 4);
INSERT INTO servico_online VALUES ('Agendamento de Reparo', 5, 'Mobile', 'Telefone', '33445566000122', '76543210987', 5, 5);
INSERT INTO servico_online VALUES ('Histórico de Manutenção do Veículo', 6, 'Web', 'Site', '44556677000133', '65432109876', 6, 6);
INSERT INTO servico_online VALUES ('Solicitação de Orçamento Online', 7, 'Mobile', 'Site', '55667788000144', '54321098765', 7, 7);
INSERT INTO servico_online VALUES ('Notificações de Diagnóstico', 8, 'Web', 'Telefone', '66778899000155', '43210987654', 8, 8);
INSERT INTO servico_online VALUES ('Avaliação Prévia de Peças', 9, 'Web', 'Site', '77889900000166', '32109876543', 9, 9);
INSERT INTO servico_online VALUES ('Encaminhamento para Oficina', 10, 'Mobile', 'Telefone', '88990011000177', '21098765432', 10, 10);



SELECT nm_func, salario_func, funcao_func
FROM funcionario
ORDER BY salario_func DESC;

SELECT nm_cl, email_cl, telefone_cl
FROM cliente
ORDER BY nm_cl ASC;



SELECT nm_func, salario_func, (salario_func * 1.10) AS salario_aumentado
FROM funcionario;

SELECT nm_peca, preco_peca, (preco_peca * 0.95) AS preco_com_desconto
FROM peca;



SELECT nm_peca, SUM(qtd_peca) AS total_em_estoque
FROM peca
GROUP BY nm_peca;

SELECT funcao_func, COUNT(*) AS qtd_funcionarios
FROM funcionario
GROUP BY funcao_func;



SELECT placa_vl, modelo_vl, marca_vl
FROM veiculo
WHERE cliente_cpf_cl IN (SELECT cpf_cl FROM cliente);

SELECT nm_func, salario_func
FROM funcionario
WHERE salario_func > (SELECT AVG(salario_func) FROM funcionario);



SELECT o.id_orcamento, o.valor_servico, o.descricao_servico, d.problema_vl, d.resultado_vl
FROM orcamento o
JOIN diagnostico d ON o.diagnostico_id_diagnostico = d.id_diagnostico;

SELECT e.id_estoque, e.dta_entrada, e.dta_saida, p.nm_peca, f.endereco_forne
FROM estoque_peca e
JOIN peca p ON e.peca_id_peca = p.id_peca
JOIN fornecedor f ON e.fornecedor_id_fornecedor = f.id_fornecedor;




COMMIT;
