CREATE DATABASE IF NOT EXISTS Ecommerce_refinado;
USE Ecommerce_refinado;

CREATE TABLE IF NOT EXISTS CLIENTS(
	idCliente INT AUTO_INCREMENT PRIMARY KEY,
    Fname VARCHAR(100) NOT NULL, -- Aumentado o tamanho para evitar erros (baseado em interações anteriores)
    Minit CHAR(3),
    Lname VARCHAR(20),
    Address VARCHAR(255)
);

CREATE TABLE Clients_PJ(
	-- idCliente_PJ não é mais AUTO_INCREMENT, pois herda o ID do Cliente
    idCliente_PJ INT PRIMARY KEY, 
    CNPJ CHAR(15) NOT NULL UNIQUE,
    SocialName VARCHAR(255),
    -- CONSTRAINT: Garante exclusividade e integridade referencial
    CONSTRAINT fk_client_pj FOREIGN KEY (idCliente_PJ) REFERENCES CLIENTS(idCliente)
);
 
CREATE TABLE Clients_PF(
	-- idCliente_PF não é mais AUTO_INCREMENT, pois herda o ID do Cliente
    idCliente_PF INT PRIMARY KEY,
    CPF CHAR(11) NOT NULL UNIQUE,
    -- CONSTRAINT: Garante exclusividade e integridade referencial
    CONSTRAINT fk_client_pf FOREIGN KEY (idCliente_PF) REFERENCES CLIENTS(idCliente)
);

CREATE TABLE PAYMENTS_Client(
    idClient INT NOT NULL,
    idPayment INT NOT NULL,
    typePayment ENUM('Boleto', 'Cartão', 'Dois Cartões', 'PIX') NOT NULL,
    limitAvailable FLOAT, -- Para cartões de crédito
    PRIMARY KEY(idClient, idPayment),
    -- O Pagamento deve ser de um Cliente que exista na tabela CLIENTS
    CONSTRAINT fk_payment_client FOREIGN KEY (idClient) REFERENCES CLIENTS(idCliente)
);
CREATE TABLE PRODUCT(
	idProduct INT AUTO_INCREMENT PRIMARY KEY,
    Pname VARCHAR(100) NOT NULL,
    Classification_kids BOOL DEFAULT FALSE,
    Categoria ENUM('Eletrônico', 'Vestimenta', 'Brinquedos', 'Alimentos', 'Móveis') NOT NULL,
    Avaliacao FLOAT DEFAULT 0,
    Size VARCHAR(45)
);

CREATE TABLE orders(
	idOrder INT AUTO_INCREMENT PRIMARY KEY,
    idOrderClient INT, -- REMOVER O 'NOT NULL' AQUI
    idPaymentType INT, 
    orderStatus ENUM('cancelado', 'confirmado', 'em processamento') DEFAULT 'em processamento',
    sendValue FLOAT DEFAULT 10,
    orderDescription VARCHAR(255),
    paymentCash BOOL DEFAULT FALSE,
    CONSTRAINT fk_orders_client FOREIGN KEY (idOrderClient) REFERENCES CLIENTS(idCliente)
		ON UPDATE CASCADE
        ON DELETE SET NULL 
);

CREATE TABLE ProdStorage(
	idProdStorage INT AUTO_INCREMENT PRIMARY KEY,
    storageLocation VARCHAR(45),
    quantity INT DEFAULT 0
);	

CREATE TABLE supplier(
	idSupplier INT AUTO_INCREMENT PRIMARY KEY,
    SocialName VARCHAR(45) NOT NULL,
    CNPJ CHAR(15) NOT NULL UNIQUE,
    contact VARCHAR(11) NOT NULL
);	

CREATE TABLE seller(
	idSeller INT AUTO_INCREMENT PRIMARY KEY,
    SocialName VARCHAR(45) NOT NULL,
    abstName VARCHAR(45),
    CNPJ CHAR(15) NOT NULL,
    CPF CHAR(9),
    location VARCHAR(255),
    contact CHAR(11) NOT NULL,
    CONSTRAINT unique_cnpj_seller UNIQUE (CNPJ),
    CONSTRAINT unique_cpf_seller UNIQUE (CPF)
);

CREATE TABLE productSeller(
	idPseller INT,
    idPproduct INT,
    prodQuantity INT DEFAULT 1,
    PRIMARY KEY (idPseller, idPproduct),
    CONSTRAINT fk_prod_seller FOREIGN KEY (idPseller) REFERENCES seller(idSeller),
    CONSTRAINT fk_prod_product FOREIGN KEY (idPproduct) REFERENCES PRODUCT(idProduct)
);

CREATE TABLE productOrder(
	idPOproduct INT,
    idPOorder INT,
    poQuantity INT DEFAULT 1,
    poStatus ENUM('disponível', 'sem estoque') DEFAULT 'disponível',
    PRIMARY KEY (idPOproduct, idPOorder),
    CONSTRAINT fk_po_product FOREIGN KEY (idPOproduct) REFERENCES PRODUCT(idProduct),
    CONSTRAINT fk_po_order FOREIGN KEY (idPOorder) REFERENCES orders(idOrder)
);

CREATE TABLE storageLocation(
	idLproduct INT,
    idLstorage INT,
    location VARCHAR(255) NOT NULL,
    PRIMARY KEY (idLproduct, idLstorage),
    CONSTRAINT fk_sl_product FOREIGN KEY (idLproduct) REFERENCES PRODUCT(idProduct),
    CONSTRAINT fk_sl_storage FOREIGN KEY (idLstorage) REFERENCES ProdStorage(idProdStorage)
);
 
CREATE TABLE productSupplier(
	idPsSupplier INT,
    idPsProduct INT,
    quantity INT NOT NULL,
    PRIMARY KEY (idPsSupplier, idPsProduct),
    CONSTRAINT fk_ps_supplier FOREIGN KEY (idPsSupplier) REFERENCES supplier(idSupplier),
    CONSTRAINT fk_ps_product FOREIGN KEY (idPsProduct) REFERENCES PRODUCT(idProduct)
);


USE Ecommerce_refinado;

INSERT INTO CLIENTS (Fname, Minit, Lname, Address) VALUES
('Maria', 'M', 'Silva', 'rua silva de prata 29, Carangola - Cidade das Flores'), -- idCliente = 1
('Matheus', 'O', 'Pimentel', 'rua alameda 289, Centro - Cidade das Flores'),   -- idCliente = 2
('Ricardo', 'F', 'Silva', 'avenida alameda vinha 1009, Centro - Cidade das Flores'),  -- idCliente = 3
('Julia', 'S', 'França', 'rua larejiras 861, Centro - Cidade das Flores'),     -- idCliente = 4
('Roberta', 'G', 'Assis', 'avenidade koller 19, Centro - Cidade das Flores'),   -- idCliente = 5
('Isabela', 'W', 'Cruz', 'rua alameda das flores 28, Centro - Cidade das Flores'); -- idCliente = 6

INSERT INTO Clients_PF (idCliente_PF, CPF) VALUES
(1, '12346789'),
(2, '987654321'),
(3, '45678913'),
(4, '789123456'),
(5, '98745631'),
(6, '654789123');


INSERT INTO PRODUCT (Pname, classification_kids, Categoria, Avaliacao, Size) VALUES
('Fone de ouvido', 0, 'Eletrônico', 4, null), -- idProduct = 1
('Barbie Elsa', 1, 'Brinquedos', 3, null),    -- idProduct = 2
('Body Carters', 1, 'Vestimenta', 5, null),   -- idProduct = 3
('Microfone Vedo - Youtuber', 0, 'Eletrônico', 4, null), -- idProduct = 4
('Sofá retrátil', 0, 'Móveis', 3, '3x5X80'),  -- idProduct = 5
('Farinha de arroz', 0, 'Alimentos', 2, null), -- idProduct = 6
('Fire Stick Amazon', 0, 'Eletrônico', 3, null); -- idProduct = 7

INSERT INTO supplier (SocialName, CNPJ, contact) VALUES
('Almeida e Filhos', '123456789123456', '21985474'), -- idSupplier = 1
('Eletrônicos Silva', '854519649143457', '21985484'),  -- idSupplier = 2
('Eletrônicos Valma', '934567893934695', '21975474');  -- idSupplier = 3

INSERT INTO ProdStorage (storageLocation, quantity) VALUES
('Rio de Janeiro', 1000), -- idProdStorage = 1
('Rio de Janeiro', 500),  -- idProdStorage = 2
('São Paulo', 10),       -- idProdStorage = 3
('São Paulo', 100),      -- idProdStorage = 4
('São Paulo', 10),       -- idProdStorage = 5
('Brasília', 60);        -- idProdStorage = 6


INSERT INTO seller (SocialName, AbstName, CNPJ, CPF, location, contact) VALUES
('Tech eletronicos', NULL, '123456789456321', NULL, 'Rio de Janeiro', '219946287'), -- idSeller = 1
('Botique Durgas', NULL, '123456749456321', '12345678', 'Rio de Janeiro', '219567895'), -- idSeller = 2
('Kids World', NULL, '456789123654485', NULL, 'São Paulo', '119865748'); -- idSeller = 3


INSERT INTO orders (idOrderClient, orderStatus, orderDescription, sendValue, paymentCash) VALUES
(1, DEFAULT, 'compra via aplicativo', NULL, 1),  -- idOrder = 1
(2, DEFAULT, 'compra via aplicativo', 50.0, 0), -- idOrder = 2
(3, 'confirmado', NULL, 1, 1),                    -- idOrder = 3
(4, DEFAULT, 'compra via web site', 150.0, 0);   -- idOrder = 4

INSERT INTO productSeller (idPseller, idPproduct, prodQuantity) VALUES
(1, 6, 80),
(2, 7, 10);

INSERT INTO productSupplier (idPsSupplier, idPsProduct, quantity) VALUES
(1, 1, 500),
(2, 2, 400),
(3, 3, 633),
(1, 4, 5),
(2, 5, 10);

INSERT INTO storageLocation (idLproduct, idLstorage, location) VALUES
(1, 2, 'RJ'),
(2, 6, 'GO');

INSERT INTO productOrder (idPOproduct, idPOorder, poQuantity, poStatus) VALUES
(1, 1, 2, NULL),
(2, 3, 1, NULL),
(3, 4, 1, NULL);

desc clients;
desc clients_pf;

SELECT 
    C.Fname, 
    CPF.CPF,
    COUNT(O.idOrder) AS Number_of_orders
FROM 
    CLIENTS AS C
INNER JOIN 
    Clients_PF AS CPF ON C.idCliente = CPF.idCliente_PF 
LEFT JOIN 
    orders AS O ON C.idCliente = O.idOrderClient 
GROUP BY 
    C.idCliente, C.Fname, CPF.CPF
HAVING
    COUNT(O.idOrder) > 0  
ORDER BY 
    Number_of_orders DESC;