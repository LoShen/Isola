#!/usr/bin/ruby
# -*- coding: utf-8 -*-

"""
Classe Cell

Attributs et comportement
des cases du plateau.

Auteur : Celia Rouquairol
Derniere modification : Fevrier 2015
"""

load "state.rb"

class Cell

	attr_reader :x
	attr_reader :y
	attr_accessor :state
	
	def initialize(x, y, state = State::White)
	# Créer une case à une position donnée, sa couleur par défaut est blanche
		@x = x
		@y = y
		@state = state
	end
	
	def state=(newState)
		@state = newState
	end
	
	def color
	# Affiche la couleur correspondante a la valeur de la case
		case @state
		when 0
			print "Invalid"
		when 1
			print "White"
		when 2
			print "Black"
		when 3
			print "Player"
		end
	end
	
	def isAccessible
	# Renvoie vrai si la case est blanche, faux sinon
		@state == 1
	end
	
end
