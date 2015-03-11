#!/usr/bin/ruby
# -*- coding: utf-8 -*-

"""
Classe Cell

Attributs et comportement
des cases du plateau.

Auteur : Celia Rouquairol
Derniere modification : Mars 2015
"""

require "gtk2"
load "state.rb"

class Cell < Gtk::HBox # Pour permettre de passer 2 arguments en paramètres

  attr_accessor :x
  attr_accessor :y
  attr_accessor :picture
  attr_accessor :state
  
  def initialize(x, y)
    # Créer une case, sa couleur par défaut est blanche
    super # Constructeur hérité de la classe mère
    add(Gtk::EventBox.new.add(Gtk::Image.new('./images/case_blanche.png'))) # On ajoute une image cliquable
    @state = State::White # L'état de la case
    @x = x # Les coordonnées de la case
    @y = y
    #@picture = Gtk::Image.new('./images/case_blanche.png') # deprecated style
    signal_connect('button_press_event') do 
      #puts x.to_s + " " + y.to_s # instruction de test, a supprimer pour la prod
      #puts @state # instruction de test, a supprimer pour la prod
      if game.playerList.current.pion.x == -1 # Si la coordonnée x du pion du joueur actuel (cad celui qui clique) n'est pas initialisée (ou a -1, à choisir)
        game.playerList.current.pion.nouvellePosition(@x, @y) # alors on initialise la position du pion
      else # Sinon le joueur est dans une phase de jeu classique
        case game.playerList.current.etape
        when 1 then @state = State::Player unless !game.playerList.current.seDeplacer(@self)
          # La première étape du joueur est de déplacer son pion, pas sûre que le self fonctionne
        when 2 then @state = State::Black unless !game.playerList.current.noircirCase(@self) 
          # La seconde étape du joueur est de noircir une case
        end
        # Les fonctions doivent informer la cellule du bon/mauvais résultat pour changer l'état de la case le cas échéant
      end
    end
    
    def set_x_y(newX, newY)
      @x = newX
      @y = newY
    end
    
    def renvoie
      print "["
      print @x
      print "]["
      print @y
      print "] "
    end
    
    def state=(newState)
      @state = newState
    end
    
    def color
      # Affiche la couleur correspondante a la valeur de la case
      case @state
      when 0
        print "Invalid"
      when 1
        print "White"
      when 2
        print "Black"
      when 3
        print "Player"
      end
    end
    
    def isAccessible
      # Renvoie vrai si la case est blanche, faux sinon
      @state == 1
    end
  end
end
