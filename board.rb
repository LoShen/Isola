#!/usr/bin/ruby
# -*- coding: utf-8 -*-

"""
Classe Board

Attributs et comportement
du plateau.

Auteur : Celia Rouquairol
Derniere modification : Fevrier 2015
"""

load "cell.rb"

class Board

	attr_accessor :board
	attr_reader :lines
	attr_reader :columns
	
	def initialize(newLines = 6, newColumns = 6)
	# Créer un plateau 6x6 par défaut dont toutes les cases sont blanches
	# Décommenter les print pour voir le résultat
	# Supprimer les print lors de la mise en prod
		@board = [[]] # Création du tableau a 2 dimensions
		@lines = newLines
		@columns = newColumns
		for incLig in (0..newLines-1) # Pour chaque ligne
			@board[incLig] = [] # On crée une colonne
			for incCol in (0..newColumns-1) # Pour chaque combinaison de lignes et de colonnes
				@board[incLig][incCol] = Cell.new(incLig, incCol) # On crée une nouvelle cellule avec la position correspondante
				#print @board[incLig][incCol].color
			end
			#print "\n"
		end
	end
	
	def [](i)
	# Définit l'accesseur [] pour la classe Board
	# NB : board[2] est un array
	# board[1][2] accède à la cell à la position 1, 2
		@board[i]
	end


end
