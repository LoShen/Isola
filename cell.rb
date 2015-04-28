#!/usr/bin/ruby
# -*- coding: utf-8 -*-

"""
Classe Cell

Attributs et comportement
des cases du plateau.

Auteur : Celia Rouquairol
Derniere modification : Mars 2015
"""

class Cell

  attr_accessor :x
  attr_accessor :y
  attr_accessor :state
  attr_accessor :value
  attr_accessor :bonus
  
  def initialize(x, y)
    @state = State::White # L'état de la case
    @x = x # Les coordonnées de la case
    @y = y
    @value = 0
    @bonus = -1
  end

  def isAccessible
    # Renvoie vrai si la case est blanche, faux sinon
    @state == State::White
  end
  
  def updateValue(v)
    @value+=v
  end

  def caseProcheValide(i, j)
  # Renvoie vrai si la case aux coordonnées (i, j) est jouable et proche de la cellule appelante, faux sinon
    ( ( (0 .. $game.board.lines-1).include?(i) and (0 .. $game.board.columns-1).include?(j) ) && !(@x == i and @y == j) ) 
  end

  def updateCaseProcheValue(v)
  # Lorsqu'une case est noircie, occupée ou libérée par un joueur,
  # la pondération des cases proches est modifiée en fonction
    (@x-1..@x+1).each do |i|
      (@y-1..@y+1).each do |j|
      # Pour chaque case proche de la cellule
        if $game.board[@x][@y].caseProcheValide(i, j)
        # Si elle est dans les limites du plateau
          $game.board[i][j].updateValue(v)
          # On change sa valeur
        end
      end
    end
  end

end
