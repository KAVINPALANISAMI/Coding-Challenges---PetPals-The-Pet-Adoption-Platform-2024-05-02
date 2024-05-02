
--1. Provide a SQL script that initializes the database for the Pet Adoption Platform ”PetPals”
create database PetPals
use PetPals
--2. Create tables for pets, shelters, donations, adoption events, and participants.
--3. Define appropriate primary keys, foreign keys, and constraints.

 create table Pets(
PetID int primary key identity(101,1) not null,
[Name] varchar(10) not null,
Age int not null,
Breed varchar(10)not null,
[Type] varchar(10) not null,
AvailableForAdoption bit,
check (AvailableForAdoption =1 or AvailableForAdoption =0))

create table Shelters(
ShelterID int primary key  not null,
[Name] VArchar(10) not null,
[Location] varchar(10) not null)

create table Donations(
DonationID int identity(301,1) primary key not null,
DonorName varchar(20) not null,
DonationType varchar(20) not null,
DonationAmount decimal not null,
DonationItem varchar(20)  not null,
DonationDate datetime not null,)

create table AdoptionEvents(
EventID int identity(401,1) primary key not null,
EventName varchar(20) not null,
EvantDate datetime not null,
[Location] varchar(20) not null)

create table Participants(
ParticipantID int primary key identity(501,1),
ParticipantName varchar(20) not null,
ParticipantType varchar(20) not null,
EventID int not null,
foreign key (EventID) references AdoptionEvents(EventID))

alter table Pets
add constraint CK_Pets
check([Type] In('Dog','Cat'))

alter table Donations
add constraint CK_Donations
check([DonationType] In('cash','Item'))

--alter table  Participants
--add constraint CK_Participants
--check([ParticipantsType] In('Shelter','Adopter'))


--4. Ensure the script handles potential errors, such as if the database or tables already exist.



--5. Write an SQL query that retrieves a list of available pets (those marked as available 
--for adoption) from the "Pets" table. Include the pet's name, age, breed, and type
--in the result set. Ensure that the query filters out pets that are not available for adoption.

-- insetr values to  tables
insert into Pets values('Tom', 4,'Male','Dog',1),
						('Timy',3,'Male','Dog',0),
						('Pussy',4,'Female','Cat',1)

insert into Shelters values (201,'Kings Pets','Chennai'),
							(202,'Quens Pets','Karur')

insert into Donations values ('Kavin','Cash',5000,'cash','2023-04-25 12:00'),
							('Sathis','Item',6000,'Cat','2024-05-30 01:00')	

insert into AdoptionEvents values ('KingAdoption','2024-04-25 08:00','Chennai'),
									('QuensAdoption','2024-04-30 11:00','Karur')

insert into Participants values ('Bhoopesh','Shelter',401),
								('Dharun','Adopter',402)


select [Name], Age,Breed,[Type]
from Pets
where AvailableForAdoption=1

--6. Write an SQL query that retrieves the names of participants (shelters and adopters) 
--registered for a specific adoption event. Use a parameter to specify the event ID.
--Ensure that the query joins the necessary tables to retrieve the participant names and types.

declare @eid  int 
set @eid=401

select p.ParticipantName,p.ParticipantType
from Participants p
join AdoptionEvents a
on p.EventID=a.EventID
where a.EventID=@eid

--7. Create a stored procedure in SQL that allows a shelter to update its information (name and
--location) in the "Shelters" table. Use parameters to pass the shelter ID and the new information.
--Ensure that the procedure performs the update and handles potential errors, such as an invalid
--shelter ID.declare @sh intset @sh=203declare @name varchar(20)set @name='Bishuppets'declare @L varchar(20)set @L ='Trichy'insert into Shelters values (@sh,@name,@L) --8. Write an SQL query that calculates and retrieves the total donation amount for each shelter 
--(by shelter name) from the "Donations" table. The result should include the shelter name and the
--total donation amount. Ensure that the query handles cases where a shelter has received no
--donations.alter table Donationsadd  ShelterID intalter table Donationsadd constraint FK_ShelterForeign key (ShelterID)  References Shelters(ShelterID)select s.Name ,sum(d.DonationAmount) as [toatl Donation]from Donations djoin Shelters son d.shelterID=s.ShelterIDGroup by s.Name--9. Write an SQL query that retrieves the names of pets from the "Pets" table that do not have an
--owner (i.e., where "OwnerID" is null). Include the pet's name, age, breed, and type in the result
--set.alter table Petsadd [ownerId] int update Pets set OwnerId=1 where PetID=101update Pets set OwnerId=2 where PetID=103Select [Name], Age,Breed,[Type]from Petswhere ownerId is null--10. Write an SQL query that retrieves the total donation amount for each month and year (e.g.,
--January 2023) from the "Donations" table. The result should include the month-year and the
--corresponding total donation amount. Ensure that the query handles cases where no donations
--were made in a specific month-year.insert into Donations values ('Preadeepa','cash',7000,'cash','2023-06-04 11:00',201)Select year(DonationDate) as [Year] ,Month(DonationDate) as [Month], sum(DonationAmount)from DonationsGroup by year(DonationDate),Month(DonationDate)--11. Retrieve a list of distinct breeds for all pets that are either aged between 1 and 
--3 years or olderthan 5 years.select distinct * from Petswhere Age between 1 and 3 or Age>5--12. Retrieve a list of pets and their respective shelters where the pets are currently available
--for adoption.alter table Petsadd ShelterID intupdate Pets set ShelterID=201 where PetID=101update Pets set ShelterID=202 where PetID=102update Pets set ShelterID=202 where PetID=103
select p.Name,s.Name
from Pets p
join 
Shelters s
on p.ShelterID=s.ShelterID
where p.AvailableForAdoption=1

--13. Find the total number of participants in events organized by shelters located in 
--specific city.Example: City=Chennaiselect ParticipantNamefrom Participants pjoinAdoptionEvents eon P.EventID=e.EventIDwhere e.Location='Chennai'--14. Retrieve a list of unique breeds for pets with ages between 1 and 5 years.
-- For MAle
select distinct *from Pets where (Age between 1 and 5) and Breed='Male'
-- For Female 
select distinct *from Pets where (Age between 1 and 5) and Breed='Female'

--15. Find the pets that have not been adopted by selecting their information from the 'Pet' table


select * from Pets
where AvailableForAdoption=1

--16. Retrieve the names of all adopted pets along with the adopter's name from the 'Adoption' and
--'User' tables.--17. Retrieve a list of all shelters along with the count of pets currently available 
--for adoption in each shelter.

--18. Find pairs of pets from the same shelter that have the same breed.
select s.ShelterID,p.Name
from Pets p
join Shelters s
on p.ShelterID=s.ShelterID
group by p.Breed,s.ShelterID
--19. List all possible combinations of shelters and adoption events.
select * 
from Shelters
cross join 
AdoptionEvents

--20. Determine the shelter that has the highest number of adopted pets.
select [s.Name]
from Pets p
join 
Shelters s
on p.ShelterId=s.ShelterID
group by [Shelters.Name]
order by count(PetID) desc




