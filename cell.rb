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
  
  def initialize(x, y)
    @state = State::White # L'état de la case
    @x = x # Les coordonnées de la case
    @y = y
    @value = 0
  end
  
  def set_x_y(newX, newY)
    @x = newX
    @y = newY
  end
  
  def renvoieCoo
    print "["
    print @x
    print "]["
    print @y
    print "] "
  end

  def renvoiePond
    print "["
    print @value
    print "]"
  end

  def renvoie
    print "["
    print @x
    print "]["
    print @y
    print "] = "
    print @value
    print "\n"
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
    @state == State::White
  end
  
  def updateValue(v)
    @value+=v
  end

  def caseProcheValide(i, j)#i et j les coordonnées de la case testée, si elle est proche et jouable par rapport a la cellule appelante
    #(!(@x == i and @y == j) && ((i > -1 && j > -1) && (i < $game.board.lines && j < $game.board.columns)))
    ( ( (0 .. $game.board.lines-1).include?(i) and (0 .. $game.board.columns-1).include?(j) ) && !(@x == i and @y == j) ) 
  end

  def noircirCaseLog
    #On itère sur les cases proches pour mettre a jour leur valeur
    (@x-1..@x+1).each do |i|
      (@y-1..@y+1).each do |j|
        if $game.board[@x][@y].caseProcheValide(i, j)
          #puts "Boucle x="+i.to_s+" y="+j.to_s
          $game.board[i][j].updateValue(-1)
        end
      end
    end
  end

  def moveTokenLog(v)
    #on itère sur les cases proches de la position pour mettre a jour les valeurs des cases.
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
