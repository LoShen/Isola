#!/usr/bin/ruby
# -*- coding: utf-8 -*-

"""
Classe Board

Attributs et comportement
du plateau.

Auteur : Celia Rouquairol
Derniere modification : Avril 2015
"""

class Board

  attr_accessor :board
  attr_reader :lines
  attr_reader :columns
  
  def initialize(newLines = 6, newColumns = 6)
    # Créer un plateau 6x6 par défaut dont toutes les cases sont blanches
    @board = [[]] # Création du tableau a 2 dimensions
    @lines = newLines
    @columns = newColumns
    for incLig in (0..newLines-1) # Pour chaque ligne
      @board[incLig] = [] # On crée une colonne
      for incCol in (0..newColumns-1) # Pour chaque combinaison de lignes et de colonnes
        @board[incLig][incCol] = Cell.new(incLig, incCol) # On crée une nouvelle cellule avec la position correspondante
      end
    end
    
    init_CellValue # Initialisation de la pondération des cases
    alea_bonus # Initialisation des bonus
  end

  def [](i)
    # Définit l'accesseur [] pour la classe Board
    # NB : board[2] est un array
    # board[1][2] accède à la cell à la position 1, 2
    @board[i]
  end

  def init_CellValue 
  #Initialisation de la ponderation de chacune des cellules, du bord vers le centre
    l1 = 0 # Indice du début de la ligne à pondérer
    l2 = @lines-1 # Indice de fin de la ligne à pondérer
    c1 = 0 # Indice de début de la colonne à pondérer
    c2 = @columns-1 # Indice de fin de la colonne à pondérer
    v = 1 # Valeur donnée a la case

    while (l1 <= @lines/2 || c1 <= @columns/2) do
		# Tant que l'on a pas parcouru tout le plateau
      for l in (l1..l2) 
        for c in (c1..c2)
				# Pour chaque case
          if (l==l1 || l==l2) && (c==c1 || c==c2)
		  		# Si c'est un bord
            @board[l][c].value = v-1
						# Elle vaut un peu moins que les cases au même rang
          else
            @board[l][c].value = v
						# Sinon elle prend la valeur "classique"
          end
        end
      end
	  	# On parcourt le bord un cran plus petit
      l1+=1
      l2-=1
      c1+=1
      c2-=1
      v+=2 # La pondération des cases augmente lorsqu'on se rapproche du centre
    end
  end

  def alea_bonus
  # Définit le nombre de bonus, leur catégorie et leur emplacement sur le plateau
    nbBonus = (@lines * @columns)/rand(4..10) # Nombre aléatoire de bonus
    while nbBonus > 0 do
      x = rand(0..@lines-1) # Position aléatoire
      y = rand(0..@columns-1)
      @board[x][y].bonus = rand(3) # Catégorie aléatoire
      nbBonus -= 1 # On décrémente le nombre de bonus restant à placer
    end
  end

end
