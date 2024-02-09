CREATE DATABASE IF NOT EXISTS myPodDB;
USE myPodDB;

-- Table pour stocker les informations des médecins
CREATE TABLE IF NOT EXISTS Medecins (
    MedecinID INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    prenom VARCHAR(100) NOT NULL,
    Specialite VARCHAR(255),
    NumeroTel VARCHAR(20),
    Email VARCHAR(255) UNIQUE,
    motdepasse VARCHAR(100) NOT NULL,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table pour stocker les informations personnelles des patients
CREATE TABLE IF NOT EXISTS Patients (
    PatientID INT AUTO_INCREMENT PRIMARY KEY,
    MedecinID INT,
    NomPren VARCHAR(255) NOT NULL,
    DateDeNais DATE,
    Adresse VARCHAR(255),
    NumeroTel VARCHAR(20),
    Email VARCHAR(255) UNIQUE,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (MedecinID) REFERENCES Medecins(MedecinID)
);
-- Table pour stocker les informations de l'utilisateur (authentification)
CREATE TABLE IF NOT EXISTS Infos (
    infoID INT AUTO_INCREMENT PRIMARY KEY,
    UserID INT,
    Username VARCHAR(255) UNIQUE NOT NULL,
    PasswordHash VARCHAR(255) NOT NULL,
    UserType ENUM('patient', 'medecin', 'admin') NOT NULL,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table pour stocker le plan de traitement
CREATE TABLE IF NOT EXISTS PlansTraitement (
    PlanID INT AUTO_INCREMENT PRIMARY KEY,
    PatientID INT,
    MedecinID INT,
    Description TEXT,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP,
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
    FOREIGN KEY (MedecinID) REFERENCES Medecins(MedecinID)
);

-- Table pour stocker les profils basaux (pour la pompe)
CREATE TABLE IF NOT EXISTS BasalProfiles (
    ProfileID INT AUTO_INCREMENT PRIMARY KEY,
    PatientID INT,
    BasalRate FLOAT,
    TimeFrame TIME,
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID)
);

-- Table pour stocker l'historique des injections (bolus)
CREATE TABLE IF NOT EXISTS HistoriqueInjections (
    HistoryID INT AUTO_INCREMENT PRIMARY KEY,
    PatientID INT,
    TempsInjection TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Dose FLOAT,
    TypeInjection ENUM('bolus', 'correction'),
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID)
);
-- Table pour stocker les informations des administrateurs
CREATE TABLE IF NOT EXISTS Admins (
    AdminID INT AUTO_INCREMENT PRIMARY KEY,
    Email VARCHAR(255) UNIQUE NOT NULL,
    PasswordHash VARCHAR(255) NOT NULL
);



-- Alimentation des tables

-- Insertion de données dans la table Medecins
INSERT INTO Medecins (nom, prenom, Specialite, NumeroTel, Email, motdepasse)
VALUES
    ('Dr. Dupont', 'Jean', 'Cardiologue', '555-123-4567', 'dr.dupont@example.com', 'motdepasse1'),
    ('Dr. Martin', 'Sophie', 'Généraliste', '555-987-6543', 'dr.martin@example.com', 'motdepasse2');

-- Insertion de données dans la table Patients
INSERT INTO Patients (MedecinID, NomPren, DateDeNais, Adresse, NumeroTel, Email)
VALUES
    (1, 'Patient1 NomPren', '1995-05-20', '123 Rue A', '555-111-2222', 'patient1@example.com'),
    (1, 'Patient2 NomPren', '1988-08-15', '456 Rue B', '555-333-4444', 'patient2@example.com');



-- Insertion de données dans la table Infos (utilisateurs)
INSERT IGNORE INTO Infos (UserID, Username, PasswordHash, UserType)
VALUES
    (1, 'patient1', 'hash123', 'patient'),
    (2, 'patient2', 'hash456', 'patient'),
    (3, 'medecin1', 'hash789', 'medecin'),
    (4, 'admin1', 'hashadmin', 'admin');

-- Insertion de données dans la table PlansTraitement
INSERT IGNORE INTO PlansTraitement (PatientID, MedecinID, Description)
VALUES
    (1, 3, 'Plan de traitement pour John Doe'),
    (2, 3, 'Plan de traitement pour Jane Smith');

-- Insertion de données dans la table BasalProfiles
INSERT IGNORE INTO BasalProfiles (PatientID, BasalRate, TimeFrame)
VALUES
    (1, 1.5, '08:00:00'),
    (2, 2.0, '07:30:00');

-- Insertion de données dans la table HistoriqueInjections
INSERT IGNORE INTO HistoriqueInjections (PatientID, TempsInjection, Dose, TypeInjection)
VALUES
    (1, '2024-01-15 10:30:00', 2.5, 'bolus'),
    (2, '2024-01-16 14:45:00', 3.0, 'correction');

-- Insertion de données dans la table Admins
INSERT INTO Admins (Email, PasswordHash)
VALUES
    ('admin@example.com', 'hashadmin')
