use bhati;                -- using database bhati
select * from pets
order by OwnerID;
select * from ProceduresDetails;    -- checking datasets
select * from ProceduresHistory;
select * from owners
order by OwnerID;

--Extract information on pet names along with their owner names in the same table.
select a.Name as dog_name,CONCAT(b.Name,' ',b.Surname) as owner_name
from pets as a inner join owners as b
on a.OwnerID =b.OwnerID; 

--Extract information for those pets whose owners live in either “GrandRapids” or “Southfield”
select a.Name as dog_name,CONCAT(b.Name,' ',b.Surname) as owner_name
from pets as a inner join owners as b
on a.OwnerID =b.OwnerID
where b.City in ('Grand Rapids', 'Southfield'); 

--Find the pet’s information which had a procedure performed
select PetID,Name as Dog_name from pets -- question (c)
where PetID in (select distinct(PetID) from ProceduresHistory);

-- Extract information on pet ids along with a description of the procedure performed on them
select a.PetID,a.ProcedureType,b.Description
from ProceduresHistory as a inner join ProceduresDetails as b
on a.ProcedureSubCode =b.ProcedureSubCode
order by a.PetID; 

--Same as above question but only keep those pet ids which are present in pets.csv
select a.PetID,a.ProcedureType,b.Description
from ProceduresHistory as a inner join ProceduresDetails as b
on a.ProcedureSubCode =b.ProcedureSubCode
where a.PetID in (select petID from pets)
order by a.PetID; 

--Find the sum of the price incurred on each pet’s procedure.
select a.PetID,a.Name,b.ProcedureSubCode,sum(c.Price) as Total_Expenditure
from Pets as a inner join ProceduresHistory as b
on a.PetID =b.PetID
inner join ProceduresDetails as c
on b.ProcedureSubCode =c.ProcedureSubCode
group by a.PetID,a.Name,b.ProcedureSubCode
order by a.PetID

--Same as above question but only consider those pet’s whose names start with ‘C’
select a.PetID,a.Name,b.ProcedureSubCode,sum(c.Price) as Total_Expenditure
from (select * from pets where Name like 'c%') as a inner join ProceduresHistory as b
on a.PetID =b.PetID 
inner join ProceduresDetails as c
on b.ProcedureSubCode =c.ProcedureSubCode
group by a.PetID,a.Name,b.ProcedureSubCode
order by a.PetID

--Same as above but only consider those pet’s whose owner’s name starts with ‘T’
select a.PetID,a.Name,b.ProcedureSubCode,sum(c.Price) as Total_Expenditure
from (select * from pets where OwnerID in (select OwnerID from owners where Name like
't%') ) as a inner join ProceduresHistory as b
on a.PetID =b.PetID
inner join ProceduresDetails as c
on b.ProcedureSubCode =c.ProcedureSubCode 
group by a.PetID,a.Name,b.ProcedureSubCode
order by a.PetID--Find the owner names who own more than 1 petselect a.PetID,a.Name as pet_name,CONCAT(b.Name,' ',b.Surname) as owner_name into Pets_owner_table
from pets as a inner join owners as b
on a.OwnerID =b.OwnerID;
select * from Pets_owner_table

--Find the count of procedures performed on each pet who are Dogs
select owner_name,count(owner_name) as count 
from Pets_owner_table
group by (owner_name)
having count(owner_name)>1
select a.PetID,a.Name,count(b.ProcedureType ) as procedure_count
from pets as a inner join ProceduresHistory as b
on a.PetID =b.PetID
where a.Kind = 'Dog'
group by a.PetID,a.Name

--Find the average price incurred by each owner for their pet’s procedure
select CONCAT (c.Name,c.surname) as owner_name,avg(Price) as avg_expenditure
from pets as a inner join ProceduresHistory as b
on a.PetID=b.PetID
inner join owners as c
on a.OwnerID =c.OwnerID
inner join ProceduresDetails as d
on b.ProcedureSubCode =d.ProcedureSubCode
group by CONCAT (c.Name,c.surname)