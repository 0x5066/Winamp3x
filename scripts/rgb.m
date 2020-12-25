//maybe i'll come back to this - 0x5066
#ifndef included
#error This script can only be compiled as a #include
#endif

//rgb mess
Global Timer rgbTimer, rgbBandTimer1, rgbBandTimer2, rgbBandTimer3, rgbBandTimer4, rgbBandTimer5, rgbBandTimer6, rgbBandTimer7, rgbBandTimer8, rgbBandTimer9, rgbBandTimer10, rgbBandTimer11, rgbBandTimer12, rgbBandTimer13, rgbBandTimer14, rgbBandTimer15, rgbBandTimer16;

Global int r1;
Global int g1;
Global int b1;

Global int rgb_val;
Global int nextTimer;
Global int banddelay;

//Global String prev2, prev3, prev4, prev5, prev6, prev7, prev8, prev9, prev10, prev11, prev12, prev13, prev14, prev15, prev16;

System.onScriptLoaded()
{
    //more rgb junk
  banddelay = 66;

  rgbTimer = new Timer;
  rgbTimer.setDelay(10);
  rgbBandTimer1 = new Timer;
  rgbBandTimer1.setDelay(banddelay);
  rgbBandTimer2 = new Timer;
  rgbBandTimer2.setDelay(banddelay);
  rgbBandTimer3 = new Timer;
  rgbBandTimer3.setDelay(banddelay);
  rgbBandTimer4 = new Timer;
  rgbBandTimer4.setDelay(banddelay);
  rgbBandTimer5 = new Timer;
  rgbBandTimer5.setDelay(banddelay);
  rgbBandTimer6 = new Timer;
  rgbBandTimer6.setDelay(banddelay);
  rgbBandTimer7 = new Timer;
  rgbBandTimer7.setDelay(banddelay);
  rgbBandTimer8 = new Timer;
  rgbBandTimer8.setDelay(banddelay);
  rgbBandTimer9 = new Timer;
  rgbBandTimer9.setDelay(banddelay);
  rgbBandTimer10 = new Timer;
  rgbBandTimer10.setDelay(banddelay);
  rgbBandTimer11 = new Timer;
  rgbBandTimer11.setDelay(banddelay);
  rgbBandTimer12 = new Timer;
  rgbBandTimer12.setDelay(banddelay);
  rgbBandTimer13 = new Timer;
  rgbBandTimer13.setDelay(banddelay);
  rgbBandTimer14 = new Timer;
  rgbBandTimer14.setDelay(banddelay);
  rgbBandTimer15 = new Timer;
  rgbBandTimer15.setDelay(banddelay);
  rgbBandTimer16 = new Timer;
  rgbBandTimer16.setDelay(banddelay);

  r1 = 255;
  g1 = 0;
  b1 = 0;

  //255 is divisible by 1, 3, 5, 15, 17, 51, or 85
  rgb_val = 51;

  //prev2 = "255, 0, 0";
  //prev3 = "255, 0, 0";
  //prev4 = "255, 0, 0";
  //prev5 = "255, 0, 0";
  //prev6 = "255, 0, 0";
  //prev7 = "255, 0, 0";
  //prev8 = "255, 0, 0";
  //prev9 = "255, 0, 0";
  //prev10 = "255, 0, 0";
  //prev11 = "255, 0, 0";
  //prev12 = "255, 0, 0";
  //prev13 = "255, 0, 0";
  //prev14 = "255, 0, 0";
  //prev15 = "255, 0, 0";
  //prev16 = "255, 0, 0";

		rgbBandTimer1.stop();
		rgbBandTimer2.stop();
		rgbBandTimer3.stop();
		rgbBandTimer4.stop();
		rgbBandTimer5.stop();
		rgbBandTimer6.stop();
		rgbBandTimer7.stop();
		rgbBandTimer8.stop();
		rgbBandTimer9.stop();
		rgbBandTimer10.stop();
		rgbBandTimer11.stop();
		rgbBandTimer12.stop();
		rgbBandTimer13.stop();
		rgbBandTimer14.stop();
		rgbBandTimer15.stop();
		rgbBandTimer16.stop();
		rgbTimer.stop();

}


rgbTimer.onTimer(){
	if(nextTimer==1){rgbBandTimer1.start();}
	else if(nextTimer==2){rgbBandTimer2.start();}
	else if(nextTimer==3){rgbBandTimer3.start();}
	else if(nextTimer==4){rgbBandTimer4.start();}
	else if(nextTimer==5){rgbBandTimer5.start();}
	else if(nextTimer==6){rgbBandTimer6.start();}
	else if(nextTimer==7){rgbBandTimer7.start();}
	else if(nextTimer==8){rgbBandTimer8.start();}
	else if(nextTimer==9){rgbBandTimer9.start();}
	else if(nextTimer==10){rgbBandTimer10.start();}
	else if(nextTimer==11){rgbBandTimer11.start();}
	else if(nextTimer==12){rgbBandTimer12.start();}
	else if(nextTimer==13){rgbBandTimer13.start();}
	else if(nextTimer==14){rgbBandTimer14.start();}
	else if(nextTimer==15){rgbBandTimer15.start();}
	else if(nextTimer==16){rgbBandTimer16.start(); rgbTimer.stop();}

	nextTimer++;
}

rgbBandTimer1.onTimer(){
	visualizer.setXmlParam("ColorBand1", ""+integerToString(r1)+","+integerToString(g1)+","+integerToString(b1)+"");
	visualizer.setXmlParam("colorbandpeak", visualizer.getXmlParam("ColorBand15"));

	//TDText.setXmlParam("text",""+integerToString(r1)+","+integerToString(g1)+","+integerToString(b1));

	//do the math

	if(r1==255 && b1==0){g1+=rgb_val;}
	if(g1==255 && b1==0){r1-=rgb_val;}
	if(g1==255 && r1==0){b1+=rgb_val;}
	if(b1==255 && r1==0){g1-=rgb_val;}
	if(b1==255 && g1==0){r1+=rgb_val;}
	if(r1==255 && g1==0){b1-=rgb_val;}

	//if rgb_val is 1, 3, 5, 15, 17, 51, or 85 this code is useless
	/*
	if(r1>255)r1=255;
	if(g1>255)g1=255;
	if(b1>255)b1=255;
	if(r1<0)r1=0;
	if(g1<0)g1=0;
	if(b1<0)b1=0;
	*/
}

rgbBandTimer2.onTimer(){
	visualizer.setXmlParam("ColorBand2", visualizer.getXmlParam("ColorBand1"));
}

rgbBandTimer3.onTimer(){
	visualizer.setXmlParam("ColorBand3", visualizer.getXmlParam("ColorBand2"));
}

rgbBandTimer4.onTimer(){
	visualizer.setXmlParam("ColorBand4", visualizer.getXmlParam("ColorBand3"));
}

rgbBandTimer5.onTimer(){
	visualizer.setXmlParam("ColorBand5", visualizer.getXmlParam("ColorBand4"));
}

rgbBandTimer6.onTimer(){
	visualizer.setXmlParam("ColorBand6", visualizer.getXmlParam("ColorBand5"));
}

rgbBandTimer7.onTimer(){
	visualizer.setXmlParam("ColorBand7", visualizer.getXmlParam("ColorBand6"));
}

rgbBandTimer8.onTimer(){
	visualizer.setXmlParam("ColorBand8", visualizer.getXmlParam("ColorBand7"));
}

rgbBandTimer9.onTimer(){
	visualizer.setXmlParam("ColorBand9", visualizer.getXmlParam("ColorBand8"));
}

rgbBandTimer10.onTimer(){
	visualizer.setXmlParam("ColorBand10", visualizer.getXmlParam("ColorBand9"));
}

rgbBandTimer11.onTimer(){
	visualizer.setXmlParam("ColorBand11", visualizer.getXmlParam("ColorBand10"));
}

rgbBandTimer12.onTimer(){
	visualizer.setXmlParam("ColorBand12", visualizer.getXmlParam("ColorBand11"));
}

rgbBandTimer13.onTimer(){
	visualizer.setXmlParam("ColorBand13", visualizer.getXmlParam("ColorBand12"));
}

rgbBandTimer14.onTimer(){
	visualizer.setXmlParam("ColorBand14", visualizer.getXmlParam("ColorBand13"));
}

rgbBandTimer15.onTimer(){
	visualizer.setXmlParam("ColorBand15", visualizer.getXmlParam("ColorBand14"));
}


rgbBandTimer16.onTimer(){
	visualizer.setXmlParam("ColorBand16", visualizer.getXmlParam("ColorBand15"));
}