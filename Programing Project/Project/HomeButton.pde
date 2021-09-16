/*
This class was created and maintained by Eoin Pinaqui.
This class is used to create and draw the home button that appears on thebanner in the program
*/

class HomeButton extends RectangleWidget {

  PFont homeFont;
  PImage homeIcon;
  HomeButton(int x, int y, int width, int height, String title, color widgetColor, int event, PFont homeFont)
  {
    super(x, y, width, height, title, widgetColor, event, color(255), x, y);
    this.homeFont = homeFont;
    homeIcon = loadImage("Home Icon.png");
    homeIcon.resize(width, height);
  }
  
  void draw()
  {
    if (mouseY >= y && mouseY <y +height && mouseX >=x && mouseX <= x+width)
    {
      stroke(255);
    } else {
      noStroke();
    }
    fill(widgetColor);
    textFont(homeFont);
    rect(x, y, width, height);
    textAlign(CENTER, CENTER);
    image(homeIcon, x, y);
  }
}
