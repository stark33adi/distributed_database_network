--LETS CREAte a horizontal partioned of the member table according to the west and east coast
CREATE TABLE member_partitioned (
MemberId        numeric(12) NOT NULL,
MemberFirstName     varchar(32) NOT NULL,
MemberLastName      varchar(32) NOT NULL,
MemberInitial       varchar(32),
MemberAddress       varchar(100)   ,
MemberAddressId     numeric(10) NOT NULL,
MemberPhone     varchar(14),
MemberEMail     varchar(32) NOT NULL,
MemberPassword      varchar(32) NOT NULL,
MembershipId        numeric(10) NOT NULL,
MemberSinceDate     TIMESTAMP(3)        NOT NULL,
ZipCodeId   numeric(10) NOT NULL,
ZipCode     varchar(5)  NOT NULL,
CityId      numeric(10),
StateName   varchar(20) NOT NULL)PARTITION BY LIST (StateName);

-- create the two partioend table  west_member : for west_coast_server  and east_member : for east_coast_server
CREATE TABLE west_member PARTITION OF member_partitioned  FOR VALUES IN ('California','Texas');
CREATE TABLE east_member PARTITION OF member_partitioned  FOR VALUES IN ('Delaware','Florida','Georgia'
															 ,'Iowa','New Jersey','New York'
															 ,'Maryland','Pennsylvania');
                                                             
-- populate the data into the partioned tables
INSERT INTO  member_partitioned
SELECT MemberId,
MemberFirstName,
MemberLastName ,
MemberInitial,
MemberAddress ,
MemberAddressId ,
MemberPhone ,
MemberEMail,
MemberPassword ,
MembershipId,
MemberSinceDate,
ZipCodeId ,
ZipCode,
CityId ,
statename
FROM (select * from member inner join zipcode on member.memberaddressid=zipcode.zipcodeid
inner join state on zipcode.stateid=state.stateid )as boom;

