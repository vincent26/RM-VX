module Equip_Value
  
  #Texte
  COMMAND_CHANGE_EQUIP = "Equipment"  #Nom de la commande changement d'équipement
  COMMAND_OPTIMIZATION = "Optimiser"   #Nom de la commande optimisation
  COMMAND_CLEAR_EQUIP = "Tout_enlever" #Nom de la commande tout enlever
  #Vue dans la help box :
  C_CHE_DESC = "Choix de l'équipement au cas par cas" #Description de la commande Changement d'équipement
  C_O_DESC = "Optimisation de l'équipement"  #Description de la commande optimisation
  C_CLE_DESC = "Retire tout l'équipement"  #Description de la commande tout enlever
  
  #Image
  BACK_COMMANDE = "test1" #Image de fond lors du choix de la commande
  BACK_EQUIP = "test2"            #Image de fond lors du choix de l'emlacement sur le héros
  BACK_STATUS = "test3"         #Image de fond lors du choix de l'item de remplacement (vue du status)
  PERSO_BACK = ["carte","carte_1","carte","carte_1"] #image derriere le selcteur d'emplacement qui represente le perso mettre le nom des images dans l'ordre des héros de la bdd
  
  #Son (SE)
  VALIDATION = "Decision1"  #Son pour le choix dans les commande et de l'item
  RETOUR = "Cancel"   #son de retour
  ASSIGNATION = "Equip" #son d'assignation d'équipement
  CHANGEMENT_PERSO = "Switch1" #son de changement de perso
  IMPOSSIBILITER = "Buzzer1" #son d'impossibiliter d'equiper un item
  
  #Position window
  #NAME = [x,y]
  EQUIPEMENT = [420,235] #window avec le nom des emplacement et le nom des arme
  COMMANDE = [423,48]      #Window avec les commande opimiser et tout enlever
  
  
  #Position objet ( avec 16 en moins car 0,0 dans une window = 16,16 sur l'écran)
  #NAME = [x,y]
  #Window_Equipement
  #Ajustement des emplacement arme/armure
  #mettre autant de coordonnée que d'emplacement d'équipement
  #sous la forme [x,y],     !!!!! ne surtout pas oublier la virgule aprés le crochet !!!!!
  #faire un retour a la ligne pour chaque emplacement
  POS_EQUIP =[
                              [86,68] ,#position de l'emplacement armure 1
                              [27,135], #position de l'emplacement armure 2
                              [104,152], #position de l'emplacement armure 3
                              [174,186],
                              [19,241],
                              [174,241],
                              [104,307],
                              [27,363],
                              [211,380],
                              [211,434],
                              ] #<<== ne pas supprimer
  
  POS_FACE = [267,29] #Position de la face du héros
  POS_NAME = [267,47] #Position du nom du héros
  #Window_Status
  POS_NAME_OLD = [5,109] #Position du nom de l'ancienne arme/armure
  POS_NAME_NEW = [27,133]#position du nom de la nouvelle arme/armure
  POS_CAR_OLD = [123,159]#Position ancien caractéristique
  POS_CAR_NEW = [193, 159]#Position nouveaux caractéristique
  POS_PERSO_BACK = [0,0] #position de l'image de fond du perso
    
  #Taille et police
  SIZE_COMMAND = 30                     #Taille du texte de la partie commande
  SIZE_PERSO_NAME = 20               #Taille du nom du personnage
  POLICE_COMMANDE = "Arial"       #Police des commande
  POLICE_PERSO_NAME = "Arial"   #Police du nom du personnage
  POLICE_ITEM_NAME = "Arial"        #Police du nom des items
  #Si une Police n'est pas trouver (ou n'existe pas) elle est remplacer par celle de base "Verdana"
  
  #Modification inventaire
  NBR_MORCEAUX_ARMURE = 10 #nombre de morceaux d'armure (en comptant le ouclier,le tors,le casque, et l'accesoire)
  #Ajouter  <Armure = ID> dans les note d'une armure pour lui définir son emplacement
  #ID et l'emplacement : (ne rien mettre utilise la définition de base (armure,bouclier,casque et accessoire))
  #Pour toi
  #0  -> Casque
  #1  -> Epaule
  #2  -> Armure
  #3  -> Gant
  #4  -> Arme droite
  #5  -> Arme gauche
  #6  -> Jambiere
  #7  -> Botte
  #8  -> Accessoire 1
  #9  -> Accessoire 2
  #10 -> Item assignable au 2 emplacement accessoire
 
  #      <Armure = ID>
 
  EMPLACEMENT_ARME_1 = 5
  EMPLACEMENT_ARME_2 = 6
  EMPLACEMENT_CASQUE = 1
  EMPLACEMENT_TORSE = 3
  EMPLACEMENT_ACCESSOIRE = 9
end
#==============================================================================
# ** Scene_Equip
#------------------------------------------------------------------------------
#  This class performs the equipment screen processing.
#==============================================================================
 
class Scene_Equip < Scene_Base
  include Equip_Value
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     actor_index : actor index
  #     equip_index : equipment index
  #--------------------------------------------------------------------------
  def initialize(actor_index = 0, equip_index = 0)
    @actor_index = actor_index
    @equip_index = equip_index
  end
  #--------------------------------------------------------------------------
  # * Start processing
  #--------------------------------------------------------------------------
  def start
    super
    create_menu_background
    @actor = $game_party.members[@actor_index]
    create_perso_back
    @help_window = Window_Help.new
    @help_window.opacity = 0
    @help_window.contents.font.size = 18 
    @help_window.contents.font.bold = true
    create_item_windows
    @equip_window = Window_Equip.new(EQUIPEMENT[0], EQUIPEMENT[1], @actor)
    @equip_window2 = Window_Equip2.new(0, 0, @actor)
    @equip_window2.active = false #true
    @equip_window2.opacity = 0
    @equip_window.active = false
    @equip_window.opacity = 0
    @equip_window.help_window = @help_window
    @equip_window.index = @equip_index
    @status_window = Window_EquipStatus.new(0, 0, @actor)
    @status_window.opacity = 0
    @status_window.hide
    @sous_menu_window = Window_Equip_Commande.new(COMMANDE[0],COMMANDE[1])
    @sous_menu_window.opacity = 0
    @sous_menu_window.active = true
    @sous_menu_window.help_window = @help_window
  end
  
  #--------------------------------------------------------------------------
  # * Creation du background
  #--------------------------------------------------------------------------
  def create_menu_background
    @menuback_sprite = Sprite.new
    @menuback_sprite.bitmap = Cache.picture(BACK_COMMANDE)
    @menuback_sprite.z = -2
    update_menu_background
  end
  
  def create_perso_back
    @persoback_sprite = Sprite.new
    @persoback_sprite.bitmap = Cache.picture(PERSO_BACK[@actor.id-1])
    @persoback_sprite.z = -1
  end
  
  #--------------------------------------------------------------------------
  # * Changement du background
  #--------------------------------------------------------------------------
  def change_background(name)
    @menuback_sprite.bitmap = Cache.picture(name)
  end
  #--------------------------------------------------------------------------
  # * Termination Processing
  #--------------------------------------------------------------------------
  def terminate
    super
    dispose_menu_background
    @help_window.dispose
    @equip_window.dispose
    @equip_window2.dispose
    @status_window.dispose
    @sous_menu_window.dispose
    @persoback_sprite.dispose
    dispose_item_windows
  end
  #--------------------------------------------------------------------------
  # * Return to Original Screen
  #--------------------------------------------------------------------------
  def return_scene
    $scene = Scene_Menu.new(2)
  end
  #--------------------------------------------------------------------------
  # * Switch to Next Actor Screen
  #--------------------------------------------------------------------------
  def next_actor
    @actor_index += 1
    @actor_index %= $game_party.members.size
    $scene = Scene_Equip.new(@actor_index, @equip_window.index)
  end
  #--------------------------------------------------------------------------
  # * Switch to Previous Actor Screen
  #--------------------------------------------------------------------------
  def prev_actor
    @actor_index += $game_party.members.size - 1
    @actor_index %= $game_party.members.size
    $scene = Scene_Equip.new(@actor_index, @equip_window.index)
  end
  #--------------------------------------------------------------------------
  # * Update Frame
  #--------------------------------------------------------------------------
  def update
    super
    update_menu_background
    @help_window.update
    update_equip_window
    update_status_window if !@sous_menu_window.active
    update_item_windows if !@sous_menu_window.active
    if @sous_menu_window.active
      update_command_selection
    else
      if @equip_window.active
        update_equip_selection
      elsif @item_window.active
        update_item_selection
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Create Item Window
  #--------------------------------------------------------------------------
  def create_item_windows
    @item_windows = []
    for i in 0..NBR_MORCEAUX_ARMURE-1
      @item_windows[i] = Window_EquipItem.new(423, 46, 232, 180, @actor, i)
      @item_windows[i].opacity = 0
      @item_windows[i].help_window = @help_window
      @item_windows[i].visible = false #(@equip_index == i)
      @item_windows[i].active = false
      @item_windows[i].index = -1
    end
  end
  
  #--------------------------------------------------------------------------
  # * Commande optimisation
  #--------------------------------------------------------------------------
  def command_optimize
    Sound.play_decision
    @actor.optimize_equipments
    @status_window.refresh
    @equip_window.refresh
    @equip_window2.refresh
    for item_window in @item_windows
        item_window.refresh
    end
  end
  #--------------------------------------------------------------------------
  # * [Remove All] Command
  #--------------------------------------------------------------------------
  def command_clear
    Sound.play_decision
    @actor.clear_equipments
    @status_window.refresh
    @equip_window.refresh
    @equip_window2.refresh
    for item_window in @item_windows
        item_window.refresh
    end
  end
  
  #--------------------------------------------------------------------------
  # * Dispose of Item Window
  #--------------------------------------------------------------------------
  def dispose_item_windows
    for window in @item_windows
      window.dispose
    end
  end
  #--------------------------------------------------------------------------
  # * Update Item Window
  #--------------------------------------------------------------------------
  def update_item_windows
    for i in 0..NBR_MORCEAUX_ARMURE-1
      @item_windows[i].visible = (@equip_window.index == i)
      @item_windows[i].update
    end
    @item_window = @item_windows[@equip_window.index]
  end
  #--------------------------------------------------------------------------
  # * Update Equipment Window
  #--------------------------------------------------------------------------
  def update_equip_window
    @equip_window.update
    @equip_window2.update
  end
  #--------------------------------------------------------------------------
  # * Update Status Window
  #--------------------------------------------------------------------------
  def update_status_window
    if @equip_window.active
      @status_window.set_new_parameters(nil, nil, nil, nil,nil,nil,nil,nil,nil)
    elsif @item_window.active
      temp_actor =  Game_Actor.new(@actor.actor_id)
      temp_actor.armor_id = @actor.armor_id.clone
      temp_actor.change_equip(@equip_window.index, @item_window.item, true)
      new_atk = temp_actor.atk
      new_def = temp_actor.def
      new_spi = temp_actor.spi
      new_agi = temp_actor.agi
      new_hit  = temp_actor.hit
      new_eva = temp_actor.eva
      new_cri = temp_actor.cri
      @status_window.set_new_parameters(new_atk, new_def, new_spi, new_agi,new_hit,new_eva,new_cri,@actor.equips[@equip_window.index],@item_window.item)
    end
    @status_window.update
  end
  
  #--------------------------------------------------------------------------
  # * Update Equip cmmande selection
  #--------------------------------------------------------------------------
  def update_command_selection
    @sous_menu_window.update
    if Input.trigger?(Input::B)
      Audio.se_play("Audio/SE/" + RETOUR, 80, 100)
      return_scene
    elsif Input.trigger?(Input::R)
      Audio.se_play("Audio/SE/" + CHANGEMENT_PERSO, 80, 100)
      next_actor
    elsif Input.trigger?(Input::L)
      Audio.se_play("Audio/SE/" + CHANGEMENT_PERSO, 80, 100)
      prev_actor
    elsif Input.trigger?(Input::C)
      if @sous_menu_window.index == 0
        Audio.se_play("Audio/SE/" + VALIDATION, 80, 100)
        @equip_window.active = true
        @equip_window2.active = true
        for i in 0...NBR_MORCEAUX_ARMURE-1
          @item_windows[i].visible = (@equip_index == i)
        end
        @sous_menu_window.active = false
        @sous_menu_window.hide
        change_background(BACK_EQUIP)
      elsif @sous_menu_window.index == 1
        Audio.se_play("Audio/SE/" + ASSIGNATION, 80, 100)
        command_optimize
      else
        Audio.se_play("Audio/SE/" + ASSIGNATION, 80, 100)
        command_clear
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Update Equip Region Selection
  #--------------------------------------------------------------------------
  def update_equip_selection
    if Input.trigger?(Input::B)
      Audio.se_play("Audio/SE/" + RETOUR, 80, 100)
      @sous_menu_window.show
      @sous_menu_window.active = true
      for window in @item_windows
        window.hide
      end
      @equip_window.active = false
      @equip_window2.active = false
      change_background(BACK_COMMANDE)
    elsif Input.trigger?(Input::R)
      Audio.se_play("Audio/SE/" + CHANGEMENT_PERSO, 80, 100)
      next_actor
    elsif Input.trigger?(Input::L)
      Audio.se_play("Audio/SE/" + CHANGEMENT_PERSO, 80, 100)
      prev_actor
    elsif Input.trigger?(Input::C)
      if @actor.fix_equipment
        Audio.se_play("Audio/SE/" + IMPOSSIBILITER, 80, 100)
      else
        Audio.se_play("Audio/SE/" + VALIDATION, 80, 100)
        @equip_window.active = false
        @equip_window2.active = false
        @equip_window2.hide
        change_background(BACK_STATUS)
        @persoback_sprite.opacity = 0
        @status_window.show
        @item_window.active = true
        @item_window.index = 0
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Update Item Selection
  #--------------------------------------------------------------------------
  def update_item_selection
    if Input.trigger?(Input::B)
      Audio.se_play("Audio/SE/" + RETOUR, 80, 100)
      @equip_window.active = true
      @equip_window2.active = true
      @equip_window2.show
      @equip_window2.refresh
      change_background(BACK_EQUIP)
      @persoback_sprite.opacity = 255
      @status_window.hide
      @item_window.active = false
      @item_window.index = -1
    elsif Input.trigger?(Input::C)
      Audio.se_play("Audio/SE/" + ASSIGNATION, 80, 100)
      @actor.change_equip(@equip_window.index, @item_window.item)
      @equip_window.active = true
      @equip_window2.active = true
      @equip_window2.show
      @equip_window2.refresh
      change_background(BACK_EQUIP)
      @persoback_sprite.opacity = 255
      @status_window.hide
      @item_window.active = false
      @item_window.index = -1
      @equip_window.refresh
      for item_window in @item_windows
        item_window.refresh
      end
    end
  end
end
 
#==============================================================================
# ** Game_Actor  [AJOUT]
#------------------------------------------------------------------------------
#  Ajoute la commande d'optimisation d'inventaire et de déséquipement et augmentation inventaire
#==============================================================================
class Game_Actor < Game_Battler
  include Equip_Value
  
  attr_accessor :armor_id
  attr_reader :actor_id
  
  #--------------------------------------------------------------------------
  # * Setup
  #     actor_id : actor ID
  #--------------------------------------------------------------------------
  alias setup_menu_equipement_vincent setup
  def setup(actor_id) ######################################
    setup_menu_equipement_vincent(actor_id)
 
    @armor_id = Array.new(NBR_MORCEAUX_ARMURE,0)
    @armor_id[EMPLACEMENT_ARME_1-1] = actor.weapon_id
    @armor_id[EMPLACEMENT_ARME_2-1] = actor.armor1_id
    @armor_id[EMPLACEMENT_CASQUE-1] = actor.armor2_id
    @armor_id[EMPLACEMENT_TORSE-1] = actor.armor3_id
    @armor_id[EMPLACEMENT_ACCESSOIRE-1] = actor.armor4_id
    
  end
  #--------------------------------------------------------------------------
  # * Get Armor Object Array
  #--------------------------------------------------------------------------
  def armors ####################################
    result = []
    unless two_swords_style
      result.push($data_armors[@armor_id[EMPLACEMENT_ARME_2-1]])
    end
     for i in 0..@armor_id.length-1
       next if i == EMPLACEMENT_ARME_1-1
       next if i == EMPLACEMENT_ARME_2-1
       result.push($data_armors[@armor_id[i]])
    end
    return result
  end
  #--------------------------------------------------------------------------
  # * Change Equipment (designate object)
  #     equip_type : Equip region (0..9)
  #     item       : Weapon or armor (nil is used to unequip)
  #     test       : Test flag (for battle test or temporary equipment)
  #--------------------------------------------------------------------------
  def change_equip(equip_type, item, test = false)
    last_item = equips[equip_type]
    unless test
      return if $game_party.item_number(item) == 0 if item != nil
      $game_party.gain_item(last_item, 1)
      $game_party.lose_item(item, 1)
    end
    item_id = item == nil ? 0 : item.id
    if equip_type == EMPLACEMENT_ARME_1-1  # Weapon
      @weapon_id = item_id
      unless two_hands_legal?             # If two hands is not allowed
        change_equip(EMPLACEMENT_ARME_2-1, nil, test)        # Unequip from other hand
      end
    elsif equip_type == EMPLACEMENT_ARME_2-1  # Shield
      @armor1_id = item_id
      unless two_hands_legal?             # If two hands is not allowed
        change_equip(EMPLACEMENT_ARME_1-1, nil, test)        # Unequip from other hand
      end
    elsif equip_type == EMPLACEMENT_CASQUE-1
      @armor2_id = item_id
    elsif equip_type == EMPLACEMENT_TORSE-1
      @armor3_id = item_id
    elsif equip_type == EMPLACEMENT_ACCESSOIRE-1
      @armor4_id = item_id
    end
    @armor_id[equip_type] = item_id
  end
  #--------------------------------------------------------------------------
  # * Discard Equipment
  #     item : Weapon or armor to be discarded.
  #    Used when the "Include Equipment" option is enabled.
  #--------------------------------------------------------------------------
  def discard_equip(item)
    if item.is_a?(RPG::Weapon)
      if @weapon_id == item.id
        @weapon_id = 0
        @armor_id[EMPLACEMENT_ARME_1-1] = 0
      elsif two_swords_style and @armor1_id == item.id
        @armor1_id = 0
        @armor_id[EMPLACEMENT_ARME_2-1] = 0
      end
    elsif item.is_a?(RPG::Armor)
      if not two_swords_style and @armor1_id == item.id
        @armor1_id = 0
        @armor_id[EMPLACEMENT_ARME_2-1] = 0
      elsif @armor2_id == item.id
        @armor2_id = 0
        @armor_id[EMPLACEMENT_CASQUE-1] = 0
      elsif @armor3_id == item.id
        @armor3_id = 0
        @armor_id[EMPLACEMENT_TORSE-1] = 0
      elsif @armor4_id == item.id
        @armor4_id = 0
        @armor_id[EMPLACEMENT_ACCESSOIRE-1] = 0
      else
        for i in  0..@armor_id.length-1
          @armor_id[i] = 0 if @armor_id[i] == item.id
        end
      end
    end
  end
 
  def class_id=(class_id)
    @class_id = class_id
    for i in 0..NBR_MORCEAUX_ARMURE-1     # Remove unequippable items
      change_equip(i, nil) unless equippable?(equips[i])
    end
  end
  
  #--------------------------------------------------------------------------
  # * Get Equipped Item Object Array
  #--------------------------------------------------------------------------
  def equips
    return create_equips_list
  end
  
  def create_equips_list
    result = Array.new(NBR_MORCEAUX_ARMURE,nil)
    for i in 0..@armor_id.length-1
      result[i] =  $data_armors[@armor_id[i]]
      result[i] =  $data_weapons[@armor_id[i]] if i == EMPLACEMENT_ARME_1-1
      result[i] =  $data_weapons[@armor_id[i]] if  i == EMPLACEMENT_ARME_2-1 && two_swords_style
    end
    return result
  end
  
  #--------------------------------------------------------------------------
  # * Commande de vidage équipement
  #--------------------------------------------------------------------------
  def clear_equipments
    equips.size.times do |i|
      change_equip(i, nil)
    end
  end
  
  #--------------------------------------------------------------------------
  # * Commande d'optimisation d'équipement
  #--------------------------------------------------------------------------
  def optimize_equipments
      clear_equipments
      equips.size.times do |i|
        items = $game_party.items.select do |item|
          if item.is_a?(RPG::Weapon)
            EMPLACEMENT_ARME_1-1 == i-1 &&
            equippable?(item) && performance(item) >= 0
          elsif item.is_a?(RPG::Armor)
             if item.note =~ /<Armure = (\d+)>/
              armure = $1.to_i
              if armure == 10
                if i-1 == 8 || i-1 == 9
                  armure = i-1
                end
              end
            elsif item.kind == 0
              armure = EMPLACEMENT_ARME_2-1
            elsif item.kind == 1
              armure = EMPLACEMENT_CASQUE-1
            elsif item.kind == 2
              armure = EMPLACEMENT_TORSE-1
            elsif item.kind == 3
              armure = EMPLACEMENT_ACCESSOIRE-1
            end
            armure == i - 1 &&
            equippable?(item) && performance(item) >= 0
          end
        end
        @tab = [0]
        for j in 0..items.length-1
          if weapons[0] != nil
            if i-1 == EMPLACEMENT_ARME_2-1&&weapons[0].two_handed
              @tab.push(performance(items[j])-performance(weapons[0]))
            else
              @tab.push(performance(items[j]))
            end
          else
            @tab.push(performance(items[j]))
          end
        end
        change_equip(i-1, items[@tab.index(@tab.max)-1]) if @tab.max > 0
        change_equip(i-1, nil) if @tab.max <= 0
      end
    end
    
  #--------------------------------------------------------------------------
  # * Commande d'assignation d'un score a un équipement
  #--------------------------------------------------------------------------
    def performance(item)
      return 0 if item == nil
      return item.atk+item.def+item.agi+item.spi
    end
end
#==============================================================================
# ** Window_Base  [AJOUT]
#------------------------------------------------------------------------------
#  Ajout de la commande show et hide au window (plus simple a gerer)
#==============================================================================
class Window_Base < Window
  #--------------------------------------------------------------------------
  # * Commande Show
  #--------------------------------------------------------------------------
  def show
    self.visible = true
    self
  end
  #--------------------------------------------------------------------------
  # * Commande Hide
  #--------------------------------------------------------------------------
  def hide
    self.visible = false
    self
  end
end
 
#==============================================================================
# ** Window_Equip_Commande
#------------------------------------------------------------------------------
#  Commande associer au menu équipement (changer equipement,optimiser,tout enlever)
#==============================================================================
class Window_Equip_Commande < Window_Selectable
  
  include Equip_Value
  WLH = SIZE_COMMAND
  WLH2 = 38
  
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     x     : window X coordinate
  #     y     : window Y corrdinate
  #--------------------------------------------------------------------------
  def initialize(x, y)
    super(x, y-(WLH-34)/2, 232, WLH2 * 10 + 32)
    refresh
    self.index = 0
  end
  #--------------------------------------------------------------------------
  # * Get Item
  #--------------------------------------------------------------------------
  def item
    return @data[self.index]
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    @data = [COMMAND_CHANGE_EQUIP,COMMAND_OPTIMIZATION,  COMMAND_CLEAR_EQUIP]
    @item_max = @data.size
    self.contents.font.color = system_color
    self.contents.font.size = WLH-2
    self.contents.font.name  = [POLICE_COMMANDE,"Verdana"]
    self.contents.font.bold = true
    self.contents.font.color = normal_color
    self.contents.draw_text(0, 0, self.width-32, WLH, @data[0])
    self.contents.draw_text(0,  WLH2, self.width-32, WLH, @data[1])
    self.contents.draw_text(0,  WLH2*2, self.width-32, WLH, @data[2])
  end
  
  #--------------------------------------------------------------------------
  # * Item rect
  #--------------------------------------------------------------------------
  def item_rect(index)
    rect = Rect.new(0, 0, 0, 0)
    rect.width = (contents.width + @spacing) / @column_max - @spacing
    rect.height = WLH+2
    rect.x = index % @column_max * (rect.width + @spacing)
    rect.y = index / @column_max * WLH2
    return rect
  end
  
  #--------------------------------------------------------------------------
  # * Update Help Text
  #--------------------------------------------------------------------------
  def update_help
    @help_window.set_text(C_CHE_DESC) if self.index == 0
    @help_window.set_text(C_O_DESC) if self.index == 1
    @help_window.set_text(C_CLE_DESC) if self.index == 2
  end
end

#==============================================================================
# ** Window_Equip
#------------------------------------------------------------------------------
#  This window displays items the actor is currently equipped with on the
# equipment screen.
#==============================================================================
class Window_Equip < Window_Selectable
  
  include Equip_Value
  WLH = 19
  WLH2 = 23  
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     x     : window X coordinate
  #     y     : window Y corrdinate
  #     actor : actor
  #--------------------------------------------------------------------------
  def initialize(x, y, actor)
    super(x, y, 200, WLH2 * 11 + 32)
    @actor = actor
    refresh
    self.index = 0
  end
  #--------------------------------------------------------------------------
  # * Get Item
  #--------------------------------------------------------------------------
  def item
    return @data[self.index]
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    @data = @actor.equips
    @item_max = @data.length
    self.contents.font.color = system_color
    for i in 0..@data.length-1
      draw_item_name(@data[i], 4, WLH2 * i)
    end
  end
  
  #--------------------------------------------------------------------------
  # * Item rect
  #--------------------------------------------------------------------------
  def item_rect(index)
    rect = Rect.new(0, 0, 0, 0)
    rect.width = (contents.width + @spacing) / @column_max - @spacing
    rect.height = WLH
    rect.x = index % @column_max * (rect.width + @spacing)
    rect.y = index / @column_max * WLH2
    return rect
  end
  
  #--------------------------------------------------------------------------
  # * Dessin du nom d'un item
  #--------------------------------------------------------------------------
  def draw_item_name(item,x,y, enabled = true)
    if item != nil
      self.contents.font.name  = [POLICE_ITEM_NAME,"Verdana"]
      self.contents.font.size = WLH-2
      self.contents.font.bold = true
      self.contents.font.color = normal_color
      self.contents.font.color.alpha = enabled ? 255 : 128
      self.contents.draw_text(x, y, self.width-32, WLH, item.name)
    end
  end
  
  #--------------------------------------------------------------------------
  # * Update Help Text
  #--------------------------------------------------------------------------
  def update_help
    @help_window.set_text(item == nil ? "" : item.description)
  end
end

#==============================================================================
# ** Window_Equip2
#------------------------------------------------------------------------------
#  Cretion des icone selectionable pour l'équipement
#==============================================================================
class Window_Equip2 < Window_Selectable
  
  include Equip_Value
  WLH = 20
  WLH2 = 24
  
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     x     : window X coordinate
  #     y     : window Y corrdinate
  #     actor : actor
  #--------------------------------------------------------------------------
  def initialize(x, y, actor)
    super(x, y, 640, 480)
    @actor = actor
    refresh
    self.index = 0
  end
  #--------------------------------------------------------------------------
  # * Get Item
  #--------------------------------------------------------------------------
  def item
    return @data[self.index]
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    @data = @actor.equips
    @item_max = @data.length
    for i in 0..@data.length-1
      if @data[i] != nil
        y = item_rect(i).y + item_rect(i).height/2-12
        x = item_rect(i).x + item_rect(i).width/2-12
        draw_icon(@data[i].icon_index,x, y, true)
      end
    end
    draw_actor_face(@actor, POS_FACE[0], POS_FACE[1])
    self.contents.font.name  = [POLICE_PERSO_NAME,"Verdana"]
    self.contents.font.bold = true
    self.contents.font.color = hp_color(@actor)
    self.contents.font.size = SIZE_PERSO_NAME
    self.contents.draw_text(POS_NAME[0], POS_NAME[1], 96, 30, @actor.name)
    self.contents.font.size = WLH-2
  end
  
  #--------------------------------------------------------------------------
  # * Item rect
  #--------------------------------------------------------------------------
  def item_rect(index)
    rec =  Rect.new(POS_EQUIP[index][0], POS_EQUIP[index][1], 30, 30) if index < POS_EQUIP.length
    rec =  Rect.new( 0, 0, 30, 30)  if index >= POS_EQUIP.length
    rec.width = 35
    rec.height = 34
    rec.x -= 16
    rec.y -= 16
    return rec
  end
  
  #--------------------------------------------------------------------------
  # * Update Help Text
  #--------------------------------------------------------------------------
  def update_help
    @help_window.set_text(item == nil ? "" : item.description)
  end
end
 
#==============================================================================
# ** Window_EquipItem
#------------------------------------------------------------------------------
#  This window displays choices when opting to change equipment on the
# equipment screen.
#==============================================================================
 
class Window_EquipItem < Window_Item
  
  include Equip_Value
  WLH = 20
  WLH2 = 24
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     x          : sindow X coordinate
  #     y          : sindow Y corrdinate
  #     width      : sindow width
  #     height     : sindow height
  #     actor      : actor
  #     equip_type : equip region (0-4)
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height, actor, equip_type) 
    @actor = actor
    if equip_type == EMPLACEMENT_ARME_2-1 and actor.two_swords_style
      equip_type = EMPLACEMENT_ARME_1-1                              # Change shield to weapon
    end
    @equip_type = equip_type
    super(x, y, width, height)
    @column_max = 1
    refresh
  end
  #--------------------------------------------------------------------------
  # * Whether to include item in list
  #     item : item
  #--------------------------------------------------------------------------
  def include?(item)
    return true if item == nil
    if @equip_type == EMPLACEMENT_ARME_1-1
      return false unless item.is_a?(RPG::Weapon)
    else
      return false unless item.is_a?(RPG::Armor)
      if item.note =~ /<Armure = (\d+)>/
        armure = $1.to_i
        if armure == 10
          if @equip_type ==  9 || @equip_type ==  8
            armure = @equip_type
          end
        end
      else
        armure = -1
        armure = EMPLACEMENT_ARME_2-1 if item.kind == 0
        armure = EMPLACEMENT_CASQUE-1 if item.kind == 1
        armure = EMPLACEMENT_TORSE-1 if item.kind == 2
        armure = EMPLACEMENT_ACCESSOIRE-1 if item.kind == 3
      end
      return false if (armure != @equip_type )
    end
    return @actor.equippable?(item)
  end
  
  #--------------------------------------------------------------------------
  # * Item rect
  #--------------------------------------------------------------------------
  def item_rect(index)
    rect = Rect.new(0, 0, 0, 0)
    rect.width = (contents.width + @spacing) / @column_max - @spacing
    rect.height = WLH
    rect.x = index % @column_max * (rect.width + @spacing)
    rect.y = index / @column_max * WLH2+5
    return rect
  end
  
  #--------------------------------------------------------------------------
  # * dessin d'un nom d'item
  #--------------------------------------------------------------------------
  def draw_item_name(item,x,y, enabled = true)
    if item != nil
      draw_icon(item.icon_index, x, y-2, enabled)
      self.contents.font.name  = [POLICE_ITEM_NAME,"Verdana"]
      self.contents.font.size = 18
      self.contents.font.bold = true
      self.contents.font.color = normal_color
      self.contents.font.color.alpha = enabled ? 255 : 128
      self.contents.draw_text(x + 24, y, self.width-32, WLH, item.name)
    end
  end
  
  #--------------------------------------------------------------------------
  # * dessin d'un item
  #--------------------------------------------------------------------------
  def draw_item(index)
    rect = item_rect(index)
    self.contents.clear_rect(rect)
    item = @data[index]
    if item != nil
      number = $game_party.item_number(item)
      enabled = enable?(item)
      rect.width -= 4
      draw_item_name(item, rect.x, rect.y, enabled)
      self.contents.draw_text(rect, sprintf(":%2d", number), 2)
    end
  end
  
  #--------------------------------------------------------------------------
  # * Whether to display item in enabled state
  #     item : item
  #--------------------------------------------------------------------------
  def enable?(item)
    return true
  end
end
#==============================================================================
# ** Window_EquipStatus
#------------------------------------------------------------------------------
#  This window displays actor parameter changes on the equipment screen, etc.
#==============================================================================

class Window_EquipStatus < Window_Base
  
  include Equip_Value
  WLH = 20
  WLH2 = 24
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     x     : window X coordinate
  #     y     : window Y corrdinate
  #     actor : actor
  #--------------------------------------------------------------------------
  def initialize(x, y, actor)
    super(x, y, 640, 480)
    @actor = actor
    refresh
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    x = 37
    y = 157
    self.contents.font.size = 18
      self.contents.font.bold = true
    draw_item_name(@item_old,POS_NAME_OLD[0],POS_NAME_OLD[1])
    draw_item_name(@item_new,POS_NAME_NEW[0],POS_NAME_NEW[1])
    draw_parameter( 0, 0)
    draw_parameter( WLH2 * 1, 1)
    draw_parameter( WLH2 * 2, 2)
    draw_parameter( WLH2 * 3, 3)
    draw_parameter( WLH2 * 4, 4)
    draw_parameter( WLH2 * 5, 5)
    draw_parameter( WLH2 * 6, 6)
    draw_actor_face(@actor, POS_FACE[0], POS_FACE[1])
    self.contents.font.name  = [POLICE_PERSO_NAME,"Verdana"]
    self.contents.font.bold = true
    self.contents.font.color = hp_color(@actor)
    self.contents.font.size = SIZE_PERSO_NAME
    self.contents.draw_text(POS_NAME[0], POS_NAME[1], 96, 30, @actor.name)
    self.contents.font.size = 18
    self.contents.font.name  = [POLICE_ITEM_NAME,"Verdana"]
  end
  def draw_icon(icon_index, x, y, enabled = true)
    bitmap = Cache.system("Iconset")
    rect = Rect.new(icon_index % 16 * 24, icon_index / 16 * 24, 24, 24)
    self.contents.blt(x, y-1, bitmap, rect, enabled ? 255 : 128)
  end
  #--------------------------------------------------------------------------
  # * Set Parameters After Equipping
  #     new_atk : attack after equipping
  #     new_def : defense after equipping
  #     new_spi : spirit after equipping
  #     new_agi : agility after equipping
  #--------------------------------------------------------------------------
  def set_new_parameters(new_atk, new_def, new_spi, new_agi,new_hit,new_eva,new_cri,item_old,item_new)
    if @new_atk != new_atk or @new_def != new_def or
       @new_spi != new_spi or @new_agi != new_agi or
       @new_hit != new_hit or @new_eva != new_eva or 
       @new_cri != new_cri or @item_new != item_new or @item_old != item_old
       
      @new_atk = new_atk
      @new_def = new_def
      @new_spi = new_spi
      @new_agi = new_agi
      @new_hit =new_hit
      @new_eva = new_eva
      @new_cri = new_cri
      @item_new = item_new
      @item_old = item_old
      refresh
    end
  end
  #--------------------------------------------------------------------------
  # * Get Post Equip Parameter Drawing Color
  #     old_value : parameter before equipment change
  #     new_value : parameter after equipment change
  #--------------------------------------------------------------------------
  def new_parameter_color(old_value, new_value)
    if new_value > old_value      # Get stronger
      return power_up_color
    elsif new_value == old_value  # No change
      return normal_color
    else                          # Get weaker
      return power_down_color
    end
  end
  #--------------------------------------------------------------------------
  # * Draw Parameters
  #     x    : draw spot x-coordinate
  #     y    : draw spot y-coordinate
  #     type : type of parameter (0 - 3)
  #--------------------------------------------------------------------------
  def draw_parameter( y, type)
    case type
    when 0
      value = @actor.atk
      new_value = @new_atk
    when 1
      value = @actor.def
      new_value = @new_def
    when 2
      value = @actor.spi
      new_value = @new_spi
    when 3
      value = @actor.agi
      new_value = @new_agi
    when 4
      value = @actor.hit
      new_value = @new_hit
    when 5
      value = @actor.eva
      new_value = @new_eva
    when 6
      value = @actor.cri
      new_value = @new_cri
    end
    self.contents.font.name  = [POLICE_ITEM_NAME,"Verdana"]
    self.contents.font.size = 18
    self.contents.font.bold = true
    self.contents.font.color = normal_color
    self.contents.draw_text(POS_CAR_OLD[0], POS_CAR_OLD[1]+y, 30, WLH, value, 2)
    if new_value != nil
      self.contents.font.color = new_parameter_color(value, new_value)
      self.contents.draw_text(POS_CAR_NEW[0], POS_CAR_NEW[1]+y, 30, WLH, new_value, 2)
    end
  end
end
