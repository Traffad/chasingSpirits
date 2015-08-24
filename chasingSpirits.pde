//initierar tärnigar och så vidare prblemet som jag stöter på just nu är 
// att antalet tärnigskast är enfaldiga

// Av Andreas Sandskär 23-24 augusti 2015
// Saknar spelarhänder som nästa steg

//förutsättingar för att vinna eller förlora
int villager_max=21;
int days_max=14+1;

int villager_pot=villager_max;

// håller koll på vart byborna tar vägen
int villager_taken, villager_spelare;

// räknar ut bybor till handen om möjligt
int villager_fb, villager_ef, villager_tot;


//räknare för att nå slutresultaten
int villager_sum=0;
int days_sum=1;

//antalet spelare
int numSpelare = 4;
int[] spelare = new int[numSpelare];
//int o;

//antalet Rundor
int numRundor = 14;
float[] runda = new float[numRundor];

//lyckoräknare
//int lyckat, olyckat;
//float chans;

//vasenraknare
int spirit;
int spirit_spawn;
int spirit_kc;

int day_current;

void setup() {
  noLoop();
}
void draw() {
  //  for (int k=0; k<runda.length; k++) {
  //   nollstall();
  for (int l=1; l<=days_max; l++) {
    //dagräknare
    day_current=l;
    if (villager_sum != villager_max) {
      if (l != days_max) {
        //en spelomgång har upp till tre faser per spelare och jag antar att man delar med sig av fynd av invånare vilket fördröjer spelet lite i början.
        //första tärningskasten ärd det en tärnig
        for (int j=0; j<numSpelare; j++) {
          //   println();
          //   print("Spelare "+j+" "  );
          villager_fb=villager_sum;
          if (villager_sum == 0) {
            if (villager_pot !=0) {              
              println("söker en gång ("+villager_sum+")("+villager_pot+").");
              rulla();
              danger_test();
            }
          } 
          //när det finns en bybo så kan man använda sig av den för att söka med en till tärning
          else {
            switch(spirit) {
            case 0: 
              if (villager_pot >=2) {
                println("Söker två gånger ("+villager_sum+")("+villager_pot+").");
                rulla();
                danger_test();
                rulla();
                danger_test();
              } 
              else
                if (villager_pot !=0) {
                  println("Söker en ("+villager_sum+")("+villager_pot+").");
                  rulla();
                  danger_test();
                }
              break;
            case 1: 
              if (villager_pot !=0) {
                print("Söker en och ");
                rulla();
                danger_test();
              }
              if (spelare[j] >= 2) {

                println("schasar bort ett väsen. Hemma("+villager_sum+") Kvar("+villager_pot+") Tagna("+villager_taken+").");
                spirit_del();
              } 
              else {
                if (villager_pot !=0) {
                  println("söker en gång till.");
                  rulla();
                  danger_test();
                }
              }
              break;
            case 2: 

              if (spelare[j] >= 2) {
                println("Shasar bort två väsen ("+villager_sum+").");
                spirit_del();
              } 
              else {
                rulla();
                danger_test();
              }
              if (spelare[j] >= 2) {
                spirit_del();
              }
              else {
                rulla();
                danger_test();
              }                         
              break; 
            case 3: 
              // vad som hände var att det treje väsendet han komm före första bybon
              if (spelare[j] >= 2) {
                println("Shasar bort två väsen ("+villager_sum+" bybor).");
                spirit_del();
                spirit_del();
              } 
              else {
                //jag antar att man försöker att hitta en bybo som första då.
                if (spelare[j] >= 2 && villager_pot !=0) {
                  println("Söker en gång,");
                  rulla();
                  danger_test();
                }
                if (spelare[j] >= 2) {
                  println("Shasar bort ett väsen ("+villager_sum+" bybor).");
                  spirit_del();
                } 
                else {
                  if (villager_pot !=0) {
                    println("Söker en gång,");
                    rulla();
                    danger_test();
                  }
                }
              }         
              break;
            case 4: 
              // vad som hände var att det treje väsendet han komm före första bybon
              if (spelare[j] >= 2) {
                println("Shasar bort två väsen ("+villager_sum+" bybor).");
                spirit_del();
                spirit_del();
              } 
              else {
                //jag antar att man försöker att hitta en bybo som första då.
                if (spelare[j] >= 2 && villager_pot !=0) {
                  println("Söker en gång,");
                  rulla();
                  danger_test();
                }
                if (spelare[j] >= 2) {
                  println("Shasar bort ett väsen ("+villager_sum+" bybor).");
                  spirit_del();
                } 
                else {
                  if (villager_pot !=0) {
                    println("Söker en gång,");
                    rulla();
                    danger_test();
                  }
                }
              }        
              break;
            case 5: 
              println("fem");  
              if (spelare[j] >= 2) {
                spirit_del();
                spirit_del();
              }
              break;  
            case 6: 
              println("sex");  
              //om man kan eleminera en så kan man eliminera 2
              //dessutom är oddsen höga att man kan plocka två med två
              if (spelare[j] >= 2) {
                spirit_del();
                spirit_del();
              }
              break;
            }
          }

          villager_ef=villager_sum-villager_fb;


          if (villager_sum !=0) {
            if (spelare[j] <3 && spelare[j]+villager_ef<3 ) {
              spelare[j] += villager_ef;
              villager_sum-= villager_ef;
            }
            if (villager_pot==0) {
              if (spelare[j] <4 && spelare[j]+villager_ef<4 ) {
                spelare[j] += villager_ef;
                villager_sum-= villager_ef;
              }
            }
          }
        }

        // Lägger till en spirt när en sammanlaggd fara har blivit 6
        // nu kan strategin vara att de sprider sin tur över områden
        // men just nu kör jag med generellt 6
        // det vi ejentligen kör är med att väsena slår och områden med lägre
        // spawnar vilket antagligen kan ge fler eller färre beroende på
        // spelarstrategi
        for (int i = 6; i <= danger && spirit !=6 ; danger -= 6) {
          spirit_add();
        }

        //såklart ska vart väsen få rulla en gång var per dygn
        for (int m = 1; m <= spirit ; m++) {
          if (villager_sum !=0) {
            rulla();
            spirit_test();
            println("Väsena tar för sig och har nu taigt ("+villager_taken+") och ni har ("+villager_sum+"). Kvar("+villager_pot+")");
          }
        }
        println("");
        println(l+"a dagen. ("+villager_sum+") bybor:  spirit "+spirit+" fara "+danger);
      }
      if (villager_sum >= villager_max) {
        villager_sum = villager_max;
      }

      //så testläget om man vinner med handen behöver kollas här
      for (int q=0; q < spelare.length; q++) {
        villager_spelare+=spelare[q];
      }
      //för att händerna ska fungera så behöver jag räkna ut det emellanåt
      // detta för att veta om spelet är över då färre kort syns i sum
      print(" antal villlages spelarna har  "+       villager_spelare   );

      villager_tot=villager_sum+villager_spelare;

      // anpassar slutspelsituationen till detta strax
      if (villager_tot == villager_max) {
        println("");
        //          print(k+" Spelet är slut: ");
        print("Grattis! "+numSpelare+" äventyrare räddade de " +villager_sum+" byborna! På den "+l+"e dagen med "+ TARNING+" tärningskast."+" Dangermeter: "+danger);
        print(". Hjältarna sjasade dessutom bort "+ spirit_kc+ " väsen. Spelarna har i händerna "+villager_spelare);
        l=days_max;


        //nollställer handen så att den inte dublas vid nästa dag


        // Satestikräknare för flerspel
        //       lyckat++;
      }

      if (villager_tot != villager_max) {
        if (l == days_max) {
          println("");
          //            print(k+" Spelet är slut: ");
          print("Tiden är ute: "+numSpelare+" äventyrare hann rädda "+ villager_sum+" med "+ TARNING+" tärningskast."+" Spiritmeter: "+spirit_spawn+" som tog " +villager_taken);
          print(". Hjältarna sjasade dessutom bort "+ spirit_kc);
          //            olyckat++;
        }
      }
      villager_spelare=0;
    }
  }
}
/*  println("");
 chans = 100*((float)lyckat/(float)numRundor);
 println(lyckat+" lyckade omgångar och " +olyckat+" olyckade gånger. En chans på "+chans+"%");
 
 }
 */

int TARNING;
int dice_test;
//tärningskast
void rulla() {
  int kast=0;
  kast = (int)random(6) + 1;
  dice_test=kast;
}

int danger;
void danger_test() {  
  if (dice_test == 1) danger++;
  else if (dice_test == 2) danger++;
  else if (dice_test == 3) villager_add();
  else if (dice_test == 4) villager_add();
  else if (dice_test == 5) danger++;
  else if (dice_test == 6) danger++;
  TARNING++;
}

void villager_add() {
  if (villager_pot !=0) {
    villager_sum++;
    villager_pot--;
  }
}
void villager_take() {
  if (villager_sum !=0) {
    villager_sum--;
    villager_taken++;
  }
}

void spirit_test() {  
  if (villager_sum >= 1) { 
    if (dice_test == 1) villager_take();
    else if (dice_test == 2) villager_take();
    else if (dice_test == 3) ;
    else if (dice_test == 4) ;
    else if (dice_test == 5) villager_take();
    else if (dice_test == 6) villager_take();
  }
}



void spirit_add() {
  spirit++;
  spirit_spawn++;
  //när det nya väsendet kommer in så tar den bybor direkt
  //beroende på dag olika antal
  if (villager_sum >=1 ) {

    villager_take();

    print("Det nya väsendet tar först en");

    if (villager_sum >=2 ) {
      if (day_current>=5) {
        villager_take();
        print(", en till");
      }
    }
    if (villager_sum >=3 ) {
      if (day_current>=8) {
        villager_take();
        print(" och en tredje");
      }
    }
  }
  println(". Nu är det ("+villager_sum+") bybor kvar.");
}

void spirit_del() {
  if (spirit != 0) {
    spirit--;
    spirit_kc++;
  }
  villager_sum++;
  villager_taken--;

  if (spirit == 0) {
    villager_sum+=villager_taken;
    villager_taken=0;
    println("Alla väsen är nu försvunna ("+villager_taken+") och ni har ("+villager_sum+"). Kvar("+villager_pot+")");
  }
}


/*
void nollstall() {
 villager_sum=0;
 TARNING=0;
 danger=0;
 }
 */
