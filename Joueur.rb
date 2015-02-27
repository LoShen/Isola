#!/usr/bin/env ruby

#require './Pion.rb'

class Joueur
  attr_accessor :pseudo#, pion
  
  def initialize
    @pseudo = ""
    #@pion = Pion.new
  end

  def to_s
    "Le pseudo de ce joueur est "+@pseudo+".\n"
    #"il est a la case de coordonnes "+pion.x+","+pion.y+"\n"
  end
  
  def pseudo=(newPseudo)
    @pseudo = newPseudo
  end

=begin
  def setPion=(newPion)
    @pion = newPion
  end
=end
end
