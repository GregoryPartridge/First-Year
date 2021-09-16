/* 
This class was created and maintained by Eoin Pinaqui.
This class is used to create and draw the directional page widgets that are seen on the banner in the main program.
*/

class PageDirections extends RectangleWidget
{
  PFont directionsFont;

  PageDirections(int x, int y, int width, int height, String title, color widgetColor, int event, PFont directionsFont)
  {
    super(x, y, width, height, title, widgetColor, event, color(255), x, y);
    this.directionsFont = directionsFont;
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
    rect(x, y, width, height);
    textFont(directionsFont);
    fill(255);
    textAlign(CENTER, CENTER);
    text(label, x + width/2, y + height/2);
  }
}
