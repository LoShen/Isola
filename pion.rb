#!/usr/bin/ruby 1.9.3
# -*- coding: utf-8 -*-

# Time-stamp: <2015-04-11 15:16:38 oxedora>  le # etait necessaire pour que ca interprete, mais c'est toujours fonctionnel, donc osef.

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

  def maxCaseProche #Recuperation de la case a la plus grosse value
    x = -1
    y = -1
    v = -10
    
    puts "Preboucle de maxCaseProche x="+x.to_s+" y="+y.to_s
    puts "Coordonnes du pion avant la boucle x="+@x.to_s+" y="+@y.to_s
    (@x-1..@x+1).each do |i|
      (@y-1..@y+1).each do |j|
        #puts "Dans la boucle i="+i.to_s+" j="+j.to_s+" valeur de la case = "+$game.board[i][j].value.to_s
        if ( $game.board[@x][@y].caseProcheValide(i, j) && $game.board[i][j].isAccessible )
          if (v < $game.board[i][j].value)
            #puts "Boucle de maxCaseProche x="+x.to_s+" y="+y.to_s
            x = i
            y = j
            v = $game.board[i][j].value
          end
        end
      end
    end
    Cell.new(x, y)
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
