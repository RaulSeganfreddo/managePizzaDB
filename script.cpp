#include<cstdio>
#include<iostream>
#include<fstream>
#include"./dependences/include/libpq-fe.h"
#define PG_HOST "127.0.0.1"
#define PG_USER "postgres" // CHANGE_THIS
#define PG_DB "Pizzeria" //CHANGE_THIS
#define PG_PASS "PASS" // CHANGE_THIS
#define PG_PORT 5432 // CHANGE_THIS

using namespace std;

void checkResults(PGresult* res, const PGconn* conn) {
	if (PQresultStatus(res) != PGRES_TUPLES_OK) {
		cout << " Risultati inconsistenti !" << PQerrorMessage(conn) << endl;
		PQclear(res);
		exit(1);
	}
}




int main() {

	char conninfo[250];

	sprintf_s(conninfo, " user =%s password =%s dbname =%s hostaddr =%s port =%d",
		PG_USER, PG_PASS, PG_DB, PG_HOST, PG_PORT);

	PGconn* conn = PQconnectdb(conninfo);
	
	if (PQstatus(conn) != CONNECTION_OK) {
		cout << " Errore di connessione \n" << PQerrorMessage(conn);
		PQfinish(conn);
		exit(1);
	}

	cout << " Connessione avvenuta correttamente " << endl;
	
	cout << " Query 1: " << endl;
	cout << "Mostrare a schermo data e importo del ricavo giornaliero di una data scelta." << endl;
	PGresult* res;
	res = PQexec(conn, "select DATE(Scontrino.data) as Date, (sum(prezzo_pizza) + sum(prezzo_bibite) + sum(COALESCE(n_coperti*1.50,0))) AS ricavo_totale FROM Scontrino FULL JOIN Tavolo ON Scontrino.id_cliente = Tavolo.id_cliente WHERE DATE(Scontrino.data) = '2020-12-20' group by Date");

	checkResults(res, conn);
	
	int tuple = PQntuples(res);
	int campi = PQnfields(res);


	char str[200];
	// Stampo intestazioni
	for (int i = 0; i < campi; ++i)
	{
		sprintf_s(str, "%-30.30s ", PQfname(res, i));
		cout << str;
	}
	cout << endl;

	// Stampo i valori selezionati
	for (int i = 0; i < tuple; ++i)
	{
		for (int j = 0; j < campi; ++j)
		{
			sprintf_s(str, "%-30.30s ", PQgetvalue(res, i, j));
			cout << str;
		}
		cout << endl;
	}
	cout << endl;


	PQclear(res);

	cout << endl;
	cout << endl;
	cout << " Query 2: " << endl;
	cout << endl;
	cout << "Mostrare a video quali pizze contengono l'ultimo ingrediente che e' stato ordinato." << endl;
	cout << endl;
	res = PQexec(conn, "select pi.nome, Ordini.prodotto from Pizze_Ingredienti as pi full join Magazzino on pi.ingrediente = Magazzino.prodotto full join Ordini on Magazzino.prodotto = Ordini.prodotto where Ordini.data = (select MAX(Ordini.data) from Ordini)");

	checkResults(res, conn);

	tuple = PQntuples(res);
	campi = PQnfields(res);


	// Stampo intestazioni
	for (int i = 0; i < campi; ++i)
	{
		sprintf_s(str, "%-30.30s ", PQfname(res, i));
		cout << str;
	}
	cout << endl;

	// Stampo i valori selezionati
	for (int i = 0; i < tuple; ++i)
	{
		for (int j = 0; j < campi; ++j)
		{
			sprintf_s(str, "%-30.30s ", PQgetvalue(res, i, j));
			cout << str;
		}
		cout << endl;
	}
	cout << endl;

	PQclear(res);

	cout << endl;
	cout << endl;
	cout << " Query 3: " << endl;
	cout << endl;
	cout << "Ricavare ragione sociale del fornitore o cognome del dipendente nel caso l'importo versato dal conto del locale sia uguale o superiore a 200 euro." << endl;
	cout << endl;
	res = PQexec(conn, "select c.importo, forn.ragione_sociale, p.cognome, c.data from Personale p right join Conto c on p.id_personale = c.salario full join Fatture on c.n_fattura = Fatture.n_fattura left join Fornitore forn on Fatture.fornitore = forn.p_iva where c.importo >= 200");

	checkResults(res, conn);

	tuple = PQntuples(res);
	campi = PQnfields(res);


	// Stampo intestazioni
	for (int i = 0; i < campi; ++i)
	{
		sprintf_s(str, "%-25.25s ", PQfname(res, i));
		cout << str;
	}
	cout << endl;

	// Stampo i valori selezionati
	for (int i = 0; i < tuple; ++i)
	{
		for (int j = 0; j < campi; ++j)
		{
			sprintf_s(str, "%-25.25s ", PQgetvalue(res, i, j));
			cout << str;
		}
		cout << endl;
	}
	cout << endl;

	PQclear(res);

	cout << endl;
	cout << endl;
	cout << " Query 4 " << endl;;
	cout << endl;
	cout << "Mostrare a schermo il numero di prodotti consumati in un determinato giorno e il numero di prodotti rimanenti in magazzino, ordinati per prodotto in ordine alfabetico." << endl;
	cout << endl;
	
	res = PQexec(conn, "select m.prodotto, SUM(c.quantita) as sum_quantita, (m.quantita - SUM(c.quantita)) as prodotti_rimanenti from Scontrino s full join Comanda c on s.id_cliente = c.id_cliente full outer join Bibite b on c.nome_bibita = b.nome full outer join Pizze p on c.nome_pizza = p.nome left join Pizze_Ingredienti pi on p.nome = pi.nome left join Magazzino m on pi.ingrediente = m.prodotto or b.nome = m.prodotto where m.prodotto is not null and c.quantita is not null and DATE(s.data) = '2020-12-20' group by m.prodotto order by m.prodotto asc");

	checkResults(res, conn);

	tuple = PQntuples(res);
	campi = PQnfields(res);


	// Stampo intestazioni
	for (int i = 0; i < campi; ++i)
	{
		sprintf_s(str, "%-30.30s ", PQfname(res, i));
		cout << str;
	}
	cout << endl;

	// Stampo i valori selezionati
	for (int i = 0; i < tuple; ++i)
	{
		for (int j = 0; j < campi; ++j)
		{
			sprintf_s(str, "%-30.30s ", PQgetvalue(res, i, j));
			cout << str;
		}
		cout << endl;
	}
	cout << endl;

	PQclear(res);

	cout << endl;
	cout << endl;
	cout << " Query 5 " << endl;
	cout << endl;
	cout << "Data una pizza che e' stata ordinata (Rustica in questo esempio), trovare se il cliente che ha ordinato questa pizza e' presente in sala o ha ordinato d'asporto. Mostrare a schermo rispettivamente numero del tavolo o nome del cliente." << endl;
	cout << endl;
	res = PQexec(conn, "SELECT c.id_cliente, a.nome, t.n_tavolo FROM Comanda c JOIN Asporto a ON c.id_cliente = a.id_cliente LEFT JOIN Tavolo t ON c.id_cliente = t.id_cliente WHERE c.nome_pizza = 'Rustica' ");

	checkResults(res, conn);

	tuple = PQntuples(res);
	campi = PQnfields(res);


	// Stampo intestazioni
	for (int i = 0; i < campi; ++i)
	{
		sprintf_s(str, "%-20.20s ", PQfname(res, i));
		cout << str;
	}
	cout << endl;

	// Stampo i valori selezionati
	for (int i = 0; i < tuple; ++i)
	{
		for (int j = 0; j < campi; ++j)
		{
			sprintf_s(str, "%-20.20s ", PQgetvalue(res, i, j));
			cout << str;
		}
		cout << endl;
	}
	cout << endl;

	PQclear(res);

	cout << endl;
	cout << endl;
	cout << " Query 6 " << endl;
	cout << endl;
	cout << "Trovata la bibita avente quantita' minore nel magazzino, stampare a video qual e' la fattura relativa all'ordine di quel prodotto, qual era la quantita' presente nel magazzino e il fornitore." << endl;
	cout << endl;
	res = PQexec(conn, "select ft.n_fattura, m.prodotto, m.quantita, ft.fornitore from Fatture ft join Ordini o on ft.id_ordine = o.id_ordine join Magazzino m on o.prodotto = m.prodotto where m.bibita_o_ingrediente = TRUE and m.quantita = (select MIN(m.quantita) from Magazzino m where m.bibita_o_ingrediente = TRUE)");

	checkResults(res, conn);

	tuple = PQntuples(res);
	campi = PQnfields(res);


	// Stampo intestazioni
	for (int i = 0; i < campi; ++i)
	{
		sprintf_s(str, "%-20.20s ", PQfname(res, i));
		cout << str;
	}
	cout << endl;

	// Stampo i valori selezionati
	for (int i = 0; i < tuple; ++i)
	{
		for (int j = 0; j < campi; ++j)
		{
			sprintf_s(str, "%-20.20s ", PQgetvalue(res, i, j));
			cout << str;
		}
		cout << endl;
	}
	cout << endl;


	PQclear(res);

	PQfinish(conn);
	return 0;
}