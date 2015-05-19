#!/usr/bin/ruby
# -*- coding: utf-8 -*-

class TokenChoice < Gtk::HBox

  attr_reader :picture_adress
  attr_reader :picture
  attr_accessor :ebox
  
  def initialize(picture_adress)

    super
    @picture_adress = picture_adress
    @picture = Gtk::Image.new(picture_adress)
    @ebox = Gtk::EventBox.new.add(@picture)
    add(@ebox) # N'affiche pas ebox en tant qu'élément graphique sinon  
  
  end

end
