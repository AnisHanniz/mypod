const express = require("express");
const bodyParser = require("body-parser");
const mysql = require("mysql");
const cors = require("cors");

const app = express();
const port = 3000;

app.use(cors());
app.use(bodyParser.json());

// Configuration de la connexion à la base de données MySQL
const pool = mysql.createPool({
  connectionLimit: 10,
  host: "srv-dpi-proj-adgm.univ-rouen.fr",
  user: "votre_utilisateur", // Remplacez par votre utilisateur
  password: "votre_mot_de_passe", // Remplacez par votre mot de passe
  database: "myPodDB",
});

// Route de test pour vérifier que l'API fonctionne
app.get("/", (req, res) => {
  res.json({ message: "API myPodDB fonctionne" });
});

// Route pour récupérer tous les médecins
app.get("/medecins", (req, res) => {
  pool.query("SELECT * FROM Medecins", (error, results) => {
    if (error) return res.status(500).json({ error });
    res.json(results);
  });
});

// Route pour récupérer un médecin par ID
app.get("/medecins/:id", (req, res) => {
  const { id } = req.params;
  pool.query(
    "SELECT * FROM Medecins WHERE MedecinID = ?",
    [id],
    (error, results) => {
      if (error) return res.status(500).json({ error });
      res.json(results[0]);
    }
  );
});
// Route pour récupérer tous les plans de traitement
app.get("/planstraitement", (req, res) => {
  pool.query("SELECT * FROM PlansTraitement", (error, results) => {
    if (error) return res.status(500).json({ error });
    res.json(results);
  });
});
// Route pour récupérer tous les profils basaux
app.get("/basalprofiles", (req, res) => {
  pool.query("SELECT * FROM BasalProfiles", (error, results) => {
    if (error) return res.status(500).json({ error });
    res.json(results);
  });
});
// Route pour récupérer l'historique des injections
app.get("/historiqueinjections", (req, res) => {
  pool.query("SELECT * FROM HistoriqueInjections", (error, results) => {
    if (error) return res.status(500).json({ error });
    res.json(results);
  });
});

// Ajoutez des routes similaires pour les autres tables

app.listen(port, () => {
  console.log(`API myPodDB en écoute sur http://localhost:${port}`);
});
