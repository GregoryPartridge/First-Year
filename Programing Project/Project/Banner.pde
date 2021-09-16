boolean mouseOnBanner;
/*
This class was created and maintained by Eoin Pinaqui. This class creates the banner that is shown at the top of the screen.
This banner is drawn underneath the widgets that appear to be on it.
*/
class Banner
{
  private int width, height, x, y;
  private PFont logo;
  private color bannerColor;

  Banner(int width, int height, int x, int y, PFont logo, color bannerColor)
  {
    this.width = width;
    this.height = height;
    this.x = x;
    this.y = y;
    this.logo = logo;
    this.bannerColor = bannerColor;
    mouseOnBanner=false;
  }

  void draw()
  {
    textFont(logo);
    textAlign(LEFT, TOP);
    noStroke();
    fill(bannerColor);
    rect(0, 0, displayWidth, displayHeight/6);
    textFont(logo);
    fill(255);
    text("TCD News", 20, 20);
    if(mouseY < displayHeight/6) mouseOnBanner=true;
  }

  color getBannerColor()
  {
    return bannerColor;
  }

  int getHeight()
  {
    return displayHeight/6;
  }
}
