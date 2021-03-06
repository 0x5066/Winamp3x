#include lib/std.mi

Global Group frameGroup;
Global AnimatedLayer ragyoHairL, ragyoHairR;
Global int totalFramesL, totalFramesR, lastBeatL, lastBeatR, lastframe;
Global Timer beatTimer;

System.onScriptLoaded() {
  frameGroup = getScriptGroup();
  ragyoHairL = frameGroup.findObject("ragyovis_hair.animatedlayerL");
  ragyoHairR = frameGroup.findObject("ragyovis_hair.animatedlayerR");
  totalFramesL = ragyoHairL.getLength() - 1;
  totalFramesR = ragyoHairR.getLength() - 1;
  lastBeatL = 0;
  lastBeatR = 0;

  beatTimer = new Timer;
  beatTimer.setDelay(17);
  beatTimer.start();
}

System.onScriptUnloading() {
  delete beatTimer;
}

beatTimer.onTimer() {
  double beatValueL = System.getVisBand(0, 0) / 255;
  double beatValueR = System.getVisBand(0, 0) / 255;

  int ragyoFrameL = beatValueL * (totalFramesL + 1);
  int ragyoFrameR = beatValueR * (totalFramesR + 1);

  if (ragyoFrameL > totalFramesL) ragyoFrameL = totalFramesL;
  if (ragyoFrameL < lastBeatL) ragyoFrameL = (ragyoFrameL + lastBeatL) / 2;

  if (ragyoFrameR > totalFramesR) ragyoFrameR = totalFramesR;
  if (ragyoFrameR < lastBeatR) ragyoFrameR = (ragyoFrameR + lastBeatR) / 2;

  lastBeatL = ragyoFrameL;
  lastBeatR = ragyoFrameR;

  ragyoHairL.gotoframe(ragyoFrameL);
  ragyoHairR.gotoframe(ragyoFrameR);
}
