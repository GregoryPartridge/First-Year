/**
  * A widget which is used to show the progress of an operation. A loading
  * animation is also present.
  * ----------------------------------------------------------------------------
  *
  * Maintained by Lexes Mantiquilla & Gregory Partridge
  */
class LoadingBarWidget extends Widget {
  int opacity, counter, circleRadius, squareDimensions1, squareDimensions2;
  float angle;
  boolean goingDown;

  /**
    * Constructs a LoadingBarWidget object which sets the instance variables and
    * sets defaults for the loading animation.
    */
  LoadingBarWidget(int x, int y, int width, int height, String label, color loadingBarColor,  int event) {
    super(x, y, width, height, label, loadingBarColor, event);
    opacity = 255;
    angle = 0;
    counter=0;
    circleRadius=160;
    squareDimensions1=80;
    squareDimensions2=70;
    goingDown=false;
  }

  /** Draws the LoadingBarWidget according to the percent passed */
  void draw(float percentFinished) {
    noStroke();
    if (percentFinished <= 0.99f) {
      opacity = 255;
    }
    if (opacity > 0) {
      fill(255);
      rect (x, y, width, height);
      if (percentFinished <= 0.99f) {
        fill(widgetColor);
      } else {
        fill(widgetColor, opacity);
        opacity -= 5;
      }
      rect(x + 1, y + 1, (width - 2) * percentFinished, height);
    }
      if(percentFinished <= 0.99f && percentFinished > 0 && currentScreen != 1)
      {
        pushMatrix();
        translate(displayWidth/2,displayHeight/2);
        rotate(radians(angle));
        fill(0);
        ellipse(0,0,circleRadius,circleRadius);
        rect(0,0,squareDimensions2,squareDimensions2);
        rect(-70,-70,squareDimensions2,squareDimensions2);
        rect(0,0,squareDimensions2,squareDimensions2);
        rect(0,0,squareDimensions2,squareDimensions2);
        fill(255);
        rect(-40,-40,squareDimensions1,squareDimensions1);

        angle+=(SPEED_AT_WHICH_LOAD_WHEEL_ROTATES * percentFinished);
        popMatrix();
        //fill(0);
        //text((int)(100 * percentFinished)+"%",displayWidth/2-10,displayHeight/2);
      }
      //if(percentFinished > 0.8)
      //{
      //  if(circleRadius>=0)
      //  {
      //    circleRadius-=2;
      //  }
      //  else
      //  {
      //    circleRadius=0;
      //  }
      //  if(squareDimensions1>=0)
      //  {
      //    squareDimensions1--;
      //  }
      //  else
      //  {
      //    squareDimensions1=0;
      //  }
      //  if(squareDimensions2>=0)
      //  {
      //    squareDimensions2--;
      //  }
      //  else
      //  {
      //    squareDimensions2=0;
      //  }
      //}
    }
  }
