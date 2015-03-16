#!/usr/bin/env ruby
Time-stamp: <2015-03-16 14:47:24 chilya>

require './pion.rb'
require './cell.rb'

class Joueur
  attr_reader :pseudo
  attr_accessor :pion
  attr_accessor :etape
  
  def initialize(String p)
    @pseudo = p
    @pion = Pion.new(-1, -1)
    @etape = 1
  end

  def caseProche(Cell c)#Explicite
    @pion.caseProche(c)
  end

  def seDeplacer(Cell c)
    if caseProche(c) && c.isAccessible #Verifie si la case est valide
      @pion.nouvellePosition(c)#Si oui, fait changer le pion de position
      @etape = @etape+1#Ca s'est bien passe donc on passe a l'etape suivante
    end
    (caseProche(c) && c.isAccessible)#Renvoie un booleen pour savoir comment s'est passe l'operation
  end

  def noircirCase(Cell c)
    if c.isAccessible#Si la case peut etre noircie
      c.state = State::Black#On noirci
      @etape = @etape+1#Ca s'est bien passe donc on passe a l'etape suivante
    end
    c.isAccessible#Booleen pour verifier si tout s'est bien passe
  end

  def to_s#Explicite
    " Le pseudo de ce joueur est "+@pseudo+".\n Il est a la case de coordonnes "+@pion.x+","+@pion.y+"\n"
  end

end
