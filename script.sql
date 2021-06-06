drop table if exists Conto; 
drop table if exists Personale;
drop table if exists Fatture;
drop table if exists Ordini;
drop table if exists Fornitore;
drop table if exists Composta_da_bibite;
drop table if exists Composta_da_pizze;
drop table if exists Comanda;
drop table if exists Scontrino;
drop table if exists Pizze_Ingredienti;
drop table if exists Bibite;
drop table if exists Pizze;
drop table if exists Magazzino;
drop table if exists Tavolo;
drop table if exists Asporto;
drop table if exists Cliente;

create table Cliente (
	id_cliente SERIAL NOT NULL,
	tipo boolean NOT NULL,
	PRIMARY KEY (id_cliente)
);

create table Asporto (
	utente varchar(16) NOT NULL,
	password varchar(16) NOT NULL,
	nome varchar(16) NOT NULL,
	id_cliente int NOT NULL,
	PRIMARY KEY (utente, id_cliente),
	FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente) ON UPDATE CASCADE ON DELETE CASCADE
);

create table Tavolo (
	n_tavolo int NOT NULL,
	n_coperti int NOT NULL,
	id_cliente int NOT NULL,
	id_cameriere int NOT NULL,
	PRIMARY KEY (n_tavolo),
	FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente) ON UPDATE CASCADE ON DELETE CASCADE
);
create table Magazzino (
	prodotto varchar(32) NOT NULL,
	bibita_o_ingrediente boolean NOT NULL,
	quantita int NOT NULL,
	scorta_min int NOT NULL,
	importo decimal(4,2) NOT NULL,
	PRIMARY KEY (prodotto)
);

create table Pizze (
	nome varchar(32) NOT NULL,
	importo decimal(4,2) NOT NULL,
	PRIMARY KEY (nome)
);

create table Bibite (
	nome varchar(32) NOT NULL,
	importo decimal(4,2) NOT NULL,
	PRIMARY KEY (nome),
	FOREIGN KEY (nome) REFERENCES Magazzino(prodotto) ON UPDATE CASCADE ON DELETE CASCADE
);

create table Pizze_Ingredienti (
	nome varchar(32) NOT NULL,
	ingrediente varchar(32) NOT NULL,
	PRIMARY KEY (nome, ingrediente),
	FOREIGN KEY (nome) REFERENCES Pizze(nome),
	FOREIGN KEY (ingrediente) REFERENCES Magazzino(prodotto) ON UPDATE CASCADE ON DELETE CASCADE
);

create table Scontrino (
	n_scontrino int NOT NULL,
	id_cliente int NOT NULL UNIQUE,
	data timestamp NOT NULL,
	prezzo_pizza decimal(6,2),
	prezzo_bibite decimal(6,2),
	PRIMARY KEY (n_scontrino)
);

create table Comanda (
	id_comanda SERIAL NOT NULL,
	nome_pizza varchar(32) NOT NULL,
	nome_bibita varchar(32),
	id_cliente int NOT NULL,
	quantita int NOT NULL,
	PRIMARY KEY (id_comanda),
	FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (id_cliente) REFERENCES Scontrino(id_cliente) ON UPDATE CASCADE ON DELETE CASCADE
);

create table Composta_da_pizze (
	comanda_id int NOT NULL,
	nome_pizza varchar(32) NOT NULL,
	PRIMARY KEY(comanda_id, nome_pizza),
	FOREIGN KEY(comanda_id) REFERENCES Comanda(id_comanda) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY(nome_pizza) REFERENCES Pizze(nome) ON UPDATE CASCADE ON DELETE CASCADE
);

create table Composta_da_bibite (
	comanda_id int NOT NULL,
	nome_bibita varchar(32) NOT NULL,
	PRIMARY KEY(comanda_id, nome_bibita),
	FOREIGN KEY(comanda_id) REFERENCES Comanda(id_comanda) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY(nome_bibita) REFERENCES Bibite(nome) ON UPDATE CASCADE ON DELETE CASCADE
);

create table Fornitore (
	p_iva char(11) NOT NULL,
	ragione_sociale varchar(32),
	indirizzo varchar(32),
	PRIMARY KEY (p_iva)
);

create table Ordini (
	id_ordine SERIAL NOT NULL,
	fornitore char(11) NOT NULL,
	quantita int NOT NULL,
	prodotto varchar(32) NOT NULL,
	bibita_o_ingrediente boolean NOT NULL,
	data timestamp NOT NULL,
	PRIMARY KEY (id_ordine),
	FOREIGN KEY (fornitore) REFERENCES Fornitore(p_iva) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (prodotto) REFERENCES Magazzino(prodotto) ON UPDATE CASCADE ON DELETE CASCADE
);

create table Fatture (
	n_fattura int NOT NULL,
	bibita_o_ingrediente boolean NOT NULL,
	fornitore char(11) NOT NULL,
	data timestamp NOT NULL,
	importo decimal(6,2) NOT NULL,
	id_ordine int NOT NULL,
	PRIMARY KEY (n_fattura),
	FOREIGN KEY (fornitore) REFERENCES Fornitore(p_iva) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (id_ordine) REFERENCES Ordini(id_ordine) ON UPDATE CASCADE ON DELETE CASCADE
);

create table Personale (
	id_personale SERIAL NOT NULL,
	nome varchar(16) NOT NULL,
	cognome varchar(16) NOT NULL,
	stipendio decimal(7,2) NOT NULL,
	mance decimal(4,2),
	PRIMARY KEY (id_personale)
);

create table Conto (
	id_operazione SERIAL NOT NULL,
	tipo boolean NOT NULL,
	data timestamp NOT NULL,
	n_fattura int,
	n_scontrino int,
	importo decimal(6,2) NOT NULL,
	salario int,
	PRIMARY KEY (id_operazione),
	FOREIGN KEY (n_fattura) REFERENCES Fatture(n_fattura) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (n_scontrino) REFERENCES Scontrino(n_scontrino) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (salario) REFERENCES Personale(id_personale) ON UPDATE CASCADE ON DELETE CASCADE
);

insert into Cliente(tipo) VALUES /* TRUE = Tavolo, FALSE = Asporto */
(TRUE),
(TRUE),
(FALSE),
(FALSE),
(TRUE),
(TRUE),
(FALSE);


insert into Asporto(utente,password,nome,id_cliente) VALUES
('ginny46','qwerty','Ginevra',03),
('alby','asdfghjkl','Alberto',04),
('franco68','ihdfjcbx','Franco',07);

insert into Tavolo(n_tavolo,n_coperti,id_cliente,id_cameriere) VALUES
(45,5,01,02),
(14,4,02,02),
(23,8,05,05),
(52,3,06,05);


insert into Magazzino(prodotto,bibita_o_ingrediente,quantita,scorta_min,importo) VALUES  /* True = Bibita, False = Ingrediente */
('pomodoro',FALSE,500,250,0.50),
('mozzarella',FALSE,500,250,0.50),
('mozzarella di bufala',FALSE,200,50,1.00),
('origano',FALSE,200,50,0.50),
('asparagi',FALSE,150,50,1.00),
('grana',FALSE,200,75,0.50),
('uovo',FALSE,30,15,1.00),
('panna',FALSE,20,5,0.50),
('salamino',FALSE,200,75,1.00),
('frutti di mare',FALSE,50,10,1.50),
('melanzane',FALSE,200,70,1.00),
('zucchine',FALSE,200,70,1.00),
('pancetta',FALSE,150,50,1.50),
('misto funghi',FALSE,150,30,1.50),
('prezzemolo',FALSE,30,5,0.50),
('acciughe',FALSE,100,25,1.50),
('capperi',FALSE,100,25,1.50),
('olive nere',FALSE,150,50,1.00),
('salsiccia',FALSE,150,75,1.00),
('cipolla',FALSE,150,50,1.00),
('tonno',FALSE,100,40,1.50),
('gorgonzola',FALSE,60,25,1.00),
('patate fritte',FALSE,150,70,1.00),
('asiago',FALSE,100,30,1.00),
('prosciutto cotto',FALSE,200,100,1.00),
('funghi',FALSE,250,150,1.00),
('carciofi',FALSE,150,50,1.00),
('speck',FALSE,100,30,1.50),
('prosciutto crudo',FALSE,100,40,1.50),
('spinaci',FALSE,100,40,0.50),
('peperoni',FALSE,200,75,1.00),
('carote',FALSE,150,50,0.50),
('gamberetti',FALSE,70,20,1.50),
('porcini',FALSE,100,40,1.50),
('gamberoni',FALSE,50,20,2.00),
('wurstel',FALSE,200,75,1.00),
('radicchio',FALSE,250,100,2.00),
('pomodorini',FALSE,75,20,1.00),
('rucola',FALSE,30,5,0.50),
('patate lesse',FALSE,40,10,1.00),
('crema di salmone e zucchine',FALSE,15,5,1.50),
('vongole',FALSE,20,5,2.00),
('cozze',FALSE,20,5,2.00),
('crema di zucca',FALSE,25,5,1.50),
('olive verdi',FALSE,25,5,1.00),
('acqua naturale 1.5L',TRUE,200,100,2.50),
('acqua frizzante 1.5L',TRUE,150,70,2.50),
('coca-cola 0.33L',TRUE,200,100,2.50),
('coca-cola 0.5L',TRUE,200,100,4.50),
('te al limone 0.33L',TRUE,150,75,2.30),
('te al limone 0.5L',TRUE,150,75,4.00),
('te alla pesca 0.33L',TRUE,150,75,2.30),
('te alla pesca 0.5L',TRUE,150,75,4.00),
('fanta 0.33L',TRUE,200,100,2.50),
('fanta 0.5L',TRUE,200,100,4.50),
('sprite 0.33L',TRUE,150,50,2.50),
('sprite 0.5L',TRUE,150,50,4.00),
('birra bionda 0.3L',TRUE,200,100,2.70),
('birra bionda 0.5L',TRUE,300,100,5.00),
('birra rossa 0.3L',TRUE,200,100,3.00),
('birra rossa 0.5L',TRUE,300,100,5.50),
('vino rosso 1L',TRUE,200,100,7.00),
('vino bianco 1L',TRUE,200,100,7.50),
('gingerino',TRUE,70,50,2.00),
('spritz',TRUE,250,100,2.50),
('succhi di frutta',TRUE,150,50,3.00);

insert into Pizze(nome,importo) VALUES
('Margherita',4.00),
('Bufala',4.50),
('Marinara',3.00),
('Asparagi',5.50),
('Bassanese',6.50),
('Carbonara',7.00),
('Diavola',5.50),
('Frutti di mare',6.50),
('Melanzane',5.50),
('Zucchine',5.50),
('Emiliana',6.50),
('Monferina',7.50),
('Napoletana',6.00),
('Romana',6.50),
('Siciliana',7.50),
('Trentina',6.50),
('Tonno e cipolla',6.50),
('Olandese',7.00),
('Pugliese',5.50),
('Patatosa',5.00),
('4 formaggi',6.50),
('Quattro stagioni',7.00),
('Rustica',6.50),
('San Daniele',6.50),
('Vegetariana',7.50),
('Zucchine e gamberetti',6.50),
('Porcini',6.00),
('Porcini e gamberoni',8.00),
('Prosciutto',6.00),
('Prosciutto e funghi',6.50),
('Capricciosa',7.00),
('Viennese',5.00),
('Trevigiana',7.00),
('Veneta',8.00),
('Vulcano',8.50),
('Patapizza trentina',7.50),
('Perla di mare',9.00),
('Zucca',8.50);

insert into Bibite(nome,importo) VALUES
('acqua naturale 1.5L',2.50),
('acqua frizzante 1.5L',2.50),
('coca-cola 0.33L',2.50),
('coca-cola 0.5L',4.50),
('te al limone 0.33L',2.30),
('te al limone 0.5L',4.00),
('te alla pesca 0.33L',2.30),
('te alla pesca 0.5L',4.00),
('fanta 0.33L',2.50),
('fanta 0.5L',4.50),
('sprite 0.33L',2.50),
('sprite 0.5L',4.00),
('birra bionda 0.3L',2.70),
('birra bionda 0.5L',5.00),
('birra rossa 0.3L',3.00),
('birra rossa 0.5L',5.50),
('vino rosso 1L',7.00),
('vino bianco 1L',7.50),
('gingerino',2.00),
('spritz',2.50),
('succhi di frutta',3.00);

insert into Pizze_Ingredienti(nome,ingrediente) VALUES
('Margherita','pomodoro'),
('Margherita','mozzarella'),
('Bufala','pomodoro'),
('Bufala','mozzarella di bufala'),
('Marinara','pomodoro'),
('Marinara','origano'),
('Asparagi','pomodoro'),
('Asparagi','mozzarella'),
('Asparagi','asparagi'),
('Asparagi','grana'),
('Bassanese','pomodoro'),
('Bassanese','mozzarella'),
('Bassanese','asparagi'),
('Bassanese','uovo'),
('Bassanese','grana'),
('Carbonara','pomodoro'),
('Carbonara','mozzarella'),
('Carbonara','pancetta'),
('Carbonara','uovo'),
('Carbonara','panna'),
('Carbonara','grana'),
('Diavola','pomodoro'),
('Diavola','mozzarella'),
('Diavola','salamino'),
('Frutti di mare','pomodoro'),
('Frutti di mare','mozzarella'),
('Frutti di mare','frutti di mare'),
('Melanzane','pomodoro'),
('Melanzane','mozzarella'),
('Melanzane','melanzane'),
('Melanzane','grana'),
('Zucchine','pomodoro'),
('Zucchine','mozzarella'),
('Zucchine','zucchine'),
('Zucchine','grana'),
('Emiliana','pomodoro'),
('Emiliana','mozzarella'),
('Emiliana','zucchine'),
('Emiliana','melanzane'),
('Emiliana','grana'),
('Monferina','pomodoro'),
('Monferina','mozzarella'),
('Monferina','pancetta'),
('Monferina','misto funghi'),
('Monferina','grana'),
('Monferina','prezzemolo'),
('Napoletana','pomodoro'),
('Napoletana','mozzarella'),
('Napoletana','acciughe'),
('Romana','pomodoro'),
('Romana','mozzarella'),
('Romana','acciughe'),
('Romana','capperi'),
('Siciliana','pomodoro'),
('Siciliana','mozzarella'),
('Siciliana','acciughe'),
('Siciliana','capperi'),
('Siciliana','olive nere'),
('Siciliana','origano'),
('Trentina','pomodoro'),
('Trentina','mozzarella'),
('Trentina','salsiccia'),
('Trentina','cipolla'),
('Tonno e cipolla','pomodoro'),
('Tonno e cipolla','mozzarella'),
('Tonno e cipolla','tonno'),
('Tonno e cipolla','cipolla'),
('Olandese','pomodoro'),
('Olandese','mozzarella'),
('Olandese','tonno'),
('Olandese','cipolla'),
('Olandese','gorgonzola'),
('Pugliese','pomodoro'),
('Pugliese','mozzarella'),
('Pugliese','cipolla'),
('Patatosa','pomodoro'),
('Patatosa','mozzarella'),
('Patatosa','patate fritte'),
('4 formaggi','pomodoro'),
('4 formaggi','mozzarella'),
('4 formaggi','asiago'),
('4 formaggi','gorgonzola'),
('4 formaggi','grana'),
('Quattro stagioni','pomodoro'),
('Quattro stagioni','mozzarella'),
('Quattro stagioni','prosciutto cotto'),
('Quattro stagioni','funghi'),
('Quattro stagioni','carciofi'),
('Quattro stagioni','asparagi'),
('Rustica','pomodoro'),
('Rustica','mozzarella'),
('Rustica','gorgonzola'),
('Rustica','speck'),
('San Daniele','pomodoro'),
('San Daniele','mozzarella'),
('San Daniele','prosciutto crudo'),
('Vegetariana','pomodoro'),
('Vegetariana','mozzarella'),
('Vegetariana','melanzane'),
('Vegetariana','zucchine'),
('Vegetariana','spinaci'),
('Vegetariana','peperoni'),
('Vegetariana','carote'),
('Zucchine e gamberetti','pomodoro'),
('Zucchine e gamberetti','mozzarella'),
('Zucchine e gamberetti','zucchine'),
('Zucchine e gamberetti','gamberetti'),
('Porcini','pomodoro'),
('Porcini','mozzarella'),
('Porcini','porcini'),
('Porcini','prezzemolo'),
('Porcini e gamberoni','pomodoro'),
('Porcini e gamberoni','mozzarella'),
('Porcini e gamberoni','porcini'),
('Porcini e gamberoni','gamberoni'),
('Porcini e gamberoni','prezzemolo'),
('Prosciutto','pomodoro'),
('Prosciutto','mozzarella'),
('Prosciutto','prosciutto cotto'),
('Prosciutto e funghi','pomodoro'),
('Prosciutto e funghi','mozzarella'),
('Prosciutto e funghi','prosciutto cotto'),
('Prosciutto e funghi','funghi'),
('Capricciosa','pomodoro'),
('Capricciosa','mozzarella'),
('Capricciosa','prosciutto cotto'),
('Capricciosa','funghi'),
('Capricciosa','carciofi'),
('Viennese','pomodoro'),
('Viennese','mozzarella'),
('Viennese','wurstel'),
('Trevigiana','pomodoro'),
('Trevigiana','mozzarella'),
('Trevigiana','radicchio'),
('Trevigiana','grana'),
('Veneta','pomodoro'),
('Veneta','mozzarella'),
('Veneta','pancetta'),
('Veneta','radicchio'),
('Veneta','gorgonzola'),
('Veneta','grana'),
('Vulcano','pomodoro'),
('Vulcano','mozzarella'),
('Vulcano','acciughe'),
('Vulcano','capperi'),
('Vulcano','salamino'),
('Vulcano','speck'),
('Vulcano','pomodorini'),
('Vulcano','rucola'),
('Patapizza trentina','mozzarella'),
('Patapizza trentina','patate lesse'),
('Patapizza trentina','salsiccia'),
('Patapizza trentina','grana'),
('Perla di mare','crema di salmone e zucchine'),
('Perla di mare','mozzarella'),
('Perla di mare','gamberoni'),
('Perla di mare','vongole'),
('Perla di mare','cozze'),
('Zucca','crema di zucca'),
('Zucca','mozzarella'),
('Zucca','gorgonzola'),
('Zucca','speck');

insert into Scontrino(n_scontrino,id_cliente,data,prezzo_pizza,prezzo_bibite) VALUES
(01,03,'2020-12-20 19:01:45',26.00,NULL),
(02,04,'2020-12-20 19:05:32',24.00,NULL),
(03,07,'2020-12-20 19:15:17',25.50,NULL),
(04,02,'2020-12-20 19:37:48',22.00,10.50),
(05,01,'2020-12-20 19:43:56',27.50,16.30),
(06,06,'2020-12-20 20:02:19',21.00,8.50),
(07,05,'2020-12-20 20:15:31',60.00,35.00);

insert into Comanda(nome_pizza,nome_bibita,id_cliente,quantita) VALUES
('Prosciutto e funghi','te al limone 0.33L',01,2),
('Capricciosa','birra bionda 0.3L',01,1),
('Siciliana','coca-cola 0.5L',01,2),
('Patatosa','fanta 0.33L',02,2),
('Diavola','birra rossa 0.3L',02,1),
('Prosciutto e funghi','acqua naturale 1.5L',02,1),
('Frutti di mare',NULL,03,2),
('Trentina',NULL,03,1),
('Rustica',NULL,03,2),
('Vegetariana',NULL,04,1),
('Porcini',NULL,04,2),
('Bufala',NULL,04,1),
('Patapizza trentina','te alla pesca 0.5L',05,2),
('Trevigiana','birra bionda 0.5L',05,3),
('Perla di mare','acqua frizzante 1.5L',05,1),
('Veneta','vino rosso 1L',05,1),
('Olandese','coca-cola 0.33L',05,1),
('Patatosa','sprite 0.33L',06,1),
('Porcini e gamberoni','birra rossa 0.3L',06,2),
('Zucca',NULL,07,2),
('Vulcano',NULL,07,1);


insert into Fornitore(p_iva,ragione_sociale,indirizzo) VALUES
('00075625478','Bevo e non bevo S.p.A.','Otranto via Acerri 14'),
('66548213048','Latterie Venete S.n.c.','Padova via G.Cesare 72'),
('96421336544','Salumi Berreta S.n.c.','Vicenza via Zaccaria 17'),
('14569875325','Cuor di Nalga S.p.A','Treviso via Cavour 68');

insert into Ordini(fornitore,quantita,prodotto,bibita_o_ingrediente,data) VALUES /* TRUE = BIBITA, FALSE = INGREDIENTE */
('66548213048',300,'mozzarella',FALSE,'2020-12-07 15:43:12'),
('96421336544',75,'salsiccia',FALSE,'2020-12-07 16:03:43'),
('00075625478',50,'gingerino',TRUE,'2020-12-09 09:35:47'),
('00075625478',150,'coca-cola 0.33L',TRUE,'2020-12-09 10:54:34'),
('00075625478',200,'acqua naturale 1.5L',TRUE,'2020-12-09 10:57:43'),
('00075625478',200,'birra bionda 0.5L',TRUE,'2020-12-09 11:09:23'),
('14569875325',80,'asiago',FALSE,'2020-12-10 13:46:38');



insert into Fatture(n_fattura,bibita_o_ingrediente,fornitore,data,importo,id_ordine) VALUES /* TRUE = BIBITA, FALSE = INGREDIENTE */
(01,TRUE,'00075625478','2020-12-12 16:31:45',200.00,04),
(02,TRUE,'00075625478','2020-12-12 16:38:25',200.00,05),
(03,TRUE,'00075625478','2020-12-12 16:45:00',150.00,03),
(04,TRUE,'00075625478','2020-12-15 17:27:03',100.00,07),
(05,FALSE,'66548213048','2020-12-13 11:24:45',300.00,01),
(06,FALSE,'14569875325','2020-12-13 15:18:29',80.00,06),
(07,FALSE,'96421336544','2020-12-14 17:48:11',75.00,02);


insert into Personale(id_personale,nome,cognome,stipendio,mance) VALUES
(01,'Alberto','Morandin',647.45,NULL),
(02,'Gessica','Albino',435.50,10.00),
(03,'Franco','Abate',351.80,NULL),
(04,'Alberto','Tigullio',556.65,NULL),
(05,'Irene','Del Vecchio',475.90,7.00);

insert into Conto(tipo,data,n_fattura,n_scontrino,importo,salario) VALUES /* TRUE = Entrata, FALSE = Uscita */
(FALSE,'2020-12-12 16:31:45',01,NULL,200.00,NULL),
(FALSE,'2020-12-12 16:38:25',02,NULL,200.00,NULL),
(FALSE,'2020-12-12 16:45:00',03,NULL,150.00,NULL),
(FALSE,'2020-12-13 11:24:45',04,NULL,300.00,NULL),
(FALSE,'2020-12-13 15:18:42',05,NULL,80.00,NULL),
(FALSE,'2020-12-14 17:48:11',06,NULL,75.00,NULL),
(FALSE,'2020-12-15 17:23:03',07,NULL,100.00,NULL),
(TRUE,'2020-12-20 19:01:45',NULL,01,26.00,NULL),
(TRUE,'2020-12-20 19:05:32',NULL,02,24.00,NULL),
(TRUE,'2020-12-20 19:15:17',NULL,03,25.50,NULL),
(TRUE,'2020-12-20 19:37:48',NULL,04,32.50,NULL),
(TRUE,'2020-12-20 19:43:56',NULL,05,43.80,NULL),
(TRUE,'2020-12-20 20:02:19',NULL,06,29.50,NULL),
(TRUE,'2020-12-20 20:15:31',NULL,07,95.00,NULL),
(FALSE,'2021-01-10 09:02:26',NULL,NULL,647.45,01),
(FALSE,'2021-01-10 09:09:58',NULL,NULL,435.50,02),
(FALSE,'2021-01-10 09:15:14',NULL,NULL,351.80,03),
(FALSE,'2021-01-10 09:19:32',NULL,NULL,556.65,04),
(FALSE,'2021-01-10 09:25:43',NULL,NULL,475.90,05); 






/* QUERY PER LE INTERROGAZIONI */

/* QUERY 1: */

select DATE(Scontrino.data) as Date, (sum(prezzo_pizza) + sum(prezzo_bibite) + 
sum(COALESCE(n_coperti*1.50,0))) AS ricavo_totale FROM Scontrino 
FULL JOIN Tavolo ON Scontrino.id_cliente = Tavolo.id_cliente 
WHERE DATE(Scontrino.data) = '2020-12-20' 
group by Date


/* QUERY 2: */

select pi.nome, Ordini.prodotto from Pizze_Ingredienti as pi 
full join Magazzino on pi.ingrediente = Magazzino.prodotto 
full join Ordini on Magazzino.prodotto = Ordini.prodotto 
where Ordini.data = (select MAX(Ordini.data) from Ordini)


/* QUERY 3: */

select c.importo, forn.ragione_sociale, p.cognome, c.data 
from Personale p right join Conto c on p.id_personale = c.salario 
full join Fatture on c.n_fattura = Fatture.n_fattura 
left join Fornitore forn on Fatture.fornitore = forn.p_iva 
where c.importo >= 200


/* QUERY 4: */

select m.prodotto, SUM(c.quantita) as sum_quantita, 
(m.quantita - SUM(c.quantita)) as prodotti_rimanenti 
from Scontrino s full join Comanda c on s.id_cliente = c.id_cliente 
full outer join Bibite b on c.nome_bibita = b.nome 
full outer join Pizze p on c.nome_pizza = p.nome 
left join Pizze_Ingredienti pi on p.nome = pi.nome 
left join Magazzino m on pi.ingrediente = m.prodotto or b.nome = m.prodotto 
where m.prodotto is not null and c.quantita is not null and DATE(s.data) = '2020-12-20' 
group by m.prodotto 
order by m.prodotto asc


/* QUERY 5: */

SELECT c.id_cliente, a.nome, t.n_tavolo 
FROM Comanda c JOIN Asporto a ON c.id_cliente = a.id_cliente 
LEFT JOIN Tavolo t ON c.id_cliente = t.id_cliente 
WHERE c.nome_pizza = 'Rustica'


/* QUERY 6: */

select ft.n_fattura, m.prodotto, m.quantita, ft.fornitore 
from Fatture ft join Ordini o on ft.id_ordine = o.id_ordine 
join Magazzino m on o.prodotto = m.prodotto 
where m.bibita_o_ingrediente = TRUE and m.quantita = (select MIN(m.quantita) 
														from Magazzino m 
														where m.bibita_o_ingrediente = TRUE)


/* INDICI */

/* INDICE SU FATTURE */

drop index if exists ricerche_su_fatture;
create index ricerche_su_fatture on Fatture(n_fattura, fornitore, importo);


/* INDICE SU SCONTRINO */

drop index if exists ricerche_su_scontrini;
create index ricerche_su_scontrini on Scontrino(n_scontrino, prezzo_pizza, prezzo_bibite, data);