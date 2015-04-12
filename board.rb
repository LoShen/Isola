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
  	# Crée un plateau de dimensions newLines x newColumns (6x6 par défaut)
  	# Chaque case du plateau est une Cell
    # Décommenter les print pour voir le résultat
    # Supprimer les print lors de la mise en prod
    @board = [[]] # Création du tableau a 2 dimensions
    @lines = newLines
    @columns = newColumns
    for incLig in (0..newLines-1) # Pour chaque ligne
      @board[incLig] = [] # On crée une colonne
      for incCol in (0..newColumns-1) # Pour chaque combinaison de lignes et de colonnes
        @board[incLig][incCol] = Cell.new(incLig, incCol) # On crée une nouvelle cellule avec la position correspondante
        @board[incLig][incCol].set_x_y(incLig, incCol)
        @board[incLig][incCol].renvoieCoo
      end # Fin du for inCol
      print "\n"
    end#Fin du for incLig
    
    init_CellValue # Initialisation de la pondération
 
    #Affichage de verification
    puts "\n\n"
    (0..@lines-1).each do |i|
       (0..@columns-1).each do |j|   
          @board[i][j].renvoiePond
        end
      puts"\n"
      end#Fin du for d'affichage
      
  end#Fin du constructeur

  def [](i)
    # Définit l'accesseur [] pour la classe Board
    # NB : board[2] est un array
    # board[1][2] accède à la cell à la position 1, 2
    @board[i]
  end

  def init_CellValue
  	# Initialisation de la ponderation des cellules du plateau
  	# Parcours du bord jusqu'au centre
  	# La pondération augmente au fur et à mesure
    l1 = 0 # Indice de début de la ligne à pondérer
    l2 = @lines-1 # Indice de fin de la ligne à pondérer
    c1 = 0 # Indice de début de la colonne à pondérer
    c2 = @columns-1 # Indice de fin de la colonne à pondérer
    v = 1 # Pondération donnée a la case

    while (l1 <= @lines/2 || c1 <= @columns/2) do # Tant que l'on n'a pas atteint le centre
      for l in (l1..l2) 
        for c in (c1..c2)
        	# Pour chaque case du bord
          if (l==l1 || l==l2) && (c==c1 || c==c2) # Si c'est un coin
            @board[l][c].value = v-1 # On lui attribut une valeur moins élevée que les autres cases du bord
          else
            if l==l1 || l==l2
              @board[l][c].value = v
            elsif c==c1 || c==c2
              @board[l][c].value = v
            end
          end
        end#for c
      end#for l
      # Une fois le bord traité, on passe au "bord" plus petit
      l1 += 1 # On augmente donc l'indice de début des lignes
      l2 -= 1 # On diminue celui de fin
      c1 += 1 # Idem pour les colonnes
      c2 -= 1
      v += 3 # La valeur augmente à chaque fois, puisqu'on se rapproche du centre
    end#endwhile
  end

end

=begin
Gtk.init
	window = Gtk::Window.new
	#window.set_size_request 450, 250 # taille par defaut de la fenetre
	window.set_window_position :center # position initiale de la fenetre a l'ecran
	lines = 6
	columns = 6
	table = Gtk::Table.new(lines, columns)
	print "\n"
	mat = Board.new(lines, columns)
	puts "\n"
	for i in 0..(lines - 1)
  	for j in 0..(columns - 1)
  		#mat[i][j].set_x_y(i, j)
  		#window.add(mat[i][j])
  		#mat[i][j].renvoie
  		table.attach(mat[i][j], j, j+1, i, i+1)
  	end
  end

  window.add(table)
  '''
  $i = 0
	$j = 0
	$a = 0
	mat[$i][$j].renvoie
	for cell in table
		cell.signal_connect("button_press_event") do
		$b = $a
		puts $b
    	#mat[$i][$j].renvoie
    end
    $a = $a + 1
    
		$j = $j + 1
		if $j >= (columns -1)
			$j = 0
			$i = $i + 1
		end
		if $i >= (lines -1)
			$i = 0
		end
		
	end
	'''
  """
  for cell in window # ceci n'est pas une cellule
		window.child.signal_connect('button_press_event') {
    	mat[1][1].renvoie
    }
	end
"""
	
	
	
	window.show_all

'''
puts mat[2][3].state
puts mat[2][3].renvoie
puts mat[1][3].isAccessible
mat[1][3].state = 2
puts mat[1][3].isAccessible
puts mat[2][3].isAccessible
'''
Gtk.main
=end
