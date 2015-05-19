#!/usr/bin/ruby
# -*- coding: utf-8 -*-

require './bonus.rb'
require './tokenChoice.rb'

Gtk.init

# On initialise tous les elements necessaires a l'affichage et au commencement de la partie 
def main

  gameInformations = Array.new(9) # On cree un tableau qui collectera toutes les informations necessaires a l'initialisation du jeu

  # On concerve on nombre de 2 joueurs
  gameInformations[0] = 2

  $bonusArray = [Bonus.new('Blanchir', './images/bonus1.png'), Bonus.new('Noircir', './images/bonus2.png'), Bonus.new('Teleport', './images/bonus3.png')]

  $endOfProgramm = true 


  # Booleen distingant : _ lorsque l'on clique sur la croix pour fermant la fenetre pour mettre fin au programme -> 'true'
  #                       _ lorque l'on ferme la fenetre en fin de partie pour en ouvrir une nouvelle (recommencer une partie) -> 'false'

  # Creation de la fenetre principale
  $window = Gtk::Window.new
  $window.set_title("ISOLA")         # Titre de la fenetre principale
  $window.set_default_size(350, 350) # Taille de la fenetre principal
  $window.window_position = Gtk::Window::POS_CENTER_ALWAYS # Quelque soit l'affichage, la fenetre sera toujours centree

  # Trouver comment mettre une image en fond pour le jeu
  background = Gtk::Image.new('images/background.jpg')

  # Boite verticale principale qui contiendra toutes les modifications d'affichage de la fenetre principale
  $allBox = Gtk::VBox.new

  $window.add($allBox) # On ajoute la boite principale a la fenetre principale
  $window.show_all     # Affichage de la fenetre principale et de ces 'enfants'

  # Lorsque la fenetre principale se ferme
  $window.signal_connect "destroy" do
    
    # Si l'on souhaite definitivement quitter le programme -> 'true'
    if $endOfProgramm
      
      Gtk.main_quit # On quitte la boucle et le progamme s'arrete
      
    end

  end

  menu(gameInformations)

end

# Affichage de la fenetre du menu principal
def menu(gameInformations)
  
  #essayer d'adapter la taille de la fenetre selon l'affichage
  $window.set_default_size(350, 350)
  
  #Message de bienvenue du menu principal
  welcome = Gtk::Label.new("Bonjour! et bienvenue sur ISOLA!")

  # Creation du bouton 'Jouer' (cette operation sera recurrente, pour chaque 
  play = Gtk::Button.new('Jouer')
  play.set_size_request 80, 35    # Modification de la taille du bouton 'Jouer'

  playFixed = Gtk::Fixed.new      # Pour fixer la taille d'un widget
  playFixed.put play, 0.5, 0.5    # La taille du bouton 'Jouer' reste fixe selon la taille de la fenetre qui le contient

  playAlignment = Gtk::Alignment.new(0.5, 0.5, 0, 0) # Positionner le bouton au centre de l'espace qui lui est aloue(alignement du bouton)
  playAlignment.add(playFixed)                       # On regroupe le bouton ainsi que sa fixation de taille dans l'alignement
  # Fin de creation du bouton 'Jouer'

  # Bouton 'Regles'
  rules = Gtk::Button.new('Règles')
  rules.set_size_request 80, 35 

  rulesFixed = Gtk::Fixed.new
  rulesFixed.put rules, 0.5, 0.5 

  rulesAlignment = Gtk::Alignment.new(0.5, 0.5, 0, 0)
  rulesAlignment.add(rulesFixed)
  # Fin bouton 'Regles'

  # Bouton 'Quitter'
  leave = Gtk::Button.new('Quitter')
  leave.set_size_request 80, 35 

  leaveFixed = Gtk::Fixed.new
  leaveFixed.put leave, 0.5, 0.5 

  leaveAlignment = Gtk::Alignment.new(0.5, 0.5, 0, 0)
  leaveAlignment.add(leaveFixed)
  # Fin bouton 'Quitter'

  $allBox.add(welcome)
  $allBox.add(playAlignment)
  $allBox.add(rulesAlignment)
  $allBox.add(leaveAlignment)

  $allBox.show_all

  # Lorsque l'on clique sur le bouton 'Jouer' (cette operation sera recurrente, pour chaque bouton sur lequel l'utilisateur clique)
  play.signal_connect "clicked" do
    
    # On supprime tous les elements(enfants/widgets) de la boite principale
    $allBox.remove(welcome)
    $allBox.remove(playAlignment)
    $allBox.remove(rulesAlignment)
    $allBox.remove(leaveAlignment)

    # On passe a l'etape(fonction) suivante en conservant notre tableau(en argument)
    # qui poursuivra sa collecte d'informations
    sizeOfBoard(gameInformations)

  end # Fin des instructions liees au cliques du bouton 'Jouer' 

  # Lorsque l'on clique sur le bouton 'Regles'
  rules.signal_connect "clicked" do

    $allBox.remove(welcome)
    $allBox.remove(playAlignment)
    $allBox.remove(rulesAlignment)
    $allBox.remove(leaveAlignment)

    displayRules(gameInformations)

  end # Fin clique 'Regles'

  # Lorsque l'on clique sur le bouton 'Quitter'
  leave.signal_connect "clicked" do

    $allBox.remove(welcome)
    $allBox.remove(playAlignment)
    $allBox.remove(rulesAlignment)
    $allBox.remove(leaveAlignment)

    leave($allBox, gameInformations)

  end # Fin clique 'Quitter'

end

# Le(s) joueur(s) selectionne(ent) les dimensions du plateau
def sizeOfBoard(gameInformations)

  linesBox = Gtk::HBox.new
  enterNumberOfLines = Gtk::Label.new("Veuillez saisir le nombre de lignes de votre plateau de jeu:\n\tminimum : 6 lignes\n\tmaximum : 10 lignes")

  linesEntry = Gtk::Entry.new # Cree une nouvelle zone de texte pour saisir le nombre de lignes du plateau de jeu
  linesEntry.max_length = 2   # nombre maximum de caractere pour la saisie du nombre de lignes

  linesBox.add(enterNumberOfLines)
  linesBox.add(linesEntry)
  
  columnsBox = Gtk::HBox.new
  enterNumberOfColumns = Gtk::Label.new("Veuillez saisir le nombre de colonnes de votre plateau de jeu:\n\tminimum : 6 colonnes\n\tmaximum : 10 colonnes")

  columnsEntry = Gtk::Entry.new # Cree une nouvelle zone de texte pour saisir le nombre de colonnes du plateau de jeu
  columnsEntry.max_length = 2   # nombre maximum de caractere pour la saisie du nombre de colonnes

  columnsBox.add(enterNumberOfColumns)
  columnsBox.add(columnsEntry)

  #Message de prévention
  prevLabel = Gtk::Label.new("Si vos dimensions sortent des limites autorisées\n\t elles seront réajustées automatiquement")

  buttonsBox = Gtk::HBox.new

  #bouton retour
  back = Gtk::Button.new('retour')
  back.set_size_request 80, 35 

  backAlignment = Gtk::Alignment.new(0.5, 0.5, 0, 0)
  backAlignment.add(back)

  #bouton poursuivre
  continue = Gtk::Button.new('continuer')
  continue.set_size_request 80, 35 

  continueAlignment = Gtk::Alignment.new(0.5, 0.5, 0, 0)
  continueAlignment.add(continue)

  buttonsBox.add(backAlignment)
  buttonsBox.add(continueAlignment)
  
  $allBox.add(linesBox)
  $allBox.add(columnsBox)
  $allBox.add(prevLabel)
  $allBox.add(buttonsBox)


  $allBox.show_all

  back.signal_connect "clicked" do

    # On supprime tous les elements de la boite principale
    $allBox.remove(linesBox)
    $allBox.remove(columnsBox)
    $allBox.remove(prevLabel)
    $allBox.remove(buttonsBox)

    # On revient au menu principal
    menu(gameInformations)

  end

  continue.signal_connect "clicked" do
    if linesEntry.text == nil || linesEntry.text.to_s.to_i < 6 
      gameInformations[1] = 6 
    elsif linesEntry.text.to_s.to_i > 10
      gameInformations[1] = 10 
    else
      gameInformations[1] = linesEntry.text.to_s.to_i
    end
    if columnsEntry.text == nil || columnsEntry.text.to_s.to_i < 6 
      gameInformations[2] = 6 
    elsif columnsEntry.text.to_s.to_i > 10
      gameInformations[2] = 10 
    else
      gameInformations[2] = columnsEntry.text.to_s.to_i
    end
"""
    # Si la saisie d'au moins une des valeurs(nombre de lignes et/ou nombre de colonnes) est incorrecte
    if linesEntry.text[0] == nil || columnsEntry.text[0] == nil || linesEntry.text.to_s.to_i < 6 || linesEntry.text.to_s.to_i > 10 || columnsEntry.text.to_s.to_i < 6 || columnsEntry.text.to_s.to_i > 10 

      # On fait apparaitre une fenetre pop up qui affichera un message d'erreur prevu a cet effet
      errorLinesAndColumnsPopup = Gtk::Window.new(Gtk::Window::POPUP)
      errorLinesAndColumnsPopup.set_default_size(200, 150)  # Taille de la fenetre pop up
      errorLinesAndColumnsPopup.set_window_position :center # On la positionne au centre de l'ecran

      # Boite verticale qui contiendra dans l'ordre : un message d'erreur puis le bouton de validation
      errorVBox = Gtk::VBox.new

      # Label contenant le message d'erreur
      linesAndColumnsErrorValue = Gtk::Label.new('Navré ! La valeur saisie est incorrecte ! Veuillez recommencer')

      # Le bouton permettant de faire disparaitre la fenetre pop up pour corriger la saisie
      ok = Gtk::Button.new('OK')
      ok.set_size_request 80, 35 # Taille du bouton
      
      # Alignement du bouton au centre
      okAlignment = Gtk::Alignment.new(0.5, 0.5, 0, 0) 
      okAlignment.add(ok)

      # Ajout du Label(message d'erreur) puis du bouton, de maniere verticale dans une boite 
      errorVBox.add(linesAndColumnsErrorValue)
      errorVBox.add(okAlignment)

      # Ajout de la boite verticale a la fenetre pop up
      errorLinesAndColumnsPopup.add(errorVBox)

      # Affichage de la fenetre pop up et de tous ces 'enfants'
      errorLinesAndColumnsPopup.show_all

      # En cliquant sur le bouton 'OK', la fenetre pop up se fermera
      ok.signal_connect 'clicked' do

        errorLinesAndColumnsPopup.destroy

      end
     
    else"""
      # Sinon si la saisie des valeurs(lignes / colonnes) est bonne,     

      # On stock les 2 valeurs sous forme d'entiers dans notre tableau d'unformations permettant de créer le jeu
      #gameInformations[1] = linesEntry.text.to_s.to_i
      #gameInformations[2] = columnsEntry.text.to_s.to_i

      # On supprime tous les elements de la boite principale
    $allBox.remove(linesBox)
    $allBox.remove(columnsBox)
    $allBox.remove(prevLabel)
    $allBox.remove(buttonsBox)

      # Puis l'on passe a la phase suivante le choix du mode(joueur / IA)
      gameKind(gameInformations)

    #end

  end

end

# Choix du mode de jeu (contre humain/IA, avec/sans bonus)
def gameKind(gameInformations)

  playerVsPlayer = Gtk::RadioButton.new "JcJ (Joueur VS Joueur)" 

  playerVsPlayerAlignment = Gtk::Alignment.new(0.5, 0.5, 0, 0)
  playerVsPlayerAlignment.add(playerVsPlayer)

  $allBox.add(playerVsPlayerAlignment)


  playerVsIA = Gtk::RadioButton.new playerVsPlayer, "JcE (Joueur VS Intelligence artificielle)"
  
  playerVsIAAlignment = Gtk::Alignment.new(0.5, 0.5, 0, 0)
  playerVsIAAlignment.add(playerVsIA)

  $allBox.add(playerVsIAAlignment)

  bonusCheck = Gtk::CheckButton.new "Jouer avec bonus ?"

  bonusCheckAlignment = Gtk::Alignment.new(0.5, 0.5, 0, 0)
  bonusCheckAlignment.add(bonusCheck)

  $allBox.add(bonusCheckAlignment)

  # implementation du choix IA vs IA. Non implemente par manque de temps. 

  ''' #IAvsIA
     iAVsIA = Gtk::RadioButton.new button2, "Intelligence artificielle VS Intelligence artificielle"
     
     iAVsIAAlignment = Gtk::Alignment.new(0.5, 0.5, 0, 0)
     iAVsIAAlignment.add(iAVsIA)

     gameKindBox.add(iAVsIAAlignment)
''' #IAvsIA
  
  buttonPlayerHBox = Gtk::HBox.new

  #bouton retour
  back = Gtk::Button.new('retour')
  back.set_size_request 80, 35 

  backAlignment = Gtk::Alignment.new(0.5, 0.5, 0, 0)
  backAlignment.add(back)

  #bouton poursuivre
  continue = Gtk::Button.new('continuer')
  continue.set_size_request 80, 35 

  continueAlignment = Gtk::Alignment.new(0.5, 0.5, 0, 0)
  continueAlignment.add(continue)

  buttonPlayerHBox.add(backAlignment)
  buttonPlayerHBox.add(continueAlignment)

  $allBox.add(buttonPlayerHBox)

  $allBox.show_all

  back.signal_connect "clicked" do

    # On supprime tous les elements de notre boite principale
    $allBox.remove(playerVsPlayerAlignment)
    $allBox.remove(playerVsIAAlignment)
    $allBox.remove(bonusCheckAlignment)
    #IAvsIA gameKindBox.remove(iAVsIAAlignment)
    $allBox.remove(buttonPlayerHBox)

    # On revient au menu principal
    menu(gameInformations)

  end

  continue.signal_connect "clicked" do

    $allBox.remove(playerVsPlayerAlignment)
    $allBox.remove(playerVsIAAlignment)
    $allBox.remove(bonusCheckAlignment)
    #IAvsIA gameKindBox.remove(iAVsIAAlignment)
    $allBox.remove(buttonPlayerHBox)

    if playerVsPlayer.active? then

      gameInformations[5] = false
      gameInformations[6] = false
      choosePlayerName(1, gameInformations)

    else 
      #IAvsIA if playerVsIA.active? then

      gameInformations[5] = false
      gameInformations[6] = true
      choosePlayerName(1, gameInformations)

      ''' #IAvsIA
       else
         
         $gameInformations[5] = true
         $gameInformations[6] = true
         choosePlayerName(1, gameInformations)

       end
''' #IAvsIA

      # les parties commentées ' #IAvsIA ' ne sont pas utiles si on implemente pas l'affrontement de deux IA (de preference avec une
      # fonction "pas a pas" pour que l'utilisateur voie se derouler l'action au tour par tour 

    end
    $bonus = bonusCheck.active? 
  end
end

def choosePlayerName(countPlayerName, gameInformations)
  
  enterYourName = Gtk::Label.new("Joueur #{countPlayerName} veuillez saisir votre nom\n\t(maximum 30 caractères)")

  nameEntry = Gtk::Entry.new #Cree une nouvelle zone de texte pour saisir le nom du joueur
  nameEntry.max_length = 30 #nombre maximum de caractere pour la saisie du nom du joueur
  
  #bouton ok
  ok = Gtk::Button.new('OK')
  ok.set_size_request 80, 35 

  okFixed = Gtk::Fixed.new
  okFixed.put ok, 0.5, 0.5 

  okAlignment = Gtk::Alignment.new(0.5, 0.5, 0, 0)
  okAlignment.add(okFixed)
  
  $allBox.add(enterYourName)
  $allBox.add(nameEntry)
  $allBox.add(okAlignment)

  $allBox.show_all
  #puts countPlayerName
  
  ok.signal_connect "clicked" do

    #rajouter l'instruction pour conserver le nom saisi
    #(ajouter un player)
    gameInformations[countPlayerName + 2] = nameEntry.text

    $allBox.remove(enterYourName)
    $allBox.remove(nameEntry)
    $allBox.remove(okAlignment)

    countPlayerName += 1

    if countPlayerName <= 2

      #tant que tous les joueurs n'ont pas choisi leur nom,
      #on propose au joueur suivant de choisir le sien
      choosePlayerName(countPlayerName, gameInformations)

    else
    #sinon on passe a la phase de de selection des pions de chaque joueur

      enablesTokensArray = [true, true, true, true, true, true]

      chooseToken(1, gameInformations, enablesTokensArray)

    end

  end

end

#Chacun des joueurs va pouvoir choisir un pion (parmi ceux proposés)
def chooseToken(countPlayerName, gameInformations, enablesTokensArray)
  
  chooseYourToken = Gtk::Label.new("#{gameInformations[countPlayerName + 2]} veuillez choisir votre pion")

  # Creation des images des pions cliquables
  token1 = TokenChoice.new('./images/pion1.png')
  token2 = TokenChoice.new('./images/pion2.png')
  token3 = TokenChoice.new('./images/pion3.png')
  token4 = TokenChoice.new('./images/pion4.png')
  token5 = TokenChoice.new('./images/pion5.png')
  token6 = TokenChoice.new('./images/pion6.png')  

  tokenHBox1 = Gtk::HBox.new
  tokenHBox2 = Gtk::HBox.new

  # Uniquement les pions disponibles seront affiches
  if enablesTokensArray[0]
      tokenHBox1.add(token1)
  end

  if enablesTokensArray[1]
      tokenHBox1.add(token2)
  end

  if enablesTokensArray[2]
      tokenHBox1.add(token3)
  end

  if enablesTokensArray[3]
      tokenHBox2.add(token4)
  end

  if enablesTokensArray[4]
      tokenHBox2.add(token5)
  end

  if enablesTokensArray[5]
      tokenHBox2.add(token6)
  end

  $allBox.add(chooseYourToken)
  $allBox.add(tokenHBox1)
  $allBox.add(tokenHBox2)
  
  $allBox.show_all

  token1.signal_connect "button_press_event" do

    updateChooseToken(countPlayerName, gameInformations, enablesTokensArray, 0, token1, chooseYourToken, tokenHBox1, tokenHBox2)

  end

  token2.signal_connect "button_press_event" do

    updateChooseToken(countPlayerName, gameInformations, enablesTokensArray, 1, token2, chooseYourToken, tokenHBox1, tokenHBox2)

  end

  token3.signal_connect "button_press_event" do

    updateChooseToken(countPlayerName, gameInformations, enablesTokensArray, 2, token3, chooseYourToken, tokenHBox1, tokenHBox2)

  end

  token4.signal_connect "button_press_event" do

    updateChooseToken(countPlayerName, gameInformations, enablesTokensArray, 3, token4, chooseYourToken, tokenHBox1, tokenHBox2)

  end

  token5.signal_connect "button_press_event" do

    updateChooseToken(countPlayerName, gameInformations, enablesTokensArray, 4, token5, chooseYourToken, tokenHBox1, tokenHBox2)

  end

  token6.signal_connect "button_press_event" do

    updateChooseToken(countPlayerName, gameInformations, enablesTokensArray, 5, token6, chooseYourToken, tokenHBox1, tokenHBox2)

  end

end

# Met a jour la phase de selection du pion 
def updateChooseToken(countPlayerName, gameInformations, enablesTokensArray, indice, token, chooseYourToken, tokenHBox1, tokenHBox2)

  gameInformations[countPlayerName + 6] = token.picture_adress # On conserve l'adresse de l'image du pion choisi
  
  enablesTokensArray[indice] = false # Le pion n'est alors plus disponible pour le choix du prochain joueur

  $allBox.remove(chooseYourToken)
  $allBox.remove(tokenHBox1)
  $allBox.remove(tokenHBox2)

  countPlayerName += 1
      
  if countPlayerName <= gameInformations[0] # tant que tous les joueurs n'ont pas selectionne un pion, on passe au joueur suivant
    
    chooseToken(countPlayerName, gameInformations, enablesTokensArray)
    
  else # Sinon on passe a la phase de creation du jeu
    
    createGame(gameInformations)
    
  end

end

#Creation du jeu
def createGame(gameInformations)

  # On cree le jeu avec les informations collectees au prealable
  $game = GameController.new(gameInformations)

  # On passe a la phase de jeu
  game(gameInformations)

end

def game(gameInformations)

  # On recupere le nombre de lignes et de colonnes selectionnees au prealable
  lines = gameInformations[1]   
  columns = gameInformations[2]

  # On affichera sur trois lignes horizontales :
  $playerBox = Gtk::HBox.new # les informations concernant le joueur actuel
  $boardBox = Gtk::HBox.new  # l'etat du plateau de jeu

  if $bonus then
    $bonusListState = Gtk::Label.new("Vous n'avez aucun bonus") # represente l'etat de la liste des bonus du joueur courant
    $bonusBox = Gtk::HBox.new  # la liste des bonus du joueur actuel
  end
  $playerName = Gtk::Label.new($game.playersList[$game.current].pseudo.to_s)
  $playerToken = Gtk::Image.new($game.playersList[$game.current].pion.image)
  $order = Gtk::Label.new("Veuillez placer votre pion")
  $playerName.set_text($game.playersList[$game.current].pseudo.to_s)
  $catable = Gtk::Table.new(lines, columns)
  fixed = Gtk::Fixed.new
  alignement = Gtk::Alignment.new(0.5, 0.5, 0, 0)

  # On initialise graphiquement le plateau selon le nombre de lignes et de colonnes
  for i in 0..(lines - 1)
    for j in 0..(columns - 1)

      $catable.attach(GraphicCell.new(i, j), j, j+1, i, i+1)

    end
  end

  $playerBox.add($playerName)
  $playerBox.add($playerToken)

  fixed.put($catable, 0.5, 0.5)
  alignement.add(fixed)

  $boardBox.add(alignement)
  if $bonus then
    for i in 0..2
      $bonusBox.add($bonusArray[i])
    end
  end

  $allBox.add($playerBox)
  $allBox.add($order)
  $allBox.add($boardBox)
  if $bonus
    $allBox.add($bonusListState)
    $allBox.add($bonusBox)
  end
  $allBox.show_all
  if $bonus
    $bonusBox.hide_all
  end
end

def updateBonus
  if $bonus then
    #puts 'UPDATE BONUS!!'
    noBonus = true
    $allBox.show_all
    for i in 0..2
      if $game.playersList[$game.current].tableauBonus[i] then
        noBonus = false
        #puts $game.playersList[$game.current].tableauBonus[i]
        $bonusArray[i].show
      else
        $bonusArray[i].hide
      end
    end
    if noBonus then
      $bonusListState.set_text("Vous n'avez aucun bonus")
    else
      $bonusListState.set_text("Voici votre liste de bonus")
    end
  end
end

def initializeBonus
  if $bonus then
    for i in 0..2
      $bonusArray[i].activated = false
    end
  end
end

def endGamePopUp
  # Si le joueur a perdu, on affiche un pop up qui informe que la partie est finie et renvoie au menu
  if $game.playersList[$game.current-1].canPlay && !$game.playersList[$game.current].canPlay || !$game.playersList[$game.current].canPlay

    endWindow = Gtk::Window.new(Gtk::Window::POPUP)
    endWindow.set_default_size(200, 150)
    endWindow.set_window_position :center
    
    vbox = Gtk::VBox.new
    
    label = Gtk::Label.new($game.playersList[$game.current].pseudo.to_s+" a perdu !")
    
    endOfGameButton = Gtk::Button.new('Retour au menu principal')
    endOfGameButton.set_size_request 180, 35 
    
    endOfGameButtonAlignment = Gtk::Alignment.new(0.5, 0.5, 0, 0)
    endOfGameButtonAlignment.add(endOfGameButton)
    
    vbox.add(label)
    vbox.add(endOfGameButtonAlignment)
    
    endWindow.add(vbox)
    
    endWindow.show_all
    
    # Lorsque l'on clique sur le bouton de fin de jeu
    endOfGameButton.signal_connect "clicked" do
      
      $endOfProgramm = false # On ne compte pas quitter definitivement le programme -> 'false'
      
      endWindow.destroy # On ferme la fenetre pop up de fin de partie
      $window.destroy   # On ferme la fenetre du plateau de jeu
      
      main # On revient au menu principal
      
    end

  end
  
end  

#affichage des regles du jeu
def displayRules(gameInformations)
  
  # On ouvre et on lit le fichier texte contenant les regles du jeu
  file = File.open("rules.txt", "r")
  rules = file.read

  rulesText = Gtk::TextView.new # Cree une nouvelle zone de texte dans laquelle sera affiche le fichier avec les regles
  rulesText.editable = false    # La zone de texte n'est pas modifiable
  rulesText.buffer.text = rules # Ecriture du fichier texte dans la zone de texte
  
  file.close

  # Bouton fermant les regles du jeu
  closeRules = Gtk::Button.new('Fermer')
  closeRules.set_size_request 80, 35 

  closeRulesAlignment = Gtk::Alignment.new(0.5, 0.5, 0, 0)
  closeRulesAlignment.add(closeRules)

  $allBox.add(rulesText)
  $allBox.add(closeRulesAlignment)

  $allBox.show_all

  closeRules.signal_connect "clicked" do

    $allBox.remove(rulesText)
    $allBox.remove(closeRulesAlignment)
    menu(gameInformations)

  end

end

# Passer la vertical box en parametre est necessaire, sans quoi aucun affichage ne sera effectue dans la fenetre
def leave(leaveBox, gameInformations)
  
  # Affiche la proposition de quitter le programme
  leaveQuestion = Gtk::Label.new('etes-vous certain de vouloir quitter le jeu?')

  # Pour contenir de maniere horizontale les bouton 'oui' et 'non' 
  leaveButtons = Gtk::HBox.new

  # Bouton 'oui'
  leave = Gtk::Button.new('Oui')
  leave.set_size_request 80, 35 

  leaveAlignment = Gtk::Alignment.new(0.5, 0.5, 0, 0)
  leaveAlignment.add(leave)

  # Bouton 'non'
  notLeave = Gtk::Button.new('Non')
  notLeave.set_size_request 80, 35  

  notLeaveAlignment = Gtk::Alignment.new(0.5, 0.5, 0, 0)
  notLeaveAlignment.add(notLeave)

  # On place les boutons 'oui' et 'non' dans la boite horizontale
  leaveButtons.add(leaveAlignment)
  leaveButtons.add(notLeaveAlignment)

  leaveBox.add(leaveQuestion)
  leaveBox.add(leaveButtons)

  leaveBox.show_all

  # Lorsque l'on clique sur le bouton 'oui'
  leave.signal_connect "clicked" do

    Gtk.main_quit

  end

  # Lorsque l'on clique sur le bouton 'non'
  notLeave.signal_connect "clicked" do

    # On supprime tous les elements de la boite verticale principale
    leaveBox.remove(leaveQuestion)
    leaveBox.remove(leaveButtons)

    menu(gameInformations) # Afin d'y reafficher le menu principal

  end

end

# On appel la premiere fonction qui permet de lancer le programme
main

Gtk.main
