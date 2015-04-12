# -*- coding: utf-8 -*-
#!/usr/bin/ruby
# -*- coding: utf-8 -*-

"""
Classe Cell

Attributs et comportement
des cases du plateau.

Auteur : Celia Rouquairol
Derniere modification : Avril 2015
"""

class GraphicCell < Gtk::HBox

  attr_reader :x
  attr_reader :y
  attr_accessor :picture # Image de la case
  attr_accessor :ebox # EventBox contenant l'image
  
  def initialize(x, y)
  	# Crée une case de coordonnées (x, y) et blanche par défaut
    super # Constructeur de la classe mère
    @x = x
    @y = y
    @picture = Gtk::Image.new('./images/case_blanche.png') # Image par défaut
    @ebox = Gtk::EventBox.new.add(@picture) # L'image est placée dans une EventBox pour être cliquable
    add(@ebox) # N'affiche pas ebox en tant qu'élément graphique sinon
    signal_connect('button_press_event') do # Comportement de la case au clic
      puts $game.playersList[$game.current].pseudo.to_s+" "
      $game.board[@x][@y].renvoie # instruction de test, a supprimer pour la prod
      #puts @state # instruction de test, a supprimer pour la prod

      if $game.playersList[$game.current].pion.x == -1 # Si le joueur actuel n'a pas encore placé son pion
        $game.board[@x][@y].updateCellsAround(-1) # Les cases proches de la cellule cliquée sont dévaluées
        puts "AVANT UPDATE BOARD "+@x.to_s+ " "+@y.to_s
        updateBoard($game.board[@x][@y]) # Le plateau est mis à jour
        nextPlayer # On passe au joueur suivant
        if $game.playersList[$game.current].est_IA # Si le joueur suivant est une IA
        	iaPlacerPion
        end # est_IA
      else
        case $game.playersList[$game.current].etape # On vérifie à quelle étape correspond le clic
        when 1 then # S'il correspond au déplacement
          if $game.board[@x][@y].isAccessible and $game.playersList[$game.current].pion.caseProche($game.board[@x][@y])
          	# Si la case cliquée est libre et proche du pion
            moveToken($game.board[@x][@y]) # Le pion est déplacé sur cette case
            updateBoard($game.board[@x][@y]) # Le plateau est mis à jour
            nextStep # Le joueur passe à l'étape suivante
          end # case valide
        when 2 then # S'il correspond au noircissement d'une case
          if $game.board[@x][@y].isAccessible # Si la case est blanche
            noircirCase($game.board[@x][@y]) # On la noircit
            nextStep # Le joueur passe à l'étape suivante
            endGamePopUp # On vérifie si le joueur n'a pas perdu
            nextPlayer # On passe au joueur suivant
            if $game.playersList[$game.current].est_IA # Si le joueur suivant est une IA
              iaJouerTour
            else
              endGamePopUp
            end # est_IA
					end # case blanche
				end # case when
          endGamePopUp          
			end # étape
		end
	end

  def iaJouerTour
  	cible = $game.playersList[$game.current].pion.maxCaseProche # Il se déplace sur la case proche la plus avantageuse
    puts cible.renvoieCoo
    if ((0..$game.board.lines-1).include?(cible.x) && (0..$game.board.columns-1).include?(cible.y)) # Si la case est valide
    	moveToken(cible) # Le pion est déplacé sur cette case
      updateBoard(cible) # Le plateau est mis à jour
     	puts "Position de l'IA "+$game.playersList[$game.current].pion.x.to_s+" "+$game.playersList[$game.current].pion.y.to_s
      noircirCase($game.playersList[$game.current-1].pion.maxCaseProche) # L'IA noircit la case la plus avantageuse de l'autre joueur
      endGamePopUp # On vérifie si l'IA n'a pas perdu
      nextPlayer # On passe au joueur suivant
    end
  end
  
  def iaPlacerPion
  	# Place le pion de l'IA lorsqu'il n'est pas initialisé
		cible = $game.playersList[$game.current].iaCaseDepart # Elle choisit sa case de départ
    cible.updateCellsAround(-1) # Les cases proches sont dévaluées
    updateBoard(cible) # Le plateau est mis à jour
    #puts  $game.playersList[$game.current].pion.x.to_s+" "+ $game.playersList[$game.current].pion.y.to_s
    nextPlayer # On passe au joueur suivant
  end
  
  def moveToken(newCell) 
  	# Déplace le pion du joueur sur la case newCell
    #puts "EST UNE CASE PROCHE : " +$game.playersList[$game.current].pion.caseProche($game.board[@x][@y]).to_s
    #puts "ACCESSIBLE : " + $game.board[@x][@y].isAccessible.to_s
    oldX = $game.playersList[$game.current].pion.x # facilite la lecture pour la suite de la méthode
    oldY = $game.playersList[$game.current].pion.y
    $game.board[oldX][oldY].state = State::White # L'ancienne case du pion redevient disponible

    logToGraph(oldX, oldY, './images/case_blanche.png') #change l'image de la case graphique associée a sa case logique

    $game.board[oldX][oldY].updateCellsAround(1) # La valeur des cases proches de l'ancienne position du pion est augmentée
    $game.board[newCell.x][newCell.y].updateCellsAround(-1) # Les cases proches de la nouvelle position sont dévaluées
  end

  def noircirCase(cell) 
  	# Noircit la case cell
    $game.board[cell.x][cell.y].updateCellsAround(-1) # Les cases proches sont dévaluées
    $game.board[cell.x][cell.y].state = State::Black # L'état est mis à jour
    logToGraph(cell.x, cell.y, './images/case_noiwe.png') # L'image également
    puts cell.isAccessible
  end
  
  def updateBoard(cell) 
  	# Déplace le pion, rafraichit l'affichage
    $game.board[cell.x][cell.y].state = State::Player # La case est désormais occupée par un joueur
    $game.playersList[$game.current].seDeplacer(cell) # Le pion est déplacé sur la cellule
    logToGraph(cell.x, cell.y, $game.playersList[$game.current].pion.image) # L'image du pion est placée sur la case choisie
  end

  def nextPlayer 
  	# Passage au joueur suivant, bouclage de la liste
    $game.current += 1 # On passe au joueur suivant
    if $game.current == $game.nbPlayers then $game.current = 0 end # Si le joueur est le dernier de la liste, on retourne au premier
  end

  def nextStep 
  	# Passage a l'etape suivante pour le joueur en cours
    $game.playersList[$game.current].etape += 1 # On passe a l'etape suivante
    if $game.playersList[$game.current].etape == 3 then $game.playersList[$game.current].etape = 1 end # Si on a fait la derniere etape, on reset
  end

  def logToGraph(x, y, image) 
  	#Retrouve la cellule graphique associée à la bonne cellule logique et en change son image
    j = $game.board.columns - 1 # Le for parcourt depuis la fin de la table
    i = $game.board.lines - 1

    for cell in $catable do # On itère sur chaque case pour trouver celle où était placé le pion
      if(i == x && j == y) # Si on trouve la bonne case
        cell.picture.set(image) # On change son image
        break # On arrête le parcours
      end
      # On décrémente manuellement
      j = j - 1
      if j < 0
        j = $game.board.columns - 1
        i = i - 1
      end
    end
  end

  def endGamePopUp
  	# Si le joueur a perdu, on affiche une fenêtre le signalant
    if !$game.playersList[$game.current].canPlay # Si le joueur est dans une phase de jeu classique, test s'il peut jouer
      label = Gtk::Label.new($game.playersList[$game.current].pseudo.to_s+" a perdu !")
      button = Gtk::Button.new("Ok :'(")
      button.signal_connect('button_press_event') do
        Gtk.main_quit
      end
      window = Gtk::Window.new
      vbox = Gtk::VBox.new
      vbox.add(label)
      vbox.add(button)
      window.add(vbox)
      window.set_default_size(100, 50)
      window.set_window_position :center
      window.show_all
    end
  end  
end
