#!/usr/bin/env ruby
# Time-stamp: <2015-03-23 19:02:46 oxedora>

class Joueur
  attr_reader :pseudo
  attr_accessor :pion
  attr_accessor :etape
  
  def initialize(p, newImage)
    @pseudo = p
    @pion = Pion.new(newImage)
    @etape = 1
  end

  def caseProche(c) #Explicite
    @pion.caseProche(c)
  end

  def seDeplacer(c)
    @pion.nouvellePosition(c) #Si oui, fait changer le pion de position
    # @etape = @etape+1 #Ca s'est bien passe donc on passe a l'etape suivante
  end

  def canPlay
    @pion.canMove
  end

  def to_s #Explicite
    " Le pseudo de ce joueur est "+@pseudo+".\n Il est a la case de coordonnes "+@pion.x+","+@pion.y+"\n"
  end

end
