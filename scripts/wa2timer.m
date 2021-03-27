//Feel free to steal and/or modify.
//If you're coming from the WACUP forums, do kindly give credit to
//"Eris Lund (0x5066)" or "0x5066", or don't! I don't mind.
//As of this writing there's a strange bug with streamed/endless VGM playback
//where clicking on the timer still appends a "-", I'm hoping to fix this soon.

#include "lib/std.mi"

Global String digits;
Global GuiObject DisplayTime, DisplayTimeShade;
Global Timer timerSongTimer;
Global Timer timerSongTimerReverse;

Global PopUpMenu clockMenu;

Function AreWePlaying();
Function InReverse();
Function TimeElapsedOrRemaining();
Function setTimer(int timermode);
Function StaticTime();
Function StaticTimeRemainder();

System.onScriptLoaded() 
{
    Group mainshade = getContainer("Main").getLayout("Shade");
    /* Replace "timer" with "shade.time" for Winamp Classic Modern */
    DisplayTimeShade = mainshade.findObject("shade.time");

    Group mainnormal = getContainer("Main").getLayout("Normal");
    /* Replace "timer" with "display.time" for Winamp Classic Modern */
    DisplayTime = mainnormal.findObject("display.time");
    //The above was taken from Ariszló's updated oldtimer.maki script
    //Allows it to be included in the skin.xml file of the skin

  	timerSongTimer = new Timer;
	timerSongTimer.setDelay(50);
    timerSongTimerReverse = new Timer;
    timerSongTimerReverse.setDelay(50);

    setTimer(getPrivateInt(getSkinName(), "TimerElapsedRemaining", 1));
    TimeElapsedOrRemaining();
}

TimeElapsedOrRemaining()
{
    int timermode = getPrivateInt(getSkinName(), "TimerElapsedRemaining", 1);
    setTimer(timermode);
}

DisplayTime.onRightButtonUp (int x, int y){
    int timermode = getPrivateInt(getSkinName(), "TimerElapsedRemaining", 1);

  	clockMenu = new PopUpMenu;
  	  
	clockMenu.addcommand("Time elapsed", 1, timermode == 1,0);
	clockMenu.addcommand("Time remaining", 2, timermode == 2,0);
  	
	timermode = clockMenu.popAtMouse();
 
	setTimer(timermode);
	
	complete;
}

DisplayTimeShade.onRightButtonUp (int x, int y){
    int timermode = getPrivateInt(getSkinName(), "TimerElapsedRemaining", 1);

  	clockMenu = new PopUpMenu;
  	  
	clockMenu.addcommand("Time elapsed", 1, timermode == 1,0);
	clockMenu.addcommand("Time remaining", 2, timermode == 2,0);
  	
	timermode = clockMenu.popAtMouse();
 
	setTimer(timermode);

	complete;
}

DisplayTime.onLeftButtonDown(int x, int y)
{
    int timermode = getPrivateInt(getSkinName(), "TimerElapsedRemaining", 1);

    timermode++;

    if (timermode == 3){
        timermode = 1;
    }
    setTimer(timermode);
    complete;
}

DisplayTimeShade.onLeftButtonDown(int x, int y)
{
    int timermode = getPrivateInt(getSkinName(), "TimerElapsedRemaining", 1);

    timermode++;

    if (timermode == 3){
        timermode = 1;
    }
    setTimer(timermode);
    complete;
}

//Here we run these checks every time a playback related action happens
//It's not enough to check on title change
System.onPlay(){
    int songlength = System.getPlayItemLength();
    int timermode = getPrivateInt(getSkinName(), "TimerElapsedRemaining", 1);

    TimeElapsedOrRemaining();
    if (timermode == 2){
        if(songlength <= 0){
            StaticTime();
            timerSongTimerReverse.stop();
            timerSongTimer.start();
//We do this to check if what we're currently playing is a stream/endless VGM track
//as trying to display the time remaining is pointless and only adds a "-", so we
//force to start the timer for the "Time Elapsed" mode if that is the case
        }
        else{
            StaticTimeRemainder();
            timerSongTimer.stop();
            timerSongTimerReverse.start();
//otherwise, display the time remaining
        }
    }
}

System.onPause(){
    int songlength = System.getPlayItemLength();
    int timermode = getPrivateInt(getSkinName(), "TimerElapsedRemaining", 1);

    TimeElapsedOrRemaining();
    if (timermode == 2){
        if(songlength <= 0){
            StaticTime();
            timerSongTimerReverse.stop();
            timerSongTimer.start();
        }
        else{
            StaticTimeRemainder();
            timerSongTimer.stop();
            timerSongTimerReverse.start();
        }
    }
}

System.onResume(){
    int songlength = System.getPlayItemLength();
    int timermode = getPrivateInt(getSkinName(), "TimerElapsedRemaining", 1);

    TimeElapsedOrRemaining();
    if (timermode == 2){
        if(songlength <= 0){
            StaticTime();
            timerSongTimerReverse.stop();
            timerSongTimer.start();
        }
        else{
            StaticTimeRemainder();
            timerSongTimer.stop();
            timerSongTimerReverse.start();
        }
    }
}

System.onInfoChange(String info){
    int songlength = System.getPlayItemLength();
    int timermode = getPrivateInt(getSkinName(), "TimerElapsedRemaining", 1);

    TimeElapsedOrRemaining();
    if (timermode == 2){
        if(songlength <= 0){
            StaticTime();
            timerSongTimerReverse.stop();
            timerSongTimer.start();
        }
        else{
            StaticTimeRemainder();
            timerSongTimer.stop();
            timerSongTimerReverse.start();
        }
    }
}

//We stop every timer and instead display Winamp Modern's default of "00:00"
//In this case it's "  :  "
System.onStop(){
    TimeElapsedOrRemaining();
    timerSongTimer.stop();
    timerSongTimerReverse.stop();
    DisplayTime.setXmlParam("text", "  :  ");
    DisplayTimeShade.setXmlParam("text", "  :  ");
}

StaticTime(){ //Needed since the timer has a delay of 50ms and we don't want any odd flashing on loading
    int milliseconds = System.getPosition();
    String currentpos = System.integerToTime(milliseconds);

    if(milliseconds < 600000){
        DisplayTime.setXmlParam("text", "0"+currentpos);
        DisplayTimeShade.setXmlParam("text", "0"+currentpos);
    }
    else{
        DisplayTime.setXmlParam("text", currentpos);
        DisplayTimeShade.setXmlParam("text", currentpos);
    }
}

StaticTimeRemainder(){ //Needed since the timer has a delay of 50ms and we don't want any odd flashing on loading
    int milliseconds = System.getPosition();
    int songlength = System.getPlayItemLength();
    int remainder = songlength - milliseconds;
    int milliseconds_rev = milliseconds-songlength;
    String strremainder = System.integerToTime(remainder);
    String currentpos_rev = System.integerToTime(milliseconds-songlength);

//The purpose of this check is to ensure we properly place
//a "0" if we happen to be below 600000ms, or 10 minutes
//If we are above 600000ms or 10 minutes, don't append a "0"
    if(remainder < 600000){
        DisplayTime.setXmlParam("text", "-0"+strremainder);
        DisplayTimeShade.setXmlParam("text", "-0"+strremainder);
    }
    else{
        DisplayTime.setXmlParam("text", "-"+strremainder);
        DisplayTimeShade.setXmlParam("text", "-"+strremainder);
    }
//In case of plugins providing a way to play outside the song's original length
//and the user just so happened to have time remaining enabled, we want to
//ensure they still get the proper time position displayed, even if it's irrelevant.
//Winamp 2/Winamp Classic do this.
    if(milliseconds > songlength){
        if(milliseconds_rev < 600000){
            DisplayTime.setXmlParam("text", "-0"+currentpos_rev);
            DisplayTimeShade.setXmlParam("text", "-0"+currentpos_rev);
        }
        else{
            DisplayTime.setXmlParam("text", "-"+currentpos_rev);
            DisplayTimeShade.setXmlParam("text", "-"+currentpos_rev);
        }
    }
}

timerSongTimer.onTimer(){
    int milliseconds = System.getPosition();
    String currentpos = System.integerToTime(milliseconds);

//The purpose of this check is to ensure we properly place
//a "0" if we happen to be below 600000ms, or 10 minutes
//If we are above 600000ms or 10 minutes, don't append a "0"
    if(milliseconds < 600000){
        DisplayTime.setXmlParam("text", "0"+currentpos);
        DisplayTimeShade.setXmlParam("text", "0"+currentpos);
    }
    else{
        DisplayTime.setXmlParam("text", currentpos);
        DisplayTimeShade.setXmlParam("text", currentpos);
    }
}

timerSongTimerReverse.onTimer(){
    int milliseconds = System.getPosition();
    int songlength = System.getPlayItemLength();
    int remainder = songlength - milliseconds;
    int milliseconds_rev = milliseconds-songlength;
    String strremainder = System.integerToTime(remainder);
    String currentpos_rev = System.integerToTime(milliseconds-songlength);

//The purpose of this check is to ensure we properly place
//a "0" if we happen to be below 600000ms, or 10 minutes
//If we are above 600000ms or 10 minutes, don't append a "0"
    if(remainder < 600000){
        DisplayTime.setXmlParam("text", "-0"+strremainder);
        DisplayTimeShade.setXmlParam("text", "-0"+strremainder);
    }
    else{
        DisplayTime.setXmlParam("text", "-"+strremainder);
        DisplayTimeShade.setXmlParam("text", "-"+strremainder);
    }
//The purpose of this check is to ensure we properly place
//a "0" if we happen to be below 600000ms, or 10 minutes
//If we are above 600000ms or 10 minutes, don't append a "0"
    if(milliseconds > songlength){
        if(milliseconds_rev < 600000){
            DisplayTime.setXmlParam("text", "-0"+currentpos_rev);
            DisplayTimeShade.setXmlParam("text", "-0"+currentpos_rev);
        }
        else{
            DisplayTime.setXmlParam("text", "-"+currentpos_rev);
            DisplayTimeShade.setXmlParam("text", "-"+currentpos_rev);
        }
    }
}

AreWePlaying() {
//Just some sanity checks to ensure we're in the right modes
    if (getStatus() == -1){ //Paused
        timerSongTimerReverse.stop();
        StaticTime();
        timerSongTimer.start();         
	}
    else if (getStatus() == 0){ //Stopped
        timerSongTimerReverse.stop();
        timerSongTimer.stop();
        DisplayTime.setXmlParam("text", "  :  ");
        DisplayTimeShade.setXmlParam("text", "  :  ");
	}
	else if (getStatus() == 1){ //Playing
        timerSongTimerReverse.stop();
        StaticTime();
        timerSongTimer.start();   
	}
}

InReverse(){
//Just some sanity checks to ensure we're in the right modes
    int songlength = System.getPlayItemLength();

//In case of streams or VGM formats with endless playback
//We don't want the user to still be able to toggle
//between time remaining or elapsed, so we force
//the elapsed mode to run
//This has now been actually fixed
    if(songlength <= 0){
        if (getStatus() == -1){ //Paused
            StaticTime();
            timerSongTimerReverse.stop();  
            timerSongTimer.start();
	    }
    else if (getStatus() == 0){ //Stopped
            timerSongTimer.stop();
            timerSongTimerReverse.stop();
            DisplayTime.setXmlParam("text", "  :  ");
            DisplayTimeShade.setXmlParam("text", "  :  ");
	    }
	    else if (getStatus() == 1){ //Playing
            StaticTime();
            timerSongTimerReverse.stop();  
            timerSongTimer.start();  
	    }
    }
    else{
        if (getStatus() == -1){ //Paused
            timerSongTimer.stop();
            StaticTimeRemainder();
            timerSongTimerReverse.start();      
		}
    else if (getStatus() == 0){ //Stopped
            timerSongTimer.stop();
            timerSongTimerReverse.stop();
            DisplayTime.setXmlParam("text", "  :  ");
            DisplayTimeShade.setXmlParam("text", "  :  ");
		}
	else if (getStatus() == 1){ //Playing
            timerSongTimer.stop();
            StaticTimeRemainder();
            timerSongTimerReverse.start();   
	    }
    }
}

setTimer(int timermode){
    if(timermode>=1 && timermode<=2){ //i fucking hate building menus
	    if (timermode == 1){
            AreWePlaying();
	    }
	    else if (timermode == 2){
            InReverse();
        }
	    setPrivateInt(getSkinName(), "TimerElapsedRemaining", timermode);
    }
}