#!/usr/bin/env ruby

require './Joueur.rb'#, './Case'

class JoueurHumain < Joueur
    
  def seDeplacer(cible)
    while !(JoueurHumain.pion.caseProche(cible))
      puts "Cette case n'est pas valide, choisissez en une autre\nEntrez deux entiers pour x et y :"
      x = gets.chomp
      cible.x = x
      y = gets.chomp
      cible.y = y
    end
    JoueurHumain.pion.x = x
    JoueurHumain.pion.y = y
  end

  def noircirCase(cible)
    while !(cible.etat == libre)
      puts "Erreur, cette case ne peut pas etre noircie (deja noire ou un joueur est dessus)\nEntrez deux entiers pour x et y :"
      x = gets.chomp
      cible.x = x
      y = gets.chomp
      cible.y = y
    end
    cible.etat = nonLibre
  end
  
  def peutJouer
    for i in ((JoueurHumain.pion.x-1)..(JoueurHumain.pion.x+1))
      for j in ((JoueurHumain.pion.y-1)..(JoueurHumain.pion.y+1))
        cible.x = i
        cible.y = j
        if cible.etat == libre
          return true
          break
        end
      end
    end
    return false
  end

  def jouerTour
    if JoueurHumain.peutJouer
      puts "Choisissez la case ou vous voulez vous deplacer, entrez le x:"
      cible1.x = gets.chomp
      puts "Puis le y :"
      cible1.y = gets.chomp
      JoueurHumain.seDeplacer(cible1)

      puts "Choisissez la case que vous voulez noircir, entrez le x:"
      cible2.x = gets.chomp
      puts "Puis le y :"
      cible2.y = gets.chomp
      JoueurHumain.noircirCase(cible2)
    else
      puts "Vous avez perdu !"
  end

end
