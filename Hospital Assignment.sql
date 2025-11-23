set search_path to hospital;
show search_path;

select*from admissions;
select*from appointments;
select*from bills;
select*from  doctors;
select*from nurses;
select*from patients;
select*from payments;
select*from prescriptions;
select*from treatments;
select*from wards;

 -- 1.Retrieve the list of all male patients who were born after 1990, including their patient ID, first 
-- name, last name, and date of birth.  
select p."PatientID" , p."FirstName" ,p."LastName" ,p."DateOfBirth",p."Gender" 
from patients p 
where p."Gender"= 'M' and p."DateOfBirth" > between '1990-12-31' and '2025-11-12';



-- 2.Produce a report showing the ten most recent appointments in the system, ordered from the 
-- newest to the oldest.  

select "AppointmentID", "PatientID", "AppointmentDate"
from appointments a 
order by "AppointmentDate" desc 
limit 10;

--  3.Generate a report that shows all appointments along with the full names of the patients and 
-- doctors involved.  
 
with Appointment_info as ( 
select a."AppointmentID",a."PatientID",a."AppointmentDate",p."FirstName" as "Patient_name", d."DoctorID",d."FirstName" as "Doctor's_name"
from appointments a 
join patients p 
on a."PatientID" = p."PatientID" 
join doctors d 
on d."DoctorID" = a."DoctorID" 
)
select * from Appointment_info 
order by "AppointmentDate" desc;


SELECT a."AppointmentID" ,
CONCAT(p."FirstName" , ' ', p."LastName" ) AS patient_name,
CONCAT(d."FirstName" , ' ', d."LastName" ) AS doctor_name,
a."AppointmentDate" ,
a."Status" 
FROM appointments a
JOIN patients p ON a."PatientID"  = p."PatientID" 
JOIN Doctors d ON a."DoctorID" = d."DoctorID" ;


select*from patients;
select*from treatments;
select*from appointments;

--  4.Prepare a list that shows all patients together with any treatments they have received,
-- ensuring that patients without treatments also appear in the results.
select p."PatientID", p."FirstName", p."LastName",t."TreatmentID",t."TreatmentType"
from patients p 
left join appointments a 
on p."PatientID"= a."PatientID" 
left join treatments t 
on t."AppointmentID" = a."AppointmentID" 
order by "TreatmentType";

-- 5.Identify any treatments recorded in the system that do not have a matching appointment. 
with Treatment_info as (
select a."AppointmentDate",t."TreatmentID",t."TreatmentType", t."AppointmentID", a."AppointmentID" as "matched_appointment"
from treatments t 
left join appointments a 
on t."AppointmentID" = a."AppointmentID" 
)
select *from Treatment_info 
where matched_appointment is null;


select*from  doctors;
select*from appointments;

-- 6.Create a summary that shows how many appointments each doctor has handled,
 -- ordered from the highest to the lowest count.  
select d."DoctorID",d."FirstName",d."LastName", count(a."AppointmentID") as total_appointment
from doctors d 
left join appointments a 
on d."DoctorID" = a."DoctorID" 
group by d."DoctorID",d."FirstName",d."LastName" 
order by total_appointment desc;

-- 7.produce a list of doctors who have handled more than twenty appointments, 
-- showing their doctor ID, specialization, and total appointment count.  
with Doctor_appointments as (
select d."DoctorID" ,d."Specialization", count(a."AppointmentID" ) as total_appointments
from Doctors d
join Appointments a
on d."DoctorID" = a."DoctorID"  
group by d."DoctorID" , d."Specialization"
)
select *from Doctor_appointments 
where total_appointments >20
order by total_appointments desc;

select*from  doctors;
select*from appointments;
select*from patients;

-- 8.Retrieve the details of all patients who have had appointments with doctors 
-- whose specialization is “Cardiology.”  
select distinct p."PatientID",p."FirstName", p."LastName", a."AppointmentID", d."DoctorID", d."Specialization"
from patients p 
join appointments a 
on p."PatientID" = a."PatientID" 
join doctors d 
on a."DoctorID" = d."DoctorID" 
where d."Specialization" = 'Cardiology';


select*from bills;
select*from patients;
select*from admissions;

-- 9. Produce a list of patients who have at least one bill that remains unpaid.  
select distinct  p."PatientID",p."FirstName",p."LastName",a."AdmissionID",b."OutstandingAmount"
from patients p 
join admissions a 
on p."PatientID" = a."PatientID" 
join bills b 
on a."AdmissionID" = b."AdmissionID" 
where b."OutstandingAmount" = '0';

-- 10. Retrieve all bills whose total amount is higher than the 
-- average total amount for all bills in the system. 
select * from bills b 
where b."TotalAmount"  > (
select AVG("TotalAmount")
from bills
);


select*from appointments;
select*from patients;

-- 11. For each patient in the database, identify their most recent 
-- appointment and list it along with the patient’s ID.  
select distinct on (a."PatientID")
a."PatientID",
a."AppointmentID",
a."AppointmentDate",
a."Status"
from appointments a
order by a."PatientID", a."AppointmentDate" desc;


-- 12. For every appointment in the system, assign a sequence number 
-- that ranks each patient’s appointments from most recent to oldest.  
select "AppointmentID","PatientID", "AppointmentDate",dense_rank() over(partition by "PatientID"
    order by "AppointmentDate" desc) as appointment_rank
from appointments a 
order by "PatientID", appointment_rank;

-- 13. Generate a report showing the number of appointments per day for October 2021, 
-- including a running total across the month. 
SELECT
DATE("AppointmentDate") as appointment_day,
COUNT(*) as daily_appointments,
SUM(COUNT(*)) OVER (ORDER BY DATE("AppointmentDate")) as running_total
FROM appointments
WHERE "AppointmentDate" >= '2021-10-01' AND "AppointmentDate" < '2021-11-01'
GROUP BY DATE("AppointmentDate")
ORDER BY appointment_day;


select*from bills;

--  14. Using a temporary query structure, calculate the average, minimum, and 
-- maximum total bill amount, and then return these values in a single result set. 
select 
    AVG("TotalAmount") AS average_bill,
    min("TotalAmount") AS minimum_bill,
    max("TotalAmount") AS maximum_bill
from bills;


select*from bills;
select*from admissions;

-- 15. Build a query that identifies all patients who currently have an outstanding balance, 
-- based on information from admissions and billing records
select distinct p."PatientID", p."FirstName",p."LastName", a."AdmissionID",b."OutstandingAmount" 
from patients p 
join admissions a 
on p."PatientID"  = a."PatientID" 
join bills b 
on a."AdmissionID"  = b."AdmissionID" 
where  b."OutstandingAmount" > '0'
ORDER BY p."PatientID" desc;


select*from appointments;

-- 16. Create a query that generates all dates from January 1 to January 15, 2021, 
-- and show how many appointments occurred on each of those dates. 


select*from patients;

-- 17. Add a new patient record to the Patients table, providing appropriate 
-- information for all required fields. 
insert into patients("PatientID","FirstName", "LastName", "Gender", "DateOfBirth", "Email")
values(
'P1001','Luke', 'Mbandu','M','2000-01-01','lukembandu@gmail.com'
);


select*from patients;
select*from appointments;


-- 18. Modify the appointments table so that any appointment with a NULL 
-- status is updated to show “Scheduled.”  
update appointments 
set "Status"= 'Scheduled'
where "Status" is null;

select* from prescriptions;

-- 19. Remove all prescription records that belong to appointments marked as “Cancelled.”  
delete from prescriptions 
where "AppointmentID" in (
select "AppointmentID"
from appointments a 
where a."Status" = 'Cancelled');

select* from appointments;
select* from doctors;
-- 20. Create a stored procedure that adds a new record to the Doctors table.
create or replace procedure hospital.add_doctor(
p_doctor_id varchar(50),
P_first_name varchar(50),
p_last_name varchar(50),
p_specialization varchar(50),
p_email varchar(50),
p_phone_number varchar(50)
)
language plpgsql
as $$
begin
	insert into hospital.doctors(
	"DoctorID",
	"FirstName",
	"LastName",
	"Specialization",
	"Email",
	"PhoneNumber"
	)
	values(
	p_doctor_id,
	P_first_name,
	p_last_name,
	p_specialization,
	p_email,
	p_phone_number
	);
end;
$$;

call hospital.add_doctor('D0015','James','Yusuf','Pediatrics','jamesyusuf@gmail.com','555-02312');
select*from doctors;

select*from appointments;
-- 21. Create a stored procedure that records a new appointment and 
-- automatically performs validation before inserting. 
create or replace procedure hospital.add_appointment(
p_appointment_id varchar(50),
p_patient_id varchar(50),
p_doctor_id varchar(50),
p_appointment_date date,
p_status varchar(50),
p_nurse_id varchar(50)
)
language plpgsql
as $$
begin
	insert into hospital.appointments(
	"AppointmentID",
	"PatientID",
	"DoctorID",
	"AppointmentDate",
	"Status",
	"NurseID"
	)
	values(
	p_appointment_id,
	p_patient_id,
	p_doctor_id,
	p_appointment_date,
	p_status,
	p_nurse_id 
	);
end;
$$;

call hospital.add_appointment('A0021','P0123','D0345','2021-11-28','Scheduled','N0200');

select*from appointments a
where a."AppointmentID"  = 'A0021';

select*from doctors d 
where d."DoctorID"= 'D0345';


