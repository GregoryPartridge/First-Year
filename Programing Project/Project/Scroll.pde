class Scroll
{
  float scrollerY;
  float oldScrollerY;
  int   newScrollerTimer;
  int   scaledHeight;
  Scroll()
  {
    scrollerY=145;
    scaledHeight = displayHeight-40;
  }

  void draw()
  {
    noStroke();
    fill(225);
    //Background Bar
    rect(displayWidth-40, 120, 20, scaledHeight-BANNER_HEIGHT);
    fill(125);
    rect(displayWidth-40, 120, 20, 20);
    rect(displayWidth-40, scaledHeight, 20, 20);
    ellipse(displayWidth-30, 120, 20, 20);
    ellipse(displayWidth-30, scaledHeight+20, 20, 20);
    fill(175);
    //Back of Scroller
    rect(displayWidth-40, scrollerY-8, 20, 35);
    fill(125);
    //Two Bars of Scroller
    rect(displayWidth-36, scrollerY, 4, 19);
    rect(displayWidth-28, scrollerY, 4, 19);
    if (newScrollerTimer<millis()) {
      oldScrollerY = scrollerY;
      newScrollerTimer = millis()+1500;
    }
  }

  float mouseDragged()
  {
    if (mouseX<(displayWidth - 20) && mouseX>(displayWidth - 40) /*&& mouseY>(BANNER_HEIGHT+40) && mouseY<(scaledHeight-40)*/)
    {
      if (mouseY<BANNER_HEIGHT+50) { 
        scrollerY=BANNER_HEIGHT+50;
        return scrollerY;
      } else if (mouseY>scaledHeight-30) {
        scrollerY=scaledHeight-30;
        return scrollerY;
      } else if((mouseY>BANNER_HEIGHT+50) && (mouseY<scaledHeight-40)){
        scrollerY=mouseY;
        return scrollerY;
      } else return 0.0;
    } else return 0.0;
  }
  void moveBar(float movedValue) {
    println(movedValue);
    scrollerY += (-movedValue);
  }
}
