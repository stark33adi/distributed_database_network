--           MADE A CONNECT FOR THE EAST_COAST SERVER AND THE HEADQUARTER SERVER IN THE AWS AURORA CLOUD

--include the dblink extension in the EAST COAST SERVER
CREATE EXTENSION dblink;
--create a foreign server for the headquarter_cloud server named 'send_data_to_east_server', 
--this server will fetch data to east in case of requirement
CREATE SERVER send_data_to_east_server FOREIGN DATA WRAPPER dblink_fdw OPTIONS
(host 'database-1-instance-1.cypieevs4ui9.us-east-1.rds.amazonaws.com', dbname 'postgres', port '5440');
--create a mapping for the send_data_to_east_server SERVER in the east server so that they can share data sucessfullly
CREATE USER MAPPING FOR postgres server send_data_to_east_server OPTIONS 
(user 'headquarter', password 'mynewpassword');
--grant acces of FOREIGN SERVER send_data_to_east_server TO the east_coast_server
GRANT USAGE ON FOREIGN SERVER send_data_to_east_server to postgres;
-- FINALLY coneect the two servers
SELECT dblink_connect('headquarter_to_east','send_data_to_east_server');





--           MADE A CONNECT FOR THE WEST_COAST SERVER AND THE HEADQUARTER SERVER IN THE AWS AURORA CLOUD

--include the dblink extension in the WEST COAST SERVER
CREATE EXTENSION dblink;
--create a foreign server for the headquarter_cloud server named 'send_data_to_west_server', 
--this server will fetch data to west in case of requirement
CREATE SERVER send_data_to_west_server FOREIGN DATA WRAPPER dblink_fdw OPTIONS
(host 'database-1-instance-1.cypieevs4ui9.us-east-1.rds.amazonaws.com', dbname 'postgres', port '5440');
--create a mapping for the send_data_to_west_server SERVER in the west server so that they can share data sucessfullly
CREATE USER MAPPING FOR postgres server send_data_to_west_server OPTIONS 
(user 'headquarter', password 'mynewpassword');
--grant acces of FOREIGN SERVER send_data_to_west_server TO the west_coast_server
GRANT USAGE ON FOREIGN SERVER send_data_to_west_server to postgres;
-- FINALLY coneect the two servers
SELECT dblink_connect('headquarter_to_west','send_data_to_west_server');
SELECT * from dblink('headquarter_to_west','select memberid,memberlastname from member') AS x(a int,b text);





--           MADE A CONNECT FOR THE WEST_COAST SERVER AND THE RED BOX 1 SERVER LOCATED IN THE WEST


	--include the dblink extension in the WEST COAST RED BOX 1 SERVER
CREATE EXTENSION dblink;
--create a foreign server for the WEST COAST SERVER named 'send_data_to_red_box_1_west', 
--this server will fetch data to itself from the WEST COAST SERVER in case of requirement
CREATE SERVER send_data_to_red_box_1_west FOREIGN DATA WRAPPER dblink_fdw OPTIONS
(host 'Peeyushs-MacBook-Pro.local', dbname 'postgres', port '5430');
--create a mapping for the send_data_to_red_box_1_west SERVER in the west_coast_red_box_1 so that they can share data sucessfullly
CREATE USER MAPPING FOR postgres server send_data_to_red_box_1_west  OPTIONS (user 'postgres', password 'mynewpassword');
--grant acces of FOREIGN SERVER send_data_to_red_box_1_west TO the west_coast_red_box_1
GRANT USAGE ON FOREIGN SERVER send_data_to_red_box_1_west to postgres;
-- FINALLY coneect the two servers
SELECT dblink_connect('WEST_to_red_box_1_west','send_data_to_red_box_1_west');



--           MADE A CONNECT FOR THE WEST_COAST SERVER AND THE RED BOX 2 SERVER LOCATED IN THE WEST


--include the dblink extension in the WEST COAST RED BOX 2 SERVER
CREATE EXTENSION dblink;
--create a foreign server for the WEST COAST SERVER named 'send_data_to_red_box_2_west', 
--this server will fetch data to itself from the WEST COAST SERVER in case of requirement
CREATE SERVER send_data_to_red_box_2_west FOREIGN DATA WRAPPER dblink_fdw OPTIONS
(host 'Peeyushs-MacBook-Pro.local', dbname 'postgres', port '5430');
--create a mapping for the send_data_to_red_box_2_west SERVER in the west_coast_red_box_2 so that they can share data sucessfullly
CREATE USER MAPPING FOR postgres server send_data_to_red_box_2_west  OPTIONS 
(user 'postgres', password 'mynewpassword');
--grant acces of FOREIGN SERVER send_data_to_red_box_2_west TO the west_coast_red_box_2
GRANT USAGE ON FOREIGN SERVER send_data_to_red_box_2_west to postgres;
-- FINALLY coneect the two servers
SELECT dblink_connect('WEST_to_red_box_2_west','send_data_to_red_box_2_west');





--           MADE A CONNECT FOR THE EAST_COAST SERVER AND THE RED BOX 1 SERVER LOCATED IN THE EAST

--include the dblink extension in the EAST COAST RED BOX 1 SERVER
CREATE EXTENSION dblink;
--create a foreign server for the EAST COAST SERVER named 'send_data_to_red_box_1', 
--this server will fetch data to itself from the EAST COAST SERVER in case of requirement
CREATE SERVER send_data_to_red_box_1 FOREIGN DATA WRAPPER dblink_fdw OPTIONS
(host 'localhost', dbname 'postgres', port '5431');
--create a mapping for the send_data_to_red_box_2 SERVER in the east_coast_red_box_1 so that they can share data sucessfullly
CREATE USER MAPPING FOR postgres server send_data_to_red_box_1 OPTIONS 
(user 'postgres', password 'mynewpassword');
--grant acces of FOREIGN SERVER send_data_to_red_box_1 TO the east_coast_red_box_1
GRANT USAGE ON FOREIGN SERVER send_data_to_red_box_1 to postgres;
-- FINALLY coneect the two servers
SELECT dblink_connect('EAST_to_red_box_east_1','send_data_to_red_box_1');







--           MADE A CONNECT FOR THE EAST_COAST SERVER AND THE RED BOX 2 SERVER LOCATED IN THE EAST


--include the dblink extension in the EAST COAST RED BOX 2 SERVER
CREATE EXTENSION dblink;
--create a foreign server for the EAST COAST SERVER named 'send_data_to_red_box_2_east', 
--this server will fetch data to itself from the EAST COAST SERVER in case of requirement
CREATE SERVER send_data_to_red_box_2_east FOREIGN DATA WRAPPER dblink_fdw OPTIONS
(host 'Peeyushs-MacBook-Pro.local', dbname 'postgres', port '5431');

--alter server send_data_to_red_box_1_east options (host 'Peeyushs-MacBook-Pro.local') 
--create a mapping for the send_data_to_red_box_2_east SERVER in the east_coast_red_box_2 so that they can share data sucessfullly
CREATE USER MAPPING FOR postgres server send_data_to_red_box_2_east OPTIONS 
(user 'postgres', password 'mynewpassword');
--grant acces of FOREIGN SERVER send_data_to_red_box_2_east TO the east_coast_red_box_2
GRANT USAGE ON FOREIGN SERVER send_data_to_red_box_2_east to postgres;
-- FINALLY coneect the two servers
SELECT dblink_connect('EAST_to_red_box_2_east','send_data_to_red_box_2_east');






--           MADE A CONNECT FOR THE West_red_box_server_2 SERVER AND THE HEADQUARTER SERVER IN THE AWS AURORA CLOUD

--include the dblink extension in the west_coast_red_box_2 SERVER
CREATE EXTENSION dblink;
--create a foreign server for the headquarter_cloud server named 'send_data_to_west_red_box_1_server', 
--this server will fetch data to west_red_box_2 in case of special requirement
CREATE SERVER send_data_to_west_red_box_2_server FOREIGN DATA WRAPPER dblink_fdw OPTIONS
(host 'database-1-instance-1.cypieevs4ui9.us-east-1.rds.amazonaws.com', dbname 'postgres', port '5440');
--create a mapping for the send_data_to_west_red_box_2_server SERVER in the east server so that they can share data sucessfullly
CREATE USER MAPPING FOR postgres server send_data_to_west_red_box_2_server OPTIONS 
(user 'headquarter', password 'mynewpassword');
--grant acces of FOREIGN SERVER send_data_to_east_server TO the east_coast_server
GRANT USAGE ON FOREIGN SERVER send_data_to_west_red_box_2_server to postgres;
-- FINALLY coneect the two servers
SELECT dblink_connect('headquarter_to_east','send_data_to_west_red_box_2_server');



--           MADE A CONNECT FOR THE West_coast SERVER AND THE west_coast_red_box_2 SERVER IN THE AWS AURORA CLOUD

--include the dblink extension in the west_coast_red_box_2 SERVER
CREATE EXTENSION dblink;
CREATE SERVER fetch_data_to_west_coast_from_red_box_2_server FOREIGN DATA WRAPPER dblink_fdw OPTIONS
(host 'Peeyushs-MacBook-Pro.local', dbname 'postgres', port '5426');
CREATE USER MAPPING FOR postgres server fetch_data_to_west_coast_from_red_box_2_server OPTIONS 
(user 'postgres', password 'mynewpassword');
GRANT USAGE ON FOREIGN SERVER fetch_data_to_west_coast_from_red_box_2_server to postgres;
-- FINALLY coneect the two servers
SELECT dblink_connect('rb_2_to_west_coast','fetch_data_to_west_coast_from_red_box_2_server');