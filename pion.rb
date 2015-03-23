#!/usr/bin/ruby 1.9.3
# -*- coding: utf-8 -*-

# Time-stamp: <2015-03-23 20:25:07 oxedora>  le # etait necessaire pour que ca interprete, mais c'est toujours fonctionnel, donc osef.

class Pion 

  #attributs, sisi

  attr_accessor :x
  attr_accessor :y
  attr_accessor :image

  #constructeur

  def initialize (newImage, x = -1, y = -1)
    @x=x
    @y=y
    @image = newImage
  end

  #methodes

  def caseProche (cell)
    # Renvoie vrai si la cellule de destination est une des 8 cases proches du token, faux sinon
    ( ( (@x-1 .. @x+1).include?(cell.x) and (@y-1 .. @y+1).include?(cell.y) ) && !(@x == cell.x and @y == cell.y) ) 
  end

  def nouvellePosition(cell)
    @x=cell.x
    @y=cell.y
  end

  def canMove
    res = false
    for i in @x-1..@x+1
      for j in @y-1..@y+1
        if (0..$game.board.lines-1).include?(i) && (0..$game.board.columns-1).include?(j) 
          if $game.board[i][j].isAccessible then res = true end
          if res then break end
        end
      end
    end
    res
  end


end
