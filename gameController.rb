#!/usr/bin/ruby
# -*- coding: utf-8 -*-

"""
Classe GameController

Cette classe gère tout le jeu.
Elle fait le lien entre toutes
les autres classes.

Auteur : Celia Rouquairol
Derniere modification : Mars 2015
"""


class GameController

	attr_accessor :playersList # Tableau a une dimension
	attr_accessor :nbPlayers
	attr_accessor :current # joueur actuel
	attr_accessor :board # Tableau a deux dimensions
	
	def initialize(nb = 2, boardLines = 6, boardColumns = 6)
	# Créer un tableau de joueurs ainsi qu'un plateau
		@current = 0
		@nbPlayers = nb # nailed it
		@playersList = [Joueur.new('Edouard', './images/pion_j0.png'), Joueur.new('Selyah', './images/pion_j1.png')] # tableau du nombre de joueurs
		@board = Board.new(boardLines, boardColumns)
	end
	
	def canMove(currentPlayer) # Supprimer si la fonction du joueur fonctionne
	# Renvoie vrai si le joueur peut se déplacer au début de son tour, faux sinon
		currentPlayer.canMove(@board)
	end
	
end
