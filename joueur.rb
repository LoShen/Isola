#!/usr/bin/env ruby
# Time-stamp: <2015-04-09 19:01:52 oxedora>

class Joueur
  attr_reader :pseudo
  attr_accessor :pion # Le pion est une classe à part entière
  attr_accessor :etape # Se déplacer ou noircir une case
  attr_reader :est_IA
  
  def initialize(p, newImage, b = false)
    @pseudo = p
    @pion = Pion.new(newImage)
    @etape = 1
    @est_IA = b
  end

  def caseProche(c) 
  	# Renvoie vrai si la case c est proche du pion, faux sinon
    @pion.caseProche(c)
  end

  def seDeplacer(c)
  	# Déplace le pion à la case c
    @pion.nouvellePosition(c) #Si oui, fait changer le pion de position
    # @etape = @etape+1 #Ca s'est bien passe donc on passe a l'etape suivante
  end

  def canPlay
  	# Renvoie vrai si le joueur peut jouer, faux sinon
    @pion.canMove
  end

  def to_s 
  	# Affiche les attributs du joueur
    " Le pseudo de ce joueur est "+@pseudo+".\n Il est a la case de coordonnes "+@pion.x+","+@pion.y+"\n"
  end

  def iaCaseDepart
  	# Place le pion de l'IA à la case la plus aventageuse
  	# Les cases du centre étant les plus pondérées, on commence par le centre
    lines = $game.board.lines # Facilite la lecture
    columns = $game.board.columns

    l1 = (lines%2 == 1) ? (lines/2+1) : (lines/2) # Indice de début des lignes à parcourir
    l2 = lines/2+1 # Indice de fin des lignes à parcourir
    c1 = (columns%2 == 1) ? (columns/2+2) : (columns/2+1) # Indice de début des colonnes à parcourir
    c2 = columns/2 # Indice de fin des colonnes à parcourir
    init = false # Vrai si la position du pion est initialisée, faux sinon
    alter = true # Afin de tester les coins en dernier, on incrémente un coup les lignes, un coup les colonnes

    while ((l1 > -1 || c1 > -1) && !init)do # Tant qu'on est dans le plateau et que le pion n'est pas placé
			if (!alter) # On alterne l'incrémentation des lignes et des colonnes
        l1-=1
        l2+=1
      else
        c1-=1
        c2+=1
      end
      alter = !alter

      for l in (l1..l2) # On parcours le bord courant
        for c in (c1..c2)
          if ($game.board[l1][c1].isAccessible) # Si la case est accessible
            init = true # On place le pion
          end
        end#for c
      end#for l
    end#endwhile
    $game.board[l1][c1] # On renvoie la case la plus avantageuse
  end
  
  def iaTour    
  end
end
