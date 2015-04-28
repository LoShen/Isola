#!/usr/bin/env ruby
# Time-stamp: <2015-04-22 17:49:41 oxedora>

class Joueur
  attr_reader :pseudo
  attr_accessor :pion
  attr_accessor :etape
  attr_reader :est_IA
  attr_accessor :tableauBonus
  attr_accessor :bonusEnCours

  def initialize(p, newImage, b = false)
    @pseudo = p
    @pion = Pion.new(newImage)
    @etape = 1
    @est_IA = b
    @tableauBonus = [false, false, false] # Pour chaque bonus, un booléen indique s'il est possédé par le joueur
    @bonusEnCours = 'None'
  end

  def caseProche(c) #Explicite
    @pion.caseProche(c)
  end

  def seDeplacer(c)
    @pion.nouvellePosition(c) #Si oui, fait changer le pion de position
  end

  def canPlay
    @pion.canMove
  end

  def to_s #Explicite
    " Le pseudo de ce joueur est "+@pseudo+".\n Il est a la case de coordonnes "+@pion.x+","+@pion.y+"\n"
  end

  def iaCaseDepart
  # Place l'ia sur une des cases les plus avantageuses du plateau
    lines = $game.board.lines # Facilite la lecture pour le reste de la fonction
    columns = $game.board.columns
	
		# On se place au milieu du plateau dans le sens de la longueur
    l1 = (lines%2 == 1) ? (lines/2+1) : (lines/2) # Indice de début des lignes
    l2 = lines/2+1 # Indice de fin des lignes
		# On se place au milieu du plateau dans le sens de la largeur
    c1 = (columns%2 == 1) ? (columns/2+2) : (columns/2+1) # Indice de début des colonnes
    c2 = columns/2 # Indice de fin des colonnes
    init = false # Vérifie si l'ia est placée
    alter = true # Permet d'affiner la recherche de la pondération la plus élevée

    while ((l1 > -1 || c1 > -1) && !init)do
		# Tant que l'on est dans le plateau et que l'ia n'est pas placée
      if (!alter)
	  	# On alterne l'incrémentation des indices afin de tester les coins en dernier
        l1-=1
        l2+=1
      else
        c1-=1
        c2+=1
      end
      alter = !alter

      for l in (l1..l2)
        for c in (c1..c2)
				# Pour chaque case
          if ($game.board[l1][c1].isAccessible) # Si elle est accessible
            init = true # L'ia se place dessus
          end
        end
      end
    end
    $game.board[l1][c1] # On renvoie la cellule choisie
  end
end
