
CREATE DATABASE IF NOT EXISTS myPodDB;
 use myPodDB;

CREATE TABLE `registre` IF NOT EXISTS (
  `nom` varchar(100) NOT NULL,
  `prenom` varchar(100) NOT NULL,
  `adressemail` varchar(100) NOT NULL,
  `motdepasse` varchar(100) NOT NULL,
  `pseudo` varchar(100) NOT NULL,
  `id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

ALTER TABLE `registre`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `registre`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
COMMIT;


INSERT INTO registre (nom, prenom, adressemail, motdepasse, pseudo) VALUES ('dine', 'dine', 'dine@dine.com', 'dine', 'dine');


-- Table pour stocker les informations personnelles des patiens
CREATE TABLE Patients (
    PatientID INT AUTO_INCREMENT PRIMARY KEY,
    NomPren VARCHAR(255) NOT NULL,
    NumSecu INT(10) NOT NULL,
    DateDeNais DATE,
    Adresse VARCHAR(255),
    NumeroTel VARCHAR(20),
    Email VARCHAR(255) UNIQUE,
    -- Autre
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table pour stocker les informations des médecins
CREATE TABLE Medecins (
    MedecinID INT AUTO_INCREMENT PRIMARY KEY,
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
    UserType ENUM('patient', 'medecin', 'admin') NOT NULL,
    -- Autre
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

--à modifier
-- Table pour stocker le plan de traitement
CREATE TABLE PlansTraitement (
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
CREATE TABLE BasalProfiles (
    ProfileID INT AUTO_INCREMENT PRIMARY KEY,
    PatientID INT,
    BasalRate FLOAT,
    TimeFrame TIME,
    -- Autre
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID)
);

CREATE TABLE AppSettings (
    SettingID INT AUTO_INCREMENT PRIMARY KEY,
    PatientID INT,
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

--Alimentation des tables

-- Insertion de données dans la table Patients
INSERT INTO Patients (NomPren, NumSecu, DateDeNais, Adresse, NumeroTel, Email)
VALUES
    ('John Doe', 1234567890, '1990-05-15', '123 Main St', '555-123-4567', 'john.doe@example.com'),
    ('Jane Smith', 9876543210, '1985-08-20', '456 Elm St', '555-987-6543', 'jane.smith@example.com');

-- Insertion de données dans la table Medecins
INSERT INTO Medecins (NomPren, Specialite, NumeroTel, Email)
VALUES
    ('Dr. Smith', 'Cardiologue', '555-555-5555', 'dr.smith@example.com'),
    ('Dr. Johnson', 'Généraliste', '555-666-6666', 'dr.johnson@example.com');

-- Insertion de données dans la table Infos (utilisateurs)
INSERT INTO Infos (UserID, Username, PasswordHash, UserType)
VALUES
    (1, 'patient1', 'hash123', 'patient'),
    (2, 'patient2', 'hash456', 'patient'),
    (3, 'medecin1', 'hash789', 'medecin'),
    (4, 'admin1', 'hashadmin', 'admin');

-- Insertion de données dans la table PlansTraitement
INSERT INTO PlansTraitement (PatientID, MedecinID, Description)
VALUES
    (1, 3, 'Plan de traitement pour John Doe'),
    (2, 3, 'Plan de traitement pour Jane Smith');

-- Insertion de données dans la table BasalProfiles
INSERT INTO BasalProfiles (PatientID, BasalRate, TimeFrame)
VALUES
    (1, 1.5, '08:00:00'),
    (2, 2.0, '07:30:00');

-- Insertion de données dans la table AppSettings
INSERT INTO AppSettings (PatientID, SettingName, SettingValue)
VALUES
    (1, 'Thème', 'Clair'),
    (2, 'Notifications', 'Activé');

-- Insertion de données dans la table HistoriqueInjections
INSERT INTO HistoriqueInjections (PatientID, TempsInjection, Dose, TypeInjection)
VALUES
    (1, '2024-01-15 10:30:00', 2.5, 'bolus'),
    (2, '2024-01-16 14:45:00', 3.0, 'correction');

