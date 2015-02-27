#!/usr/bin/ruby
# -*- coding: utf-8 -*-

"""
Classe State

Différents états des cases
du plateau.
Cette énumération est définie en 
tant que collection afin de pouvoir
itérer sur chaque item.

Auteur : Celia Rouquairol
Derniere modification : Fevrier 2015
"""

class State
	def State.add_item(key, value) # Permet d'ajouter des "catégories" d'état
		@hash ||= {} # Crée le dictionnaire
		@hash[key] = value # Ajoute a la nouvelle clé la valeur correspondante
	end
	
	def State.const_missing(key) # Facilite l'écriture de l'accès à une clé
		@hash[key] # Permet d'écrire Etat::Blanc plutôt que Etat.hash[:Blanc]
	end
	
	def State.each # Définit la fonction permettant de parcourir toute la collection
		@hash.each {|key, value| yield(key, value)} # Pour chaque clé et valeur associée, les affiche
	end
	
	
	# On ajoute les états souhaités avec leur valeur
	State.add_item :Invalid, 0
	State.add_item :White, 1
	State.add_item :Black, 2
	State.add_item :Player, 3
end
