#!/usr/bin/ruby
# -*- coding: utf-8 -*-

"""
Classe Board

Attributs et comportement
du plateau.

Auteur : Celia Rouquairol
Derniere modification : Fevrier 2015
"""

load "cell.rb"

class Board

	attr_accessor :board
	attr_reader :lines
	attr_reader :columns
	
	def initialize(newLines = 6, newColumns = 6)
	# Créer un plateau 6x6 par défaut dont toutes les cases sont blanches
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
				@board[incLig][incCol].renvoie
			end
			print "\n"
		end
	end
	
	def [](i)
	# Définit l'accesseur [] pour la classe Board
	# NB : board[2] est un array
	# board[1][2] accède à la cell à la position 1, 2
		@board[i]
	end

end


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
  
  print "\n"
  print "\n"
  print "\n"
  
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
