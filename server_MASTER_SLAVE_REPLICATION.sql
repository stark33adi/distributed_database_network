--           SERVER MASTER SLAVE REPLICATION
-- WE WILL BE PERFORMING STREAMING REPLICATION USING WAL FILES
-- if you are not able to findyour pg_hba.conf file then refer this : https://stackoverflow.com/questions/14025972/postgresql-how-to-find-pg-hba-conf-file-using-mac-os-x

-- 1.) Now CREATE the Replication User  (runs this in command line of your databse with a particlar port )

CREATE USER i_replicator REPLICATION LOGIN ENCRYPTED PASSWORD 'mynewpassword';
 /var/lib/postgresql/data
-- 2.) Add your REPLICATION USER TO THE config file of POSTGRESQL name : pg_hba.conf     :  runs this on your command line

echo 'host replication replicator 0.0.0.0/0 trust' >>  /Library/PostgreSQL/14/data/pg_hba.conf 

host replication replicator  172.17.0.1
--3.) open your postgresql.conf file and add these lines there (add them above CONNECTIONS AND AUTHENTICATION)

wal_level = hot_standby  # allow SLAVE TO DO queries while in read only recover mode
max_wal_senders=3   # DETERMINES how many SLAVES can suck data from it
hot_standby = on  # allow quaries while in read only recovery mode

-- if you want to write is using the terminal then use the below line to open it 
nano /Library/PostgreSQL/14/data/postgresql.conf 




-- 4.) Restart your DOCKER PORT or your POSGRES SERVER (do this in commnd line)

docker restart west_coast_red_box_1

--5.) setup up a pg_basebackup  (this makes the exact BINARY copy of all of the databse cluster) (runs this in command line for the specific docker port)
pg_basebackup -h localhost -p 5425 -D /Library/PostgreSQL/14/data/posgressslave -U i_replicator -P -v


pg_basebackup -h localhost -p 5432 -D /Library/PostgreSQL/14/data/posgressslave/backup -U i_replicator -P -v


--6.) SETUP SLAVE AND START IT

--first install VIM in the docker container 
apt-get update
apt-get install vim

--create a recovery file (run this int docker container for that port)
/Library/PostgreSQL/14/data/posgressslave/recovery.conf

-- add connection info into the file 

primary_conninfo = 'host=db port=5432 user=i_replicator password=mynewpassword'
trigger_file = '/Library/PostgreSQL/14/data/failover'
standby_mode = 'on'

-- if modifiable is OFF the runn this before pasting
:set modifiable


-- do this
docker run --name west_coast_red_box_1_slave -e POSTGRES_USER=west_coast_red_box_1 -e POSTGRES_PASSWORD=mynewpassword -v /Library/PostgreSQL/14/data/posgressslave:/Library/PostgreSQL/14/data --link west_coast_red_box_1:db postgres



docker run --name west_coast_red_box_1_slave -e POSTGRES_USER=west_coast_red_box_1 -e POSTGRES_PASSWORD=mynewpassword -v /Library/PostgreSQL/14/data/posgressslave/backup:/var/lib/postgresql/data --link west_coast_red_box_1:postgres postgres:14


















--           SERVER MASTER SLAVE REPLICATION
-- WE WILL BE PERFORMING STREAMING REPLICATION USING WAL FILES
-- if you are not able to findyour pg_hba.conf file then refer this : https://stackoverflow.com/questions/14025972/postgresql-how-to-find-pg-hba-conf-file-using-mac-os-x

-- 1.) Now CREATE the Replication User  (runs this in command line of your databse with a particlar port )

CREATE USER i_replicator REPLICATION LOGIN ENCRYPTED PASSWORD 'mynewpassword';

-- 2.) Add your REPLICATION USER TO THE config file of POSTGRESQL name : pg_hba.conf     :  runs this on your command line
--NOTE : the path to pg_hba.conf  can be different for your system
echo 'host replication i_replicator 0.0.0.0/0 trust' >>   /var/lib/postgresql/data/pg_hba.conf 

--3.) open your postgresql.conf file and add these lines there (add them above CONNECTIONS AND AUTHENTICATION)

wal_level = hot_standby  # allow SLAVE TO DO queries while in read only recover mode
max_wal_senders=3   # DETERMINES how many SLAVES can suck data from it
hot_standby = on  # allow queries while in read only recovery mode


-- 4.) Restart your DOCKER PORT or your POSGRES SERVER (do this in commnd line)

docker restart west_coast_red_box_1

--5.) setup up a pg_basebackup  (this makes the exact BINARY copy of all of the databse cluster) (runs this in command line for the specific docker port)
pg_basebackup -h Peeyushs-MacBook-Pro.local -p 5426 -D /tmp/postgressslave -U i_replicator -P -v



--6.) SETUP SLAVE AND START IT

--first install VIM in the docker container 
apt-get update
apt-get install vim

--create a recovery file (run this int docker container for that port)
touch /tmp/postgressslave/recovery.conf

-- add connection info into the file 

primary_conninfo = 'host=db port=5426 user=i_replicator password=mynewpassword'
trigger_file = '/Library/PostgreSQL/14/data/failover'
standby_mode = 'on'

-- if modifiable is OFF the runn this before pasting
:set modifiable


-- do this
docker run --name west_coast_red_box_2_slave -e POSTGRES_USER=west_coast_red_box_2 -e POSTGRES_PASSWORD=mynewpassword -v /tmp/postgressslave:/var/lib/postgresql/data --link west_coast_red_box_2:db postgres
