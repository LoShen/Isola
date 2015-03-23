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
  
  def initialize(x, y)
    @state = State::White # L'état de la case
    @x = x # Les coordonnées de la case
    @y = y
	end
    
    def set_x_y(newX, newY)
      @x = newX
      @y = newY
    end
    
    def renvoie
      print "["
      print @x
      print "]["
      print @y
      print "] "
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

end
