#!/usr/bin/ruby
# -*- coding: utf-8 -*-

"""
Classe Cell

Attributs et comportement
des cases du plateau.

Auteur : Celia Rouquairol
Derniere modification : Avril 2015
"""

class Cell

  attr_accessor :x
  attr_accessor :y
  attr_accessor :state
  attr_accessor :value
  
  def initialize(x, y)
  	# Crée une case de coordonnées (x, y) dont l'état est blanc par défaut et la pondération (value) nulle
    @state = State::White # L'état de la case
    @x = x # Les coordonnées de la case
    @y = y
    @value = 0
  end
  
  def set_x_y(newX, newY)
  	# Modifie les cordonnées de la case
    @x = newX
    @y = newY
  end
  
  def renvoieCoo
  	# Renvoie les cordoonées de la case
    print "["
    print @x
    print "]["
    print @y
    print "] "
  end

  def renvoiePond
  	# Renvoie la pondération de la case
    print "["
    print @value
    print "]"
  end

  def renvoie
  	# Renvoie la pondération d'un case ainsi que ses coordonnées
    print "["
    print @x
    print "]["
    print @y
    print "] = "
    print @value
    print "\n"
  end

  def state=(newState)
  	# Modifie l'état de la case
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
    @state == State::White
  end
  
  def updateValue(v)
  	# Ajoute la valeur v à la pondération de la case
    @value+=v
  end

  def caseProcheValide(i, j)
  	# Renvoie vrai si la case aux coordonnées (i, j) est jouable et une case proche de la cellule appelante
    #(!(@x == i and @y == j) && ((i > -1 && j > -1) && (i < $game.board.lines && j < $game.board.columns)))
    ( ( (0 .. $game.board.lines-1).include?(i) and (0 .. $game.board.columns-1).include?(j) ) && !(@x == i and @y == j) ) 
  end

  def updateCellsAround(v)
    # Lorsqu'une case est noircie ou occupée par un joueur, on décrémente la valeur de ses cases proches jouables
    (@x-1..@x+1).each do |i|
      (@y-1..@y+1).each do |j|
        if $game.board[@x][@y].caseProcheValide(i, j)
          #puts "Boucle x="+i.to_s+" y="+j.to_s
          $game.board[i][j].updateValue(v)
        end
      end
    end
  end

end
