#include "lib/std.mi"

Function refreshVisSettings();
Function setVis (int mode);
Function ProcessMenuResult (int a);

Function setColorBands (String rgb, int start, int end);									//set bands color in range (1-16)				rgb value("0,255,127"), start position(4), end position(12)
Function setColorBandsOdd (String rgb);														//set odd bands color							rgb value("0,255,127")
Function setColorBandsEven (String rgb);													//set even bands color							rgb value("0,255,127")
Function setColorBandsGradient(int r, int g, int b, int stepr, int stepg, int stepb);		//set color bands to a gradient					red(0), green(255), blue(127), step red(10), step green(-5), step blue(+2)
Function setColorosc (String rgb);															//set oscilloscope color						rgb value("0,255,127")
Function setColoroscRange (String rgb, int start, int end);									//set oscilloscope color in range (1-5)			rgb value("0,255,127"), start position(1), end position(4)
Function setColoroscOdd (String rgb);														//set odd oscilloscope color					rgb value("0,255,127")
Function setColoroscEven (String rgb);														//set even oscilloscope color					rgb value("0,255,127")

Global Container containerMain;
Global Container containerPL;
Global Layout layoutPL, layoutMainNormal, layoutMainShade;
Global Group NormalGroupMain, NormalGroupDisplay, ShadeGroupMain, ShadeGroupDisplay;
Global Vis visualizer, visualizershade, visualizerpl;
Global Layer visgrid_thick, visgrid_thin, visgrid_car;
Global Button OAIDUBtnUE1, OAIDUBtnUE2, OAIDUBtnUE3;

Global PopUpMenu visMenu;
Global PopUpMenu specmenu;
Global PopUpMenu oscmenu;
Global PopUpMenu pksmenu;
Global PopUpMenu anamenu;
Global PopUpMenu stylemenu;
Global PopUpMenu fpsmenu;
Global PopUpMenu colmenu;
Global PopUpMenu wmpmenu;
Global PopUpMenu winmenu;
Global PopUpMenu animenu;
Global PopUpMenu gamemenu;
Global PopUpMenu plusmenu;
Global PopUpMenu gridmenu;
Global PopUpMenu waxpmenu;

Global Int currentMode, a_falloffspeed, p_falloffspeed, a_coloring, v_fps, v_color, grid;
Global Boolean show_peaks;
Global layer Trigger, HideForVic, TriggerBlocker, TriggerBlockerShade;

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
  containerMain = System.getContainer("winampvis");
	layoutMainNormal = containerMain.getLayout("winampvis2");
	NormalGroupMain = layoutMainNormal.findObject("i_hate_maki_sometimes");

	visualizer = NormalGroupMain.findObject("player.vis2");
	visgrid_thick = NormalGroupMain.findObject("visgridimg.thick");
	visgrid_thin = NormalGroupMain.findObject("visgridimg.thin");
	visgrid_car = NormalGroupMain.findObject("visgridimg.car");

//more rgb junk
  banddelay = 33;

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

	Trigger = NormalGroupMain.findObject("player.vis.trigger2");

	visualizer.setXmlParam("peaks", integerToString(show_peaks));
	visgrid_thick.setXmlParam("visible", integerToString(grid));
	visgrid_thin.setXmlParam("visible", integerToString(grid));
	visgrid_car.setXmlParam("visible", integerToString(grid));
	visualizer.setXmlParam("peakfalloff", integerToString(p_falloffspeed));
	visualizer.setXmlParam("falloff", integerToString(a_falloffspeed));
	visualizer.setXmlParam("fps", integerToString(v_fps));
	visualizer.setXmlParam("ColorBand1", integerToString(v_color));
	visualizer.setXmlParam("ColorBand2", integerToString(v_color));
	visualizer.setXmlParam("ColorBand3", integerToString(v_color));
	visualizer.setXmlParam("ColorBand4", integerToString(v_color));
	visualizer.setXmlParam("ColorBand5", integerToString(v_color));
	visualizer.setXmlParam("ColorBand6", integerToString(v_color));
	visualizer.setXmlParam("ColorBand7", integerToString(v_color));
	visualizer.setXmlParam("ColorBand8", integerToString(v_color));
	visualizer.setXmlParam("ColorBand9", integerToString(v_color));
	visualizer.setXmlParam("ColorBand10", integerToString(v_color));
	visualizer.setXmlParam("ColorBand11", integerToString(v_color));
	visualizer.setXmlParam("ColorBand12", integerToString(v_color));
	visualizer.setXmlParam("ColorBand13", integerToString(v_color));
	visualizer.setXmlParam("ColorBand14", integerToString(v_color));
	visualizer.setXmlParam("ColorBand15", integerToString(v_color));
	visualizer.setXmlParam("ColorBand16", integerToString(v_color));
	visualizer.setXmlParam("colorbandpeak", integerToString(v_color));
	visualizer.setXmlParam("colorosc1", integerToString(v_color));
	visualizer.setXmlParam("colorosc2", integerToString(v_color));
	visualizer.setXmlParam("colorosc3", integerToString(v_color));
	visualizer.setXmlParam("colorosc4", integerToString(v_color));
	visualizer.setXmlParam("colorosc5", integerToString(v_color));
	visualizer.setXmlParam("colorallbands", integerToString(v_color));

	refreshVisSettings ();
}

refreshVisSettings ()
{
	currentMode = getPrivateInt(getSkinName(), "Visualizer Mode2", 1);
	show_peaks = getPrivateInt(getSkinName(), "Visualizer show Peaks2", 1);
	grid = getPrivateInt(getSkinName(), "Visualizer show Grid2", 0);
	a_falloffspeed = getPrivateInt(getSkinName(), "Visualizer analyzer falloff2", 4);
	p_falloffspeed = getPrivateInt(getSkinName(), "Visualizer peaks falloff2", 0);
	a_coloring = getPrivateInt(getSkinName(), "Visualizer analyzer coloring2", 0);
	v_fps = getPrivateInt(getSkinName(), "Visualizer FPS2", 3);
	v_color = getPrivateInt(getSkinName(), "Visualizer Color themes2", 0);

	visualizer.setXmlParam("peaks", integerToString(show_peaks));
	visgrid_thick.setXmlParam("visible", integerToString(grid));
	visgrid_thin.setXmlParam("visible", integerToString(grid));
	visgrid_car.setXmlParam("visible", integerToString(grid));
	visualizer.setXmlParam("peakfalloff", integerToString(p_falloffspeed));
	visualizer.setXmlParam("falloff", integerToString(a_falloffspeed));
	visualizer.setXmlParam("fps", integerToString(v_fps));
	visualizer.setXmlParam("ColorBand1", integerToString(v_color));
	visualizer.setXmlParam("ColorBand2", integerToString(v_color));
	visualizer.setXmlParam("ColorBand3", integerToString(v_color));
	visualizer.setXmlParam("ColorBand4", integerToString(v_color));
	visualizer.setXmlParam("ColorBand5", integerToString(v_color));
	visualizer.setXmlParam("ColorBand6", integerToString(v_color));
	visualizer.setXmlParam("ColorBand7", integerToString(v_color));
	visualizer.setXmlParam("ColorBand8", integerToString(v_color));
	visualizer.setXmlParam("ColorBand9", integerToString(v_color));
	visualizer.setXmlParam("ColorBand10", integerToString(v_color));
	visualizer.setXmlParam("ColorBand11", integerToString(v_color));
	visualizer.setXmlParam("ColorBand12", integerToString(v_color));
	visualizer.setXmlParam("ColorBand13", integerToString(v_color));
	visualizer.setXmlParam("ColorBand14", integerToString(v_color));
	visualizer.setXmlParam("ColorBand15", integerToString(v_color));
	visualizer.setXmlParam("ColorBand16", integerToString(v_color));
	visualizer.setXmlParam("colorbandpeak", integerToString(v_color));
	visualizer.setXmlParam("colorosc1", integerToString(v_color));
	visualizer.setXmlParam("colorosc2", integerToString(v_color));
	visualizer.setXmlParam("colorosc3", integerToString(v_color));
	visualizer.setXmlParam("colorosc4", integerToString(v_color));
	visualizer.setXmlParam("colorosc5", integerToString(v_color));
	visualizer.setXmlParam("colorallbands", integerToString(v_color));

	if (a_coloring == 0)
	{
		visualizer.setXmlParam("coloring", "Normal");
	}
	else if (a_coloring == 1)
	{
		visualizer.setXmlParam("coloring", "Normal");
	}
	else if (a_coloring == 2)
	{
		visualizer.setXmlParam("coloring", "Fire");
	}
	else if (a_coloring == 3)
	{
		visualizer.setXmlParam("coloring", "Line");
	}
	
	if (v_fps == 0)
		{
			visualizer.setXmlParam("fps", "30");
		}
		else if (v_fps == 1)
		{
			visualizer.setXmlParam("fps", "30");
		}
		else if (v_fps == 2)
		{
			visualizer.setXmlParam("fps", "60");
		}
		else if (v_fps == 3)
		{
			visualizer.setXmlParam("fps", "75");
		}
		else if (v_fps == 4)
		{
			visualizer.setXmlParam("fps", "512");
		}
		else if (v_fps == 5)
		{
			visualizer.setXmlParam("fps", "120");
		}

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

	if (v_color == 0)
		{
			visualizer.setXmlParam("ColorBand1", "22,131,7");
			visualizer.setXmlParam("ColorBand2", "39,147,0");
			visualizer.setXmlParam("ColorBand3", "47,155,7");
			visualizer.setXmlParam("ColorBand4", "55,180,15");
			visualizer.setXmlParam("ColorBand5", "48,189,15");
			visualizer.setXmlParam("ColorBand6", "39,205,15");
			visualizer.setXmlParam("ColorBand7", "146,221,32");
			visualizer.setXmlParam("ColorBand8", "187,221,40");
			visualizer.setXmlParam("ColorBand9", "212,180,32");
			visualizer.setXmlParam("ColorBand10", "220,164,23");
			visualizer.setXmlParam("ColorBand11", "197,122,7");
			visualizer.setXmlParam("ColorBand12", "213,114,0");
			visualizer.setXmlParam("ColorBand13", "213,101,0");
			visualizer.setXmlParam("ColorBand14", "213,89,0");
			visualizer.setXmlParam("ColorBand15", "205,40,15");
			visualizer.setXmlParam("ColorBand16", "238,48,15");
			visualizer.setXmlParam("colorbandpeak", "150,150,150");
			visualizer.setXmlParam("colorosc1", "255,255,255");
			visualizer.setXmlParam("colorosc2", "214,214,222");
			visualizer.setXmlParam("colorosc3", "181,189,189");
			visualizer.setXmlParam("colorosc4", "160,170,175");
			visualizer.setXmlParam("colorosc5", "148,156,165");

		}
		else if (v_color == 1)
		{
			visualizer.setXmlParam("ColorBand1", "22,131,7");
			visualizer.setXmlParam("ColorBand2", "39,147,0");
			visualizer.setXmlParam("ColorBand3", "47,155,7");
			visualizer.setXmlParam("ColorBand4", "55,180,15");
			visualizer.setXmlParam("ColorBand5", "48,189,15");
			visualizer.setXmlParam("ColorBand6", "39,205,15");
			visualizer.setXmlParam("ColorBand7", "146,221,32");
			visualizer.setXmlParam("ColorBand8", "187,221,40");
			visualizer.setXmlParam("ColorBand9", "212,180,32");
			visualizer.setXmlParam("ColorBand10", "220,164,23");
			visualizer.setXmlParam("ColorBand11", "197,122,7");
			visualizer.setXmlParam("ColorBand12", "213,114,0");
			visualizer.setXmlParam("ColorBand13", "213,101,0");
			visualizer.setXmlParam("ColorBand14", "213,89,0");
			visualizer.setXmlParam("ColorBand15", "205,40,15");
			visualizer.setXmlParam("ColorBand16", "238,48,15");
			visualizer.setXmlParam("colorbandpeak", "150,150,150");
			visualizer.setXmlParam("colorosc1", "255,255,255");
			visualizer.setXmlParam("colorosc2", "214,214,222");
			visualizer.setXmlParam("colorosc3", "181,189,189");
			visualizer.setXmlParam("colorosc4", "160,170,175");
			visualizer.setXmlParam("colorosc5", "148,156,165");

		}
		else if (v_color == 2)
		{
			visualizer.setXmlParam("colorallbands", "0,176,32");
			visualizer.setXmlParam("colorbandpeak", "32,32,255");

			setColorosc("160,255,160");

		}
		else if (v_color == 3)
		{
			visualizer.setXmlParam("colorallbands", "0,0,255");
			visualizer.setXmlParam("colorbandpeak", "255,255,255");

			setColorosc("160,255,160");

		}
		else if (v_color == 4)
		{
			visualizer.setXmlParam("colorallbands", "255,165,0");
			visualizer.setXmlParam("colorbandpeak", "255,0,0");

			setColorosc("160,255,160");

		}
		else if (v_color == 5)
		{
			setColorBandsOdd("242,244,247");
			setColorBandsEven("172,185,209");
			visualizer.setXmlParam("colorbandpeak", "242,244,247");

			setColorosc("242,244,247");

		}
		else if (v_color == 6)
		{
			visualizer.setXmlParam("ColorBand1", "82,97,102");
			visualizer.setXmlParam("ColorBand2", "74,88,93");
			visualizer.setXmlParam("ColorBand3", "78,92,97");
			visualizer.setXmlParam("ColorBand4", "83,97,104");
			visualizer.setXmlParam("ColorBand5", "88,102,107");
			visualizer.setXmlParam("ColorBand6", "94,107,112");
			visualizer.setXmlParam("ColorBand7", "100,113,118");
			visualizer.setXmlParam("ColorBand8", "106,120,125");
			visualizer.setXmlParam("ColorBand9", "112,121,131");
			visualizer.setXmlParam("ColorBand10", "117,131,136");
			visualizer.setXmlParam("ColorBand11", "122,137,142");
			visualizer.setXmlParam("ColorBand12", "127,141,146");
			visualizer.setXmlParam("ColorBand13", "131,145,150");
			visualizer.setXmlParam("ColorBand14", "136,150,155");
			visualizer.setXmlParam("ColorBand15", "140,154,159");
			visualizer.setXmlParam("ColorBand16", "145,159,164");
			visualizer.setXmlParam("colorbandpeak", "162,193,204");
			visualizer.setXmlParam("colorosc1", "82,97,102");
			visualizer.setXmlParam("colorosc2", "83,97,104");
			visualizer.setXmlParam("colorosc3", "106,120,125");
			visualizer.setXmlParam("colorosc4", "127,141,146");
			visualizer.setXmlParam("colorosc5", "145,159,164");

		}
		else if (v_color == 7)
		{
			visualizer.setXmlParam("ColorBand1", "#5a5490");
			visualizer.setXmlParam("ColorBand2", "#60599a");
			visualizer.setXmlParam("ColorBand3", "#665ea1");
			visualizer.setXmlParam("ColorBand4", "#6c63ac");
			visualizer.setXmlParam("ColorBand5", "#7368b1");
			visualizer.setXmlParam("ColorBand6", "#7a6dba");
			visualizer.setXmlParam("ColorBand7", "#8274c4");
			visualizer.setXmlParam("ColorBand8", "#8a7ad0");
			visualizer.setXmlParam("ColorBand9", "#927bd9");
			visualizer.setXmlParam("ColorBand10", "#9985e1");
			visualizer.setXmlParam("ColorBand11", "#9f8ceb");
			visualizer.setXmlParam("ColorBand12", "#a590f2");
			visualizer.setXmlParam("ColorBand13", "#aa94f9");
			visualizer.setXmlParam("ColorBand14", "#b199fa");
			visualizer.setXmlParam("ColorBand15", "#bda4fc");
			visualizer.setXmlParam("ColorBand16", "#bda4fc");
			visualizer.setXmlParam("colorbandpeak", "#b5bffb");
			visualizer.setXmlParam("colorosc1", "#665ea1");
			visualizer.setXmlParam("colorosc2", "#7a6dba");
			visualizer.setXmlParam("colorosc3", "#927bd9");
			visualizer.setXmlParam("colorosc4", "#9f8ceb");
			visualizer.setXmlParam("colorosc5", "#b199fa");

		}
		else if (v_color == 8)
		{
			visualizer.setXmlParam("ColorBand1", "255,4,55");
			visualizer.setXmlParam("ColorBand2", "242,5,55");
			visualizer.setXmlParam("ColorBand3", "229,6,55");
			visualizer.setXmlParam("ColorBand4", "217,7,57");
			visualizer.setXmlParam("ColorBand5", "203,10,56");
			visualizer.setXmlParam("ColorBand6", "190,10,58");
			visualizer.setXmlParam("ColorBand7", "177,12,58");
			visualizer.setXmlParam("ColorBand8", "164,13,58");
			visualizer.setXmlParam("ColorBand9", "151,14,59");
			visualizer.setXmlParam("ColorBand10", "138,16,59");
			visualizer.setXmlParam("ColorBand11", "125,16,59");
			visualizer.setXmlParam("ColorBand12", "112,18,60");
			visualizer.setXmlParam("ColorBand13", "99,19,61");
			visualizer.setXmlParam("ColorBand14", "86,21,61");
			visualizer.setXmlParam("ColorBand15", "73,21,61");
			visualizer.setXmlParam("ColorBand16", "60,23,62");
			visualizer.setXmlParam("colorbandpeak", "190,10,58");
			visualizer.setXmlParam("colorosc1", "255,4,55");
			visualizer.setXmlParam("colorosc2", "229,6,55");
			visualizer.setXmlParam("colorosc3", "203,10,56");
			visualizer.setXmlParam("colorosc4", "164,13,58");
			visualizer.setXmlParam("colorosc5", "112,18,60");

		}
		else if (v_color == 9)
		{
			visualizer.setXmlParam("ColorBand1", "247,207,0");
			visualizer.setXmlParam("ColorBand2", "240,195,0");
			visualizer.setXmlParam("ColorBand3", "232,186,0");
			visualizer.setXmlParam("ColorBand4", "224,175,0");
			visualizer.setXmlParam("ColorBand5", "216,165,0");
			visualizer.setXmlParam("ColorBand6", "207,154,0");
			visualizer.setXmlParam("ColorBand7", "200,144,0");
			visualizer.setXmlParam("ColorBand8", "191,135,0");
			visualizer.setXmlParam("ColorBand9", "184,124,0");
			visualizer.setXmlParam("ColorBand10", "175,114,0");
			visualizer.setXmlParam("ColorBand11", "167,103,0");
			visualizer.setXmlParam("ColorBand12", "160,92,0");
			visualizer.setXmlParam("ColorBand13", "152,82,0");
			visualizer.setXmlParam("ColorBand14", "143,73,0");
			visualizer.setXmlParam("ColorBand15", "136,62,0");
			visualizer.setXmlParam("ColorBand16", "128,52,0");
			visualizer.setXmlParam("colorbandpeak", "184,124,0");
			visualizer.setXmlParam("colorosc1", "252,201,202");
			visualizer.setXmlParam("colorosc2", "233,169,169");
			visualizer.setXmlParam("colorosc3", "215,136,137");
			visualizer.setXmlParam("colorosc4", "195,104,105");
			visualizer.setXmlParam("colorosc5", "177,72,71");

		}
		else if (v_color == 10)
		{
			visualizer.setXmlParam("ColorBand16", "36,44,66");
			visualizer.setXmlParam("ColorBand15", "47,44,62");
			visualizer.setXmlParam("ColorBand14", "59,44,59");
			visualizer.setXmlParam("ColorBand13", "72,45,55");
			visualizer.setXmlParam("ColorBand12", "83,45,52");
			visualizer.setXmlParam("ColorBand11", "95,46,48");
			visualizer.setXmlParam("ColorBand10", "107,46,45");
			visualizer.setXmlParam("ColorBand9", "119,46,42");
			visualizer.setXmlParam("ColorBand8", "131,47,38");
			visualizer.setXmlParam("ColorBand7", "142,47,35");
			visualizer.setXmlParam("ColorBand6", "154,48,31");
			visualizer.setXmlParam("ColorBand5", "166,48,28");
			visualizer.setXmlParam("ColorBand4", "178,48,25");
			visualizer.setXmlParam("ColorBand3", "190,49,21");
			visualizer.setXmlParam("ColorBand2", "201,49,18");
			visualizer.setXmlParam("ColorBand1", "213,50,15");
			visualizer.setXmlParam("colorbandpeak", "213,50,15");
			visualizer.setXmlParam("colorosc5", "36,44,65");
			visualizer.setXmlParam("colorosc4", "80,45,53");
			visualizer.setXmlParam("colorosc3", "124,47,40");
			visualizer.setXmlParam("colorosc2", "169,48,27");
			visualizer.setXmlParam("colorosc1", "213,50,15");

		}
		else if (v_color == 11)
		{
			visualizer.setXmlParam("ColorBand1", "130,185,217");
			visualizer.setXmlParam("ColorBand2", "137,189,218");
			visualizer.setXmlParam("ColorBand3", "144,192,220");
			visualizer.setXmlParam("ColorBand4", "151,195,221");
			visualizer.setXmlParam("ColorBand5", "158,198,222");
			visualizer.setXmlParam("ColorBand6", "165,201,224");
			visualizer.setXmlParam("ColorBand7", "171,204,226");
			visualizer.setXmlParam("ColorBand8", "178,208,228");
			visualizer.setXmlParam("ColorBand9", "185,211,230");
			visualizer.setXmlParam("ColorBand10", "192,215,230");
			visualizer.setXmlParam("ColorBand11", "198,218,231");
			visualizer.setXmlParam("ColorBand12", "206,221,234");
			visualizer.setXmlParam("ColorBand13", "212,224,236");
			visualizer.setXmlParam("ColorBand14", "219,227,237");
			visualizer.setXmlParam("ColorBand15", "225,231,238");
			visualizer.setXmlParam("ColorBand16", "233,234,240");
			visualizer.setXmlParam("colorbandpeak", "233,234,240");
			visualizer.setXmlParam("colorosc1", "225,230,238");
			visualizer.setXmlParam("colorosc2", "203,220,233");
			visualizer.setXmlParam("colorosc3", "182,209,229");
			visualizer.setXmlParam("colorosc4", "160,199,223");
			visualizer.setXmlParam("colorosc5", "138,189,219");

		}
		else if (v_color == 12)
		{
			visualizer.setXmlParam("ColorBand1", "214,168,186");
			visualizer.setXmlParam("ColorBand2", "182,43,171");
			visualizer.setXmlParam("ColorBand3", "106,1,242");
			visualizer.setXmlParam("ColorBand4", "8,34,245");
			visualizer.setXmlParam("ColorBand5", "4,166,251");
			visualizer.setXmlParam("ColorBand6", "3,246,118");
			visualizer.setXmlParam("ColorBand7", "80,245,0");
			visualizer.setXmlParam("ColorBand8", "223,245,5");
			visualizer.setXmlParam("ColorBand9", "247,143,5");
			visualizer.setXmlParam("ColorBand10", "254,41,5");
			visualizer.setXmlParam("ColorBand11", "216,34,5");
			visualizer.setXmlParam("ColorBand12", "209,160,158");
			visualizer.setXmlParam("ColorBand13", "230,242,246");
			visualizer.setXmlParam("ColorBand14", "230,242,246");
			visualizer.setXmlParam("ColorBand15", "216,208,232");
			visualizer.setXmlParam("ColorBand16", "216,208,232");
			visualizer.setXmlParam("colorbandpeak", "225,160,235");
			visualizer.setXmlParam("colorosc1", "216,208,232");
			visualizer.setXmlParam("colorosc2", "209,160,158");
			visualizer.setXmlParam("colorosc3", "216,34,5");
			visualizer.setXmlParam("colorosc4", "254,41,5");
			visualizer.setXmlParam("colorosc5", "247,143,5");

		}
		else if (v_color == 13)
		{
			visualizer.setXmlParam("ColorBand1", "252,201,202");
			visualizer.setXmlParam("ColorBand2", "247,192,193");
			visualizer.setXmlParam("ColorBand3", "242,183,185");
			visualizer.setXmlParam("ColorBand4", "236,176,175");
			visualizer.setXmlParam("ColorBand5", "232,166,167");
			visualizer.setXmlParam("ColorBand6", "227,157,158");
			visualizer.setXmlParam("ColorBand7", "222,149,149");
			visualizer.setXmlParam("ColorBand8", "217,141,140");
			visualizer.setXmlParam("ColorBand9", "212,132,132");
			visualizer.setXmlParam("ColorBand10", "208,123,123");
			visualizer.setXmlParam("ColorBand11", "202,114,114");
			visualizer.setXmlParam("ColorBand12", "197,106,106");
			visualizer.setXmlParam("ColorBand13", "192,97,98");
			visualizer.setXmlParam("ColorBand14", "187,89,88");
			visualizer.setXmlParam("ColorBand15", "182,81,80");
			visualizer.setXmlParam("ColorBand16", "177,72,71");
			visualizer.setXmlParam("colorbandpeak", "184,124,0");
			visualizer.setXmlParam("colorosc1", "252,201,202");
			visualizer.setXmlParam("colorosc2", "233,169,169");
			visualizer.setXmlParam("colorosc3", "215,136,137");
			visualizer.setXmlParam("colorosc4", "195,104,105");
			visualizer.setXmlParam("colorosc5", "177,72,71");

		}
		else if (v_color == 14)
		{
			visualizer.setXmlParam("colorallbands", "0,255,0");
			visualizer.setXmlParam("colorbandpeak", "0,255,0");

			setColorosc("0,255,0");

		}
		else if (v_color == 15)
		{
			visualizer.setXmlParam("ColorBand16", "130,166,170");
			visualizer.setXmlParam("ColorBand15", "137,171,175");
			visualizer.setXmlParam("ColorBand14", "145,175,180");
			visualizer.setXmlParam("ColorBand13", "151,180,184");
			visualizer.setXmlParam("ColorBand12", "159,185,188");
			visualizer.setXmlParam("ColorBand11", "166,190,193");
			visualizer.setXmlParam("ColorBand10", "173,194,197");
			visualizer.setXmlParam("ColorBand9", "181,198,202");
			visualizer.setXmlParam("ColorBand8", "188,203,207");
			visualizer.setXmlParam("ColorBand7", "195,208,212");
			visualizer.setXmlParam("ColorBand6", "202,213,215");
			visualizer.setXmlParam("ColorBand5", "209,218,220");
			visualizer.setXmlParam("ColorBand4", "217,222,225");
			visualizer.setXmlParam("ColorBand3", "224,227,229");
			visualizer.setXmlParam("ColorBand2", "231,232,233");
			visualizer.setXmlParam("ColorBand1", "235,234,236");
			visualizer.setXmlParam("colorbandpeak", "254,246,231");
			visualizer.setXmlParam("colorosc5", "47,44,50");
			visualizer.setXmlParam("colorosc4", "85,83,88");
			visualizer.setXmlParam("colorosc3", "146,143,147");
			visualizer.setXmlParam("colorosc2", "205,203,207");
			visualizer.setXmlParam("colorosc1", "235,234,236");

		}
		else if (v_color == 16)
		{
			visualizer.setXmlParam("ColorBand1", "181,231,94");
			visualizer.setXmlParam("ColorBand2", "186,228,94");
			visualizer.setXmlParam("ColorBand3", "190,227,94");
			visualizer.setXmlParam("ColorBand4", "195,224,94");
			visualizer.setXmlParam("ColorBand5", "198,223,94");
			visualizer.setXmlParam("ColorBand6", "203,221,94");
			visualizer.setXmlParam("ColorBand7", "207,218,94");
			visualizer.setXmlParam("ColorBand8", "211,217,94");
			visualizer.setXmlParam("ColorBand9", "216,215,94");
			visualizer.setXmlParam("ColorBand10", "221,213,94");
			visualizer.setXmlParam("ColorBand11", "225,212,94");
			visualizer.setXmlParam("ColorBand12", "229,208,94");
			visualizer.setXmlParam("ColorBand13", "234,207,94");
			visualizer.setXmlParam("ColorBand14", "236,186,94");
			visualizer.setXmlParam("ColorBand15", "232,146,94");
			visualizer.setXmlParam("ColorBand16", "229,108,94");
			visualizer.setXmlParam("colorbandpeak", "150,150,150");

			setColorosc("196,181,80");

		}
		else if (v_color == 17)
		{
			setColorBandsOdd("0,222,255");
			setColorBandsEven("0,97,142");
			visualizer.setXmlParam("colorbandpeak", "140,222,255");

			setColorosc("140,222,255");

		}
		else if (v_color == 18)
		{
			setColorBandsOdd("255,0,0");
			setColorBandsEven("105,0,0");
			visualizer.setXmlParam("colorbandpeak", "255,43,0");

			setColorosc("255,43,0");

		}
		else if (v_color == 19)
		{

		}
		else if (v_color == 20)
		{
			visualizer.setXmlParam("colorallbands", "59,51,163");
			visualizer.setXmlParam("colorbandpeak", "122,115,219");	
			
			setColorosc("122,115,219");
		}
		else if (v_color == 21)
		{
			visualizer.setXmlParam("colorallbands", "213,175,38");
			visualizer.setXmlParam("colorbandpeak", "213,175,38");

			setColorosc("213,175,38");

		}
		else if (v_color == 22)
		{

		}
		if(v_color == 23){
			//luna
			
			visualizer.setXmlParam("colorallbands", "49,106,197");
			visualizer.setXmlParam("colorbandpeak", "49,106,197");
			setColorOsc("49,106,197");

		}
		else if(v_color == 24){
			//olive green
			
			visualizer.setXmlParam("colorallbands", "147,160,112");
			visualizer.setXmlParam("colorbandpeak", "153,84,10");
			setColorOsc("147,160,112");
		}
		else if(v_color == 25){
			//silver
			
			visualizer.setXmlParam("colorallbands", "178,180,191");
			visualizer.setXmlParam("colorbandpeak", "178,180,191");
			setColorOsc("178,180,191");
		}
		else if(v_color == 26){
			//luna - gradient

			setColorBandsGradient(3,84,227,4,4,2);

			visualizer.setXmlParam("colorbandpeak", "61,149,255");
			setColorOscOdd("3,84,227");
			setColorOscEven("61,149,255");

		}
		else if(v_color == 27){
			//olive green - gradient

			setColorBandsGradient(165,179,125,4,4,4);

			visualizer.setXmlParam("colorbandpeak", "231,240,197");
			setColorOscOdd("165,179,125");
			setColorOscEven("231,240,197");

		}
		else if(v_color == 28){
			//silver - gradient

			setColorBandsGradient(165,164,190,6,6,4);

			visualizer.setXmlParam("colorbandpeak", "252,252,252");
			setColorOscOdd("165,164,190");
			setColorOscEven("252,252,252");
			
		}
		else if(v_color == 29){
			//RGB
			nextTimer = 1;
			rgbTimer.start();
		}
		if (grid == 0)
		{
			visgrid_thick.setXmlParam("visible", "0");
			visgrid_thin.setXmlParam("visible", "0");
			visgrid_car.setXmlParam("visible", "0");
		}
		else if (grid == 1)
		{
			visgrid_thick.setXmlParam("visible", "0");
			visgrid_thin.setXmlParam("visible", "0");
			visgrid_car.setXmlParam("visible", "0");
		}
		else if (grid == 2)
		{
			visgrid_thick.setXmlParam("visible", "1");
			visgrid_thin.setXmlParam("visible", "0");
			visgrid_car.setXmlParam("visible", "0");
		}
		else if (grid == 3)
		{
			visgrid_thick.setXmlParam("visible", "0");
			visgrid_thin.setXmlParam("visible", "1");
			visgrid_car.setXmlParam("visible", "0");
		}
		else if (grid == 4)
		{
			visgrid_thick.setXmlParam("visible", "0");
			visgrid_thin.setXmlParam("visible", "0");
			visgrid_car.setXmlParam("visible", "1");
		}
		else if (v_fps == 5)
		{
			visgrid_thick.setXmlParam("visible", "1");
			visgrid_thin.setXmlParam("visible", "1");
			visgrid_car.setXmlParam("visible", "1");
		}
	setVis (currentMode);
}

Trigger.onLeftButtonDown (int x, int y)
{
	currentMode++;

	if (currentMode == 6)
	{
		currentMode = 0;
	}

	setVis	(currentMode);
	complete;
}



Trigger.onRightButtonUp (int x, int y)
{
	visMenu = new PopUpMenu;
	specmenu = new PopUpMenu;
	oscmenu = new PopUpMenu;
	pksmenu = new PopUpMenu;
	anamenu = new PopUpMenu;
	stylemenu = new PopUpMenu;
	fpsmenu = new PopUpMenu;
	colmenu = new PopUpMenu;
	wmpmenu = new PopUpMenu;
	winmenu = new PopUpMenu;
	animenu = new PopUpMenu;
	gamemenu = new PopUpMenu;
	plusmenu = new PopUpMenu;
	gridmenu = new PopUpMenu;
	waxpmenu = new PopUpMenu;

	visMenu.addCommand("Presets:", 999, 0, 1);
	visMenu.addCommand("No Visualization", 100, currentMode == 0, 0);
	
	visMenu.addSubMenu(colmenu, "Visualizer Color Schemes");

	
	colmenu.addSubMenu(animenu, "Anime");
	animenu.addCommand("REVOCS", 508, v_color == 8, 0);
	animenu.addCommand("Ryuko", 510, v_color == 10, 0);
	animenu.addCommand("Satsuki", 511, v_color == 11, 0);
	animenu.addCommand("Ragyo", 512, v_color == 12, 0);
	animenu.addCommand("A.P.E", 509, v_color == 9, 0);
	animenu.addCommand("Zero Two", 513, v_color == 13, 0);
	
	colmenu.addSubMenu(plusmenu, "Microsoft Plus! 98");
	plusmenu.addCommand("More Windows", 521, v_color == 21, 0);
	
	colmenu.addSubMenu(gamemenu, "Video Games");
	gamemenu.addCommand("GoldSrc VGUI", 516, v_color == 16, 0);
	
	colmenu.addSubMenu(wmpmenu, "Windows Media Player");
	wmpmenu.addCommand("Bars and Scope", 502, v_color == 2, 0);
	wmpmenu.addCommand("Ocean Mist and Scope", 503, v_color == 3, 0);
	wmpmenu.addCommand("Fire Storm and Scope", 504, v_color == 4, 0);
	
	colmenu.addSubMenu(winmenu, "Winamp Skins");
	winmenu.addCommand("Winamp Classic", 500, v_color == 0, 0);
	winmenu.addCommand("Winamp Modern", 505, v_color == 5, 0);
	winmenu.AddSubMenu(waxpmenu, "Winamp XP");
	winmenu.addCommand("Bento", 506, v_color == 6, 0);
	winmenu.addCommand("Big Bento Modern", 507, v_color == 7, 0);	

	waxpmenu.addCommand("Luna", 523, v_color == 23, 0);
	waxpmenu.addCommand("Luna (Gradient)", 526, v_color == 26, 0);
	waxpmenu.addCommand("Olive Green", 524, v_color == 24, 0);
	waxpmenu.addCommand("Olive Green (Gradient)", 527, v_color == 27, 0);
	waxpmenu.addCommand("Silver", 525, v_color == 25, 0);
	waxpmenu.addCommand("Silver (Gradient)", 528, v_color == 28, 0);
	
	colmenu.addCommand("Commodore 64", 520, v_color == 20, 0);
	colmenu.addCommand("Midori Mizuno", 515, v_color == 15, 0);
	colmenu.addCommand("RGB", 529, v_color == 29, 0);
	colmenu.addCommand("Sound Recorder", 514, v_color == 14, 0);

	colmenu.addCommand("That old Hi-Fi", 517, v_color == 17, 0);
	colmenu.addCommand("That old Hi-Fi in crimson red", 518, v_color == 18, 0);
	
	specmenu.addCommand("Thick Bands", 1, currentMode == 1, 0);
	specmenu.addCommand("Thin Bands", 2, currentMode == 2, 0);
	visMenu.addSubMenu(specmenu, "Spectrum Analyzer");

	oscmenu.addCommand("Lines", 3, currentMode == 3, 0);
	oscmenu.addCommand("Dots", 4, currentMode == 4, 0);
	oscmenu.addCommand("Solid", 5, currentMode == 5, 0);
	visMenu.addSubMenu(oscmenu, "Oscilloscope");

	visMenu.addSeparator();
	visMenu.addCommand("Options:", 102, 0, 1);

	visMenu.addCommand("Show Peaks", 101, show_peaks == 1, 0);
	
	visMenu.addSubMenu(gridmenu, "Grid Options:");
	
	gridmenu.addCommand("No Grid", 600, grid == 0, 0);
	gridmenu.addCommand("Thick Grid", 602, grid == 2, 0);
	gridmenu.addCommand("Thin Grid", 603, grid == 3, 0);
	gridmenu.addCommand("Car Display", 604, grid == 4, 0);
	gridmenu.addCommand("All of the above", 605, grid == 5, 0);
	
	pksmenu.addCommand("Slower", 200, p_falloffspeed == 0, 0);
	pksmenu.addCommand("Slow", 201, p_falloffspeed == 1, 0);
	pksmenu.addCommand("Moderate", 202, p_falloffspeed == 2, 0);
	pksmenu.addCommand("Fast", 203, p_falloffspeed == 3, 0);
	pksmenu.addCommand("Faster", 204, p_falloffspeed == 4, 0);
	
	visMenu.addSubMenu(pksmenu, "Peak Falloff Speed");
	anamenu.addCommand("Slower", 300, a_falloffspeed == 0, 0);
	anamenu.addCommand("Slow", 301, a_falloffspeed == 1, 0);
	anamenu.addCommand("Moderate", 302, a_falloffspeed == 2, 0);
	anamenu.addCommand("Fast", 303, a_falloffspeed == 3, 0);
	anamenu.addCommand("Faster", 304, a_falloffspeed == 4, 0);
	
	visMenu.addSubMenu(anamenu, "Analyzer Falloff Speed");
	stylemenu.addCommand("Normal", 400, a_coloring == 0, 0);
	stylemenu.addCommand("Fire", 402, a_coloring == 2, 0);
	stylemenu.addCommand("Line", 403, a_coloring == 3, 0);
	
	visMenu.addSubMenu(stylemenu, "Analyzer Coloring");
	
	visMenu.addSeparator();
	
	visMenu.addSubMenu(fpsmenu, "Frames Per Second");
	fpsmenu.addCommand("Lame (30 FPS)", 407, v_fps == 0, 0);
	fpsmenu.addCommand("Fast (60 FPS)", 409, v_fps == 2, 0);
	fpsmenu.addCommand("Faster (75 FPS)", 410, v_fps == 3, 0);
	fpsmenu.addCommand("Impulse Speed (120 FPS)", 412, v_fps == 5, 0);
	fpsmenu.addCommand("Warp 6 (512 FPS)", 411, v_fps == 4, 0);
	
	ProcessMenuResult (visMenu.popAtMouse());
	
	delete visMenu;
	delete specmenu;
	delete oscmenu;
	delete pksmenu;
	delete anamenu;
	delete stylemenu;
	delete fpsmenu;
	delete colmenu;
	delete wmpmenu;
	delete winmenu;
	delete animenu;
	delete gamemenu;
	delete gridmenu;
	delete waxpmenu;

	complete;	
}

ProcessMenuResult (int a)
{
	if (a < 1) return;

	if (a > 0 && a <= 6 || a == 100)
	{
		if (a == 100) a = 0;
		setVis(a);
	}

	else if (a == 101)
	{
		show_peaks = (show_peaks - 1) * (-1);
		visualizer.setXmlParam("peaks", integerToString(show_peaks));
		setPrivateInt(getSkinName(), "Visualizer show Peaks2", show_peaks);
	}

	else if (a >= 200 && a <= 204)
	{
		p_falloffspeed = a - 200;
		visualizer.setXmlParam("peakfalloff", integerToString(p_falloffspeed));
		setPrivateInt(getSkinName(), "Visualizer peaks falloff2", p_falloffspeed);
	}

	else if (a >= 300 && a <= 304)
	{
		a_falloffspeed = a - 300;
		visualizer.setXmlParam("falloff", integerToString(a_falloffspeed));
		setPrivateInt(getSkinName(), "Visualizer analyzer falloff2", a_falloffspeed);
	}

	else if (a >= 400 && a <= 403)
	{
		a_coloring = a - 400;
		if (a_coloring == 0)
		{
			visualizer.setXmlParam("coloring", "Normal");
		}
		else if (a_coloring == 1)
		{
			visualizer.setXmlParam("coloring", "Normal");
		}
		else if (a_coloring == 2)
		{
			visualizer.setXmlParam("coloring", "Fire");
		}
		else if (a_coloring == 3)
		{
			visualizer.setXmlParam("coloring", "Line");
		}
		setPrivateInt(getSkinName(), "Visualizer analyzer coloring2", a_coloring);
	}
		
  	else if (a >= 407 && a <= 413)
	{
		v_fps = a - 407;
		if (v_fps == 0)
		{
			visualizer.setXmlParam("fps", "30");
		}
		else if (v_fps == 1)
		{
			visualizer.setXmlParam("fps", "30");
		}
		else if (v_fps == 2)
		{
			visualizer.setXmlParam("fps", "60");
		}
		else if (v_fps == 3)
		{
			visualizer.setXmlParam("fps", "75");
		}
		else if (v_fps == 4)
		{
			visualizer.setXmlParam("fps", "512");
		}
		else if (v_fps == 5)
		{
			visualizer.setXmlParam("fps", "120");
		}
		setPrivateInt(getSkinName(), "Visualizer FPS2", v_fps);
	}
	else if (a >= 500 && a <= 529)
	{
		v_color = a - 500;
		if (v_color == 0)
		{
			visualizer.setXmlParam("ColorBand1", "22,131,7");
			visualizer.setXmlParam("ColorBand2", "39,147,0");
			visualizer.setXmlParam("ColorBand3", "47,155,7");
			visualizer.setXmlParam("ColorBand4", "55,180,15");
			visualizer.setXmlParam("ColorBand5", "48,189,15");
			visualizer.setXmlParam("ColorBand6", "39,205,15");
			visualizer.setXmlParam("ColorBand7", "146,221,32");
			visualizer.setXmlParam("ColorBand8", "187,221,40");
			visualizer.setXmlParam("ColorBand9", "212,180,32");
			visualizer.setXmlParam("ColorBand10", "220,164,23");
			visualizer.setXmlParam("ColorBand11", "197,122,7");
			visualizer.setXmlParam("ColorBand12", "213,114,0");
			visualizer.setXmlParam("ColorBand13", "213,101,0");
			visualizer.setXmlParam("ColorBand14", "213,89,0");
			visualizer.setXmlParam("ColorBand15", "205,40,15");
			visualizer.setXmlParam("ColorBand16", "238,48,15");
			visualizer.setXmlParam("colorbandpeak", "150,150,150");
			visualizer.setXmlParam("colorosc1", "255,255,255");
			visualizer.setXmlParam("colorosc2", "214,214,222");
			visualizer.setXmlParam("colorosc3", "181,189,189");
			visualizer.setXmlParam("colorosc4", "160,170,175");
			visualizer.setXmlParam("colorosc5", "148,156,165");

		}
		else if (v_color == 1)
		{
			visualizer.setXmlParam("ColorBand1", "22,131,7");
			visualizer.setXmlParam("ColorBand2", "39,147,0");
			visualizer.setXmlParam("ColorBand3", "47,155,7");
			visualizer.setXmlParam("ColorBand4", "55,180,15");
			visualizer.setXmlParam("ColorBand5", "48,189,15");
			visualizer.setXmlParam("ColorBand6", "39,205,15");
			visualizer.setXmlParam("ColorBand7", "146,221,32");
			visualizer.setXmlParam("ColorBand8", "187,221,40");
			visualizer.setXmlParam("ColorBand9", "212,180,32");
			visualizer.setXmlParam("ColorBand10", "220,164,23");
			visualizer.setXmlParam("ColorBand11", "197,122,7");
			visualizer.setXmlParam("ColorBand12", "213,114,0");
			visualizer.setXmlParam("ColorBand13", "213,101,0");
			visualizer.setXmlParam("ColorBand14", "213,89,0");
			visualizer.setXmlParam("ColorBand15", "205,40,15");
			visualizer.setXmlParam("ColorBand16", "238,48,15");
			visualizer.setXmlParam("colorbandpeak", "150,150,150");
			visualizer.setXmlParam("colorosc1", "255,255,255");
			visualizer.setXmlParam("colorosc2", "214,214,222");
			visualizer.setXmlParam("colorosc3", "181,189,189");
			visualizer.setXmlParam("colorosc4", "160,170,175");
			visualizer.setXmlParam("colorosc5", "148,156,165");

		}
		else if (v_color == 2)
		{
			visualizer.setXmlParam("colorallbands", "0,176,32");
			visualizer.setXmlParam("colorbandpeak", "32,32,255");

			setColorosc("160,255,160");

		}
		else if (v_color == 3)
		{
			visualizer.setXmlParam("colorallbands", "0,0,255");
			visualizer.setXmlParam("colorbandpeak", "255,255,255");

			setColorosc("160,255,160");

		}
		else if (v_color == 4)
		{
			visualizer.setXmlParam("colorallbands", "255,165,0");
			visualizer.setXmlParam("colorbandpeak", "255,0,0");

			setColorosc("160,255,160");

		}
		else if (v_color == 5)
		{
			setColorBandsOdd("242,244,247");
			setColorBandsEven("172,185,209");
			visualizer.setXmlParam("colorbandpeak", "242,244,247");

			setColorosc("242,244,247");

		}
		else if (v_color == 6)
		{
			visualizer.setXmlParam("ColorBand1", "82,97,102");
			visualizer.setXmlParam("ColorBand2", "74,88,93");
			visualizer.setXmlParam("ColorBand3", "78,92,97");
			visualizer.setXmlParam("ColorBand4", "83,97,104");
			visualizer.setXmlParam("ColorBand5", "88,102,107");
			visualizer.setXmlParam("ColorBand6", "94,107,112");
			visualizer.setXmlParam("ColorBand7", "100,113,118");
			visualizer.setXmlParam("ColorBand8", "106,120,125");
			visualizer.setXmlParam("ColorBand9", "112,121,131");
			visualizer.setXmlParam("ColorBand10", "117,131,136");
			visualizer.setXmlParam("ColorBand11", "122,137,142");
			visualizer.setXmlParam("ColorBand12", "127,141,146");
			visualizer.setXmlParam("ColorBand13", "131,145,150");
			visualizer.setXmlParam("ColorBand14", "136,150,155");
			visualizer.setXmlParam("ColorBand15", "140,154,159");
			visualizer.setXmlParam("ColorBand16", "145,159,164");
			visualizer.setXmlParam("colorbandpeak", "162,193,204");
			visualizer.setXmlParam("colorosc1", "82,97,102");
			visualizer.setXmlParam("colorosc2", "83,97,104");
			visualizer.setXmlParam("colorosc3", "106,120,125");
			visualizer.setXmlParam("colorosc4", "127,141,146");
			visualizer.setXmlParam("colorosc5", "145,159,164");

		}
		else if (v_color == 7)
		{
			visualizer.setXmlParam("ColorBand1", "#5a5490");
			visualizer.setXmlParam("ColorBand2", "#60599a");
			visualizer.setXmlParam("ColorBand3", "#665ea1");
			visualizer.setXmlParam("ColorBand4", "#6c63ac");
			visualizer.setXmlParam("ColorBand5", "#7368b1");
			visualizer.setXmlParam("ColorBand6", "#7a6dba");
			visualizer.setXmlParam("ColorBand7", "#8274c4");
			visualizer.setXmlParam("ColorBand8", "#8a7ad0");
			visualizer.setXmlParam("ColorBand9", "#927bd9");
			visualizer.setXmlParam("ColorBand10", "#9985e1");
			visualizer.setXmlParam("ColorBand11", "#9f8ceb");
			visualizer.setXmlParam("ColorBand12", "#a590f2");
			visualizer.setXmlParam("ColorBand13", "#aa94f9");
			visualizer.setXmlParam("ColorBand14", "#b199fa");
			visualizer.setXmlParam("ColorBand15", "#bda4fc");
			visualizer.setXmlParam("ColorBand16", "#bda4fc");
			visualizer.setXmlParam("colorbandpeak", "#b5bffb");
			visualizer.setXmlParam("colorosc1", "#665ea1");
			visualizer.setXmlParam("colorosc2", "#7a6dba");
			visualizer.setXmlParam("colorosc3", "#927bd9");
			visualizer.setXmlParam("colorosc4", "#9f8ceb");
			visualizer.setXmlParam("colorosc5", "#b199fa");

		}
		else if (v_color == 8)
		{
			visualizer.setXmlParam("ColorBand1", "255,4,55");
			visualizer.setXmlParam("ColorBand2", "242,5,55");
			visualizer.setXmlParam("ColorBand3", "229,6,55");
			visualizer.setXmlParam("ColorBand4", "217,7,57");
			visualizer.setXmlParam("ColorBand5", "203,10,56");
			visualizer.setXmlParam("ColorBand6", "190,10,58");
			visualizer.setXmlParam("ColorBand7", "177,12,58");
			visualizer.setXmlParam("ColorBand8", "164,13,58");
			visualizer.setXmlParam("ColorBand9", "151,14,59");
			visualizer.setXmlParam("ColorBand10", "138,16,59");
			visualizer.setXmlParam("ColorBand11", "125,16,59");
			visualizer.setXmlParam("ColorBand12", "112,18,60");
			visualizer.setXmlParam("ColorBand13", "99,19,61");
			visualizer.setXmlParam("ColorBand14", "86,21,61");
			visualizer.setXmlParam("ColorBand15", "73,21,61");
			visualizer.setXmlParam("ColorBand16", "60,23,62");
			visualizer.setXmlParam("colorbandpeak", "190,10,58");
			visualizer.setXmlParam("colorosc1", "255,4,55");
			visualizer.setXmlParam("colorosc2", "229,6,55");
			visualizer.setXmlParam("colorosc3", "203,10,56");
			visualizer.setXmlParam("colorosc4", "164,13,58");
			visualizer.setXmlParam("colorosc5", "112,18,60");

		}
		else if (v_color == 9)
		{
			visualizer.setXmlParam("ColorBand1", "247,207,0");
			visualizer.setXmlParam("ColorBand2", "240,195,0");
			visualizer.setXmlParam("ColorBand3", "232,186,0");
			visualizer.setXmlParam("ColorBand4", "224,175,0");
			visualizer.setXmlParam("ColorBand5", "216,165,0");
			visualizer.setXmlParam("ColorBand6", "207,154,0");
			visualizer.setXmlParam("ColorBand7", "200,144,0");
			visualizer.setXmlParam("ColorBand8", "191,135,0");
			visualizer.setXmlParam("ColorBand9", "184,124,0");
			visualizer.setXmlParam("ColorBand10", "175,114,0");
			visualizer.setXmlParam("ColorBand11", "167,103,0");
			visualizer.setXmlParam("ColorBand12", "160,92,0");
			visualizer.setXmlParam("ColorBand13", "152,82,0");
			visualizer.setXmlParam("ColorBand14", "143,73,0");
			visualizer.setXmlParam("ColorBand15", "136,62,0");
			visualizer.setXmlParam("ColorBand16", "128,52,0");
			visualizer.setXmlParam("colorbandpeak", "184,124,0");
			visualizer.setXmlParam("colorosc1", "252,201,202");
			visualizer.setXmlParam("colorosc2", "233,169,169");
			visualizer.setXmlParam("colorosc3", "215,136,137");
			visualizer.setXmlParam("colorosc4", "195,104,105");
			visualizer.setXmlParam("colorosc5", "177,72,71");

		}
		else if (v_color == 10)
		{
			visualizer.setXmlParam("ColorBand16", "36,44,66");
			visualizer.setXmlParam("ColorBand15", "47,44,62");
			visualizer.setXmlParam("ColorBand14", "59,44,59");
			visualizer.setXmlParam("ColorBand13", "72,45,55");
			visualizer.setXmlParam("ColorBand12", "83,45,52");
			visualizer.setXmlParam("ColorBand11", "95,46,48");
			visualizer.setXmlParam("ColorBand10", "107,46,45");
			visualizer.setXmlParam("ColorBand9", "119,46,42");
			visualizer.setXmlParam("ColorBand8", "131,47,38");
			visualizer.setXmlParam("ColorBand7", "142,47,35");
			visualizer.setXmlParam("ColorBand6", "154,48,31");
			visualizer.setXmlParam("ColorBand5", "166,48,28");
			visualizer.setXmlParam("ColorBand4", "178,48,25");
			visualizer.setXmlParam("ColorBand3", "190,49,21");
			visualizer.setXmlParam("ColorBand2", "201,49,18");
			visualizer.setXmlParam("ColorBand1", "213,50,15");
			visualizer.setXmlParam("colorbandpeak", "213,50,15");
			visualizer.setXmlParam("colorosc5", "36,44,65");
			visualizer.setXmlParam("colorosc4", "80,45,53");
			visualizer.setXmlParam("colorosc3", "124,47,40");
			visualizer.setXmlParam("colorosc2", "169,48,27");
			visualizer.setXmlParam("colorosc1", "213,50,15");

		}
		else if (v_color == 11)
		{
			visualizer.setXmlParam("ColorBand1", "130,185,217");
			visualizer.setXmlParam("ColorBand2", "137,189,218");
			visualizer.setXmlParam("ColorBand3", "144,192,220");
			visualizer.setXmlParam("ColorBand4", "151,195,221");
			visualizer.setXmlParam("ColorBand5", "158,198,222");
			visualizer.setXmlParam("ColorBand6", "165,201,224");
			visualizer.setXmlParam("ColorBand7", "171,204,226");
			visualizer.setXmlParam("ColorBand8", "178,208,228");
			visualizer.setXmlParam("ColorBand9", "185,211,230");
			visualizer.setXmlParam("ColorBand10", "192,215,230");
			visualizer.setXmlParam("ColorBand11", "198,218,231");
			visualizer.setXmlParam("ColorBand12", "206,221,234");
			visualizer.setXmlParam("ColorBand13", "212,224,236");
			visualizer.setXmlParam("ColorBand14", "219,227,237");
			visualizer.setXmlParam("ColorBand15", "225,231,238");
			visualizer.setXmlParam("ColorBand16", "233,234,240");
			visualizer.setXmlParam("colorbandpeak", "233,234,240");
			visualizer.setXmlParam("colorosc1", "225,230,238");
			visualizer.setXmlParam("colorosc2", "203,220,233");
			visualizer.setXmlParam("colorosc3", "182,209,229");
			visualizer.setXmlParam("colorosc4", "160,199,223");
			visualizer.setXmlParam("colorosc5", "138,189,219");

		}
		else if (v_color == 12)
		{
			visualizer.setXmlParam("ColorBand1", "214,168,186");
			visualizer.setXmlParam("ColorBand2", "182,43,171");
			visualizer.setXmlParam("ColorBand3", "106,1,242");
			visualizer.setXmlParam("ColorBand4", "8,34,245");
			visualizer.setXmlParam("ColorBand5", "4,166,251");
			visualizer.setXmlParam("ColorBand6", "3,246,118");
			visualizer.setXmlParam("ColorBand7", "80,245,0");
			visualizer.setXmlParam("ColorBand8", "223,245,5");
			visualizer.setXmlParam("ColorBand9", "247,143,5");
			visualizer.setXmlParam("ColorBand10", "254,41,5");
			visualizer.setXmlParam("ColorBand11", "216,34,5");
			visualizer.setXmlParam("ColorBand12", "209,160,158");
			visualizer.setXmlParam("ColorBand13", "230,242,246");
			visualizer.setXmlParam("ColorBand14", "230,242,246");
			visualizer.setXmlParam("ColorBand15", "216,208,232");
			visualizer.setXmlParam("ColorBand16", "216,208,232");
			visualizer.setXmlParam("colorbandpeak", "225,160,235");
			visualizer.setXmlParam("colorosc1", "216,208,232");
			visualizer.setXmlParam("colorosc2", "209,160,158");
			visualizer.setXmlParam("colorosc3", "216,34,5");
			visualizer.setXmlParam("colorosc4", "254,41,5");
			visualizer.setXmlParam("colorosc5", "247,143,5");

		}
		else if (v_color == 13)
		{
			visualizer.setXmlParam("ColorBand1", "252,201,202");
			visualizer.setXmlParam("ColorBand2", "247,192,193");
			visualizer.setXmlParam("ColorBand3", "242,183,185");
			visualizer.setXmlParam("ColorBand4", "236,176,175");
			visualizer.setXmlParam("ColorBand5", "232,166,167");
			visualizer.setXmlParam("ColorBand6", "227,157,158");
			visualizer.setXmlParam("ColorBand7", "222,149,149");
			visualizer.setXmlParam("ColorBand8", "217,141,140");
			visualizer.setXmlParam("ColorBand9", "212,132,132");
			visualizer.setXmlParam("ColorBand10", "208,123,123");
			visualizer.setXmlParam("ColorBand11", "202,114,114");
			visualizer.setXmlParam("ColorBand12", "197,106,106");
			visualizer.setXmlParam("ColorBand13", "192,97,98");
			visualizer.setXmlParam("ColorBand14", "187,89,88");
			visualizer.setXmlParam("ColorBand15", "182,81,80");
			visualizer.setXmlParam("ColorBand16", "177,72,71");
			visualizer.setXmlParam("colorbandpeak", "184,124,0");
			visualizer.setXmlParam("colorosc1", "252,201,202");
			visualizer.setXmlParam("colorosc2", "233,169,169");
			visualizer.setXmlParam("colorosc3", "215,136,137");
			visualizer.setXmlParam("colorosc4", "195,104,105");
			visualizer.setXmlParam("colorosc5", "177,72,71");

		}
		else if (v_color == 14)
		{
			visualizer.setXmlParam("colorallbands", "0,255,0");
			visualizer.setXmlParam("colorbandpeak", "0,255,0");

			setColorosc("0,255,0");

		}
		else if (v_color == 15)
		{
			visualizer.setXmlParam("ColorBand16", "130,166,170");
			visualizer.setXmlParam("ColorBand15", "137,171,175");
			visualizer.setXmlParam("ColorBand14", "145,175,180");
			visualizer.setXmlParam("ColorBand13", "151,180,184");
			visualizer.setXmlParam("ColorBand12", "159,185,188");
			visualizer.setXmlParam("ColorBand11", "166,190,193");
			visualizer.setXmlParam("ColorBand10", "173,194,197");
			visualizer.setXmlParam("ColorBand9", "181,198,202");
			visualizer.setXmlParam("ColorBand8", "188,203,207");
			visualizer.setXmlParam("ColorBand7", "195,208,212");
			visualizer.setXmlParam("ColorBand6", "202,213,215");
			visualizer.setXmlParam("ColorBand5", "209,218,220");
			visualizer.setXmlParam("ColorBand4", "217,222,225");
			visualizer.setXmlParam("ColorBand3", "224,227,229");
			visualizer.setXmlParam("ColorBand2", "231,232,233");
			visualizer.setXmlParam("ColorBand1", "235,234,236");
			visualizer.setXmlParam("colorbandpeak", "254,246,231");
			visualizer.setXmlParam("colorosc5", "47,44,50");
			visualizer.setXmlParam("colorosc4", "85,83,88");
			visualizer.setXmlParam("colorosc3", "146,143,147");
			visualizer.setXmlParam("colorosc2", "205,203,207");
			visualizer.setXmlParam("colorosc1", "235,234,236");

		}
		else if (v_color == 16)
		{
			visualizer.setXmlParam("ColorBand1", "181,231,94");
			visualizer.setXmlParam("ColorBand2", "186,228,94");
			visualizer.setXmlParam("ColorBand3", "190,227,94");
			visualizer.setXmlParam("ColorBand4", "195,224,94");
			visualizer.setXmlParam("ColorBand5", "198,223,94");
			visualizer.setXmlParam("ColorBand6", "203,221,94");
			visualizer.setXmlParam("ColorBand7", "207,218,94");
			visualizer.setXmlParam("ColorBand8", "211,217,94");
			visualizer.setXmlParam("ColorBand9", "216,215,94");
			visualizer.setXmlParam("ColorBand10", "221,213,94");
			visualizer.setXmlParam("ColorBand11", "225,212,94");
			visualizer.setXmlParam("ColorBand12", "229,208,94");
			visualizer.setXmlParam("ColorBand13", "234,207,94");
			visualizer.setXmlParam("ColorBand14", "236,186,94");
			visualizer.setXmlParam("ColorBand15", "232,146,94");
			visualizer.setXmlParam("ColorBand16", "229,108,94");
			visualizer.setXmlParam("colorbandpeak", "150,150,150");

			setColorosc("196,181,80");

		}
		else if (v_color == 17)
		{
			setColorBandsOdd("0,222,255");
			setColorBandsEven("0,97,142");
			visualizer.setXmlParam("colorbandpeak", "140,222,255");

			setColorosc("140,222,255");

		}
		else if (v_color == 18)
		{
			setColorBandsOdd("255,0,0");
			setColorBandsEven("105,0,0");
			visualizer.setXmlParam("colorbandpeak", "255,43,0");

			setColorosc("255,43,0");

		}
		else if (v_color == 19)
		{

		}
		else if (v_color == 20)
		{
			visualizer.setXmlParam("colorallbands", "59,51,163");
			visualizer.setXmlParam("colorbandpeak", "122,115,219");	
			
			setColorosc("122,115,219");
		}
		else if (v_color == 21)
		{
			visualizer.setXmlParam("colorallbands", "213,175,38");
			visualizer.setXmlParam("colorbandpeak", "213,175,38");

			setColorosc("213,175,38");

		}
		else if (v_color == 22)
		{

		}
				if(v_color == 23){
			//luna
			
			visualizer.setXmlParam("colorallbands", "49,106,197");
			visualizer.setXmlParam("colorbandpeak", "49,106,197");
			setColorOsc("49,106,197");

		}
		else if(v_color == 24){
			//olive green
			
			visualizer.setXmlParam("colorallbands", "147,160,112");
			visualizer.setXmlParam("colorbandpeak", "153,84,10");
			setColorOsc("147,160,112");
		}
		else if(v_color == 25){
			//silver
			
			visualizer.setXmlParam("colorallbands", "178,180,191");
			visualizer.setXmlParam("colorbandpeak", "178,180,191");
			setColorOsc("178,180,191");
		}
		else if(v_color == 26){
			//luna - gradient

			setColorBandsGradient(3,84,227,4,4,2);

			visualizer.setXmlParam("colorbandpeak", "61,149,255");
			setColorOscOdd("3,84,227");
			setColorOscEven("61,149,255");

		}
		else if(v_color == 27){
			//olive green - gradient

			setColorBandsGradient(165,179,125,4,4,4);

			visualizer.setXmlParam("colorbandpeak", "231,240,197");
			setColorOscOdd("165,179,125");
			setColorOscEven("231,240,197");

		}
		else if(v_color == 28){
			//silver - gradient

			setColorBandsGradient(165,164,190,6,6,4);

			visualizer.setXmlParam("colorbandpeak", "252,252,252");
			setColorOscOdd("165,164,190");
			setColorOscEven("252,252,252");
			
		}
		else if(v_color == 29){
			//RGB
			nextTimer = 1;
			rgbTimer.start();
		}
		setPrivateInt(getSkinName(), "Visualizer Color themes2", v_color);
	}
	else if (a >= 600 && a <= 605)
	{
		grid = a - 600;
		if (grid == 0)
		{
			visgrid_thick.setXmlParam("visible", "0");
			visgrid_thin.setXmlParam("visible", "0");
			visgrid_car.setXmlParam("visible", "0");
		}
		else if (grid == 1)
		{
			visgrid_thick.setXmlParam("visible", "0");
			visgrid_thin.setXmlParam("visible", "0");
			visgrid_car.setXmlParam("visible", "0");
		}
		else if (grid == 2)
		{
			visgrid_thick.setXmlParam("visible", "1");
			visgrid_thin.setXmlParam("visible", "0");
			visgrid_car.setXmlParam("visible", "0");
		}
		else if (grid == 3)
		{
			visgrid_thick.setXmlParam("visible", "0");
			visgrid_thin.setXmlParam("visible", "1");
			visgrid_car.setXmlParam("visible", "0");
		}
		else if (grid == 4)
		{
			visgrid_thick.setXmlParam("visible", "0");
			visgrid_thin.setXmlParam("visible", "0");
			visgrid_car.setXmlParam("visible", "1");
		}
		else if (grid == 5)
		{
			visgrid_thick.setXmlParam("visible", "1");
			visgrid_thin.setXmlParam("visible", "1");
			visgrid_car.setXmlParam("visible", "1");
		}
		setPrivateInt(getSkinName(), "Visualizer show Grid2", grid);
	}
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
	visualizer.setXmlParam("ColorBand1", integerToString(r1)+","+integerToString(g1)+","+integerToString(b1));
	visualizer.setXmlParam("colorosc1", integerToString(r1)+","+integerToString(g1)+","+integerToString(b1));
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
	visualizer.setXmlParam("colorosc2", visualizer.getXmlParam("colorosc1"));
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
	visualizer.setXmlParam("colorosc3", visualizer.getXmlParam("colorosc2"));
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
	visualizer.setXmlParam("colorosc4", visualizer.getXmlParam("colorosc3"));
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
	visualizer.setXmlParam("colorosc5", visualizer.getXmlParam("colorosc4"));
}


//sets every ColorBand in a range to a color
setColorBands(String rgb, int start, int end)
{
	for(int i=start; i<=end; i++){
		visualizer.setXmlParam("ColorBand"+integerToString(i)+"", rgb);
	}
}

//sets every odd ColorBand to a color
setColorBandsOdd(String rgb)
{
	for(int i=1; i<=15; i=i+2){
		visualizer.setXmlParam("ColorBand"+integerToString(i)+"", rgb);
	}
}

//sets every even ColorBand to a color
setColorBandsEven(String rgb)
{
	for(int i=2; i<=16; i=i+2){
		visualizer.setXmlParam("ColorBand"+integerToString(i)+"", rgb);
	}
}

//makes a gradient using rgb values and steps for each color
setColorBandsGradient(int r, int g, int b, int stepr, int stepg, int stepb)
{
	String grad = integerToString(r) +","+ integerToString(g) +","+ integerToString(b);
	for(int i=1; i<=16; i++){
		visualizer.setXmlParam("ColorBand"+integerToString(i)+"", grad);
		r=r+stepr; g=g+stepg; b=b+stepb;
		grad = integerToString(r) +","+ integerToString(g) +","+ integerToString(b);
	}
}

//sets every colorosc to a color
setColorosc(String rgb)
{
	for(int i=1; i<=5; i++){
		visualizer.setXmlParam("colorosc"+integerToString(i)+"", rgb);
	}
}

//sets every colorosc in a range to a color
setColoroscRange(String rgb, int start, int end)
{
	for(int i=start; i<=end; i++){
		visualizer.setXmlParam("colorosc"+integerToString(i)+"", rgb);
	}
}

//sets every odd colorosc to a color
setColoroscOdd(String rgb)
{
	for(int i=1; i<=5; i=i+2){
		visualizer.setXmlParam("colorosc"+integerToString(i)+"", rgb);
	}
}

//sets every even colorosc to a color
setColoroscEven(String rgb)
{
	for(int i=2; i<=4; i=i+2){
		visualizer.setXmlParam("colorosc"+integerToString(i)+"", rgb);
	}
}


setVis (int mode)
{
	setPrivateInt(getSkinName(), "Visualizer Mode2", mode);
	if (mode == 0)
	{
		visualizer.setMode(0);
	}
	else if (mode == 1)
	{
		visualizer.setXmlParam("bandwidth", "wide");
		visualizer.setMode(1);
	}
	else if (mode == 2)
	{
		visualizer.setXmlParam("bandwidth", "thin");
		visualizer.setMode(1);
	}
	else if (mode == 3)
	{
		visualizer.setXmlParam("oscstyle", "solid");
		visualizer.setMode(2);
	}
	else if (mode == 4)
	{
		visualizer.setXmlParam("oscstyle", "dots");
		visualizer.setMode(2);
	}
	else if (mode == 5)
	{
		visualizer.setXmlParam("oscstyle", "lines");
		visualizer.setMode(2);
	}
	currentMode = mode;
}
