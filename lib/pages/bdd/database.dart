import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseProvider {
  static Database? _database;

  Future<Database> initDB() async {
    if (_database != null) {
      return _database!;
    }
    String path = await getDatabasesPath();
    path = join(path, 'local.db');
    print("Database path: $path");

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await createLoginsTable(db);
      },
    );
    return _database!;
  }

  Future<void> createLoginsTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS logins (
        id INTEGER PRIMARY KEY,
        nom_utilisateur TEXT,
        email TEXT
      )
    ''');
    print('Table "logins" créée ou déjà existante');
  }

  Future<void> readLoginsTable(Database db) async {
    List<Map<String, dynamic>> logins = await db.query('logins');
    for (Map<String, dynamic> login in logins) {
      print('ID: ${login['id']}');
      print('Nom d\'utilisateur: ${login['nom_utilisateur']}');
      print('Email: ${login['email']}');
      print('---');
    }
  }

  Future<void> updateLoginsTable(Database db, int id, String newNomUtilisateur,
      String newEmail, String newAutreAttribut) async {
    await db.update(
      'logins',
      {'nom_utilisateur': newNomUtilisateur, 'email': newEmail},
      where: 'id = ?',
      whereArgs: [id],
    );
    print('Ligne avec l\'ID $id mise à jour');
  }

  Future<void> deleteLoginsTable(Database db, int id) async {
    await db.delete(
      'logins',
      where: 'id = ?',
      whereArgs: [id],
    );
    print('Ligne avec l\'ID $id supprimée');
  }

  Future<void> createNotificationsEtRappelsTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS notifications_et_rappels (
        id INTEGER PRIMARY KEY,
        type_notification TEXT,
        message TEXT,
        date_notification TEXT
      )
    ''');
    print('Table "notifications_et_rappels" créée ou déjà existante');
  }

  Future<void> readNotificationsEtRappelsTable(Database db) async {
    List<Map<String, dynamic>> notificationsEtRappels =
        await db.query('notifications_et_rappels');
    for (Map<String, dynamic> notification in notificationsEtRappels) {
      print('ID: ${notification['id']}');
      print('Type de notification: ${notification['type_notification']}');
      print('Message: ${notification['message']}');
      print('Date de notification: ${notification['date_notification']}');
      print('---');
    }
  }

  Future<void> updateNotificationsEtRappelsTable(
      Database db,
      int id,
      String newTypeNotification,
      String newMessage,
      String newDateNotification) async {
    await db.update(
      'notifications_et_rappels',
      {
        'type_notification': newTypeNotification,
        'message': newMessage,
        'date_notification': newDateNotification,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
    print('Ligne avec l\'ID $id mise à jour');
  }

  Future<void> deleteNotificationsEtRappelsTable(Database db, int id) async {
    await db.delete(
      'notifications_et_rappels',
      where: 'id = ?',
      whereArgs: [id],
    );
    print('Ligne avec l\'ID $id supprimée');
  }

  Future<void> createProfilsBasauxTemporairesTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS profils_basaux_temporaires (
        id INTEGER PRIMARY KEY,
        nom TEXT,
        plage_horaire_duree TEXT,
        taux_insuline REAL
      )
    ''');
    print('Table "profils_basaux_temporaires" créée ou déjà existante');
  }

  Future<void> createHistoriqueInjectionsBolusTable(Database db) async {
    await db.execute('''
    CREATE TABLE IF NOT EXISTS historique_injections_bolus (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      date_injection TEXT,
      heure_injection TEXT,
      dose REAL
    )
  ''');
    print('Table "historique_injections_bolus" créée ou déjà existante');
  }

  Future<void> readHistoriqueInjectionsBolusTable(Database db) async {
    List<Map<String, dynamic>> historiqueInjectionsBolus =
        await db.query('historique_injections_bolus');
    for (Map<String, dynamic> injection in historiqueInjectionsBolus) {
      print('ID: ${injection['id']}');
      print('Date d\'injection: ${injection['date_injection']}');
      print('Quantité injectée: ${injection['dose']}');
      print('Heure de l\'injection: ${injection['heure_injection']}');
      print('---');
    }
  }

  Future<void> insertHistoriqueInjectionsBolusTable(Database db,
      String dateInjection, String heureInjection, double dose) async {
    try {
      await db.insert(
        'historique_injections_bolus',
        {
          'date_injection': dateInjection,
          'heure_injection': heureInjection,
          'dose': dose,
        },
      );
      print(
          'Nouvelle entrée insérée dans la table historique_injections_bolus');
    } catch (e) {
      print(
          'Erreur lors de l\'insertion dans la table historique_injections_bolus : $e');
    }
  }

  Future<void> updateHistoriqueInjectionsBolusTable(Database db, int id,
      String newDateInjection, String newHeureInjection, double newDose) async {
    await db.update(
      'historique_injections_bolus',
      {
        'date_injection': newDateInjection,
        'heure_injection': newHeureInjection,
        'dose': newDose,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
    print('Ligne avec l\'ID $id mise à jour');
  }

  Future<void> deleteHistoriqueInjectionsBolusTable(Database db, int id) async {
    await db.delete(
      'historique_injections_bolus',
      where: 'id = ?',
      whereArgs: [id],
    );
    print('Ligne avec l\'ID $id supprimée');
  }

  Future<void> createLogsConnexionPodsTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS logs_connexion_pods (
        id INTEGER PRIMARY KEY,
        date_connexion TEXT,
        log_connexion TEXT
      )
    ''');
    print('Table "logs_connexion_pods" créée ou déjà existante');
  }

  Future<void> readLogsConnexionPodsTable(Database db) async {
    List<Map<String, dynamic>> logsConnexionPods =
        await db.query('logs_connexion_pods');
    for (Map<String, dynamic> log in logsConnexionPods) {
      print('ID: ${log['id']}');
      print('Date de connexion: ${log['date_connexion']}');
      print('Log de connexion: ${log['log_connexion']}');
      print('---');
    }
  }

  Future<void> updateLogsConnexionPodsTable(
      Database db,
      int id,
      String newDateConnexion,
      String newLogConnexion,
      String newAutreAttribut) async {
    await db.update(
      'logs_connexion_pods',
      {
        'date_connexion': newDateConnexion,
        'log_connexion': newLogConnexion,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
    print('Ligne avec l\'ID $id mise à jour');
  }

  Future<void> deleteLogsConnexionPodsTable(Database db, int id) async {
    await db.delete(
      'logs_connexion_pods',
      where: 'id = ?',
      whereArgs: [id],
    );
    print('Ligne avec l\'ID $id supprimée');
  }

  Future<void> createUtilisateurParamsTable(Database db) async {
    await db.execute('''
    CREATE TABLE IF NOT EXISTS utilisateur_params (
      id INTEGER PRIMARY KEY,
      nom TEXT,
      prenom TEXT,
      email TEXT,
      medecin_diabetologue TEXT,
      mode_sombre INTEGER,
      vitesse_injections REAL
    )
  ''');
    print('Table "utilisateur_params" créée ou déjà existante');
  }

  Future<void> insertOrUpdateUtilisateurParams(
    Database db,
    String nom,
    String prenom,
    String email,
    String medecinDiabetologue,
    int modeSombre,
    double vitesseInjections,
  ) async {
    final utilisateurParams = await db.query('utilisateur_params');

    if (utilisateurParams.isEmpty) {
      await db.insert(
        'utilisateur_params',
        {
          'nom': nom,
          'prenom': prenom,
          'email': email,
          'medecin_diabetologue': medecinDiabetologue,
          'mode_sombre': modeSombre,
          'vitesse_injections': vitesseInjections,
        },
      );
      print(
          'Paramètres de l\'utilisateur insérés dans la table utilisateur_params');
    } else {
      await db.update(
        'utilisateur_params',
        {
          'nom': nom,
          'prenom': prenom,
          'email': email,
          'medecin_diabetologue': medecinDiabetologue,
          'mode_sombre': modeSombre,
          'vitesse_injections': vitesseInjections,
        },
        where: 'id = ?',
        whereArgs: [utilisateurParams[0]['id']],
      );
      print(
          'Paramètres de l\'utilisateur mis à jour dans la table utilisateur_params');
    }
  }

  Future<Map<String, dynamic>?> readUtilisateurParams(Database db) async {
    final utilisateurParams = await db.query('utilisateur_params');
    if (utilisateurParams.isNotEmpty) {
      return utilisateurParams[0];
    } else {
      return null;
    }
  }

  Future<void> simulateData(Database db) async {
    try {
      final isDatabaseExist = await databaseExists(db.path);

      if (!isDatabaseExist) {
        print(
            'La base de données n\'existe pas. Création de la base de données.');
        // Initialisez votre base de données ici si elle n'existe pas
      }
      // Dummy data for 'logins' table
      final List<Map<String, dynamic>> dummyLoginsData = [
        {
          'nom_utilisateur': 'user1',
          'email': 'user1@example.com',
        },
        {
          'nom_utilisateur': 'user2',
          'email': 'user2@example.com',
        },
      ];

      final countLogins = Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM logins'));

      if (countLogins == 0) {
        for (var login in dummyLoginsData) {
          await db.insert('logins', login);
        }
      }

      // Dummy data for 'notifications_et_rappels' table
      final List<Map<String, dynamic>> dummyNotificationsData = [
        {
          'type_notification': 'Notification 1',
          'message': 'Message 1',
          'date_notification': '03-02-2024 08:00:00',
        },
        {
          'type_notification': 'Notification 2',
          'message': 'Message 2',
          'date_notification': '03-02-2024 12:00:00',
        },
      ];

      final countNotifications = Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM notifications_et_rappels'));

      if (countNotifications == 0) {
        for (var notification in dummyNotificationsData) {
          await db.insert('notifications_et_rappels', notification);
        }
      }

      // Dummy data for 'historique_injections_bolus' table
      final List<Map<String, dynamic>> dummyHistoriqueInjectionsBolusData = [
        {
          'date_injection': '03-02-2024',
          'heure_injection': '08:00',
          'dose': 5.0,
        },
        {
          'date_injection': '03-02-2024',
          'heure_injection': '12:00',
          'dose': 3.5,
        },
      ];

      final countHistoriqueInjectionsBolus = Sqflite.firstIntValue(await db
          .rawQuery('SELECT COUNT(*) FROM historique_injections_bolus'));

      if (countHistoriqueInjectionsBolus == 0) {
        for (var injection in dummyHistoriqueInjectionsBolusData) {
          await db.insert('historique_injections_bolus', injection);
        }
      }

      // Dummy data for 'profils_basaux_temporaires' table
      final List<Map<String, dynamic>> dummyProfilsBasauxData = [
        {
          'nom': 'Profil 1',
          'plage_horaire_duree': '8:00 - 12:00',
          'taux_insuline': 1.5,
        },
        {
          'nom': 'Profil 2',
          'plage_horaire_duree': '12:00 - 16:00',
          'taux_insuline': 2.0,
        },
      ];

      final countProfilsBasaux = Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM profils_basaux_temporaires'));

      if (countProfilsBasaux == 0) {
        for (var profil in dummyProfilsBasauxData) {
          await db.insert('profils_basaux_temporaires', profil);
        }
      }

      // Dummy data for 'logs_connexion_pods' table
      final List<Map<String, dynamic>> dummyLogsConnexionPodsData = [
        {
          'date_connexion': '03-02-2024 08:00:00',
          'log_connexion': 'Connexion réussie',
        },
        {
          'date_connexion': '03-02-2024 12:00:00',
          'log_connexion': 'Connexion échouée',
        },
      ];

      final countLogsConnexionPods = Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM logs_connexion_pods'));

      if (countLogsConnexionPods == 0) {
        for (var log in dummyLogsConnexionPodsData) {
          await db.insert('logs_connexion_pods', log);
        }
      }

      // Dummy data for 'utilisateur_params' table
      final List<Map<String, dynamic>> dummyUtilisateurParamsData = [
        {
          'nom': 'John',
          'prenom': 'Doe',
          'email': 'john.doe@example.com',
          'medecin_diabetologue': 'Dr. Smith',
          'mode_sombre': 1,
          'vitesse_injections': 1.2,
        },
      ];

      final countUtilisateurParams = Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM utilisateur_params'));

      if (countUtilisateurParams == 0) {
        for (var utilisateurParams in dummyUtilisateurParamsData) {
          await db.insert('utilisateur_params', utilisateurParams);
        }
      }

      print('Données fictives insérées avec succès dans la base de données.');
    } catch (e) {
      print('Erreur lors de l\'insertion des données fictives : $e');
    }
  }

  Future<void> createTableIfNotExists(
      Database db, String tableName, String createSQL) async {
    await db.execute(createSQL);
    print('Table "$tableName" créée ou déjà existante');
  }

  // Méthode pour récupérer l'e-mail de l'utilisateur depuis la base de données locale
  Future<String?> getUserEmail() async {
    final db = await initDB();
    final utilisateurParams = await db.query('utilisateur_params');
    if (utilisateurParams.isNotEmpty) {
      return utilisateurParams[0]['email'] as String?;
    } else {
      return null;
    }
  }
}
