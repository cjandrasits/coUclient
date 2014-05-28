part of couclient;

UserInterface display = new UserInterface();
class UserInterface {
  
  //NumberFormat for having commas in the currants and iMG displays
  NumberFormat commaFormatter = new NumberFormat("#,###");
  
  Storage session = window.sessionStorage;
  Storage local = window.localStorage;
  
  // If you need to change an element somewhere else, put the declaration in this class.
  // You can then access it with 'ui.yourElement'. This way we keep everything in one spot
  /////////////////////ELEMENTS//////////////////////////////////////////////
  // you won! element
  Element youWon = querySelector('#youWon');

  // Initial play button
  Element playButton = querySelector('#playButton');
  
  // Initial loading screen elements
  Element loadStatus = querySelector("#loading #loadstatus");
  Element loadStatus2 = querySelector("#loading #loadstatus2");
  Element loadingScreen = querySelector('#loading'); 
  
  // Name Meter Variables
  Element nameElement = querySelector('#playerName'); 

  // Time Meter Variables
  Element currDay = querySelector('#currDay'); 
  Element currTime = querySelector('#currTime'); 
  Element currDate = querySelector('#currDate'); 

  // Location and Map elements
  Element currLocation = querySelector('#currLocation'); 
  Element mapButton = querySelector('#mapButton');
  
  // Settings Glyph
  Element settingsButton = querySelector('#settingsGlyph');
  
  // Currant Meter Variables
  Element currantElement = querySelector('#currCurrants'); 

  // Img Meter Variables
  Element imgElement = querySelector('#currImagination');

  // Inventory Management
  Element inventorySearch = querySelector('#inventorySearch');
  
  // Pause button
  Element pauseButton = querySelector('#thinkButton');
  Element pauseMenu = querySelector('#pauseMenu');

  // bugreport button
  Element bugButton = querySelector('#bugGlyph');
  Element consoleText = querySelector('.dialog.console');
  
  // world Element
  Element worldElement = querySelector('#world');
  
  // Music Meter Variables
  Element titleElement = querySelector('#trackTitle'); 
  Element artistElement = querySelector('#trackArtist'); 
  AnchorElement SClinkElement = querySelector('#SCLink'); 
  Element volumeGlyph = querySelector('#volumeGlyph');
  InputElement volumeSlider = querySelector('#volumeSlider *');
  

  // Energy Meter Variables
  Element energymeterImage = querySelector('#energyDisks .green'); 
  Element energymeterImageLow = querySelector('#energyDisks .red'); 
  Element currEnergyText = querySelector('#currEnergy'); 
  Element maxEnergyText = querySelector('#maxEnergy'); 

  // Mood Meter Variables
  Element moodmeterImageLow =  querySelector('#leftDisk .hurt'); 
  Element moodmeterImageEmpty = querySelector('#leftDisk .dead'); 
  Element currMoodText = querySelector('#moodMeter .fraction .curr'); 
  Element maxMoodText = querySelector('#moodMeter .fraction .max'); 
  Element moodPercent = querySelector('#moodMeter .percent .number'); 
  /////////////////////ELEMENTS//////////////////////////////////////////////
  
  
  // Declare/Set initial variables here
  /////////////////////VARS//////////////////////////////////////////////////
  String name = 'null';
  
  String location = 'null';
  
  int energy = 100;
  int maxenergy = 100;  
  
  int mood = 100;
  int maxmood = 100;
  
  int currants = 0;  
  
  int img = 0;
  
  bool muted = false;
  int volume = 0;
  String SCsong = '-';
  String SCartist = '-';
  String SClink = '';
  
  /////////////////////VARS//////////////////////////////////////////////////
  // start listening for events
  init(){   
    
    // Load saved volume level
    if (local['volume'] != null) {
      volume = int.parse(local['volume']);
    }
    else
      volume = 10;
    
    // The 'you won' splash
    window.onBeforeUnload.listen((_) {
      youWon.hidden = false;
    });
    
    
    // Close button listener, closes popup windows
    for (Element e in querySelectorAll('.fa-times.close'))
    e.onClick.listen((MouseEvent m){
      e.parent.hidden = true;
    });
        
    // Starts the game
    playButton.onClick.listen((_) {
      loadingScreen.style.opacity = '0';
      sound.play('game_loaded');
      new Timer(new Duration(seconds:1),() {
        loadingScreen.remove();
        }
      );
    });
    
    // Listens for the map button
    mapButton.onClick.listen((_) {
      openWindow('map');
    });    
    
    // Listens for the settings button
    settingsButton.onClick.listen((_) {
      openWindow('settings');
    });   
    
    // Listens for the bug report button
    bugButton.onClick.listen((_) {
      Element w = openWindow('bugs/suggestions');
      TextAreaElement input = w.querySelector('textarea');
      input.value = 'UserAgent:' + window.navigator.userAgent +
          '\n////////////////////////////////\n Console Log: \n' + consoleText.text + '\n////////////////////////////////\n';
    
      // Submits the Bug
       w.querySelector('.button').onClick.listen((_) {
        Map message = new Map()
          ..['text'] = input.value.replaceAll(';', '\n');
        String json = JSON.encoder.convert(message); 
        Map m = new Map();
        m['payload'] = json;
        HttpRequest.postFormData('https://cou.slack.com/services/hooks/incoming-webhook?token=Ey3SlsfyOlJjw0sHl0N0UuMK',
           m).then((HttpRequest request){
             request.onReadyStateChange.listen((response) => display.print(response.toString()));
         }).catchError((error) {
             display.print(error.target.responseText);
         });
        w.hidden = true;
      });   
    });  
    
    // Listens for the inventory search button
    inventorySearch.onClick.listen((_) {
      openWindow('bag');
    });
    
    // Listens for the pause button
    pauseButton.onClick.listen((_) {
      pauseMenu.hidden = false;
    });  
    
    
    // Controls the volume slider and glyph
    volumeGlyph.onClick.listen((_) {
      if (session['volume'] == null)
        session['volume'] = '5';
      if (muted == true) {
        volume = int.parse(session['volume']);
        muted = false;
        volumeSlider.value = volume.toString();
      }
      else if (muted == false) {
        session['volume'] = volume.toString();
        muted = true;
        volumeSlider.value = '0';
      }
    });
    
    // display buttons
    
    sound.init().then((_) {
      for (Element button in loadingScreen.querySelectorAll('.button'))
        button.hidden = false;
      loadingScreen.querySelector('.fa').hidden = true;  
    });
  }

  print(message) {
    display.consoleText.innerHtml += message.toString() + ';<br>';
  }
  
  // update the userinterface
  update(){    
    // Update Clock
    List data = getDate();
    
    if (data[4] != currTime.text) {
      currDay.text = data[3].toString();
      currTime.text = data[4];
      currDate.text = data[2].toString() + ' of ' + data[1].toString();
    }

    // Update img display
    if (commaFormatter.format(img) != imgElement.text)
    imgElement.text = commaFormatter.format(img);
    
    
    
    // Update currant display
    if (commaFormatter.format(currants) != currantElement.text)
    currantElement.text = commaFormatter.format(currants);
    
    // Update mood elements
    if(maxmood <= 0) {
      maxmood = 1;   }
    if (mood.toString() != currMoodText.text || maxmood.toString() != maxMoodText.text) {
      currMoodText.text=mood.toString();
      maxMoodText.text=maxmood.toString();
      moodPercent.text=((100*((mood/maxmood))).toInt()).toString();
      moodmeterImageLow.style.opacity = ((0.7-(mood/maxmood))).toString();
      if (mood <= 0)
        moodmeterImageEmpty.style.opacity = 1.toString();
      else
        moodmeterImageEmpty.style.opacity = 0.toString();
    }

    // Update name display  
    if (name.length >= 17)
        name = name.substring(0, 15) + '...';
    if (name != nameElement.text)
      nameElement.text = name;
    
   
    // Update energy elements
    if(maxenergy <= 0) {
      maxenergy = 1;   }
    if (currEnergyText.text != energy.toString())
    currEnergyText.text = energy.toString();
    if (maxEnergyText.text != maxenergy.toString())
    maxEnergyText.text = maxenergy.toString();
    String angle = ( (120 - (energy/maxenergy)*120).toInt() ).toString();
    energymeterImage.style.transform = 'rotate(' +angle+ 'deg)';
    energymeterImageLow.style.transform = 'rotate(' +angle+ 'deg)';
    energymeterImageLow.style.opacity = ((1-(energy/maxenergy))).toString();
    
    // Update the location text
    if (location.length >= 20)
            location = location.substring(0, 17) + '...';
    if (location != currLocation.text)
          currLocation.text = location;
    
    
    // Update the audio icon
    if (muted == true && volumeGlyph.classes.contains('fa-volume-up')) {
      volumeGlyph.classes
        ..remove('fa-volume-up')
        ..add('fa-volume-off');
    }
    if (muted == false && volumeGlyph.classes.contains('fa-volume-off')) {
      volumeGlyph.classes
        ..remove('fa-volume-off')
        ..add('fa-volume-up');
    }
    
    // Update the volume slider
    if (int.parse(volumeSlider.value) == 0)
      muted = true;
    else
      muted = false;
    if (volume != int.parse(volumeSlider.value)) {
      volume = int.parse(volumeSlider.value);
      print('volume:$volume');
    }

    
    // Updates the stored volume level
    if (volume.toString() != local['volume'] && muted == false)
    local['volume'] = volume.toString();
    
    // Update all audioElements to the correct volume
    for (AudioElement audio in querySelectorAll('audio')) {
      if (audio.volume != display.volume/100)
      audio.volume = display.volume/100;
    
    
    
    
    // Update the soundcloud widget
    if (SCsong != titleElement.text)
    titleElement.text = SCsong;
    if (SCartist != artistElement.text)
    artistElement.text = SCartist;   
    if (SClink != SClinkElement.href)
      SClinkElement.href = SClink;

    }
    
  }

  Element openWindow(String title) {
    for (Element window in querySelectorAll('.window')) {
      window.hidden = true;
    }
    for (Element window in querySelectorAll('.window')) {
      if (window.querySelector('header').text.toLowerCase().trim() == title) {
        window.hidden = false;
        return window;
      }
    }
    return null;
  }
}




