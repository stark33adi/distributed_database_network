
--populate the redbox table in the head_quarters; We only 4 red box servers
INSERT INTO REDBOX VALUES(1,1);
INSERT INTO REDBOX VALUES(2,10);
INSERT INTO REDBOX VALUES(3,3);
INSERT INTO REDBOX VALUES(4,7);




--populate the DVDQUANTITY table in the head_quarters
--we will asume that each redbox will have 10 dvds of each type
-- initially DVDQuantityOnRent =0 and DVDLostQuantity=0
CREATE OR REPLACE FUNCTION populate_dvd_quantity(red_box_id numeric) RETURNS numeric AS
$BODY$
DECLARE
   r numeric;
BEGIN
    FOR r IN
        SELECT dvdid FROM dvd
    LOOP
        INSERT INTO DVDQUANTITY VALUES(r,red_box_id ,10,0,0);
    END LOOP;
    RETURN 0;
END;
$BODY$
LANGUAGE plpgsql;

--  FOR REDBOX 1
SELECT populate_dvd_quantity(1);
--  FOR REDBOX 2
SELECT populate_dvd_quantity(2);
--  FOR REDBOX 3
SELECT populate_dvd_quantity(3);
--  FOR REDBOX 4
SELECT populate_dvd_quantity(4);




--NOW DELETE THE COLUMNS FROM THE ORIGINAL DVD TABLE
ALTER TABLE dvd 
DROP COLUMN DVDQuantityOnHand,
DROP COLUMN DVDQuantityOnRent, 
DROP COLUMN DVDLostQuantity;  

-- DROP RENTAL TABLE
DROP TABLE RENTAL
-- and now create a new one
CREATE TABLE Rental(
RentalId        numeric(16) NOT NULL,
RedBoxIdShipped        numeric(16) NOT NULL,
MemberId        numeric(12) NOT NULL,
DVDId           numeric(16) NOT NULL,
RentalRequestDate   TIMESTAMP(3)        NOT NULL,
RentalShippedDate   TIMESTAMP(3),
RentalReturnedDate  TIMESTAMP(3),
RedBoxIdReturned        numeric(16),
CONSTRAINT Rental_RentalId_PK PRIMARY KEY (RentalId),
CONSTRAINT Rental_RedBoxIdShipped_FK FOREIGN KEY (RedBoxIdShipped) REFERENCES REDBOX(RedBoxId),
CONSTRAINT Rental_RedBoxIdReturned_FK FOREIGN KEY (RedBoxIdReturned) REFERENCES REDBOX(RedBoxId),
CONSTRAINT Rental_DVDId_FK FOREIGN KEY (DVDId) REFERENCES DVD(DVDId));







