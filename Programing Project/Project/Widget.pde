/**
  * The super class for all widgets. Has a lot of the features such as the 
  * general shape and the shadow.
  *----------------------------------------------------------------------------
  *
  * Created by Conall Tuohy & Gregory Partridge.
  */
  
  class Widget {
  float x, y, width, height;
  String label;
  int event;
  color widgetColor, labelColor;
  Widget(float x, float y, float width, float height, String label, color widgetColor,  int event)
  {
    this.x=x;
    this.y=y;
    this.width = width;
    this.height= height;
    this.label=label;
    this.event=event;
    this.widgetColor=widgetColor;
    labelColor= color(0);
  }

  void draw() {
    if (mouseY >= y && mouseY <y +height && mouseX >=x && mouseX <= x+width)
    {
      fill(0);
        rect(x, 265, + VERTICAL_OFFSET_BETWEEN_WIDGETS ,width + 3, height + 3);
        ellipse(x, 265 + (height + 3)/2 + VERTICAL_OFFSET_BETWEEN_WIDGETS, height+3, height+3);
        ellipse(x + 125, 265 + (height + 3)/2 + VERTICAL_OFFSET_BETWEEN_WIDGETS, height+3, height+3);
        
    }

    fill(widgetColor);
        rect(x, 265, + VERTICAL_OFFSET_BETWEEN_WIDGETS ,width, height);
        ellipse(x, 265 + (height)/2 + VERTICAL_OFFSET_BETWEEN_WIDGETS, height, height);
        ellipse(x + 125, 265 + (height + 3)/2 + VERTICAL_OFFSET_BETWEEN_WIDGETS, height, height);
    fill(labelColor);
    //text(label, x+10, y+height-10);
     //if(verticalOffsetOfWidgets<600) println(verticalOffsetOfWidgets);
  }

  int getEvent(int mX, int mY) {
    if (mX>x && mX < x+width && mY >y && mY <y+height)
    {
      return event;
    }
    return 0;
  }
}
