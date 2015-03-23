#!/usr/bin/ruby
# -*- coding: utf-8 -*-

Gtk.init

window = Gtk::Window.new
window.set_window_position :center
window.signal_connect('destroy') { Gtk.main_quit }

lines = 6
columns = 6

$j1 = Gtk::Image.new('./images/pion_j1.png')

aVbox = Gtk::VBox.new
baHbox = Gtk::HBox.new
bbHbox = Gtk::HBox.new
$catable = Gtk::Table.new(lines, columns)
fixed = Gtk::Fixed.new
cbVbox = Gtk::VBox.new
#mat = Board.new(lines, columns)
#$game = GameController.new

for i in 0..(lines - 1)
  	for j in 0..(columns - 1)
  		$catable.attach(GraphicCell.new(i, j), j, j+1, i, i+1)
  	end
end
cbVbox.add(Gtk::Button.new('Joueur 1'))
fixed.put($catable, 0.5, 0.5)

baHbox.add(fixed)
baHbox.add(cbVbox)

bbHbox.add(Gtk::Button.new('Bonus 1'))
bbHbox.add(Gtk::Button.new('Bonus 2'))

aVbox.add(baHbox)
aVbox.add(bbHbox)

window.add(aVbox)
window.show_all

Gtk.main
