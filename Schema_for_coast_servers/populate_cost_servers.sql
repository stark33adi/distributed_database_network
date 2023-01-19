-- HERE WE WILL CREATE A STORED FUNCTON THE WILL INTIALIZE THE COAST SERVERS
-- THIS STORED FUNCTION WILL FETCH DATA FROM THE HEADQUARTER CLOUD




CREATE OR REPLACE FUNCTION populate_cost_server(member_table_name varchar(32),connection_link varchar(64),
												foreign_server varchar(64)) RETURNS numeric AS
$BODY$
DECLARE
--member_table_name = the partition table for this particuler server
BEGIN
	-- activate the server connection we created
	PERFORM dblink_connect(connection_link,foreign_server);
	-- fetch data for the genre table
	INSERT INTO GENRE
	select * from dblink(connection_link,'select * from genre') AS
	x(gi int,gn text);
	--fetch data for the rating table
	INSERT INTO rating
	select * from dblink(connection_link,'select * from rating') AS
	x(gi int,gn text,gt text);
	-- fetch data for the movie person
	INSERT INTO movieperson
	select * from dblink(connection_link,'select * from movieperson') AS
	x(gi int,gn text,gf text,gt text,dt TIMESTAMP);
	-- fetch data for the role
	INSERT INTO role
	select * from dblink(connection_link,'select * from role') AS
	x(gi int,gn text);
	-- fetch data for the dvd table
	ALTER TABLE dvd
	ALTER COLUMN dvdtitle TYPE VARCHAR(100);
	INSERT INTO dvd
	select DVDId , DVDTitle, GenreId ,RatingId,DVDReleaseDate  
	from dblink(connection_link,'select * from dvd') AS
	x(DVDId numeric(16), DVDTitle text, GenreId numeric(2) ,RatingId numeric(2),
	DVDReleaseDate TIMESTAMP(3),
	TheaterReleaseDate  TIMESTAMP(3));
	-- fetch data for the movieperson role table
	INSERT INTO moviepersonrole
	select * from dblink(connection_link,'select * from moviepersonrole') AS
	x(gn int,gt int,gh int);
	-- fetch data for the state
	INSERT INTO state
	select * from dblink(connection_link,'select * from state') AS
	x(gi int,gn text);
	-- fetch data for the city
	INSERT INTO city
	select * from dblink(connection_link,'select * from city') AS
	x(gi int,gn text);
	-- fetch data for the zipcode
	INSERT INTO zipcode
	select * from dblink(connection_link,'select * from zipcode') AS
	x(gi int,gn int,bh int,kn int);
	-- fetch data for the  membership
	INSERT INTO membership
	select * from dblink(connection_link,'select * from membership') AS
	x(gi int,gn text,bh int,kn numeric(5,2),ktn numeric(5,2),kun numeric(5,2));
      -- fetch data for the redbox
	INSERT INTO REDBOX VALUES(1,1);
	INSERT INTO REDBOX VALUES(2,10);
	  -- fetch data for the dvd_quantity
	INSERT INTO dvdquantity
	select * from dblink(connection_link,'select * from dvdquantity where redboxid in (3,4)') AS
	x(gi int,gn int,gf int,gt int,dt int);
	--fetch values for the member table
	alter table member alter memberaddress drop not null; -- drop the not null constraint
	INSERT INTO member 
	select memberid, memberfirstname, memberlastname, memberinitial,memberaddress,
	memberaddressid,memberphone,memberemail,memberpassword,membershipid,membersincedate
	--FETCH member_table_name from headquarter cloud
	from dblink(connection_link,CONCAT('select * from ',member_table_name)) AS x(
	MemberId  numeric(12),
	MemberFirstName     varchar(32),
	MemberLastName     varchar(32),
	MemberInitial      varchar(32),
	MemberAddress      varchar(100)   ,
	MemberAddressId    numeric(10),
	MemberPhone    varchar(14),
	MemberEMail   varchar(32) ,
	MemberPassword     varchar(32) ,
	MembershipId       numeric(10),
	MemberSinceDate    TIMESTAMP(3),
	ZipCodeId   numeric(10),
	ZipCode    varchar(5),
	CityId     numeric(10),
	StateName  varchar(20));
	
    RETURN 0;
END;
$BODY$
LANGUAGE plpgsql;



-- FOR WEST COAST SERVER
select populate_cost_server('west_member','headquarter_to_west','send_data_to_west_server');

--FOR EAST COAST SERVER
select populate_cost_server('east_member','headquarter_to_east','send_data_to_east_server');


-- run this too for each coast

update membership set dvdattime = cast (substring(membershiptype,1,2)as numeric);