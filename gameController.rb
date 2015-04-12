#!/usr/bin/ruby
# -*- coding: utf-8 -*-

"""
Classe GameController

Cette classe gère tout le jeu.
Elle fait le lien entre toutes
les autres classes.

Auteur : Celia Rouquairol
Derniere modification : Avril 2015
"""


class GameController

  attr_accessor :playersList # Tableau a une dimension
  attr_accessor :nbPlayers # Nombre de joueurs
  attr_accessor :current # joueur actuel
  attr_accessor :board # Tableau a deux dimensions
  
  def initialize(nb = 2, boardLines = 6, boardColumns = 6)
    # Créer un tableau de nb joueurs ainsi qu'un plateau de boardLines lignes et boardColumns colonnes (6x6 par défaut)
    @current = 0 # Le joueur actuel
    @nbPlayers = nb # Nombre total de joueur
    @playersList = [Joueur.new('Edouard', './images/pion_j0.png'), Joueur.new('Selyah', './images/pion_j1.png', true)] # tableau du nombre de joueurs
    @board = Board.new(boardLines, boardColumns)
  end
  
  def canMove(currentPlayer) # Supprimer si la fonction du joueur fonctionne
    # Renvoie vrai si le joueur peut se déplacer au début de son tour, faux sinon
    currentPlayer.canMove(@board)
  end
  
end
