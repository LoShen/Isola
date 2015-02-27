#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require 'gtk2'
require '/home/jeremy/Documents/fac/l2/session_4/projet_isola/Case'

#initialisation de la bibliotheque GTK(on ne peut pas creer d'objet avant d'avoir appele cette methode)
Gtk.init

#creation d'une variable fenetre
window = Gtk::Window.new

window.set_title('ISOLA 1.0')

#option de modification de la taille de la fenetre(ici on ne peut pas modifier sa taille -> false)
window.resizable = false

#gestion d'evenement de la variable fenetre. destroy -> fermer la fenetre
window.signal_connect('destroy') {

    #destruction de la fenetre
    Gtk.main_quit

}

table = Gtk::Table.new(8,4)

img = Gtk::Image.new('/home/jeremy/Documents/fac/l2/session_4/projet_isola/case_blanche.png')

for i in 0..3
  for j in 0..3

    #puts "#{j} #{j+1} #{i} #{i+1}"
    table.attach((Gtk::EventBox.new.add(Gtk::Image.new('/home/jeremy/Documents/fac/l2/session_4/projet_isola/case_blanche.png'))), j, j+1, i, i+1)
    #table.attach(, j, j+1, i, i+1)

  end
end

for i in 0..3
  for j in 0..3

    

  end
end

=begin for unCase in table

  unCase.signal_connect('button_press_event') {
    print "Clicked."
  }

=end

#creation d'une variable bouton
button = Gtk::Button.new('click on')

#gestion d'evenement de la variable bouton. clicked -> lorsque l'on clique sur le bouton
button.signal_connect('clicked') {

    print "Hello world!\n"

}

window.add(table)

=begin 
rendre visible un widget et tous les widgets qu'il contient(show_all)
par exemple window.show_all
=end
 
window.show_all

Gtk.main

print "FIN !\n"
