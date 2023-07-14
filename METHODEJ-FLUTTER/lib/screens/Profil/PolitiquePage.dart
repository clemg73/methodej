import 'package:flutter/material.dart';

import '../../common/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Calendar/CalendarPage.dart';
import '../../common/globals.dart' as globals;

class Politique extends StatelessWidget {
  Politique();

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 70,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(Icons.close),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        'Politique de protection des données personnelles',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 30,
                            color: Colors.black),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text('Dernière mise à jour : Mars 2023',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              color: Colors.black),
                          textAlign: TextAlign.justify),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                          "L’application MéthodeJ met en œuvre une démarche d'amélioration continue de sa conformité au Règlement général de protection des données (RGPD), à la Directive ePrivacy, ainsi qu'à la loi n° 78-17 du 6 janvier 1978 dite Informatique et Libertés pour assurer le meilleur niveau de protection à vos données personnelles.Pour toute information sur la protection des données personnelles, vous pouvez également consulter le site de la Commission Nationale de l'Informatique et des Libertés www.cnil.fr.",
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                              color: Colors.black),
                          textAlign: TextAlign.justify),
                      SizedBox(
                        height: 40,
                      ),
                      Text(
                          "Qui est le responsable du traitement de mes données personnelles ?",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 25,
                              color: Colors.black),
                          textAlign: TextAlign.justify),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                          "Le responsable de traitement est la société qui définit pour quel usage et comment vos données personnelles sont utilisées.Les données personnelles collectées sur l’application sont traitées par l’application elle même. ",
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                              color: Colors.black),
                          textAlign: TextAlign.justify),
                      SizedBox(
                        height: 40,
                      ),
                      Text(
                          "Quelles sont les données personnelles qui sont collectées me concernant et pourquoi l’application MéthodeJ les collectes ?",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 25,
                              color: Colors.black),
                          textAlign: TextAlign.justify),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                          'MéthodeJ utilise vos données personnelles principalement pour les finalités suivantes :',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                              color: Colors.black),
                          textAlign: TextAlign.justify),
                      SizedBox(
                        height: 20,
                      ),
                      Text("1. Votre inscription à l’application",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              color: Colors.black),
                          textAlign: TextAlign.justify),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                          "Lors de votre inscription à l’application, elle collecte votre email et votre mot de passe pour parvenir à vous connecter si vous changer de compte sur l’appareil actuel ou si vous changer d’appareil. Votre mot de passe est bien sûr crypté pour des raisons de sécurité.",
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                              color: Colors.black),
                          textAlign: TextAlign.justify),
                      SizedBox(
                        height: 10,
                      ),
                      Text("2. L’enregistrement de vos cours",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              color: Colors.black),
                          textAlign: TextAlign.justify),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                          "Chaque enregistrement de cours que vous réalisez sur l’application est enregistré dans nos serveurs. C’est ces mêmes serveurs que l’on questionnera pour vous afficher ces enregistrements et cela sur n’importe quel appareil et n’importe quel endroit dans le monde avec une connexion internet.",
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                              color: Colors.black),
                          textAlign: TextAlign.justify),
                      SizedBox(
                        height: 40,
                      ),
                      Text(
                          "Sur quelle base légale et pour quelles durées mes données personnelles sont-elles traitées ?",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 25,
                              color: Colors.black),
                          textAlign: TextAlign.justify),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                          "Le traitement de vos données personnelles est justifié par différents fondements (base légale) en fonction de l'usage que nous faisons des données personnelles. Vous trouverez ci-dessous les bases légales et durées de conservation que nous appliquons à nos principaux traitements.",
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                              color: Colors.black),
                          textAlign: TextAlign.justify),
                      SizedBox(
                        height: 20,
                      ),
                      Text("Bases légales des traitements",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                              color: Colors.black),
                          textAlign: TextAlign.justify),
                      SizedBox(
                        height: 10,
                      ),
                      Text("Parmi les bases légales applicables :",
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                              color: Colors.black),
                          textAlign: TextAlign.justify),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                          "1. Le contrat : le traitement des données personnelles est nécessaire à l'exécution du contrat auquel vous avez consenti.",
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                              color: Colors.black),
                          textAlign: TextAlign.justify),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                          "2. Le consentement : vous acceptez le traitement de vos données personnelles par le biais d'un consentement exprès (case à cocher, clic ....). Vous pouvez retirer ce consentement à tout moment.",
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                              color: Colors.black),
                          textAlign: TextAlign.justify),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                          "3. La loi : le traitement de vos données personnelles est rendu obligatoire par un texte de loi.",
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                              color: Colors.black),
                          textAlign: TextAlign.justify),
                      SizedBox(
                        height: 20,
                      ),
                      Text("Durée de conservation",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                              color: Colors.black),
                          textAlign: TextAlign.justify),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                          "Toutes les données sont conservées tant que vous êtes un utilisateur « actif » pendant une durée de 2 ans à compter de votre dernier enregistrement.",
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                              color: Colors.black),
                          textAlign: TextAlign.justify),
                      SizedBox(
                        height: 15,
                      ),
                      Text("1. Premier traitement",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              color: Colors.black),
                          textAlign: TextAlign.justify),
                      SizedBox(
                        height: 5,
                      ),
                      Text("Finalité du traitement: Utilisation du compte",
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                              color: Colors.black),
                          textAlign: TextAlign.justify),
                      Text("Base légale: contrat",
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                              color: Colors.black),
                          textAlign: TextAlign.justify),
                      Text(
                          "Durée de conservation des données: 2 ans à compter du dernier enregistrement",
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                              color: Colors.black),
                          textAlign: TextAlign.justify),
                      SizedBox(
                        height: 10,
                      ),
                      Text("2. Deuxième traitement",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              color: Colors.black),
                          textAlign: TextAlign.justify),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                          "Finalité du traitement: Conservation des enregistrements",
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                              color: Colors.black),
                          textAlign: TextAlign.justify),
                      Text("Base légale: contrat",
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                              color: Colors.black),
                          textAlign: TextAlign.justify),
                      Text(
                          "Durée de conservation des données: 2 ans à compter du dernier enregistrement",
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                              color: Colors.black),
                          textAlign: TextAlign.justify),
                      SizedBox(
                        height: 40,
                      ),
                      Text("Qui sont les destinataires de mes données ?",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 25,
                              color: Colors.black),
                          textAlign: TextAlign.justify),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                          "Aucune de vos données sont transmises à des tiers. Ces dernières sont seulement conservées sur nos serveurs et seuls les représentants de méthodeJ en ont accès.",
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                              color: Colors.black),
                          textAlign: TextAlign.justify),
                      SizedBox(
                        height: 40,
                      ),
                      Text(
                          "Comment exprimer mes choix sur l'usage de mes données ?",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 25,
                              color: Colors.black),
                          textAlign: TextAlign.justify),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                          "Vous pouvez supprimer votre compte à tout moment en cliquant sur « Supprimer mon compte » dans la page de réglage.",
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                              color: Colors.black),
                          textAlign: TextAlign.justify),
                      SizedBox(
                        height: 40,
                      ),
                      Text(
                          "Quels sont mes droits au regard de l'utilisation des données personnelles ?",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 25,
                              color: Colors.black),
                          textAlign: TextAlign.justify),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                          "Conformément à la règlementation sur la protection des données personnelles, vous pouvez exercer vos droits (accès, rectification, suppression, opposition, limitation et portabilité le cas échéant) et définir le sort de vos données personnelles « post mortem » MéthodeJ en nous contactant par mail via l'adresse email: methodej.app@gmail.com.",
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                              color: Colors.black),
                          textAlign: TextAlign.justify),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                          "Afin de nous permettre de répondre rapidement, nous vous remercions de nous indiquer votre email de votre compte et de préciser, si celle-ci est différente, l’email à laquelle doit vous parvenir la réponse.Nous pourrons procéder à des vérifications pour garantir que c’est bien votre compte.",
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                              color: Colors.black),
                          textAlign: TextAlign.justify),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                          "Vous disposez par ailleurs, du droit d'introduire une réclamation auprès de la Commission Nationale de l'Informatique et des Libertés (CNIL), notamment sur son site internet www.cnil.fr.MéthodeJ dispose d'un Délégué à la Protection des données personnelles (DPO) chargé de garantir la protection des données personnelles. Vous pouvez contacter le Délégué à la protection des données personnelles de MéthodeJ à l’adresse methodej.app@gmail.com.",
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                              color: Colors.black),
                          textAlign: TextAlign.justify),
                      SizedBox(
                        height: 40,
                      ),
                      Text(
                          "Mes données sont-elles transférées en dehors de l'Union Européenne ?",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 25,
                              color: Colors.black),
                          textAlign: TextAlign.justify),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                          "Aucuns transferts de données sont réalisés. Cela inclus donc les transferts en dehors de l’Union Européenne",
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                              color: Colors.black),
                          textAlign: TextAlign.justify),
                      SizedBox(
                        height: 40,
                      ),
                      Text(
                          "Qu'en est-il des données personnelles des mineurs ?",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 25,
                              color: Colors.black),
                          textAlign: TextAlign.justify),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                          "Les services de MéthodeJ ne sont pas destinés aux Mineurs en conséquence MéthodeJ ne traite pas des données concernant spécifiquement les mineurs.Il appartient aux parents et à toute personne exerçant l'autorité parentale de décider si leur enfant mineur est autorisé à utiliser les services de l’application MéthodeJ.",
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                              color: Colors.black),
                          textAlign: TextAlign.justify),
                      SizedBox(
                        height: 65,
                      ),
                    ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
