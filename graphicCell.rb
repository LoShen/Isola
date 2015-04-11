# -*- coding: utf-8 -*-
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
    signal_connect('button_press_event') do 
      puts $game.playersList[$game.current].pseudo.to_s+" "
      $game.board[@x][@y].renvoie # instruction de test, a supprimer pour la prod
      #puts @state # instruction de test, a supprimer pour la prod

      if $game.playersList[$game.current].pion.x == -1
        $game.board[@x][@y].moveTokenLog(-1)
        updateBoard($game.board[@x][@y])
        nextPlayer
        if $game.playersList[$game.current].est_IA
          cible = $game.playersList[$game.current].iaCaseDepart
          cible.moveTokenLog(-1)
          updateBoard(cible)
          #puts  $game.playersList[$game.current].pion.x.to_s+" "+ $game.playersList[$game.current].pion.y.to_s
          nextPlayer
        end
      else
        case $game.playersList[$game.current].etape
        when 1 then 
          if $game.board[@x][@y].isAccessible and $game.playersList[$game.current].pion.caseProche($game.board[@x][@y])
            moveToken(@x, @y)
            updateBoard($game.board[@x][@y])
            nextStep
          end
        when 2 then
          if $game.board[@x][@y].isAccessible
            noircirCase($game.board[@x][@y])
            nextStep
            endGamePopUp
            nextPlayer
            if $game.playersList[$game.current].est_IA
              cible = $game.playersList[$game.current].pion.maxCaseProche
              puts cible.renvoieCoo
              if ((0..$game.board.lines-1).include?(cible.x) && (0..$game.board.columns-1).include?(cible.y))
                moveToken(cible.x, cible.y)
                updateBoard(cible)
                puts "Position de l'IA "+$game.playersList[$game.current].pion.x.to_s+" "+$game.playersList[$game.current].pion.y.to_s
                noircirCase($game.playersList[$game.current-1].pion.maxCaseProche)
                endGamePopUp
                nextPlayer
              else
                endGamePopUp
              end
            end
          end
          endGamePopUp          
        end
      end
    end
  end

  
  
  def moveToken(x, y) # On déplace le pion
    #puts "EST UNE CASE PROCHE : " +$game.playersList[$game.current].pion.caseProche($game.board[@x][@y]).to_s
    #puts "ACCESSIBLE : " + $game.board[@x][@y].isAccessible.to_s
    oldX = $game.playersList[$game.current].pion.x # facilite la lecture pour la suite de la méthode
    oldY = $game.playersList[$game.current].pion.y
    $game.board[oldX][oldY].state = State::White # L'ancienne case du pion redevient disponible

    logToGraph(oldX, oldY, './images/case_blanche.png') #change l'image de la case graphique associée a sa case logique

    $game.board[oldX][oldY].moveTokenLog(1)
    $game.board[x][y].moveTokenLog(-1)
  end

  def noircirCase(cell) 
    $game.board[cell.x][cell.y].noircirCaseLog
    $game.board[cell.x][cell.y].state = State::Black
    logToGraph(cell.x, cell.y, './images/case_noiwe.png')
    puts cell.isAccessible
  end
  
  def updateBoard(cell) # déplace le pion, rafraichit l'affichage
    $game.board[cell.x][cell.y].state = State::Player # La case est désormais occupée par un joueur
    $game.playersList[$game.current].seDeplacer(cell)
    logToGraph(cell.x, cell.y, $game.playersList[$game.current].pion.image) # L'image du pion est placée sur la case choisie
  end

  def nextPlayer # Passage au joueur suivant, bouclage de la liste
    $game.current += 1 # On passe au joueur suivant
    if $game.current == $game.nbPlayers then $game.current = 0 end # Si le joueur est le dernier de la liste, on retourne au premier
  end

  def nextStep # Passage a l'etape suivante pour le joueur en cours
    $game.playersList[$game.current].etape += 1 # On passe a l'etape suivante
    if $game.playersList[$game.current].etape == 3 then $game.playersList[$game.current].etape = 1 end # Si on a fait la derniere etape, on reset
  end

  def logToGraph(x, y, image) #Retrouve la cellule graphique associée à la bonne cellule logique et en change son image
    j = $game.board.columns - 1 # Le for parcourt depuis la fin de la table
    i = $game.board.lines - 1

    for cell in $catable do # On itère sur chaque case pour trouver celle où était placé le pion
      if(i == x && j == y)
        cell.picture.set(image)
        break
      end
      j = j - 1
      if j < 0
        j = $game.board.columns - 1
        i = i - 1
      end
    end
  end

  def endGamePopUp
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
