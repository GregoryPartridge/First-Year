/* 
This class was created and maintained by Eoin Pinaqui. This class is used to create and draw drop down widgets that appear on the banner in the program.
*/
class DropDownWidget extends RectangleWidget {

  private boolean isClicked;
  private ArrayList<RectangleWidget> theUnderButtons;
  private PFont dropDownFont;
  boolean startAnimation;
  
  DropDownWidget(int x, int y, int width, int height, String title, color widgetColor, int event, PFont dropDownFont) {
    super(x, y, width, height, title, widgetColor, event, color(255), x, y);
    this. dropDownFont = dropDownFont;
    this.isClicked = false;
    startAnimation = false;
    theUnderButtons = new ArrayList<RectangleWidget>();
  }

  void draw() {

    if (isClicked)
    {
      stroke(100);
      textAlign(CENTER);
      for (int i = 0; i < theUnderButtons.size(); i++)
      {
        theUnderButtons.get(i).draw();
      }
    }

    fill(widgetColor);
    textFont(dropDownFont);
    textAlign(CENTER, CENTER);
    if (mouseY >= y && mouseY <y +height && mouseX >=x && mouseX <= x+width)
    {
      stroke(255);
    } else {
      noStroke();
    }
    fill(widgetColor);
    rect(x, y, width, height);
    fill(255);
    text(label, x+width/2, y+height/2);
  }

  void open()
  {
    isClicked = true;
    for(int i = 0; i < theUnderButtons.size(); i++)
    {
      theUnderButtons.get(i).setAnimation(true);
    }
  }

  void closeMenu()
  {
    isClicked = false;
    for(int i = 0; i < theUnderButtons.size(); i++)
    {
      theUnderButtons.get(i).setAnimation(false);
    }
  }

  boolean isOpen()
  {
    return isClicked;
  }

  int getX()
  {
    return x;
  }

  /*
  The addOption method adds an option to a drop down menu and only takes in a string as a parameter.
  This is useful as you do not need to create a new rectangle widget every time you need to add an option, you just need to call this function
  and it will create the rectangle widget with an appropriate event integer as well as x, y, width and height values.
  */
  void addOption(String newOption, Banner theBanner)
  {
    RectangleWidget theWidget = new RectangleWidget(x, y+ height + 3 +height  * theUnderButtons.size() + 3*theUnderButtons.size(), 
      width, height, newOption, color(175), theUnderButtons.size() + 1 + event, color(0), x, y);
    theUnderButtons.add(theWidget);
  }

  ArrayList<RectangleWidget> getWidgets()
  {
    return theUnderButtons;
  }
}
