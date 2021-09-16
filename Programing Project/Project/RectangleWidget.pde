/* 
This class was created and maintained by Eoin Pinaqui.
This class is used to be a super class for DropDownWidget, PageDirections and HomeButton.
It is also used to create and draw the widgets that appear under the main drop down widget
*/

class RectangleWidget {
  int finalX, finalY, width, height, z;
  String label;
  int event;
  color widgetColor, labelColor, strokeColor;
  boolean startAnimation;
  int startX, startY, x, y;

  RectangleWidget(int finalX, int finalY, int width, int height, String label, color widgetColor, int event, color strokeColor, int x, int y)
  {
    this.finalX=finalX;
    this.finalY=finalY;
    this.width = width;
    this.height= height;
    this.label=label;
    this.event=event;
    this.widgetColor=widgetColor;
    labelColor= color(0);
    this.strokeColor = strokeColor;
    startAnimation = false;
    this.x = x;
    this.y = y;
    startX = x;
    startY = y;
  }

  /*
  Tis function will draw the widgets. It will also animate the widgets dropping down from the main drop down widget
  */
  void draw() {
    if (mouseY >= finalY && mouseY <finalY +height && mouseX >=finalX && mouseX <= finalX+width && !startAnimation)
    {
      stroke(strokeColor);
    } else 
    {
      noStroke();
    }
    textAlign(CENTER, CENTER);

    if (y == finalY)
    {
      startAnimation = false;
    }
    if (startAnimation && y >= startY && y <= finalY)
    {
      fill(widgetColor);
      rect(x, y, width, height, height/4);
      fill(0);
      text(label, x + width/2, y + height/2);
      y += 5;
    } else if (y >= finalY)
    {
      y = finalY;
      fill(widgetColor);
      rect(x, y, width, height, height/3);
      fill(0);
      text(label, x + width/2, y + height/2);
    }
  }

  int getEvent(int mX, int mY) {
    if (mX>finalX && mX < finalX+width && mY >finalY && mY <finalY+height)
    {
      return event;
    }
    return 0;
  }

  void setAnimation(boolean set)
  {
    if (set) {
      startAnimation = set;
    } else
    {
      startAnimation = set;
      x = startX;
      y = startY;
    }
  }
}
