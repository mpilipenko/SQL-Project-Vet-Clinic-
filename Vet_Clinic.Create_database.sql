-- Creation of the database Vet_clinic

CREATE DATABASE Vet_Clinic;

USE Vet_Clinic;

CREATE TABLE Animals (
	ID INT PRIMARY KEY,
	Name VARCHAR(50),
	Species VARCHAR(20) NOT NULL,
	Breed VARCHAR(50),
	Age INT,
	Sex VARCHAR(20),
	Owner VARCHAR(20),
	Vaccines VARCHAR(20),
	Drug_allergies VARCHAR(50)
);
    
INSERT INTO Animals
	(ID, Name, Species, Breed, Age, Sex, Owner, Vaccines, Drug_allergies)
VALUES
	(1, 'Audrey', 'Cat', 'Domestic Shorthair', 2, 'Female', 'O4', 'V5', 'None'),
	(2, 'Pippy', 'Dog', 'Cockapoo', 9, 'Female', 'O1', 'V7', 'Adrenaline'),
	(3, 'Jack', 'Dog', 'Labrador Retriever', 5, 'Male', 'O2', 'V10', 'Neosporin'),
	(4, 'Ginger', 'Cat', 'Abyssinian', 3, 'Female', 'O5', 'V3', 'None'),
	(5, 'Stanley', 'Cat', 'British Shorthair', 1, 'Male', 'O3', 'V2', 'None'),
	(6, 'Snoopy', 'Dog', 'German Shepherd', 12, 'Female', 'O6', 'V6', 'Steroids'),
    (7, 'Stacey', 'Cat', 'Domestic Shorthair', 10, 'Female', 'O1', 'V5', 'None'),
	(8, 'Parker', 'Dog', 'Boxer', 5, 'Male', 'O2', 'V9', 'Penicillin');

ALTER TABLE Animals
ADD CONSTRAINT FOREIGN KEY(Owner) REFERENCES Owners(ID),
ADD CONSTRAINT FOREIGN KEY(Vaccines) REFERENCES Vaccines(ID);

CREATE TABLE Owners (
	ID VARCHAR(20) PRIMARY KEY,
	First_name VARCHAR(50) NOT NULL,
	Last_name VARCHAR(50) NOT NULL,
	Street VARCHAR(50),
	Postcode VARCHAR(50),
	Phone_number VARCHAR(50)
);

INSERT INTO Owners
	(ID, First_name, Last_name, Street, Postcode, Phone_number)
VALUES
	('O1', 'Leanne', 'Heath', '84 Mill Road', 'SW85 4CF', '077650455365'),
	('O2', 'Maria', 'Pilipenko', '15 The Crescent', 'E94 0RW', '073429122990'),
	('O3', 'John', 'Smith', '250 Richmond Road', 'WC63  8GO', '0773090144325'),
	('O4', 'David', 'Evans', '78 Green Lane', 'N13 2CN', '07869775005'),
	('O5', 'Jen', 'Warren', '17B Alexander Road', 'SW53 9MS', '077234156678'),
	('O6', 'Elizabeth', 'Wilson', '2 Church Stree', 'NW59 2QM', '077690189817');

CREATE TABLE Veterinarians (
	Vet_ID INT PRIMARY KEY,
	First_name VARCHAR(20) NOT NULL,
	Last_name VARCHAR(20) NOT NULL,
	Specialisation VARCHAR(50),
	Phone_number VARCHAR(20)
);
    
INSERT INTO Veterinarians
	(Vet_ID, First_name, Last_name, Specialisation, Phone_number)
VALUES
	(1, 'Carly', 'Budd', 'General', '0792847563'),
    (2, 'Oliver', 'Amadi', 'General', '0779202945'),
    (3, 'Robert', 'Walker', 'Surgery', '0777542738'),
    (4, 'Amy', 'Home', 'Receptionist', '0792535433'),
    (5, 'Darnell', 'Jones', 'Surgery', '07231621117'),
    (6, 'Priti', 'Kaur', 'Dentistry', '07928374655');
    
CREATE TABLE Price_List (
	Procedure_ID VARCHAR(20) PRIMARY KEY,
	Procedure_name VARCHAR(20),
	Price Decimal(10,2),
	Specialisation VARCHAR(20)
);

INSERT INTO Price_List
	(Procedure_ID, Procedure_name, Price, Specialisation)
VALUES
	('P1', 'Teeth Clean', 140.00, 'Dentistry'),
	('P2', 'Tooth Extraction', 80.00, 'Dentistry'),
	('P3', 'Wound Care', 50.00, 'General'),
	('P4', 'Gastrointestinal', 160.00, 'Surgery'),
	('P5', 'Vaccination', 40.00, 'General'),
	('P6', 'Blood Test', 100.00, 'General'),
	('P7', 'General Check', 45.00, 'General'),
	('P8', 'Castration', 180.00, 'Surgery');
    
CREATE TABLE Vaccines (
	ID VARCHAR(20) PRIMARY KEY,
	Name VARCHAR(50),
	Species VARCHAR(50)
);

INSERT INTO Vaccines
	(ID, Name, Species)
VALUES
	('V1', 'Cat Flu', 'Cat'),
	('V2', 'Feline Enteritis', 'Cat'),
	('V3', 'Feline Leukaemia Virus', 'Cat'),
	('V4', 'Feline Chlamydophila', 'Cat'),
	('V5', 'All in one for cats', 'Cat'),
	('V6', 'Parvovirus', 'Dog'),
	('V7', 'Distemper', 'Dog'),
	('V8', 'Leishmaniasis', 'Dog'),
	('V9', 'Herpes', 'Dog'),
	('V10', 'All in one for dogs', 'Dog');
    
CREATE TABLE Upcoming_Appointments (
	ID INT PRIMARY KEY,
	Appointment_Date DATE,
	Pet_ID INT,
	Procedure_ID VARCHAR(20),
	Vet_ID INT,
    FOREIGN KEY(Pet_ID) REFERENCES Animals(ID),
    FOREIGN KEY(Procedure_ID) REFERENCES Price_List(Procedure_ID),
    FOREIGN KEY(Vet_ID) REFERENCES Veterinarians(Vet_ID)
);

INSERT INTO Upcoming_Appointments
	(ID, Appointment_Date, Pet_ID, Procedure_ID, Vet_ID)
VALUES
	(1, '2023-04-21', 2, 'P3', 1),
	(2, '2023-05-30', 1, 'P4', 5),
	(3, '2024-01-02', 8, 'P8', 3),
	(4, '2023-09-07', 3, 'P2', 6),
	(5, '2023-04-28', 5, 'P5', 1),
	(6, '2023-05-01', 6, 'P7', 2),
	(7, '2023-08-13', 7, 'P1', 6),
	(8, '2024-01-30', 3, 'P5', 2);
    
CREATE TABLE Past_Appointments (
	ID INT PRIMARY KEY,
	Appointment_Date DATE,
	Pet_ID INT,
	Procedure_ID VARCHAR(20),
	Vet_ID INT,
	Outstanding_balance DECIMAL(10,2),
    FOREIGN KEY(Pet_ID) REFERENCES Animals(ID),
    FOREIGN KEY(Procedure_ID) REFERENCES Price_List(Procedure_ID),
    FOREIGN KEY(Vet_ID) REFERENCES Veterinarians(Vet_ID)
);

INSERT INTO Past_Appointments
	(ID, Appointment_Date, Pet_ID, Procedure_ID, Vet_ID, Outstanding_balance)
VALUES
	(1, '2022-03-26', 5, 'P2', 6, 0.00),
	(2, '2021-12-10', 6, 'P5', 2, 0.00),
	(3, '2022-03-15', 1, 'P6', 1, 50.00),
	(4, '2023-01-19', 2, 'P7', 2, 0.00),
	(5, '2022-04-07', 3, 'P8', 3, 80.00),
	(6, '2023-03-01', 8, 'P1', 6, 40.00);

CREATE TABLE Health_Plans (
	ID VARCHAR(20),
    Plan_name VARCHAR(20),
    Price_monthly DECIMAL(10,2),
    Price_annual DECIMAL(10,2)
);
    
INSERT INTO Health_Plans
	(ID, Plan_name, Price_monthly, Price_annual)
VALUES
	('H1', 'Cat', 20.00, 220.00),
	('H2', 'Dog (under 25kg)', 25.00, 270.00),
	('H3', 'Dog (over 25kg)', 30.00, 325.00);

ALTER TABLE Health_Plans
ADD CONSTRAINT PRIMARY KEY(ID);

CREATE TABLE Annual_Plans (
	Pet_ID INT,
    Plan_ID VARCHAR(20),
    Start_date DATE,
    End_date DATE,
    FOREIGN KEY(Pet_ID) REFERENCES Animals(ID),
    FOREIGN KEY(Plan_ID) REFERENCES Health_Plans(ID)
);

INSERT INTO Annual_Plans
	(Pet_ID, Plan_ID, Start_date, End_date)
VALUES
	(1, 'H1', '2022-08-16', '2023-08-16'),
	(2, 'H2', '2023-03-13', '2024-03-13'),
	(4, 'H1', '2023-01-25', '2024-01-25'),
	(5, 'H1', '2022-12-12', '2023-12-12'),
	(7, 'H1', '2023-03-10', '2024-03-10'),
	(8, 'H3', '2022-05-10', '2023-05-10');

-- Selecting all the values from the tables
    
SELECT * FROM Animals;
SELECT * FROM Owners;
SELECT * FROM Veterinarians;
SELECT * FROM Price_List;
SELECT * FROM Upcoming_Appointments;
SELECT * FROM Past_Appointments;
SELECT * FROM Vaccines;
SELECT * FROM Health_Plans;
SELECT * FROM Annual_Plans;