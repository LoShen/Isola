#!/usr/bin/ruby 1.9.3
# -*- coding: utf-8 -*-

# Time-stamp: <2015-03-16 21:34:27 chilya>  le # etait necessaire pour que ca interprete, mais c'est toujours fonctionnel, donc osef.

require './cell.rb'

class Pion 

  #attributs, sisi

  attr_accessor :x
  attr_accessor :y

  #constructeur

  def initialize x,y
    @x=x
    @y=y
  end

  #methodes

  def caseProche (&cell)
    if abs.(cell.x-@x) == 1 && abs.(cell.y-@y) == 1 then
      true
    else false
    end
  end

  def nouvellePosition (&cell)
    if this.caseProche(cell)
      @x=cell.x
      @y=cell.y
    end

  end

end
