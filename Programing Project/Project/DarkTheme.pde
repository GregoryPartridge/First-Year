/**
  * A small button at the bottom of the screen that inverts the colour if 
  * clicked.
  *----------------------------------------------------------------------------
  *
  * Created by Gregory Partridge
  */

boolean darkThemeOn;
boolean darkThemeChangingAnimation;
float movingSlider;

class DarkTheme
{
  
  
  DarkTheme()
  {
    darkThemeOn=false;
    darkThemeChangingAnimation=false;
    movingSlider=0;
    
  }
  
  void draw()
  {
    noStroke();
    fill(0);
    rect((14 * displayWidth)/15, (14 * displayHeight)/15, displayHeight/20, displayHeight/30);
    ellipse((14 * displayWidth)/15, (14 * displayHeight)/15 + displayHeight/60, displayHeight/30, displayHeight/30);
    ellipse((14 * displayWidth)/15 + displayHeight/20, (14 * displayHeight)/15 + displayHeight/60, displayHeight/30, displayHeight/30);
    if(darkThemeOn){
      fill(#73FFE5);
    }
    else
    {
      fill(#8C001A);
    }
    if(!darkThemeChangingAnimation)
    {
      if(darkThemeOn) ellipse((14 * displayWidth)/15 + displayHeight/20 -  displayHeight/100, (14 * displayHeight)/15 + displayHeight/60, displayHeight/30 - 5, displayHeight/30 - 5);
      else ellipse((14 * displayWidth)/15 + displayHeight/100, (14 * displayHeight)/15 + displayHeight/60, displayHeight/30 - 5, displayHeight/30 - 5);
      if(darkThemeOn) filter(INVERT);
      else filter(null);
    }
    else
    {
      if(darkThemeOn)
      {
        if(darkThemeOn){
        fill(#73FFE5);
      }
        else
      {
        fill(#8C001A);
      }
         if(movingSlider<HOW_LONG_FOR_SLIDER_TO_MOVE)
         {
           ellipse((14 * displayWidth)/15 + displayHeight/100 + (movingSlider * ((14 * displayWidth)/15 + displayHeight/20 -  displayHeight/100 - (14 * displayWidth)/15 + displayHeight/100))/HOW_LONG_FOR_SLIDER_TO_MOVE, (14 * displayHeight)/15 + displayHeight/60, displayHeight/30 - 5, displayHeight/30 - 5);
           movingSlider++;
         }
         else
         {
           movingSlider=0;
           darkThemeChangingAnimation=false;
         }
      }
      else if (!darkThemeOn)
      {
        if(darkThemeOn){
        fill(#73FFE5);
      }
      else
      {
        fill(#8C001A);
      }
        if(movingSlider<HOW_LONG_FOR_SLIDER_TO_MOVE)
        {
          ellipse((14 * displayWidth)/15 + displayHeight/20 - displayHeight/100 - (movingSlider * ((14 * displayWidth)/15 + displayHeight/20 -  displayHeight/100 - (14 * displayWidth)/15 + displayHeight/100))/HOW_LONG_FOR_SLIDER_TO_MOVE, (14 * displayHeight)/15 + displayHeight/60, displayHeight/30 - 5, displayHeight/30 - 5);
           movingSlider++;
        }
        else
        {
          movingSlider=0;
          darkThemeChangingAnimation=false;
        }
      }
    }
    
    fill(0);
  }
}
