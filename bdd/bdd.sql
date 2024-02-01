CREATE DATABASE IF NOT EXISTS myPodDB;

USE myPodDB;

-- Table pour stocker les informations personnelles des patiens
CREATE TABLE Patients (
    Patients INT AUTO_INCREMENT PRIMARY KEY,
    NomPren VARCHAR(255) NOT NULL,
    DateDeNais DATE,
    Adresse VARCHAR(255),
    NumeroTel VARCHAR(20),
    Email VARCHAR(255) UNIQUE,
    -- Autre
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table pour stocker les informations des médecins
CREATE TABLE Medecins (
    DoctorID INT AUTO_INCREMENT PRIMARY KEY,
    NomPren VARCHAR(255) NOT NULL,
    Specialite VARCHAR(255),
    NumeroTel VARCHAR(20),
    Email VARCHAR(255) UNIQUE,
    -- Autre
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table pour stocker les informations de l'utilisateur (authentification)
CREATE TABLE Infos (
    infoID INT AUTO_INCREMENT PRIMARY KEY,
    UserID INT,
    Username VARCHAR(255) UNIQUE NOT NULL,
    PasswordHash VARCHAR(255) NOT NULL,
    UserType ENUM('patient', 'doctor', 'admin') NOT NULL,
    -- Autre
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


--à modifier


-- Table pour stocker le plan de traitement
CREATE TABLE PlansTraitement (
    PlanID INT AUTO_INCREMENT PRIMARY KEY,
    PatientID INT,
    DoctorID INT,
    Description TEXT,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP,
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
    FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID)
);

-- Table pour stocker les profils basaux (pour la pompe)
CREATE TABLE BasalProfiles (
    ProfileID INT AUTO_INCREMENT PRIMARY KEY,
    PatientID INT,
    BasalRate FLOAT,
    TimeFrame TIME,
    -- Autre
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID)
);

-- Table for storing application settings for each patient
CREATE TABLE AppSettings (
    SettingID INT AUTO_INCREMENT PRIMARY KEY,
    PatientID INT,
    --à modifier
    SettingName VARCHAR(255),
    SettingValue VARCHAR(255),
    -- Autre / Thème? Notifications? 
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID)
);

-- Table pour stocker l'historique des injections (bolus)
CREATE TABLE HistoriqueInjections (
    HistoryID INT AUTO_INCREMENT PRIMARY KEY,
    PatientID INT,
    TempsInjection TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Dose FLOAT,
    TypeInjection ENUM('bolus', 'correction'),
    -- Autre
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID)
);
