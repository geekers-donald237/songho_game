## Introduction

    Ce projet Flutter 3.7.4 est un jeu de stratégie appelé "Songho". Le but du jeu est de s'emparer d'un maximum de graines.
     Le joueur qui a le plus de graines à la fin de la partie l'emporte.

## Comment lancer le projet

    Pour lancer le projet, vous devez :
    Cloner ce dépôt sur votre machine locale.
    Ouvrir le projet dans un éditeur de code compatible avec Flutter.
    Exécuter la commande flutter run dans votre terminal pour lancer l'application.
    L'application devrait se lancer sur votre smartphone ou votre émulateur.


## Règles du jeu

    Le jeu Songho comporte les règles suivantes :
        La distribution est l'opération qui consiste à prendre la totalité des billes présentes dans un trou de son camp et à les disposer une à une dans les cases qui le suivent dans l'ordre inverse des aiguilles d'une montre (on peut donc distribuer aussi dans les cases de son adversaire).
        Une prise est l'opération qui consiste à ramasser la totalité des graines d'un trou dans le camp de l'adversaire car les prises se font uniquement chez son adversaire.
        Si la dernière graine distribuée tombe dans un trou de l'adversaire comportant 2 ou 3 graines (avec la distribution effectuée), le joueur capture les 2 ou 3 graines résultantes.
        Capture multiple : lorsqu'un joueur s'empare de deux ou trois graines, si la case précédente contient également deux ou trois graines, elle sont capturées aussi, et    ainsi de suite.
        Bouclage : si le nombre de graines prises dans le trou de départ est supérieur à 11, cela fait que l'on va boucler un tour : auquel cas, à chaque passage, la case de départ est sautée et donc laisser vide pour cette distribution laissée vide. Un trou contenant assez de graines pour faire une boucle complète s'appelle un Krou.
        Donner à manger : on n'a pas le droit d'affamer l'adversaire. De même, un joueur n'a pas le droit de jouer un coup qui prenne toutes les graines du camp de l'adversaire.
        Si le nombre de pierres pris par l’un des joueurs est supérieur à 35, il gagne.
        Si le nombre de pierres des deux joueurs, en excluant les prises, est inférieur à 10, le gagnant est celui qui a la somme de ses prises et du nombre des pierres de son côté, supérieur à 35.

## Interdictions

    Le jeu Songho comporte les interdictions suivantes :
    On ne peut jouer les cases A6 et B6 si le nombre de pierres dont elle dispose est égal à 
    1 ou 2. S’il est égal à 2, on peut jouer si et seulement si elle permet d’effectuer une prise, 
    ou si c’est la seule case qui dispose de pierre.
    Si, au terme d’une distribution, toutes les 7 cases (de A ou B) ont un nombre de pierres 
    compris entre 2 et 4, aucune prise n’est faite.


## Jeu de Songho

    Le Jeu de Songho est un jeu traditionnel africain qui se joue généralement avec des graines ou des cailloux. Cette application vous permet de jouer au Jeu de Songho sur votre smartphone.

## Téléchargement de l'APK

    Vous pouvez télécharger l'APK de l'application en vous rendant dans le dossier build/app/outputs/flutter-apk/ et en cherchant le fichier app-release.apk.

## Dependances 
    audioplayers: ^0.20.1
    flutter_easyloading: ^3.0.3
    # To add assets to your application, add an assets section, like this:
        assets:
            - assets/

## Description de l'application

    L'application Jeu de Songho vous permet de jouer à ce jeu traditionnel africain sur votre smartphone. Le jeu est basé sur les règles traditionnelles du Jeu de Songho et vous pouvez jouer contre l'ordinateur ou contre un ami. L'interface utilisateur est simple et intuitive, avec des graphismes élégants et des animations fluides. Les fonctionnalités incluent un mode multijoueur, des


    L'application du jeu de Songho est une implémentation mobile du jeu de société africain traditionnel appelé Songho (ou Awélé). Elle est développée en utilisant le framework Flutter version 3.7.4.

    Le but du jeu est de collecter le plus grand nombre de graines possible. Le joueur ayant le plus de graines à la fin de la partie est déclaré vainqueur.

    Le jeu se déroule sur un plateau avec deux rangées de six trous chacune, appelés A1, A2, A3, A4, A5, A6 pour la rangée du joueur 1 et B1, B2, B3, B4, B5, B6 pour la rangée du joueur 2. Chaque trou contient quatre graines au début du jeu.

    Le joueur 1 commence en prenant toutes les graines d'un de ses trous et en les distribuant une par une dans les trous suivants dans le sens inverse des aiguilles d'une montre, y compris les trous de l'adversaire si nécessaire. Si la dernière graine distribuée tombe dans un trou de l'adversaire contenant deux ou trois graines, le joueur capture ces graines. Si ce trou contient également deux ou trois graines, elles sont également capturées, et ainsi de suite. Cette capture multiple peut se poursuivre tant que les conditions sont remplies.

    Le joueur 2 joue ensuite selon le même principe, en prenant les graines d'un de ses trous et en les distribuant.

    Il y a quelques règles supplémentaires à respecter pour jouer correctement au Songho, notamment en ce qui concerne les boucles et les prises. Si un joueur prend toutes les graines de son adversaire ou affame son adversaire, il est disqualifié. De plus, si le nombre de graines prises par l'un des joueurs est supérieur à 35, il gagne automatiquement, mais si les deux joueurs ont moins de 10 graines chacun (en excluant les prises), alors le joueur avec le plus grand nombre de graines remporte la partie.

    L'application fournit une interface graphique conviviale pour jouer au jeu de Songho, avec des fonctionnalités telles que le choix du niveau de difficulté et l'option de jouer contre un ami ou contre l'ordinateur. Le joueur peut également accéder aux règles du jeu à tout moment en appuyant sur le bouton d'information.

    Pour télécharger l'APK de l'application, vous pouvez vous rendre dans le dossier build/app/outputs/flutter-apk/app-release.apk de votre projet Flutter.




