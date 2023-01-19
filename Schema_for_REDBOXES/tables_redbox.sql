--      THE TABLE SCHEMA FOR EACH REDBOX MACHINE


CREATE TABLE Genre(
GenreId         numeric(2)  NOT NULL,
GenreName       varchar(20) NOT NULL,
CONSTRAINT Genre_GenreId_PK PRIMARY KEY (GenreId));

CREATE TABLE Rating(
RatingId        numeric(2)  NOT NULL,
RatingName      varchar(10) NOT NULL,
CONSTRAINT Rating_RatingId_PK PRIMARY KEY (RatingId));

CREATE TABLE MoviePerson(
PersonId        numeric(12) NOT NULL,
PersonFirstName     varchar(32) NOT NULL,
PersonLastName      varchar(32) NOT NULL,
CONSTRAINT MoviePerson_PersonId_PK PRIMARY KEY (PersonId));


CREATE TABLE DVD(
DVDId           numeric(16) NOT NULL,
DVDTitle        varchar(32) NOT NULL,
GenreId         numeric(2)  NOT NULL,
RatingId        numeric(2)  NOT NULL,
DVDReleaseDate      TIMESTAMP(3)        NOT NULL,
DVDQuantityOnHand   numeric(8)  NOT NULL,
DVDQuantityOnRent   numeric(8)  NOT NULL,
DVDLostQuantity     numeric(8)  NOT NULL,
CONSTRAINT DVD_DVDId_PK PRIMARY KEY (DVDId),
CONSTRAINT DVD_GenreId_FK FOREIGN KEY (GenreId) REFERENCES Genre(GenreId),
CONSTRAINT DVD_RatingId FOREIGN KEY (RatingId) REFERENCES Rating(RatingId));

CREATE TABLE MoviePersonRole(
PersonId        numeric(12) NOT NULL,
DVDId           numeric(16) NOT NULL,
CONSTRAINT MoviePersonRole_PersonId_FK FOREIGN KEY (PersonId) REFERENCES MoviePerson(PersonId),
CONSTRAINT MoviePersonRole_DVDId_FK FOREIGN KEY (DVDId) REFERENCES DVD(DVDId));


CREATE TABLE Membershipstatus(
MemberId        numeric(12) NOT NULL,
eligibleforrental     numeric(12) NOT NULL,
CONSTRAINT Member_MemberId_PK PRIMARY KEY (MemberId));

CREATE TABLE Rental(
RentalId        numeric(16) NOT NULL,
MemberId        numeric(12) NOT NULL,
DVDId           numeric(16) NOT NULL,
RentalRequestDate   TIMESTAMP(3),
RentalShippedDate   TIMESTAMP(3)   NOT NULL,
RentalReturnedDate  TIMESTAMP(3),
CONSTRAINT Rental_RentalId_PK PRIMARY KEY (RentalId),
CONSTRAINT Rental_MemberId_FK FOREIGN KEY (MemberId) REFERENCES Membershipstatus(MemberId),
CONSTRAINT Rental_DVDId_FK FOREIGN KEY (DVDId) REFERENCES DVD(DVDId));



