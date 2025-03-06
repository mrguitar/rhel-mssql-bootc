#!/bin/bash

MSSQL_setup() {
    # Configure MSSQL
    read -p "
    Let's configure the database instance. Ansible can 
    easily automate this in the real world, but for now
    let's just run this script
        
    MSSQL_SA_PASSWORD='Pizzaisg00d!' 
    MSSQL_PID='evaluation' 
    /opt/mssql/bin/mssql-conf -n setup accept-eula

    ....don't tell the security narcs about me showing a fake password ;)    
    "
    setenforce 0
    echo ""
    MSSQL_SA_PASSWORD='Pizzaisg00d!' \
    MSSQL_PID='evaluation' \
    /opt/mssql/bin/mssql-conf -n setup accept-eula
    echo ""
}

MSSQL_test() {
        #Test connection
        read -p "
        Testing the connection using: 
        sqlcmd -S 127.0.0.1 -U sa -P 'Pizzaisg00d!' -C -Q 'SELECT name FROM sys.databases
        GO'"
        echo ""
        sqlcmd -S 127.0.0.1 -U sa -P 'Pizzaisg00d!' -C -Q "SELECT name FROM sys.databases
        GO"
        echo ""
}

DB_restore() {
        #Restore the AdventureWorks2022 DB
        read -p "
        We will restore the example
        AdventureWorks2022 DB using:

        sqlcmd -S 127.0.0.1 -U sa -P 'Pizzaisg00d!' -C -i /opt/restore.sql
        
        "
        echo ""
        sqlcmd -S 127.0.0.1 -U sa -P 'Pizzaisg00d!' -C -i /opt/restore.sql
        setenforce 1
        echo ""
}

DB_test() {
        #now let's show a table
        read -p "
        Showing a more real query
        SELECT *
        FROM AdventureWorks2022.INFORMATION_SCHEMA.TABLES;
        go
        "
        echo ""
        sqlcmd -S 127.0.0.1 -U sa -P 'Pizzaisg00d!' -C -Q "SELECT *
        FROM AdventureWorks2022.INFORMATION_SCHEMA.TABLES;
        go"
        echo ""
}



MSSQL_setup
MSSQL_test
DB_restore
DB_test

read -p "That's all folkes"
echo "See ya"
