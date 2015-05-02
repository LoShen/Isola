#!/usr/bin/ruby
# -*- coding: utf-8 -*-

class Bonus < Gtk::EventBox

  attr_reader :name
  attr_reader :picture
  attr_accessor :activated

  def initialize(name, imageAdress)
    
    super()
    @name = name

    @picture = Gtk::Image.new(imageAdress)
    add(@picture)

    @activated = false

    signal_connect('button_press_event') do
      
      if !@activated && $game.playersList[$game.current].bonusEnCours == 'None' then

        #charger l'image du bonus actif
        $game.playersList[$game.current].bonusEnCours = @name

      elsif $game.playersList[$game.current].bonusEnCours == 'None' then

          #charger l'image du bonus inactif
          $game.playersList[$game.current].bonusEnCours = 'None'

      end
      
      updateBonus
      
    end
=begin
    def desactivate

      @activated = !@activated

    end
=end
  end

end
