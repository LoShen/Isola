#!/usr/bin/ruby 1.9.3
# -*- coding: utf-8 -*-

# Time-stamp: <2015-04-11 15:16:38 oxedora>

class Pion 

  #attributs

  attr_accessor :x
  attr_accessor :y
  attr_accessor :image

  #constructeur

  def initialize(newImage, x = -1, y = -1)
    @x=x
    @y=y
    @image = newImage
  end

  #methodes

  def caseProche(cell)
    # Renvoie vrai si la cellule de destination est une des 8 cases proches du token, faux sinon
    ( ( (@x-1 .. @x+1).include?(cell.x) and (@y-1 .. @y+1).include?(cell.y) ) && !(@x == cell.x and @y == cell.y) ) 
  end

  def maxCaseProche 
  	# Récuperation de la case ayant la plus grosse value
    x = -1
    y = -1
    v = -10
    
    puts "Preboucle de maxCaseProche x="+x.to_s+" y="+y.to_s
    puts "Coordonnes du pion avant la boucle x="+@x.to_s+" y="+@y.to_s
    (@x-1..@x+1).each do |i| # Pour chaque case proche du pion
      (@y-1..@y+1).each do |j|
        #puts "Dans la boucle i="+i.to_s+" j="+j.to_s+" valeur de la case = "+$game.board[i][j].value.to_s
        if ( $game.board[@x][@y].caseProcheValide(i, j) && $game.board[i][j].isAccessible ) # Si la case existe et est accessible
          if (v < $game.board[i][j].value) # Si sa valeur est plus grande que v, soit la plus grosse value actuelle
            #puts "Boucle de maxCaseProche x="+x.to_s+" y="+y.to_s
            x = i # On récupère les coordonnées de la case correspondante
            y = j
            v = $game.board[i][j].value # Ainsi que sa valeur
          end
        end
      end
    end
    Cell.new(x, y) # On renvoie une cellule avec les coordonnées correspondantes
  end

  def nouvellePosition(cell)
  	# Modifie la position du pion pour correspondre à celle de la case cell
    @x=cell.x
    @y=cell.y
  end

  def canMove
  	# Renvoie vrai si le pion est déplaçable, faux sinon
    res = false # Faux par défaut
    for i in @x-1..@x+1 # Pour chaque case proche
      for j in @y-1..@y+1
        if (0..$game.board.lines-1).include?(i) && (0..$game.board.columns-1).include?(j) # Si la case est valide
          if $game.board[i][j].isAccessible then res = true end # Si elle est accessible alors le pion est déplaçable
          if res then break end # S'il y a au moins une case où le pion peut se déplacer, on arrête le parcourt
        end
      end
    end
    res # On renvoit le résultat
  end


end
