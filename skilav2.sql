use Skilaverkefni;

delimiter $$
drop trigger if exists villuboð $$
create trigger villuboð
before insert on Restrictors
for each row
	begin
		declare msg varchar(255);
        if (new.courseNumber = new.restrictorID) then
			set msg = concat('courseNumer er það sama og restrictorsID', cast(new.restrictorID as char));
            signal sqlstate '45000' set message_text = msg;
		end if;
            
	end $$

delimiter ;
drop table Restrictors;
insert into Restrictors(courseNumber,restrictorID,restrictorType)
values('GSF2A3U','GSF2A3U',1);

select * from Restrictors;
select * from villuboð;

delimiter $$
drop trigger if exists UpdateRestrictors $$
create trigger UpdateRestrictors
after update on Restrictors
for each row
	begin
		declare msg varchar(255);
        if (new.courseNumber = new.restrictorID) then
			set msg = concat('courseNumer er það sama og restrictorsID', cast(new.restrictorID as char));
            signal sqlstate '45000' set message_text = msg;
		end if;
    end $$
delimiter ;

delimiter $$
drop procedure if exists allarEiningar $$
create procedure allarEiningar(SID int)
begin

	select concat(firstName, " ", lastName) as name
    from students
    where studentID = SID
    
    union all
    
	select trackID as track
    from Registration
    where studentID = SID
    
    union all
    
    select count(courseNumber) as "CoursesNum"
    from Registration
    where studentID = SID;
    
end $$
delimiter ;
call allarEiningar(1);


delimiter $$
drop procedure if exists AddStudent $$
create procedure AddStudent(firstaNafn varchar(55), sinaNafn varchar(55), fDagur date, byrjunAnnar int, trackerID int)
begin
	insert into Students(firstName,lastName,dob,startSemester)values(firstaNafn, seinaNafn, fDagur, byrjunAnnar);
    
	set @SID = (select * from Students Order by id Desc Limit 1);
    call AddMandatoryCourses(SID, trackerID);
end $$
delimiter ;

delimiter $$
drop procedure if exists AddMandatoryCourses $$
create procedure AddMandatoryCourses(SID int, onn int)
begin
	
insert into Registration(studentID,trackID,courseNumber,registrationDate,passed,semesterID)values(SID,9,'STÆ103',curdate(),true,onn);
insert into Registration(studentID,trackID,courseNumber,registrationDate,passed,semesterID)values(SID,9,'EÐL103',curdate(),true,onn);
insert into Registration(studentID,trackID,courseNumber,registrationDate,passed,semesterID)values(SID,9,'STÆ203',curdate(),true,onn+1);
insert into Registration(studentID,trackID,courseNumber,registrationDate,passed,semesterID)values(SID,9,'EÐL203',curdate(),true,onn+1);
insert into Registration(studentID,trackID,courseNumber,registrationDate,passed,semesterID)values(SID,9,'STÆ303',curdate(),true,onn+2);
insert into Registration(studentID,trackID,courseNumber,registrationDate,passed,semesterID)values(SID,9,'GSF2A3U',curdate(),true,onn+2);
insert into Registration(studentID,trackID,courseNumber,registrationDate,passed,semesterID)values(SID,9,'FOR3G3U',curdate(),true,onn+3);
insert into Registration(studentID,trackID,courseNumber,registrationDate,passed,semesterID)values(SID,9,'GSF2B3U',curdate(),true,onn+3);
insert into Registration(studentID,trackID,courseNumber,registrationDate,passed,semesterID)values(SID,9,'GSF3B3U',curdate(),false,onn+4);
insert into Registration(studentID,trackID,courseNumber,registrationDate,passed,semesterID)values(SID,9,'FOR3D3U',curdate(),false,onn+4);

end $$
delimiter ;

delimiter $$
drop procedure if exists StudentRegistration $$
create procedure StudentRegistration(SID int, trackerID int, courseNumer char(10), semID int)
begin
	insert into Registration(studentID,trackID,courseNumber,registrationDate,passed,semesterID)
    values(SID, trackerID, courseNumer, GetDate(), false, semID);
end $$
delimiter ;
