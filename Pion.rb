#!/usr/bin/ruby 1.9.3
# -*- coding: utf-8 -*-


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

  def getX
    @x
  end

  def getY
    @y
  end 

  def caseProche x,y
    if (abs.(x-@x) > 1) then
      false
    else true
    end
  end

  def nouvellePosition x,y
    @x=x
    @y=y
  end

end
