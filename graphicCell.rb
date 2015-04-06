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
      puts x.to_s + " " + y.to_s+" v="+$game.board[x][y].value.to_s # instruction de test, a supprimer pour la prod
      puts $game.playersList[$game.current].pseudo.to_s
      #puts @state # instruction de test, a supprimer pour la prod
      if $game.playersList[$game.current].pion.x == -1
        (x-1..x+1).each do |i|
          (y-1..y+1).each do |j|
            if caseProcheValide(i, j, @x, @y)
              puts "Boucle x="+i.to_s+" y="+j.to_s
              $game.board[i][j].value-=1
            end
          end
        end
        updateBoard
        nextPlayer
      else
        case $game.playersList[$game.current].etape
        when 1 then 
          if $game.board[@x][@y].isAccessible and $game.playersList[$game.current].pion.caseProche($game.board[@x][@y])
            moveToken
            updateBoard
            nextStep
          end
        when 2 then
          if $game.board[@x][@y].isAccessible
            noircirCase
            nextStep
            endGamePopUp
            nextPlayer
          end
          endGamePopUp
        end
      end
    end
  end
  
  
  def moveToken # On déplace le pion
    #puts "EST UNE CASE PROCHE : " +$game.playersList[$game.current].pion.caseProche($game.board[@x][@y]).to_s
    #puts "ACCESSIBLE : " + $game.board[@x][@y].isAccessible.to_s
    oldX = $game.playersList[$game.current].pion.x # facilite la lecture pour la suite de la méthode
    oldY = $game.playersList[$game.current].pion.y
    $game.board[oldX][oldY].state = State::White # L'ancienne case du pion redevient disponible
    j = $game.board.columns - 1 # Le for parcourt depuis la fin de la table
    i = $game.board.lines - 1
    for cell in $catable do # On itère sur chaque case pour trouver celle où était placé le pion
      if(i == oldX && j == oldY) then cell.picture.set('./images/case_blanche.png') end
      j = j - 1
      if j < 0
        j = $game.board.columns - 1
        i = i - 1
      end
    end

    #On itère sur les cases proches de l'ancienne pos pour remettre les cases à leur valeur d'origine
    (oldX-1..oldX+1).each do |i|
      (oldY-1..oldY+1).each do |j|
        if caseProcheValide(i, j, oldX, oldY)
          puts "Boucle x="+i.to_s+" y="+j.to_s
          $game.board[i][j].value+=1
        end
      end
    end
puts "\n"
    #on itère sur les cases proches de la nouvelle position pour mettre a jour les valeurs des cases.
    (@x-1..@x+1).each do |i|
      (@y-1..@y+1).each do |j|
        if caseProcheValide(i, j, @x, @y)
          puts "Boucle x="+i.to_s+" y="+j.to_s
          $game.board[i][j].value-=1
        end
      end
    end
  end

  def noircirCase 
    $game.board[@x][@y].value = 0
    #On itère sur les cases proches pour mettre a jour leur valeur
    (@x-1..@x+1).each do |i|
      (@y-1..@y+1).each do |j|
        if caseProcheValide(i, j, @x, @y)
          puts "Boucle x="+i.to_s+" y="+j.to_s
          $game.board[i][j].value-=1
        end
      end
    end
    $game.board[@x][@y].state = State::Black
    @picture.set('./images/case_noiwe.png')
  end

  def caseProcheValide(i, j, x, y)#i et j les coordonnées de la case testée, x et y, les coordonnée de la case autour de laquelle on met a jour
    return ((i != x || j != x) && ((i > -1 && j > -1) && (i < $game.board.lines && j < $game.board.columns)))
  end
  
  def updateBoard # déplace le pion, rafraichit l'affichage
    $game.board[@x][@y].state = State::Player # La case est désormais occupée par un joueur
    $game.playersList[$game.current].seDeplacer($game.board[@x][@y])
    @picture.set($game.playersList[$game.current].pion.image) # L'image du pion est placée sur la case choisie
  end

  def nextPlayer # Passage au joueur suivant, bouclage de la liste
    $game.current += 1 # On passe au joueur suivant
    if $game.current == $game.nbPlayers then $game.current = 0 end # Si le joueur est le dernier de la liste, on retourne au premier
  end

  def nextStep # Passage a l'etape suivante pour le joueur en cours
    $game.playersList[$game.current].etape += 1 # On passe a l'etape suivante
    if $game.playersList[$game.current].etape == 3 then $game.playersList[$game.current].etape = 1 end # Si on a fait la derniere etape, on reset
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
