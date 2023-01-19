   


							------RENTAL QUERY FOR THE DISTRIBUTED NETWORK------






---Function for updating the rental table in coast server 

CREATE OR REPLACE FUNCTION rental_query_coast(red_box_id numeric,dvd_id numeric,
									   member_id numeric,rental_id numeric) RETURNS numeric AS
$BODY$
DECLARE
--none
payment_id numeric =0;
BEGIN
	
	-- assuming that the redoac connection is live
	-- check if member ship status is one or not
	
	--insert into rental table
	INSERT INTO rental VALUES(rental_id,red_box_id,member_id,dvd_id,current_date,current_date);
	
	-- update dvd quantity
	UPDATE dvdquantity SET dvdquantityonhand=dvdquantityonhand-1,
	dvdquantityonrent=dvdquantityonrent+1 WHERE dvdid = dvd_id and redboxid=red_box_id;
	--do payment
	select max(paymentid) into payment_id from payment;
	INSERT INTO payment VALUES(payment_id+1,member_id,25.0,current_date,current_date);
	
    RETURN 0;
END;
$BODY$
LANGUAGE plpgsql;


select * from rental





				-- RENTAL QUERY  function FOR REDBOX ON WEST COAST

CREATE OR REPLACE FUNCTION rental_query(red_box_id numeric,connection_link varchar(64),
												foreign_server varchar(64),dvd_id numeric,
									   member_id numeric) RETURNS numeric AS
$BODY$
DECLARE
--member_table_name = the partition table for this particuler server
rental_id numeric=0;
BEGIN
	
	-- assuming that the redoac connection is live
	-- check if member ship status is one or not
	IF (select eligibleforrental from membershipstatus where memberid=member_id) =0 THEN
		RAISE NOTICE 'Not allowed any more rentals';
		RETURN 0;
	END IF;
	--get rental id
	select max(rentalid) into rental_id from rental;
	IF rental_id is null then
		INSERT INTO rental VALUES(1,member_id ,dvd_id,current_date,current_date);
		rental_id=0;
	else
		INSERT INTO rental VALUES(rental_id+1,member_id ,dvd_id,current_date,current_date);
	end if;
	-- sync the coast server rental_query_coast(red_box_id,dvd_id,member_id,rental_id+1)
	perform from dblink(connection_link,'select rental_query_coast('||red_box_id||','||dvd_id||','||member_id||','||rental_id+1||')') AS x(gn int);
	
	--update the membershipstatus table
	if (select * from dblink(connection_link,'select total_rents_left('||member_id||')') AS x(gn int)) = 0 then
		update membershipstatus set eligibleforrental=0 where memberid=member_id;
	end if;
    RETURN 0;
END;
$BODY$
LANGUAGE plpgsql;





-- make connection
SELECT dblink_connect('WEST_to_red_box_2_west','send_data_to_red_box_2_west');


-- rent the dvd from the red box
select rental_query(2,'WEST_to_red_box_2_west','send_data_to_red_box_2_west',2,1);
			














