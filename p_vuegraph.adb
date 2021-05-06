package body p_vuegraph is

  function TradCoul(coul : in T_Coul) return T_Couleur is
  begin
    case coul is
      when rouge => return FL_RED;
      when turquoise => return FL_CYAN;
      when orange => return FL_DARKORANGE;
      when rose => return FL_DEEPPINK;
      when marron => return FL_DARKTOMATO;
      when bleu => return FL_BLUE;
      when violet => return FL_DARKVIOLET;
      when vert => return FL_GREEN;
      when jaune => return FL_YELLOW;
      when blanc => return FL_WHITE;
      when vide => return FL_BOTTOM_BCOL;
      when v => return FL_TOP_BCOL;
    end case;
  end TradCoul;

  procedure AfficheGrille(fenetre : in out TR_Fenetre; grille : in TV_Grille) is
    xorig : natural := 30;
    yorig : natural := 10;
  begin
    AjouterImage(fenetre,"s","s.xpm","",xorig,yorig,80,80);
    ChangerCouleurFond(fenetre,"s",TradCoul(v));
    for i in T_Col loop
      AjouterTexte(fenetre,Character'image(i)(2..2),Character'image(i)(2..2),xorig+(80*(T_col'pos(i)-64)),yorig,80,80);
      ChangerTailleTexte(fenetre, t_col'image(i)(2..2),40);
      ChangerAlignementTexte(fenetre,t_col'image(i)(2..2),FL_ALIGN_INSIDE);
      ChangerCouleurFond(fenetre,t_col'image(i)(2..2),TradCoul(v));
    end loop;
    for i in Grille'range(1) loop
      AjouterTexte(fenetre,integer'image(i)(2..integer'image(i)'last),integer'image(i)(2..integer'image(i)'last),xorig,yorig+(80*(i)),80,80);
      ChangerTailleTexte(fenetre, integer'image(i)(2..integer'image(i)'last),40);
      ChangerAlignementTexte(fenetre,integer'image(i)(2..integer'image(i)'last),FL_ALIGN_INSIDE);
      ChangerCouleurFond(fenetre,integer'image(i)(2..integer'image(i)'last),TradCoul(v));
      for j in Grille'range(2) loop
        if grille(i,j) = rouge then
          AjouterBoutonImage(fenetre,Character'image(j)(2..2)&integer'image(i)(2..integer'image(i)'last),"","virus.xpm",xorig+(80*(T_col'pos(j)-64)),yorig+(80*(i)),80,80);
        elsif grille(i,j) = blanc then
          AjouterBoutonImage(fenetre,Character'image(j)(2..2)&integer'image(i)(2..integer'image(i)'last),"","wall.xpm",xorig+(80*(T_col'pos(j)-64)),yorig+(80*(i)),80,80);
        else
          AjouterBoutonImage(fenetre,Character'image(j)(2..2)&integer'image(i)(2..integer'image(i)'last),"","vide.xpm",xorig+(80*(T_col'pos(j)-64)),yorig+(80*(i)),80,80);
        end if;
        if grille(i,j) in blanc..v then
          ChangerEtatBouton(fenetre,Character'image(j)(2..2)&integer'image(i)(2..integer'image(i)'last),arret);
        else
          ChangerEtatBouton(fenetre,Character'image(j)(2..2)&integer'image(i)(2..integer'image(i)'last),marche);
        end if;
        ChangerCouleurFond(fenetre,Character'image(j)(2..2)&integer'image(i)(2..integer'image(i)'last),TradCoul(grille(i,j)));
      end loop;
    end loop;
  end AfficheGrille;

  procedure ModGrille(fenetre : in out TR_Fenetre; Grille : in out TV_Grille) is
  begin
    for i in Grille'range(1) loop
      for j in Grille'range(2) loop
        if grille(i,j) in blanc..v then
          ChangerEtatBouton(fenetre,Character'image(j)(2..2)&integer'image(i)(2..integer'image(i)'last),arret);
        else
          ChangerEtatBouton(fenetre,Character'image(j)(2..2)&integer'image(i)(2..integer'image(i)'last),marche);
        end if;
        if grille(i,j) = rouge then
          ChangerImageBouton(fenetre,Character'image(j)(2..2)&integer'image(i)(2..integer'image(i)'last),"virus.xpm");
        elsif grille(i,j) = blanc then
          ChangerImageBouton(fenetre,Character'image(j)(2..2)&integer'image(i)(2..integer'image(i)'last),"wall.xpm");
        else
          ChangerImageBouton(fenetre,Character'image(j)(2..2)&integer'image(i)(2..integer'image(i)'last),"vide.xpm");
        end if;
        ChangerCouleurFond(fenetre,Character'image(j)(2..2)&integer'image(i)(2..integer'image(i)'last),TradCoul(grille(i,j)));
      end loop;
    end loop;
  end ModGrille;

  procedure jeuWindow(Grille : in out TV_Grille; Pieces : in TV_Pieces; temps : in out float; nbcoup : in out integer; jouer,recommencer : in out boolean) is
    fenetre : TR_Fenetre;
    coul : T_Coul;
    dir : T_Direction;
    Abandon : boolean := false;
    lastcoup : TV_Grille := Grille;
  begin

    nbcoup := 0;
    temps := 0.0;
    fenetre := DebutFenetre("Anti-Virus (le jeu)",1500,700);
    AjouterTexte(fenetre,"font","",850,0,650,700);
    ChangerCouleurFond(fenetre, "font", FL_DODGERBLUE);
    AjouterBouton(fenetre,"validerC","Valider",1185,550,175,75);
    AjouterBouton(fenetre,"annulerC","Annuler",990,550,175,75);
    AjouterBouton(fenetre,"quitter","Quitter",1100,640,150,50);
    AjouterBoutonImage(fenetre,"hg","","hg.xpm",720,90,80,80);
    AjouterBoutonImage(fenetre,"bg","","bg.xpm",720,250,80,80);
    AjouterBoutonImage(fenetre,"bd","","bd.xpm",720,410,80,80);
    AjouterBoutonImage(fenetre,"hd","","hd.xpm",720,570,80,80);
    ChangerTailleTexte(fenetre,"validerC",15);
    ChangerTailleTexte(fenetre,"annulerC",15);
    ChangerTailleTexte(fenetre,"quitter",15);
    ChangerCouleurFond(fenetre,"fond",TradCoul(v));
    AjouterTexte(fenetre,"textcouleur","Couleur selectionne: ",1000,200,600,100);
    AjouterTexte(fenetre,"textcouleur2","",1212,200,300,100);
    AjouterTexte(fenetre,"textdir","Direction selectionne: ",1000,301,610,100);
    AjouterTexte(fenetre,"textdir2","",1221,300,300,100);
    ChangerCouleurFond(fenetre,"textcouleur",FL_DODGERBLUE);
    ChangerCouleurFond(fenetre,"textcouleur2",FL_DODGERBLUE);
    ChangerCouleurFond(fenetre,"textdir",FL_DODGERBLUE);
    ChangerCouleurFond(fenetre,"textdir2",FL_DODGERBLUE);
    ChangerStyleTexte(fenetre,"textdir2",FL_BOLD_Style);
    ChangerTailleTexte(fenetre,"textcouleur",20);
    ChangerTailleTexte(fenetre,"textcouleur2",20);
    ChangerStyleTexte(fenetre,"textcouleur2",FL_BOLD_Style);
    ChangerTailleTexte(fenetre,"textdir",20);
    ChangerTailleTexte(fenetre,"textdir2",20);
    AjouterChrono(fenetre,"timer","",1015,10,150,50);
    ChangerTempsMinuteur(fenetre,"timer",1200.0);
    ChangerCouleurFond(fenetre,"timer",FL_SLATEBLUE);
    ChangerTailleTexte(fenetre,"timer",20);

    ChangerCouleurFond(fenetre,"validerC",FL_SLATEBLUE);
    ChangerCouleurFond(fenetre,"annulerC",FL_SLATEBLUE);
    ChangerCouleurFond(fenetre,"quitter",FL_SLATEBLUE);

    AjouterTexte(fenetre,"coup",integer'image(nbcoup),1185,10,150,50);
    ChangerCouleurFond(fenetre,"coup",FL_SLATEBLUE);
    ChangerTailleTexte(fenetre,"coup",20);
    ChangerAlignementTexte(fenetre,"coup",FL_ALIGN_INSIDE);

    AfficheGrille(fenetre,Grille);
    FinFenetre(fenetre);
    ChangerEtatBouton(fenetre,"validerC",arret);
    ChangerEtatBouton(fenetre,"hg",arret);
    ChangerEtatBouton(fenetre,"bg",arret);
    ChangerEtatBouton(fenetre,"bd",arret);
    ChangerEtatBouton(fenetre,"hd",arret);
    MontrerFenetre(fenetre);
    loop
      declare
        bouton : String := (AttendreBouton(fenetre));
        dir : T_Direction;
      begin
          for i in Grille'range(1) loop
            for j in Grille'range(2) loop
              if bouton = j&integer'image(i)(2..integer'image(i)'last) then
                coul:= Grille(i,j);
                ChangerEtatBouton(fenetre,"hg",marche);
                ChangerEtatBouton(fenetre,"bg",marche);
                ChangerEtatBouton(fenetre,"bd",marche);
                ChangerEtatBouton(fenetre,"hd",marche);
              end if;
            end loop;
          end loop;
          ChangerTexte(fenetre,"textcouleur2",T_Coul'image(coul));
          ChangerCouleurTexte(fenetre,"textcouleur2",TradCoul(coul));
          if bouton = "hg" then
            dir := hg;
            ChangerEtatBouton(fenetre,"validerC",marche);
            ChangerEtatBouton(fenetre,"annulerC",marche);
            ChangerTexte(fenetre,"textdir2","Haut Gauche");
          elsif bouton = "bg" then
            dir := bg;
            ChangerEtatBouton(fenetre,"validerC",marche);
            ChangerEtatBouton(fenetre,"annulerC",marche);
            ChangerTexte(fenetre,"textdir2","Bas Gauche");
          elsif bouton = "hd" then
            dir := hd;
            ChangerEtatBouton(fenetre,"validerC",marche);
            ChangerEtatBouton(fenetre,"annulerC",marche);
            ChangerTexte(fenetre,"textdir2","Haut Droite");
          elsif bouton = "bd" then
            dir := bd;
            ChangerEtatBouton(fenetre,"validerC",marche);
            ChangerEtatBouton(fenetre,"annulerC",marche);
            ChangerTexte(fenetre,"textdir2","Bas Droite");
          elsif bouton = "validerC" then
            nbcoup := nbcoup + 1;
            ChangerTexte(fenetre,"coup",integer'image(nbcoup));
            if Possible(Grille, coul, dir) then
              lastcoup := grille;
              MajGrille(Grille, coul, dir);
              ModGrille(fenetre, Grille);
            else
              put_line(ASCII.ESC & "[38;5;9mCoup pas possible" & ASCII.ESC & "[0m");
              ChangerTexte(fenetre,"textdir2","");
              ChangerTexte(fenetre,"textcouleur2","");
              ModGrille(fenetre, Grille);
              ChangerEtatBouton(fenetre,"validerC",arret);
              ChangerEtatBouton(fenetre,"hg",arret);
              ChangerEtatBouton(fenetre,"bg",arret);
              ChangerEtatBouton(fenetre,"bd",arret);
              ChangerEtatBouton(fenetre,"hd",arret);
            end if;
          elsif bouton = "annulerC" then
            grille := lastcoup;
            ModGrille(fenetre, grille);
            nbcoup := nbcoup + 1;
            ChangerTexte(fenetre,"coup",integer'image(nbcoup));
          elsif bouton = "quitter" then
            jouer := false;
            recommencer := true;
            CacherFenetre(fenetre);
          end if;
      end;
      exit when Guerison(Grille) or Abandon or (not jouer and recommencer);
    end loop;
    temps := 1200.0 - ConsulterTimer(fenetre,"timer");
    CacherFenetre(fenetre);
  end jeuWindow;

  procedure statWindow(s : in out p_bin_io.file_type; jouer,recommencer : in out boolean) is
    fenetre : TR_Fenetre;
    elem : TR_Score;
    i,j : integer := 0;
  begin
    reset(s,in_file);
    fenetre := DebutFenetre("Statistiques",800,800);
    while not end_of_file(s) loop
      read(s,elem);
      AjouterTexte(fenetre,integer'image(elem.config),integer'image(elem.config),150+i*100,50+j*150,100,50);
      AjouterTexte(fenetre,integer'image(i+j*5)&integer'image(elem.scoreF),integer'image(elem.scoreF),150+i*100,100+j*150,100,50);
      AjouterTexte(fenetre,integer'image(i+j*5)&elem.nomJoueur,elem.nomJoueur,150+i*100,150+j*150,100,50);
      ChangerCouleurFond(fenetre,integer'image(elem.config),FL_SLATEBLUE);
      ChangerCouleurFond(fenetre,integer'image(i+j*5)&integer'image(elem.scoreF),FL_SLATEBLUE);
      ChangerCouleurFond(fenetre,integer'image(i+j*5)&elem.nomJoueur,FL_SLATEBLUE);
      i := i+1;
      if i = 5 then
        i := 0;
        j := j + 1;
      end if;
    end loop;
    AjouterBouton(fenetre,"quitter","Quitter",0,750,800,50);
    ChangerCouleurFond(fenetre,"quitter",FL_SLATEBLUE);
    ChangerCouleurFond(fenetre,"fond",FL_DODGERBLUE);
    FinFenetre(fenetre);
    MontrerFenetre(fenetre);
    if AttendreBouton(fenetre) = "quitter" then
      jouer := false;
      recommencer := true;
      CacherFenetre(fenetre);
    end if;
    put_line("oui");
  end statWindow;

  procedure InitializeF(s : in out p_bin_io.file_type) is
    score : TR_Score;
  begin
    reset(s,out_file);
    for i in 1..20 loop
      score := (i,999999,(others=>'-'));
      write(s,score);
    end loop;
  end InitializeF;

  procedure InsertF(s : in out p_bin_io.file_type; score : in TR_Score) is
    V : TV_Partie(1..20);
    i : integer := V'first;
    elem : TR_Score;
  begin
    reset(s,in_file);
    while not end_of_file(s) loop
      read(s,elem);
      V(i) := elem;
      i := i + 1;
    end loop;
    if V(score.config).scoreF > score.scoreF then
      V(score.config) := score;
    end if;
    reset(s, out_file);
    for i in V'range loop
      write(s,V(i));
    end loop;
  end InsertF;

  procedure finPartie(s : in out p_bin_io.file_type; config : in integer; temps : in float; nbcoup : in integer; recommencer, jouer : in out boolean; acceuil : in out TR_Fenetre) is
    fenetre : TR_Fenetre;
    scoreFinal : float;
    nomJoueur : string := ConsulterContenu(acceuil,"Pseudo");
  begin
    fenetre := DebutFenetre("Victoire!",800,700);
    AjouterBouton(fenetre,"rejouer","Rejouer",0,0,266,50);
    ChangerCouleurFond(fenetre,"rejouer",FL_SLATEBLUE);
    AjouterBouton(fenetre,"quitter","Quitter",266,0,267,50);
    ChangerCouleurFond(fenetre,"quitter",FL_SLATEBLUE);
    AjouterBouton(fenetre,"nouvellepartie","Acceuil",533,0,266,50);
    ChangerCouleurFond(fenetre,"nouvellepartie",FL_SLATEBLUE);
    AjouterImage(fenetre,"win-logo","win.xpm","",272,60,256,256);
    AjouterTexte(fenetre,"titre","Victoire !",310,320,700,50);
    ChangerTailleTexte(fenetre,"titre",40);
    AjouterTexte(fenetre,"temps","Temps: "&image(temps),300,400,300,50);
    ChangerTailleTexte(fenetre,"temps",20);
    AjouterTexte(fenetre,"nbcoup","Nombres de coups: "&integer'image(nbcoup),300,450,300,50);
    ChangerTailleTexte(fenetre,"nbcoup",20);
    AjouterTexte(fenetre,"config","Configuration: "&integer'image(config),300,500,300,50);
    ChangerTailleTexte(fenetre,"config",20);
    scoreFinal := temps*float(nbcoup);
    AjouterTexte(fenetre,"score","Score final: "&image(integer(scoreFinal)),260,550,400,50);
    ChangerTailleTexte(fenetre,"score",35);
    FinFenetre(fenetre);
    MontrerFenetre(fenetre);
    declare
      bouton : string := AttendreBouton(fenetre);
      score : TR_Score;
      st : string(1..30);
    begin
      st:= (others => ' ');
      st(1..nomJoueur'length):=nomJoueur(nomJoueur'first..nomJoueur'last);
      score := (config,integer(scoreFinal),st);
      if end_of_file(s) then
        InitializeF(s);
      end if;
      InsertF(s, score);
      if bouton = "rejouer" then
        recommencer := true;
        jouer := true;
        CacherFenetre(fenetre);
      elsif bouton = "quitter" then
        recommencer := false;
        jouer := false;
        CacherFenetre(fenetre);
      elsif bouton = "nouvellepartie" then
        recommencer := true;
        jouer := false;
        CacherFenetre(fenetre);
      end if;
    end;
  end finPartie;

  procedure choixWindow(acceuil : in TR_Fenetre; config : out integer; jouer, recommencer : in out boolean; grille : out TV_Grille; Pieces : out TV_Pieces) is
    fenetre : TR_Fenetre;
    f : p_piece_io.file_type;
    nbc : integer;
    nomJoueur : string := ConsulterContenu(acceuil,"Pseudo");
  begin
    InitPartie(Grille, Pieces);
    open(f,in_file,"Parties");
    fenetre := DebutFenetre("Choix de la partie",800,700);
    nbC := nbConfig(f);
    AjouterImage(fenetre,"player","doctor.xpm","",10,10,128,128);
    AjouterTexte(fenetre,"nomJoueur",nomJoueur,140,10,200,100);
    ChangerTailleTexte(fenetre,"nomJoueur",30);
    AjouterBouton(fenetre,"quitter","Quitter",700,0,100,50);
    ChangerCouleurFond(fenetre,"quitter",FL_SLATEBLUE);
    ChangerCouleurFond(fenetre,"fond",FL_DODGERBLUE);
    ChangerCouleurFond(fenetre,"nomJoueur",FL_DODGERBLUE);
    for i in 0..nbC/5-1 loop
      for j in (5*i+1)..(5*i+5) loop
        AjouterBouton(fenetre,integer'image(j),integer'image(j),130+(110*((j-1) mod 5)),220+110*i,100,100);
        ChangerCouleurFond(fenetre,integer'image(j),FL_TOMATO);
      end loop;
    end loop;
    FinFenetre(fenetre);
    MontrerFenetre(fenetre);
    declare
      bouton : String := (AttendreBouton(fenetre));
    begin
      if bouton = "quitter" then
        jouer := false;
        recommencer := true;
        CacherFenetre(fenetre);
      else
        config := integer'value(bouton);
        Configurer(f,config,Grille,Pieces);
        CacherFenetre(fenetre);
      end if;
    end;
    close(f);
  end choixWindow;

  procedure acceuilWindow(s : in out p_bin_io.file_type; acceuil : in out TR_Fenetre; jouer, recommencer : in out boolean) is
  begin
    jouer := false;
    acceuil := DebutFenetre("Anti-Virus (le jeu)",800,700);
    AjouterImage(acceuil,"logo","logo.xpm","",250,50,300,300);
    AjouterBouton(acceuil,"jouer","JOUER",215,500,175,75,FL_RETURN_BUTTON);
    AjouterBouton(acceuil,"quitter","QUITTER",410,500,175,75);
    AjouterBouton(acceuil,"stat","Statistiques",310,600,175,75);
    AjouterChamp(acceuil,"Pseudo","Pseudo : ","Nom Joueur",275,400,250,30);
    FinFenetre(acceuil);
    ChangerCouleurFond(acceuil,"titre",FL_DODGERBLUE);
    ChangerCouleurTexte(acceuil,"titre",FL_RED);
    ChangerTailleTexte(acceuil,"titre",50);
    ChangerTailleTexte(acceuil,"Pseudo",10);
    ChangerCouleurFond(acceuil,"jouer",FL_SLATEBLUE);
    ChangerCouleurFond(acceuil,"quitter",FL_SLATEBLUE);
    ChangerCouleurFond(acceuil,"stat",FL_SLATEBLUE);
    ChangerTailleTexte(acceuil,"jouer",15);
    ChangerTailleTexte(acceuil,"quitter",15);
    ChangerCouleurTexte(acceuil,"titre",FL_RED);
    ChangerCouleurFond(acceuil,"fond",FL_DODGERBLUE);
    MontrerFenetre(acceuil);
    declare
      bouton : String := (AttendreBouton(acceuil));
      nomJoueur : string := ConsulterContenu(acceuil,"Pseudo");
    begin
      if bouton = "jouer" or bouton = "Pseudo" then
        jouer := true;
        recommencer := false;
        CacherFenetre(acceuil);
      elsif bouton = "quitter" then
        CacherFenetre(acceuil);
        jouer := false;
        recommencer := false;
      elsif bouton = "stat" then
        CacherFenetre(acceuil);
        statWindow(s, jouer,recommencer);
      end if;
    end;
  end acceuilWindow;

end p_vuegraph;
