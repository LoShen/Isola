#!/usr/bin/ruby
# -*- coding: utf-8 -*-

"""
main

Ce fichier charge toutes les classes
afin qu'il n'y ait pas de conflit
par la suite.
C'est également ce fichier qui
lance le jeu.

Auteur : Celia Rouquairol
Derniere modification : Mars 2015
"""

# Le but ici c'est de reprendre l'idée de Jérémy et de charger tous les fichiers pour éviter d'avoir des inclusions trop profondes.
# Il faut faire attention à l'ordre d'inclusion.
require 'gtk2'
require './state.rb'
require './pion.rb'
require './cell.rb'
require './joueur.rb'
require './board.rb'
require './gameController.rb'
require './graphicCell.rb'
require './inGame.rb'
