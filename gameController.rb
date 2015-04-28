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
  
  def initialize(tabInit)
    # Créer un tableau de joueurs ainsi qu'un plateau avec les valeurs de tabInit
		# tabInit contient les informations fournies par l'utilisateur
    @current = 0
    @nbPlayers = tabInit[0]
    @playersList = [Joueur.new(tabInit[3], tabInit[7], tabInit[5]), Joueur.new(tabInit[4], tabInit[8], tabInit[6])] 
		#	 Création du tableau des joueurs (pseudo, image, IA ou joueur humain)
    @board = Board.new(tabInit[1], tabInit[2])
  end
  
  def canMove(currentPlayer) # Supprimer si la fonction du joueur fonctionne
    # Renvoie vrai si le joueur peut se déplacer au début de son tour, faux sinon
    currentPlayer.canMove(@board)
  end
  
end
