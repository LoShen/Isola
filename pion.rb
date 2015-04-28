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
  # Renvoie la case proche ayant la plus grosse pondération pour l'ia
    x = -1
    y = -1
    v = -10
	
    (@x-1..@x+1).each do |i|
      (@y-1..@y+1).each do |j|
	  	# Pour chaque case proche
        if ( $game.board[@x][@y].caseProcheValide(i, j) && $game.board[i][j].isAccessible )
				# Si c'est une case blanche dans les limites du plateau
          if (v < $game.board[i][j].value)
            # Si sa valeur est plus grande que v
            x = i # On récupère les coordonnées de la case correspondante
            y = j
            v = $game.board[i][j].value # Ainsi que la valeur en question
          end
        end
      end
    end
    Cell.new(x, y) # On renvoie la cellule ainsi choisie
  end

  def nouvellePosition(cell)
    @x=cell.x
    @y=cell.y
  end

  def canMove
  # Renvoie vrai si le pion peut se déplacer, faux sinon
    res = false # Résultat
    for i in @x-1..@x+1
      for j in @y-1..@y+1
	  		# Pour chaque case proche du pion
        if (0..$game.board.lines-1).include?(i) && (0..$game.board.columns-1).include?(j) 
				# Si elle est dans les limites du plateau
          if $game.board[i][j].isAccessible then res = true end # Si elle est accessible alors le pion peut se déplacer
          if res then break end # Si au moins une case est accessible, le pion peut se déplacer
        end
      end
    end
    res
  end


end
