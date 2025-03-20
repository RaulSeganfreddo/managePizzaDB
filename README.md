# ManagePizzaDB
Little PostgreSQL database for a pizzeria.

## Table of contents:
- [General info](General-info)
- [File descriptions](File-descriptions)
- [Set up](Set-up)
- [Usage](Usage)
- [Credits](Credits)

## General info:
This is a simple DataBase for a pizzeria. The database cover administration and economic part of a pizza resturant.

## File descriptions:
- ManagePizza.pdf: full description of the entire DB project; **Italian Only!**
- script.sql: script that contains every table creation, tables population and 5 simple queries to interrogate the DB as example;
- script.cpp: C++ script that interact with the local DB and interrogate it with queries in the ```script.sql```.

## Set up:
You need to install [PostgreSql](https://www.postgresql.org/). After the installation you have to register the local user that administers your DB in PostgreSQL.
To set up this database, simply copy the ```script.sql``` (***whithout the example queries at the end!***) in the ```query tool``` and execute.

## Usage:
After the [Set up](Set-up) you can do everything you want with the DB. You can interrogate it with queries in the ```query tool```, you can edit it. Be creative!
For the ```script.cpp``` you have to change login credentials and the beginning of the script, then you have to compile it with a C++ compiler (I suggest [gcc](http://gcc.gnu.org/)) and execute the output file to see queries results.

## Credits:
This is a project I made as part of and exam for my university ([Universita'Degli Studi di Padova](https://www.unipd.it/en/)) for the Databases course. Part of the ```script.cpp``` is made by them.

Raul Seganfreddo - Nicholas Moretto
