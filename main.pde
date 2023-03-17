import processing.sound.*;
import java.util.*;







// Definisci il tempo massimo tra la pressione del primo e dell'ultimo pulsante
int MAX_PRESS_TIME = 500; // 0.5 secondi

// Variabile per memorizzare la combinazione di pulsanti in corso
String currentCombination = "";

// Variabile per memorizzare il tempo dell'ultimo pulsante premuto
long lastPressTime = 0;


// audio map
HashMap<String, SoundFile> audios = new HashMap<String, SoundFile>();
void initAudios(){
  for(int i=141; i<173; i++){  
    audios.put(str(char(i)), new SoundFile(this,"sounds/"+char(i)+".wav"));
  }
  audios.put("-", new SoundFile(this, "sounds/command.m4a"));
}

// Definisci la mappa delle combinazioni di pulsanti e dei file audio associati
HashMap<String, String> combinationMap = new HashMap<String, String>();
void initCombinations(){
  combinationMap.put("a","1");
  combinationMap.put("b","13");
  combinationMap.put("c", "12" );
  combinationMap.put("d", "124");
  combinationMap.put("e", "14");
  combinationMap.put("f", "123");
  combinationMap.put("g", "1234");
  combinationMap.put("h", "134");
  combinationMap.put("i", "23");
  combinationMap.put("j", "234");
  combinationMap.put("k", "15");
  combinationMap.put("l", "135");
  combinationMap.put("m", "125");
  combinationMap.put("n", "1245");
  combinationMap.put("o", "145");
  combinationMap.put("p", "1235");
  combinationMap.put("q", "12345");
  combinationMap.put("r", "1345");
  combinationMap.put("s", "235");
  combinationMap.put("t", "2345");
  combinationMap.put("u", "156");
  combinationMap.put("v", "1356");
  combinationMap.put("w", "2346");
  combinationMap.put("x", "1256");
  combinationMap.put("y", "12456");
  combinationMap.put("z", "1456");
  combinationMap.put("-", "");
}


String removeDuplicates(String str) {
  HashSet<Character> set = new HashSet<Character>();
  StringBuilder result = new StringBuilder();

  // Scorre tutti i caratteri della stringa
  for (int i = 0; i < str.length(); i++) {
    char c = str.charAt(i);

    // Aggiunge il carattere alla stringa risultato solo se non è presente nel set
    if (!set.contains(c)) {
      set.add(c);
      result.append(c);
    }
  }

  return result.toString();
}

// " <?> stands for error <-> stands for command char"
String whichLetterNow(){
  
  currentCombination= removeDuplicates(currentCombination);
  
  if(currentCombination.length() == 6){
    return "-";
  }
  
  var letter = "?";
  for(int i=141; i<173; i++){ 
    var currentConf = combinationMap.get(str(char(i)));
    
    if(currentConf.length() == currentCombination.length()){
      boolean isCorrect = true;
      for(int j=0; j<currentConf.length(); j++){
        if(currentCombination.indexOf(currentConf.charAt(j))<0){
          isCorrect = false;
        }
      }
      if(isCorrect == true){
        return str(char(i));
      }
    }
  }
  return "-";
}


// Definisci i pin digitali associati ai pulsanti
int[] buttonPins = {2, 3, 4, 5, 6, 7};

// Definisci lo stato precedente dei pulsanti per evitare la ripetizione degli eventi
int[] lastButtonStates = {HIGH, HIGH, HIGH, HIGH, HIGH, HIGH};


Servo[] servoMotors = {new Servo(), new Servo(), new Servo(), new Servo(), new Servo(), new Servo()};
boolean[] servoMotorsStates = new boolean[6];
void initServoMotors(){
  for(int i=0; i<6;i++){
   servoMotors[i].attach(i);    // TODO define the number of the servoMotor
   servoMotorsStates[i] = false;
  }
}
boolean acceptOtherRequestOfMovingServoMotors = true;













// with caracter "-" all servo motors are deactivated
boolean ServoMotorsPerformLetter(String letterToPerform){
 
  if(acceptOtherRequestOfMovingServoMotors == false){
    return false;
  }
  else{
    acceptOtherRequestOfMovingServoMotors = false;
  }
  
  var configurationCode = combinationMap.get(letterToPerform);
  
  for(int i=0; i<6; i++){
    if( (configurationCode.indexOf(char(i)) >= 0) != servoMotorsStates[i]){
      // case in which the servo motors are in a different position
      
      servoMotors[i].write( (servoMotorsStates[i] == true)? 0 : 180);
      servoMotorsStates[i] = !servoMotorsStates[i];
    }
  }
  
  delay(800);
  
  acceptOtherRequestOfMovingServoMotors = true;
}




void OnComposedLetter(String letterSelected){
  
  audios.get(letterSelected).play();
      
  if(letterSelected == "-"){
    
  }
}





void setup(){
  
  initAudios();
  
  initCombinations();
  
  initServoMotors();
  
  // Imposta i pin dei pulsanti come input
  for (int i = 0; i < buttonPins.length; i++) {
    pinMode(buttonPins[i], INPUT);
  }
}


void loop() {
  
  long currentTime = millis();
  long elapsedTime = currentTime - lastPressTime;
  
  // Se è passato troppo tempo dall'ultimo pulsante premuto, resetta la combinazione corrente
  if (elapsedTime > MAX_PRESS_TIME && currentCombination!= "") {
    
    var characterSelected = whichLetterNow();
    
    if(characterSelected != "?"){
      OnComposedLetter(characterSelected);
    }
    
    currentCombination = "";
  }
      
  // Controlla lo stato dei pulsanti
  for (int i = 0; i < buttonPins.length; i++) {
    int buttonState = digitalRead(buttonPins[i]);

    // Se il pulsante è stato premuto
    if (buttonState == HIGH && lastButtonStates[i] == LOW) {

      // Aggiungi il pulsante alla combinazione corrente
      currentCombination += str(i);

      // Memorizza lo stato del pulsante
      lastButtonStates[i] = buttonState;

      // Memorizza il tempo dell'ultimo pulsante premuto
      lastPressTime = currentTime;
    }
    // Se il pulsante è stato rilasciato
    else if (buttonState == LOW && lastButtonStates[i] == HIGH) {

      lastButtonStates[i] = buttonState;
    }
  }
}
