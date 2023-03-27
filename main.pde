import processing.sound.*;
import processing.io.*;
import java.util.*;




String[] POTENTIAL_WORDS = {"tree", "apple", "house", "friend", "school", "love"};
public String chooseRandomWord(){
  
  // TODO Change, just testing
  return "caf";
  
  //return POTENTIAL_WORDS[int(random(POTENTIAL_WORDS.length))];
}
public String chooseRandomLetter(){
  
  // TODO Remove, just testing
  String[] choices = {"c","a", "f", "j", "i"};
  return choices[int(random(5))];
  
  //return str(char(int(random(26))+97));
}

public void playStopAudio(String IDAudioToPlay, boolean isPlay){
  
  
  // TODO Change it is for testing purposes
  
  TestStringOutput = IDAudioToPlay;
  redraw();
  
  /*
  var audioToPlay = audios.get(IDAudioToPlay);
  
  if(isPlay){
      audioToPlay.play();
  }
  else{
      audioToPlay.stop();
  }
  */
}


// Definisci il tempo massimo tra la pressione del primo e dell'ultimo pulsante
int MAX_PRESS_TIME = 50; // 0.5 secondi
int MAX_COMMAND_COMPOSITION_TIME = 1500;
int MAX_DELAY_TO_WAIT_SERVO_MOTORS_MOVEMENT = 800;

long lastCommandCombinationPressedTime = 0;

// Variabile per memorizzare la combinazione di pulsanti in corso
String currentCombination = "";

// Variabile per memorizzare il tempo dell'ultimo pulsante premuto
long lastPressTime = 0;


// audio map
HashMap<String, SoundFile> audios = new HashMap<String, SoundFile>();
void initAudios(){
  for(int i=97; i<123; i++){  
    audios.put(str(char(i)), new SoundFile(this,"sounds/"+char(i)+".wav"));
  }
  audios.put("-", new SoundFile(this, "sounds/command.wav"));
  
  for(int i=0; i<POTENTIAL_WORDS.length; i++){  
    audios.put(POTENTIAL_WORDS[i], new SoundFile(this,"sounds/"+POTENTIAL_WORDS[i]+".wav"));
  }
  
  for(int i=0; i<NAME_OF_AUDIO_NOTIFICATIONS.length; i++){  
    audios.put(NAME_OF_AUDIO_NOTIFICATIONS[i], new SoundFile(this,"sounds/"+NAME_OF_AUDIO_NOTIFICATIONS[i]+".wav"));
  }
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
  
  for(int i=97; i<123; i++){ 
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
  return "?";
}


// Definisci i pin digitali associati ai pulsanti
int[] buttonPins = {3, 5, 7, 8, 10, 12};

int[] outputPins = {11, 13, 15, 16, 18, 19};

// Definisci lo stato precedente dei pulsanti per evitare la ripetizione degli eventi
int[] lastButtonStates = {1, 1, 1, 1, 1, 1};


/*
Servo[] servoMotors = {new Servo(), new Servo(), new Servo(), new Servo(), new Servo(), new Servo()};
boolean[] servoMotorsStates = new boolean[6];
void initServoMotors(){
  for(int i=0; i<6;i++){
   servoMotors[i].attach(i);    // TODO define the number of the servoMotor
   servoMotorsStates[i] = false;
  }
}
*/

// MOCK WITH LED
boolean[] servoMotorsStates = new boolean[6];
void initServoMotors(){
  for(int i=0; i<6;i++){
   GPIO.pinMode(outputPins[i], GPIO.OUTPUT);
   servoMotorsStates[i] = false;
  }
}






// with caracter "-" all servo motors are deactivated
boolean ServoMotorsPerformLetter(String letterToPerform){
  
  var configurationCode = combinationMap.get(letterToPerform);
  
  /*
  for(int i=0; i<6; i++){
    if( (configurationCode.indexOf(char(i)) >= 0) != servoMotorsStates[i]){
      // case in which the servo motors are in a different position
      
      servoMotors[i].write( (servoMotorsStates[i] == true)? 0 : 180);
      servoMotorsStates[i] = !servoMotorsStates[i];
    }
  }
  */
  
  
  // MOCK with leds
  
    for(int i=0; i<6; i++){
    if( (configurationCode.indexOf(char(i)) >= 0) != servoMotorsStates[i]){
      // case in which the servo motors are in a different position
      
      GPIO.digitalWrite(outputPins[i], (servoMotorsStates[i] == true)? GPIO.LOW : GPIO.HIGH );
      servoMotorsStates[i] = !servoMotorsStates[i];
    }
  }
  
  return true;
}



void OnWhateverUserInteraction(){
  var currentProcess= getCurrentBrailleProcess();
  
  if(currentProcess!=null){
    currentProcess.runAtAllUserInteraction();
  }
}

void OnNewProcessFromCommand(BrailleProcess processSelectedByTheCommand){
  setNewChainOfProcesses(new BrailleProcess[] {processSelectedByTheCommand});
}

void OnBrailleLetterTyped(String letterTyped){
  
  var currentProcess= getCurrentBrailleProcess();
  
  if(currentProcess!=null){
    currentProcess.runAtLetterTyped(letterTyped);
  }
}


void OnRecognizedCombination(String combinationSelected){
  
  playStopAudio(combinationSelected, true);
      
  long currentTime = millis();
  
  if(combinationSelected == "-"){
    lastCommandCombinationPressedTime = currentTime;
  }
  else{
      long elapsedTime = currentTime - lastCommandCombinationPressedTime;
      if (elapsedTime < MAX_COMMAND_COMPOSITION_TIME){
        
        BrailleProcess processSelected;
        
        switch(combinationSelected){
          case "a":
          processSelected= new Braille_UploadMainFlowOfProcesses();
            break;
          case "b":
          processSelected= new Braille_LetterReadingExercise("");
            break;
          case "c":
          processSelected= new Braille_LetterWritingExercise("");
            break;
          case "d":
          processSelected= new Braille_WordWritingExercise("");
            break;
          case "e":
          processSelected= new Braille_WordHapticPresentation("");
            break;
          case "f":
          processSelected= new Braille_DialogPeerToPeer();
            break;
          default:
            processSelected = null;
        }
        
        //TODO remove it is only for test
        TestStatusStringOutput = "command composed with letter: "+combinationSelected;
        redraw();
        
        
        OnNewProcessFromCommand(processSelected);
      }
      else{
        OnBrailleLetterTyped(combinationSelected);
      }
  }
}


// TODO remove it is only for testing
String TestStringOutput = "";
String TestStatusStringOutput = "";
void draw() {
  fill(0);
  textSize(24);
  textAlign(CENTER);
  text(TestStringOutput,560,300, 85,80);
  text(TestStatusStringOutput,560,450, 85,80);
}



void setup(){
  
  //TODO Remove, it is for testing
  size(1280, 800);
  
  
  
  initAudios();
  
  initCombinations();
  
  initServoMotors();
  
  // Imposta i pin dei pulsanti come input
  for (int i = 0; i < buttonPins.length; i++) {
    GPIO.pinMode(buttonPins[i], GPIO.INPUT);
  }
}




void loop() {
  
  long currentTime = millis();
  long elapsedTime = currentTime - lastPressTime;
  
  // Se è passato troppo tempo dall'ultimo pulsante premuto, resetta la combinazione corrente
  if (elapsedTime > MAX_PRESS_TIME && currentCombination!= "") {
    
    var characterSelected = whichLetterNow();
    
    //TODO Remove it is only for test purposes
    TestStatusStringOutput = "captured caracter = "+characterSelected;
    redraw();
    
    if(characterSelected != "?"){
      OnRecognizedCombination(characterSelected);
    }
    
    OnWhateverUserInteraction();
    
    currentCombination = "";
  }
      
  // Controlla lo stato dei pulsanti
  for (int i = 0; i < buttonPins.length; i++) {
    int buttonState = GPIO.digitalRead(buttonPins[i]);

    // Se il pulsante è stato premuto
    if (buttonState == 1 && lastButtonStates[i] == 0) {

      // Aggiungi il pulsante alla combinazione corrente
      currentCombination += str(i);

      // Memorizza lo stato del pulsante
      lastButtonStates[i] = buttonState;

      // Memorizza il tempo dell'ultimo pulsante premuto
      lastPressTime = currentTime;
    }
    // Se il pulsante è stato rilasciato
    else if (buttonState == 0 && lastButtonStates[i] == 1) {

      lastButtonStates[i] = buttonState;
    }
  }
}













// ------------------------------------------------------------------------------------------------------------------------------------------------------------------
// ------------------------------------------------------------------------------------------------------------------------------------------------------------------
// ------------------------------------------------------------------------------------------------------------------------------------------------------------------


//                                                                         BRILLE PROCESSES


// ------------------------------------------------------------------------------------------------------------------------------------------------------------------
// ------------------------------------------------------------------------------------------------------------------------------------------------------------------
// ------------------------------------------------------------------------------------------------------------------------------------------------------------------











int indexOfBrilleProcess = -1;
BrailleProcess[] listOfProcesses = null;
public BrailleProcess getCurrentBrailleProcess(){
  if(indexOfBrilleProcess >= 0){
    return listOfProcesses[indexOfBrilleProcess];
  }
  return null;
}
public void loadNextBrailleProcess(){
  if(indexOfBrilleProcess >= 0){
    getCurrentBrailleProcess().onKill();
    indexOfBrilleProcess--;
  }
  if(indexOfBrilleProcess >= 0){
    getCurrentBrailleProcess().runAtStart();
  }
}
public void setNewChainOfProcesses(BrailleProcess[] chainOfProcesses){
    if(indexOfBrilleProcess > 0){
      getCurrentBrailleProcess().onKill();
    }
    if(chainOfProcesses!= null && chainOfProcesses.length > 0){
       listOfProcesses = chainOfProcesses;
    }
    indexOfBrilleProcess = listOfProcesses.length -1;
    getCurrentBrailleProcess().runAtStart();
}



public enum BrailleProcessType{
  UploadMainFlowOfProcesses,    // CODE: CMD + a         
  LetterReadingExercise,        // CODE: CMD + b
  LetterWritingExercise,        // CODE: CMD + c
  WordWritingExercise,          // CODE: CMD + d
  WordHapticPresentation,       // CODE: CMD + e
  DialogPeerToPeer,             // CODE: CMD + f
  AudioNotification,
}

public abstract class BrailleProcess{
 
  public BrailleProcessType type;
  public boolean isKilled =false;
  
  public boolean isSuccess = false;
  
  public BrailleProcess(BrailleProcessType _type){
    type = _type;
  }
  
  public void runAtStart(){};
  public void runAtAllUserInteraction(){};
  public void runAtLetterTyped(String letterTyped){};
  public void onKill()
    {
      isKilled = true;
    };
    
  public void tickSelfAsFinished(){
    if(isKilled == false){
     loadNextBrailleProcess();
    }
  }
}





String[] NAME_OF_AUDIO_NOTIFICATIONS = {
  // prepare to feel the braille character
  "getReadyToFeelTheLetter", 
  // compose the braille character associated with the letter "A"
  "composeTheCombinationCorrespondentToLetter",
  "successSound",
  "failSound",
  // Enter the braille characters in sequence to form the word
  "typeInSequenceTheLetterInBrailleToComposeTheWord",
  // prepare to feel the sequence of braille characters that form the word
  "getReadyToFeelTheSequenceOfWord",
  // dialogue mode: dial braille characters and allow your player friend to perceive what you are writing.
  "introducitionToPeerToPeerDialog",
  // Now we will learn how to translate the word
  "NowWeAreGoingToLearnHowToTranslateTheWord",
  // let's see how well you do at translating each letter of the word
  "LetSCheckHowGoodAreWithTheTranslations",
  // perfect! now try to compose the whole word
  "PerfectNowTryToCompleteYourWord",
};


public class Braille_AudioNotification extends BrailleProcess{
  public String textOfAudio;
  public int stopAfterSec;
  
  // if _stopAfterSec < 0 then it stop at the first generic interaction of the user
  public Braille_AudioNotification(String _textOfAudio, int _stopAfterSec){
    super(BrailleProcessType.AudioNotification);
    textOfAudio = _textOfAudio;
    stopAfterSec=_stopAfterSec;
  }
  public void runAtStart(){
      // play audio
      playStopAudio(textOfAudio, true);
      
      if(stopAfterSec >=0){
        delay(stopAfterSec);
        tickSelfAsFinished();
      }
  }
  public void runAtAllUserInteraction(){
    if(stopAfterSec <0){
          tickSelfAsFinished();
    }
  }
  public void onKill(){
    playStopAudio(textOfAudio, false);
    super.onKill();
  }
}

public class Braille_LetterReadingExercise extends BrailleProcess{
  public String letterToRead;
  public boolean waitingForInput = false;
  public Braille_LetterReadingExercise(String _letterToRead){
    super(BrailleProcessType.LetterReadingExercise);
    if(_letterToRead == ""){
      _letterToRead = chooseRandomLetter();
    }
    letterToRead = _letterToRead;
  }
  public void runAtStart(){
    // introduce the exercise with audio: getReadyToFeelTheLetter
    playStopAudio(NAME_OF_AUDIO_NOTIFICATIONS[0], true);
    
    delay(4000);
    
    if(isKilled) return;
    
    ServoMotorsPerformLetter(letterToRead);
    
    delay(MAX_DELAY_TO_WAIT_SERVO_MOTORS_MOVEMENT);
    
    if(isKilled) return;
    
    waitingForInput = true;
  }
  
  public void runAtAllUserInteraction(){
    if(waitingForInput){
      
      //in the version with the speech recognition here should be present the evaluation
      delay(300);
      
      isSuccess = true;
      // Success audio
      playStopAudio(NAME_OF_AUDIO_NOTIFICATIONS[2], true);
      delay(300);
            
      tickSelfAsFinished();
    }
  }
    
  public void onKill(){
    
    ServoMotorsPerformLetter("-");
          
    super.onKill();
  }
}

public class Braille_LetterWritingExercise extends BrailleProcess{
  public String letterToWrite;
  public boolean waitingForInput = false;
  public Braille_LetterWritingExercise(String _letterToWrite){
    super(BrailleProcessType.LetterWritingExercise);
    if(_letterToWrite == ""){
      _letterToWrite = chooseRandomLetter();
    }
    letterToWrite = _letterToWrite;
  }
  
  public void runAtStart(){
    // introduce the exercise with audio: composeTheCombinationCorrespondentToLetter
    playStopAudio(NAME_OF_AUDIO_NOTIFICATIONS[1], true);
    
    //TODO set the correct delay in order to not feel the gap between the first and the second part of the sentence
    delay(3000);
        
    if(isKilled) return;
    playStopAudio(letterToWrite, true);
    
    delay(300);
    
    if(isKilled) return;
    
    waitingForInput = true;
  }
  
  public void runAtLetterTyped(String letterTyped){
    if(waitingForInput == true){
      
      if(isKilled) return;
          
      // give a little bit of time at the sound of the letter typed general feedback
      delay(300);
      
      if(letterTyped == letterToWrite){
        // Success audio
        playStopAudio(NAME_OF_AUDIO_NOTIFICATIONS[2], true);
        isSuccess = true;
      }
      else{
        // Fail audio
        playStopAudio(NAME_OF_AUDIO_NOTIFICATIONS[3], true);
      }
      delay(300);
      
      tickSelfAsFinished();
    }
  }
}


public class Braille_WordWritingExercise extends BrailleProcess{
  public String wordToWrite;
  public boolean waitingForInput = false;
  public int indexOfLetterTyped = 0;
  public Braille_WordWritingExercise(String _wordToWrite){
    super(BrailleProcessType.WordWritingExercise);
    
    if(_wordToWrite==""){
      _wordToWrite = chooseRandomWord();
    }
    wordToWrite = _wordToWrite;
  }
  
  public void runAtStart(){
    // introduce the exercise with audio: typeInSequenceTheLetterInBrailleToComposeTheWord
    playStopAudio(NAME_OF_AUDIO_NOTIFICATIONS[4], true);
    
    //TODO set the correct delay in order to not feel the gap between the first and the second part of the sentence
    delay(3000);
        
    if(isKilled) return;
    playStopAudio(wordToWrite, true);
    
    delay(300);
    
    if(isKilled) return;
    
    waitingForInput = true;
  }
  
  public void runAtLetterTyped(String letterTyped){
    if(waitingForInput == true){
      
      if(isKilled) return;
          
      if(letterTyped != str(wordToWrite.charAt(indexOfLetterTyped))){
        
        // fail audio
        playStopAudio(NAME_OF_AUDIO_NOTIFICATIONS[3], true);
        delay(300);
        
        tickSelfAsFinished();
      }
      else{
        indexOfLetterTyped++;
        if(indexOfLetterTyped>= wordToWrite.length()){
          // Success audio
          playStopAudio(NAME_OF_AUDIO_NOTIFICATIONS[2], true);
          delay(300);
          isSuccess = true;
          
          tickSelfAsFinished();
        }
      }
    }
  }
}


public class Braille_WordHapticPresentation extends BrailleProcess{
  public String wordToPresent;
  public Braille_WordHapticPresentation(String _wordToPresent){
    super(BrailleProcessType.WordHapticPresentation);
    if(_wordToPresent==""){
      _wordToPresent = chooseRandomWord();
    }
    wordToPresent = _wordToPresent;
  }
  public void runAtStart(){
    // introduce the exercise with audio: getReadyToFeelTheSequenceOfWord
    playStopAudio(NAME_OF_AUDIO_NOTIFICATIONS[5], true);
    
    delay(2000);
    
    playStopAudio(wordToPresent, true);
    
    delay(2000);
    
    if(isKilled) return;
    
    for(int i=0; i<wordToPresent.length(); i++){
      var letter = str(wordToPresent.charAt(i));
      
      ServoMotorsPerformLetter(letter);
    
      delay(MAX_DELAY_TO_WAIT_SERVO_MOTORS_MOVEMENT);
      if(isKilled) return;
      playStopAudio(letter, true);

      delay(500);
      
      if(isKilled) return;
    }
    
    tickSelfAsFinished();
  }
  
  public void onKill(){
    
    ServoMotorsPerformLetter("-");
          
    super.onKill();
  }
}



public class Braille_DialogPeerToPeer extends BrailleProcess{
  public Braille_DialogPeerToPeer(){
    super(BrailleProcessType.DialogPeerToPeer);
  }
  public void runAtStart(){
    
    //introducitionToPeerToPeerDialog
    playStopAudio(NAME_OF_AUDIO_NOTIFICATIONS[6], true);
  }
  
  public void runAtLetterTyped(String letterTyped){
    ServoMotorsPerformLetter(letterTyped);
  }
  
  public void onKill(){
    
    ServoMotorsPerformLetter("-");
          
    super.onKill();
  }
}




public class Braille_UploadMainFlowOfProcesses extends BrailleProcess{
 
  String wordOfTheLesson;
  public Braille_UploadMainFlowOfProcesses(){
    super(BrailleProcessType.UploadMainFlowOfProcesses);
    
    wordOfTheLesson = chooseRandomWord();
  }
  public void runAtStart(){
    
    var wordWithoutLettersRepeted = removeDuplicates(wordOfTheLesson);
        
    int numbOfProcesses = 6 + wordWithoutLettersRepeted.length();
    
    var newListOfProcesses = new BrailleProcess[5];
    
    // Audionotification introducition To Game Flow: NowWeAreGoingToLearnHowToTranslateTheWord
    newListOfProcesses[numbOfProcesses -1] = new Braille_AudioNotification(NAME_OF_AUDIO_NOTIFICATIONS[7], 3000);
    
    newListOfProcesses[numbOfProcesses -2] = new Braille_AudioNotification(wordOfTheLesson, -1);
    
    newListOfProcesses[numbOfProcesses -3] = new Braille_WordHapticPresentation(wordOfTheLesson);
    
    // Audionotification introducition To The Letter by letter translation: LetSCheckHowGoodAreWithTheTranslations
    newListOfProcesses[numbOfProcesses -4] = new Braille_AudioNotification(NAME_OF_AUDIO_NOTIFICATIONS[8], -1);
    
    for(int i=0; i<wordWithoutLettersRepeted.length(); i++){
        if(i%2==0){
          newListOfProcesses[numbOfProcesses -5 -i] = new Braille_LetterReadingExercise(str(wordWithoutLettersRepeted.charAt(i)));
        }
        else{
          newListOfProcesses[numbOfProcesses -5 -i] = new Braille_LetterWritingExercise(str(wordWithoutLettersRepeted.charAt(i)));
        }
    }
    
    // Audionotification : PerfectNowTryToCompleteYourWord
    newListOfProcesses[1] = new Braille_AudioNotification(NAME_OF_AUDIO_NOTIFICATIONS[9], 1000);
    
    newListOfProcesses[0] = new Braille_WordWritingExercise(wordOfTheLesson);
    
    
    setNewChainOfProcesses(newListOfProcesses);
  }
}
