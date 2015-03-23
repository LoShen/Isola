#!/usr/bin/ruby
# -*- coding: utf-8 -*-

'''
Creation du menu du jeu Isola

Ce programme cree un squelette du menu
du jeu Isola. Il utilise une Gtk::Box
verticale.

Auteur : Celia Rouquairol
Derniere modification : Fevrier 2015
'''

require 'gtk3'

$regles = %{
Décidez de la position initiale de votre pion parmi les 36 cases du plateau.
Vous et votre adversaire jouerez à tour de rôle.
Un tour consiste à effectuer les deux étapes suivantes :

		- Déplacer votre pion sur l'une des cases blanches voisines qui n'est pas occupée par le pion adverse.
			Il n'est donc pas possible de se déplacer sur une case noire, ni sur la case occupée par le pion adverse.
			Un pion a au maximum 8 possibilités de déplacement.
			
		- Interdire l'accès d'une case en y plaçant un carré noir. Evidemment, il n'est possible pas de placer un carré
			noir ni sur une case occupée par un pion, ni sur une case noire.
			
Le premier joueur qui ne peut plus déplacer son pion perd la partie.
}

class RubyApp < Gtk::Window

	def initialize
		super # heritage de la classe mere Gtk::Window
    
		init_ui # ui : user interface
	end
    
	def init_ui
    
    signal_connect "destroy" do Gtk.main_quit end # permet de fermer la fenetre
    	
		set_title "Isola : le jeu !" # initialise le nom de la fenetre
		
		lancerPartie = Gtk::Button.new(:label => "Jouer !") # crée un bouton dont le role sera de lancer une partie
		
		
		label = Gtk::Label.new $regles
		
		reglesJeu = Gtk::Button.new(:label => "Règles du jeu") # crée un bouton dont le role sera d'afficher les regles du jeu
		
		
		hbox = Gtk::Box.new :horizontal, 2
		vbox = Gtk::Box.new :vertical, 50 # espacement de 2px entre chaque fils dispose verticalement
		
		vbox.pack_start lancerPartie, :expand => false, :fill => true, :padding => 20
		vbox.pack_end reglesJeu, :expand => false
		
		hbox.add(vbox)    
		
		fixedMenu = Gtk::Fixed.new
		fixedMenu.put hbox, 0, 0
		
		fixedRegles = Gtk::Fixed.new
		fixedRegles.put label, 0, 0
		
		table = Gtk::Table.new(1, 1)
		table.attach(fixedMenu, 0, 1, 0, 1)
		table.attach(fixedRegles, 0, 1, 0, 1)
		
		alignement = Gtk::Alignment.new(0.5, 0.5, 0, 0)
		alignement.add table
		add alignement

 		reglesJeu.signal_connect("clicked") do
			fixedMenu.hide
			fixedRegles.show
		end
		set_default_size 300, 250 # taille par defaut de la fenetre
		set_window_position :center # position initiale de la fenetre a l'ecran
        
		show_all # affiche tous les elements de la fenetre
	end 
	
end

Gtk.init
	window = RubyApp.new
Gtk.main
