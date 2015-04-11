#!/usr/bin/env ruby
# Time-stamp: <2015-04-09 19:01:52 oxedora>

class Joueur
  attr_reader :pseudo
  attr_accessor :pion
  attr_accessor :etape
  attr_reader :est_IA
  
  def initialize(p, newImage, b = false)
    @pseudo = p
    @pion = Pion.new(newImage)
    @etape = 1
    @est_IA = b
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

  def iaCaseDepart
    lines = $game.board.lines
    columns = $game.board.columns

    l1 = (lines%2 == 1) ? (lines/2+1) : (lines/2) #Coordonnee ligne minimale
    l2 = lines/2+1 #Coordonnee ligne maximale
    c1 = (columns%2 == 1) ? (columns/2+2) : (columns/2+1)#Coordonnee colonne minimale
    c2 = columns/2 #Coordonnee ligne maximale
    init = false
    alter = true

    while ((l1 > -1 || c1 > -1) && !init)do

      if (!alter)
        l1-=1
        l2+=1
      else
        c1-=1
        c2+=1
      end
      alter = !alter

      for l in (l1..l2)
        for c in (c1..c2)
          if ($game.board[l1][c1].isAccessible)
            init = true
          end
        end#for c
      end#for l
    end#endwhile
    $game.board[l1][c1]
  end
  
  def iaTour    
  end
end
