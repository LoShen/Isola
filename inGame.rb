#!/usr/bin/ruby
# -*- coding: utf-8 -*-

require 'gtk2'
load 'board.rb'

Gtk.init

window = Gtk::Window.new
window.set_window_position :center
window.signal_connect('destroy') { Gtk.main_quit }

lines = 6
columns = 6

aVbox = Gtk::VBox.new
baHbox = Gtk::HBox.new
bbHbox = Gtk::HBox.new
catable = Gtk::Table.new(lines, columns)
cbVbox = Gtk::VBox.new
mat = Board.new(lines, columns)

for i in 0..(lines - 1)
  	for j in 0..(columns - 1)
  		catable.attach(mat[i][j], j, j+1, i, i+1)
  	end
end
cbVbox.add(Gtk::Button.new('Joueur 1'))

baHbox.add(catable)
baHbox.add(cbVbox)

bbHbox.add(Gtk::Button.new('Bonus 1'))
bbHbox.add(Gtk::Button.new('Bonus 2'))

aVbox.add(baHbox)
aVbox.add(bbHbox)

window.add(aVbox)
window.show_all

Gtk.main
