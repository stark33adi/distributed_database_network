-- HERE WE WILL CREATE A STORED FUNCTON THE WILL INTIALIZE THE REDBOX SERVERS


CREATE OR REPLACE FUNCTION populate_red_box_server(connection_link varchar(100),
												foreign_server varchar(100),red_box_id numeric) RETURNS numeric AS
$BODY$
DECLARE
r numeric;
BEGIN
	-- activate the server connection we created
	PERFORM dblink_connect(connection_link,foreign_server);
	-- fetch data for the genre table
	INSERT INTO GENRE
	select * from dblink(connection_link,'select * from genre') AS
	x(gi int,gn text);
	
	--fetch data for the rating table
	INSERT INTO rating
	select * from dblink(connection_link,'select ratingid,ratingname from rating') AS
	x(gi int,gn text);
	
	-- fetch data for the movie person
	INSERT INTO movieperson
	select * from dblink(connection_link,'select personid,personfirstname,personlastname from movieperson') AS
	x(gi int,gn text,gf text);

	
	-- fetch data for the dvd table
	ALTER TABLE dvd
	ALTER COLUMN dvdtitle TYPE VARCHAR(100);
	INSERT INTO dvd
	select *  
	from dblink(connection_link,CONCAT('select  dvd.DVDId , DVDTitle, GenreId ,RatingId,DVDReleaseDate,dvdquantityonhand,dvdquantityonrent,dvdlostquantity from dvd inner join dvdquantity on dvd.dvdid=dvdquantity.dvdid where redboxid= ',red_box_id)) AS
	x(DVDId numeric(16), DVDTitle text, GenreId numeric(2) ,RatingId numeric(2),
	DVDReleaseDate TIMESTAMP(3),
	dvdquantityonhand int,dvdquantityonrent int,dvdlostquantity int);
	
	-- fetch data for the movieperson role table
	INSERT INTO moviepersonrole
	select * from dblink(connection_link,'select personid,dvdid from moviepersonrole') AS
	x(gn int,gt int);

	
	-- fetch data for the  member table into menbershipstatus
	INSERT INTO membershipstatus
	select * from dblink(connection_link,'select memberid,memberid from member') AS x(gi int,h int);
	--initially all the customers are eligible for the dvd rents
	UPDATE  membershipstatus
	SET eligibleforrental=1;

    RETURN 0;
END;
$BODY$
LANGUAGE plpgsql;



--FOR RED_BOX_1 IN WEST COAST
select populate_red_box_server('WEST_to_red_box_1_west','send_data_to_red_box_1_west',1);



--FOR RED_BOX_2 IN WEST COAST
select populate_red_box_server('WEST_to_red_box_2_west','send_data_to_red_box_2_west',2);





--FOR RED_BOX_1 IN EAST COAST
select populate_red_box_server('WEST_to_red_box_1_west','send_data_to_red_box_1_west',3);



--FOR RED_BOX_2 IN EAST COAST
select populate_red_box_server('EAST_to_red_box_2_east','send_data_to_red_box_2_east',4);

