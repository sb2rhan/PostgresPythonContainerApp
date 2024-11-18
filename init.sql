CREATE TABLE Country (
    cname VARCHAR(50) PRIMARY KEY,
    population BIGINT
);

CREATE TABLE DiseaseType (
    id INTEGER PRIMARY KEY,
    description VARCHAR(140)
);

CREATE TABLE Disease (
    disease_code VARCHAR(50) PRIMARY KEY,
    pathogen VARCHAR(20),
    description VARCHAR(140),
    id INTEGER,
    FOREIGN KEY (id) REFERENCES DiseaseType(id) ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE Users (
    email VARCHAR(60) PRIMARY KEY,
    name VARCHAR(30),
    surname VARCHAR(40),
    salary INTEGER,
    phone VARCHAR(20),
    cname VARCHAR(50),
    FOREIGN KEY (cname) REFERENCES Country(cname) ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE Patients (
    email VARCHAR(60) PRIMARY KEY,
    FOREIGN KEY (email) REFERENCES Users(email) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Discover (
    cname VARCHAR(50),
    disease_code VARCHAR(50),
    first_enc_date DATE,
    PRIMARY KEY (cname, disease_code),
    FOREIGN KEY (cname) REFERENCES Country(cname) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (disease_code) REFERENCES Disease(disease_code) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE PatientDisease (
    email VARCHAR(60),
    disease_code VARCHAR(50),
    PRIMARY KEY (email, disease_code),
    FOREIGN KEY (email) REFERENCES Users(email) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (disease_code) REFERENCES Disease(disease_code) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE PublicServant (
    email VARCHAR(60) PRIMARY KEY,
    department VARCHAR(50),
    FOREIGN KEY (email) REFERENCES Users(email) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Doctor (
    email VARCHAR(60) PRIMARY KEY,
    degree VARCHAR(20),
    FOREIGN KEY (email) REFERENCES Users(email) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Specialize (
    id INTEGER,
    email VARCHAR(60),
    PRIMARY KEY (id, email),
    FOREIGN KEY (id) REFERENCES DiseaseType(id) ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY (email) REFERENCES Doctor(email) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Record (
    email VARCHAR(60),
    cname VARCHAR(50),
    disease_code VARCHAR(50),
    total_deaths INTEGER,
    total_patients INTEGER,
    FOREIGN KEY (email) REFERENCES PublicServant(email) ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY (cname) REFERENCES Country(cname) ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY (disease_code) REFERENCES Disease(disease_code) ON DELETE SET NULL ON UPDATE CASCADE
);

INSERT INTO Country (cname, population) VALUES
('USA', 331000000), ('Canada', 37740000), ('UK', 67886000),
('Germany', 83783942), ('France', 65273511), ('Italy', 60461826),
('Kazakhstan', 20592571), ('China', 1439323776), ('India', 1380004385), ('Brazil', 212559417);

INSERT INTO DiseaseType (id, description) VALUES
(1, 'virology'), (2, 'bacterial infection'), (3, 'parasitic disease'),
(4, 'fungal infection'), (5, 'infectious diseases'), (6, 'cardiology'),
(7, 'neurology'), (8, 'skin infection'), (9, 'oncology'), (10, 'bone diseases'),
(11, 'orthopedics'), (12, 'mental diseases'), (13, 'endocrinology');

INSERT INTO Disease (disease_code, pathogen, description, id) VALUES
('COVID-19', 'virus', 'respiratory illness', 1), ('Malaria', 'parasite', 'fever', 3),
('Tuberculosis', 'bacteria', 'lung disease', 2), ('Cholera', 'bacteria', 'severe diarrhea', 2),
('Influenza', 'virus', 'flu', 1), ('HIV', 'virus', 'immune deficiency', 1),
('Lyme', 'bacteria', 'tick-borne illness', 2), ('Measles', 'virus', 'rash', 1),
('Ebola', 'virus', 'hemorrhagic fever', 5), ('Salmonella', 'bacteria', 'food poisoning', 2);

INSERT INTO Users (email, name, surname, salary, phone, cname) VALUES
('ethan.williams@gmail.com', 'Ethan', 'Williams', 65000, '1111111111', 'USA'),
('olivia.brown@yahoo.com', 'Olivia', 'Brown', 70000, '2222222222', 'USA'),
('liam.thompson@mail.ca', 'Liam', 'Thompson', 62000, '3333333333', 'Canada'),
('emma.moore@canada.ca', 'Emma', 'Moore', 68000, '4444444444', 'Canada'),
('noah.davies@ukmail.com', 'Noah', 'Davies', 67000, '5555555555', 'UK'),
('amelia.evans@mail.uk', 'Amelia', 'Evans', 63000, '6666666666', 'UK'),
('lukas.schmidt@germany.de', 'Lukas', 'Schmidt', 71000, '7777777777', 'Germany'),
('anna.mueller@mail.de', 'Anna', 'Mueller', 72000, '8888888888', 'Germany'),
('leo.martin@frmail.fr', 'Leo', 'Martin', 60000, '9999999999', 'France'),
('chloe.bernard@mail.fr', 'Chloe', 'Bernard', 58000, '1010101010', 'France'),
('matteo.rossi@italia.it', 'Matteo', 'Rossi', 75000, '1212121212', 'Italy'),
('sofia.bianchi@mail.it', 'Sofia', 'Bianchi', 64000, '1313131313', 'Italy'),
('dana.nurgalieva@mail.kz', 'Dana', 'Nurgalieva', 67000, '1414141414', 'Kazakhstan'),
('azamat.abiyev@mail.kz', 'Azamat', 'Abiyev', 62000, '1515151515', 'Kazakhstan'),
('jing.li@mail.cn', 'Jing', 'Li', 58000, '1616161616', 'China'),
('hong.wang@mail.cn', 'Hong', 'Wang', 70000, '1717171717', 'China'),
('arjun.sharma@mail.in', 'Arjun', 'Sharma', 68000, '1818181818', 'India'),
('neha.patel@mail.in', 'Neha', 'Patel', 65000, '1919191919', 'India'),
('joao.silva@mail.br', 'Joao', 'Silva', 71000, '2020202020', 'Brazil'),
('larissa.souza@mail.br', 'Larissa', 'Souza', 63000, '2121212121', 'Brazil'),
('ethan.green@mail.com', 'Ethan', 'Green', 60000, '2223334444', 'USA'),
('olivia.johnson@mail.org', 'Olivia', 'Johnson', 75000, '3334445555', 'Canada'),
('liam.miller@mail.net', 'Liam', 'Miller', 58000, '4445556666', 'UK'),
('almagul.omarova@mail.net', 'Almagul', 'Omarova', 54000, '5556667777', 'Kazakhstan'),
('lukas.klein@mail.org', 'Lukas', 'Klein', 63000, '6667778888', 'Germany'),
('sofia.verdi@mail.it', 'Sofia', 'Verdi', 62000, '7778889999', 'Italy'),
('jing.chen@mail.com', 'Jing', 'Chen', 60000, '8889990000', 'China'),
('aibek.erken@mail.com', 'Aibek', 'Erken', 58000, '9990001111', 'Kazakhstan');

INSERT INTO Doctor (email, degree) VALUES
('ethan.williams@gmail.com', 'MD'),
('olivia.brown@yahoo.com', 'MBBS'),
('dana.nurgalieva@mail.kz', 'DO'),
('azamat.abiyev@mail.kz', 'MD'),
('matteo.rossi@italia.it', 'MBBS'),
('sofia.bianchi@mail.it', 'MD'),
('jing.li@mail.cn', 'DO'),
('neha.patel@mail.in', 'MBBS'),
('leo.martin@frmail.fr', 'MD'),
('lukas.schmidt@germany.de', 'DO');

INSERT INTO Patients (email) VALUES
('liam.thompson@mail.ca'),
('emma.moore@canada.ca'),
('noah.davies@ukmail.com'),
('amelia.evans@mail.uk'),
('chloe.bernard@mail.fr'),
('hong.wang@mail.cn'),
('arjun.sharma@mail.in'),
('joao.silva@mail.br'),
('larissa.souza@mail.br'),
('almagul.omarova@mail.net');

INSERT INTO PublicServant (email, department) VALUES
('ethan.green@mail.com', 'Health'),
('olivia.johnson@mail.org', 'Education'),
('liam.miller@mail.net', 'Environment'),
('almagul.omarova@mail.net', 'Tourism'),
('lukas.klein@mail.org', 'Housing'),
('sofia.verdi@mail.it', 'Finance'),
('jing.chen@mail.com', 'Agriculture'),
('aibek.erken@mail.com', 'Education'),
('leo.martin@frmail.fr', 'Transportation'),
('chloe.bernard@mail.fr', 'Energy');

INSERT INTO Specialize (id, email) VALUES
(1, 'ethan.williams@gmail.com'),
(6, 'ethan.williams@gmail.com'),
(2, 'olivia.brown@yahoo.com'),
(9, 'olivia.brown@yahoo.com'),
(7, 'olivia.brown@yahoo.com'),
(5, 'dana.nurgalieva@mail.kz'),
(3, 'azamat.abiyev@mail.kz'),
(4, 'azamat.abiyev@mail.kz'),
(4, 'matteo.rossi@italia.it'),
(1, 'sofia.bianchi@mail.it'),
(7, 'sofia.bianchi@mail.it'),
(9, 'sofia.bianchi@mail.it'),
(1, 'jing.li@mail.cn'),
(13, 'jing.li@mail.cn'),
(1, 'neha.patel@mail.in'),
(10, 'neha.patel@mail.in'),
(7, 'neha.patel@mail.in'),
(2, 'leo.martin@frmail.fr'),
(6, 'leo.martin@frmail.fr'),
(5, 'lukas.schmidt@germany.de');

INSERT INTO Discover (cname, disease_code, first_enc_date) VALUES
('USA', 'COVID-19', '2019-12-01'), ('Canada', 'COVID-19', '2019-12-15'),
('UK', 'COVID-19', '2019-12-20'), ('Germany', 'Influenza', '1995-01-01'),
('France', 'Tuberculosis', '1900-01-01'), ('China', 'Malaria', '2005-06-01'),
('India', 'Malaria', '2006-07-15'), ('Brazil', 'Ebola', '2014-03-01'),
('USA', 'Cholera', '1980-06-01'), ('India', 'Tuberculosis', '1965-11-20');

INSERT INTO PatientDisease (email, disease_code) VALUES
('liam.thompson@mail.ca', 'COVID-19'),
('emma.moore@canada.ca', 'COVID-19'),
('noah.davies@ukmail.com', 'Influenza'),
('amelia.evans@mail.uk', 'Influenza'),
('chloe.bernard@mail.fr', 'Tuberculosis'),
('hong.wang@mail.cn', 'Malaria'),
('arjun.sharma@mail.in', 'Malaria'),
('joao.silva@mail.br', 'Ebola'),
('larissa.souza@mail.br', 'Ebola'),
('almagul.omarova@mail.net', 'Tuberculosis');

INSERT INTO Record (email, cname, disease_code, total_deaths, total_patients) VALUES
('ethan.green@mail.com', 'USA', 'COVID-19', 500000, 2),
('olivia.johnson@mail.org', 'Canada', 'COVID-19', 3000, 30000),
('liam.miller@mail.net', 'UK', 'Influenza', 80000, 5000000),
('almagul.omarova@mail.net', 'UK', 'Influenza', 40000, 2000000),
('lukas.klein@mail.org', 'France', 'Tuberculosis', 12000, 400000),
('sofia.verdi@mail.it', 'Brazil', 'Ebola', 5000, 200000),
('jing.chen@mail.com', 'China', 'Malaria', 10000, 600000),
('aibek.erken@mail.com', 'Kazakhstan', 'COVID-19', 4, 100),
('leo.martin@frmail.fr', 'France', 'Tuberculosis', 25000, 500000),
('chloe.bernard@mail.fr', 'France', 'Tuberculosis', 12000, 300000);