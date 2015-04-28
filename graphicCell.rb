#!/usr/bin/ruby
# -*- coding: utf-8 -*-

"""
Classe Cell

Attributs et comportement
des cases du plateau.

Auteur : Celia Rouquairol
Derniere modification : Mars 2015
"""

class GraphicCell < Gtk::HBox

  attr_reader :x
  attr_reader :y
  attr_accessor :picture
  attr_accessor :ebox
  
  def initialize(x, y)
    super
    @x = x
    @y = y
    @picture = Gtk::Image.new('./images/case_blanche.png')
    @ebox = Gtk::EventBox.new.add(@picture)
    add(@ebox) # N'affiche pas ebox en tant qu'élément graphique sinon
    
    signal_connect('button_press_event') do # Comportement de la cellule au clic
      if $game.playersList[$game.current].pion.x == -1 # Si le joueur n'a pas encore placé son pion
        placerPion
      elsif $game.playersList[$game.current].bonusEnCours != 'None' # Si le joueur utilise un bonus
        jouerBonus
      else # Si le joueur se déplace ou noircit une case
        jouerEtape
      end
    end
  end
  
  def jouerBonus
    # Liste des actions sur la case cliquée lorsqu'un joueur utilise un bonus
    case $game.playersList[$game.current].bonusEnCours
    when 'Blanchir' then
      if $game.board[@x][@y].state == State::Black
        blanchirCaseBonus($game.board[@x][@y])
        $game.playersList[$game.current].tableauBonus[0] = false
        #updateBonus
        #else
        # $ListeBonus.desactivate(0)
      end
      $game.playersList[$game.current].bonusEnCours = 'None'
    when 'Noircir' then
      if $game.board[@x][@y].isAccessible
        noircirCase($game.board[@x][@y])
        $game.playersList[$game.current].tableauBonus[1] = false
        #updateBonus
        #else
        # $ListeBonus.desactivate(1)
      end
      $game.playersList[$game.current].bonusEnCours = 'None'
    when 'Teleport' then
      if $game.board[@x][@y].isAccessible
        moveToken(@x, @y)
        $game.playersList[$game.current].tableauBonus[2] = false
        #updateBonus
        #else
        # $ListeBonus.desactivate(2)
      end
      $game.playersList[$game.current].bonusEnCours = 'None'
    end
    updateBoard($game.board[@x][@y])
    endGameBonus
  end

  def jouerBonusIA
    #position du pion de l'IA
    x = $game.playersList[$game.current].pion.x
    y = $game.playersList[$game.current].pion.y
    cible = Cell.new(-1, -1)
    #Si on a la TP
    if $game.playersList[$game.current].tableauBonus[2] && $game.board[x][y].nbCasesLibresProches < 3
      cible = $game.board.bestCell
      if cible.value > $game.board[x][y].value
        moveToken(cible)
        $game.playersList[$game.current].tableauBonus[2] = false
        #updateBonus
        #else
        # $ListeBonus.desactivate(2)
      end
      #Si on a le blanchissement
    elsif $game.playersList[$game.current].tableauBonus[0] && $game.board[x][y].nbCasesLibresProches < 3
      cible = $game.playersList[$game.current].pion.closestBlackCell
      if cible.x != -1
        blanchirCaseBonus(cible)
        $game.playersList[$game.current].tableauBonus[0] = false
        #updateBonus
        #else
        # $ListeBonus.desactivate(2)
      end
      
      #Si on a le noircissement
    elsif $game.playersList[$game.current].tableauBonus[1]
      noircirCase($game.playersList[$game.current-1].pion.maxCaseProche)
    end
    if cible.x != -1 then updateBoard(cible) end
    endGameBonus
  end

  def jouerEtapeIA
    jouerBonusIA
    # Liste des actions lorsque l'IA joue son tour
    cible = $game.playersList[$game.current].pion.maxCaseProche
    # cible est la cellule vers laquelle l'ia va se déplacer
    if ((0..$game.board.lines-1).include?(cible.x) && (0..$game.board.columns-1).include?(cible.y))
      # Si la cible est dans les limites du plateau
      moveToken(cible.x, cible.y) # L'ia déplace son pion
      updateBoard(cible) # Le plateau est mis à joue
      noircirCase($game.playersList[$game.current-1].pion.maxCaseProche) # L'ia noircit une case proche de son adversaire
      endGamePopUp # On vérifie si l'ia a perdu
      nextPlayer # On passe au joueur suivant
    end
  end
  
  def jouerEtape
    # Liste des actions au tour classique d'un joueur (bouger le pion et noircir une case)
    case $game.playersList[$game.current].etape
    when 1 then # Si le joueur doit se déplacer
      if $game.board[@x][@y].isAccessible and $game.playersList[$game.current].pion.caseProche($game.board[@x][@y])
        # Si la case cliquée est libre et proche du pion du joueur
        moveToken(@x, @y) # Le joueur déplace son pion
        recupBonus # Il récupère éventuellement un bonus
        updateBoard($game.board[@x][@y]) # L'affichage du plateau est mis à jour
        nextStep # On passe à l'étape suivante
      end
    when 2 then # Si le joueur doit noircir une case
      if $game.board[@x][@y].isAccessible # Si cette case est libre
        noircirCase($game.board[@x][@y]) # Elle est noircie
        nextStep # Le joueur passe à l'étape suivante
        endGamePopUp # On vérifie si le joueur a perdu
        nextPlayer # On passe au joueur suivant
        if $game.playersList[$game.current].est_IA # Si le joueur suivant est une ia
          jouerEtapeIA # On déclenche son tour sans clic
        end
      end
      endGamePopUp # On vérifie si le joueur suivant a perdu (avant son tour, avant qu'il clique)          
    end
  end
  
  def moveToken(x, y) # On déplace le pion
    oldX = $game.playersList[$game.current].pion.x # facilite la lecture pour la suite de la méthode
    oldY = $game.playersList[$game.current].pion.y
    $game.board[oldX][oldY].state = State::White # L'ancienne case du pion redevient disponible

    logToGraph(oldX, oldY, './images/case_blanche.png') # change l'image de la case graphique associée a sa case logique

    $game.board[oldX][oldY].updateCaseProcheValue(1) # L'ancienne case devenant libre, on incrémente la pondération des cases qui lui sont proches
    $game.board[x][y].updateCaseProcheValue(-1) # On décrémente en revanche la pondération des cases proches de la case de destination
  end

  def recupBonus
    # Place le bonus récupéré dans l'inventaire du joueur
    if $game.board[@x][@y].bonus != 'None'
      indice = $game.board[@x][@y].bonus # Chaque bonus correspond à un numéro
      $game.playersList[$game.current].tableauBonus[indice] = true # On place un booléen vrai à l'indice du tableau correspondant au bonus
      $game.board[@x][@y].bonus = 'None' # Il n'y a plus de bonus sur cette case puisque le joueur l'a ramassé
    end
  end

  def noircirCase(cell) 
    # Noircit une case cliquée par un joueur et modifie la pondération des cases proches
    $game.board[cell.x][cell.y].updateCaseProcheValue(-1)
    $game.board[cell.x][cell.y].state = State::Black
    logToGraph(cell.x, cell.y, './images/case_noiwe.png')
  end

  def placerPion
    # Liste des actions du joueur lorsqu'il place son pion pour la première fois
    $game.board[@x][@y].updateCaseProcheValue(-1) # On décrémente la valeur des cases proches
    recupBonus # Le joueur récupère un éventuel bonus
    updateBoard($game.board[@x][@y]) # L'affichage du plateau est mis à jour
    nextPlayer # On passe au joueur suivant
    if $game.playersList[$game.current].est_IA # Si le joueur suivant est une IA, on la fait jouer sans clic
      cible = $game.playersList[$game.current].iaCaseDepart # Elle se place sur la case la plus avantageuse
      cible.updateCaseProcheValue(-1) # La pondération des cases proches est dévaluée
      recupBonus # L'ia récupère éventuellement un bonus
      updateBoard(cible) # L'affichage du plateau est mis à jour
      nextPlayer # On passe au joueur suivant
    end
  end
  
  def blanchirCaseBonus(cell) 
    # Blanchit une case cliquée par un joueur et modifie la pondération des cases proches
    $game.board[cell.x][cell.y].updateCaseProcheValue(1)
    $game.board[cell.x][cell.y].state = State::White
    logToGraph(cell.x, cell.y, './images/case_blanche.png')
  end
  
  def updateBoard(cell) 
    # Déplace le pion, rafraichit l'affichage
    $game.board[cell.x][cell.y].state = State::Player # La case est désormais occupée par un joueur
    $game.playersList[$game.current].seDeplacer(cell) # Le pion est déplacé sur la case
    logToGraph(cell.x, cell.y, $game.playersList[$game.current].pion.image) # L'image du pion est placée sur la case choisie
  end

  def nextPlayer 
    # Passage au joueur suivant, bouclage de la liste
    $game.current += 1 # On passe au joueur suivant
    if $game.current == $game.nbPlayers then $game.current = 0 end 
    # Si le joueur est le dernier de la liste, on retourne au premier
  end

  def nextStep 
    # Passage a l'etape suivante pour le joueur en cours
    $game.playersList[$game.current].etape += 1 # On passe a l'etape suivante
    if $game.playersList[$game.current].etape == 3 then $game.playersList[$game.current].etape = 1 end # Si on a fait la derniere etape, on reset
  end

  def logToGraph(x, y, image) 
    # Retrouve la cellule graphique associée à la bonne cellule logique et en change son image
    j = $game.board.columns - 1 # Indices des cases logiques
    i = $game.board.lines - 1

    for cell in $catable do # On itère sur chaque case graphique pour trouver celle où était placé le pion
      if(i == x && j == y) # Si les indices correspondent aux coordonnées (x, y) de la cellule cliquée)
        cell.picture.set(image) # On modifie l'image de la cellule (blanche ou occupée par un pion)
        break # Plus besoin de parcourir le reste du plateau
      end
      # Décrémentation manuelle simulant deux boucles for
      j = j - 1 
      if j < 0
        j = $game.board.columns - 1
        i = i - 1
      end
    end
  end
  
  def endGameBonus
    endGamePopUp
    nextPlayer
    endGamePopUp
    $game.current-=1
  end


  def endGamePopUp
  # Si le joueur a perdu, on affiche un pop up qui informe que la partie est finie et renvoie au menu
    if $game.playersList[$game.current-1].canPlay && !$game.playersList[$game.current].canPlay 
		# Si le joueur précédent n'a pas déjà perdu et que le joueur actuel ne peut pas se déplacer, la partie prend fin
			endwindow = Gtk::Window.new(Gtk::Window::POPUP)
      endwindow.set_default_size(200, 150)
      endwindow.set_window_position :center
      
      label = Gtk::Label.new($game.playersList[$game.current].pseudo.to_s+' a perdu !')
      # On indique quel joueur a perdu la partie
      
      button = Gtk::Button.new('Revenir au menu')
      button.set_size_request(180, 35)
      button.signal_connect('button_press_event') do
        $endOfProgramm = false
        
        endwindow.destroy
        window.destroy
        Gtk.main_quit
        #main
      end
      
      vbox = Gtk::VBox.new
      vbox.add(label)
      vbox.add(button)
      
      endwindow.add(vbox)
      endwindow.show_all
    end
  end  
  
end
