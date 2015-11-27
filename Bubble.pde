class Bubble {          //the class for each bubble
  float x, y;          //position variables
  float diameter;      //diameter
  float vx = 0;        //velocity
  float vy = 0;
  int id;                //number
  int broken = 0;        //whether or not it is broken
  float growrate = 0;    //rate at which it grows
  ArrayList others;      //other bubbles
  int superX;            //used to determine if it is a super bubble
  boolean superBubble;   //whether it is a super bubble or not
  boolean freeClick;     //whether it is a free click bubble or not

  Bubble(float xin, float yin, float din, int idin, ArrayList oin) {  //assigns values to inputs
    x = xin;    
    y = yin;
    diameter = din;
    growrate = 0;
    id = idin;
    vx = random(0, 100)/50. - 1.;
    vy = random(0, 100)/50. - 1.;
    superX = int(random(0, totalBubbles));  //random number between 0 and number or bubbles
    superBubble = false;
    freeClick = false;
    if (superX >= totalBubbles - (4-(difficulty*0.75))) superBubble = true;    //if the number is high enough, it is a super bubble
    if(id == 1) freeClick = true;                                              //only one bubble gets set as a free click bubble
    others = oin;
  } 
  void burst()
  {
    if (this.broken != BROKEN) // only burst once
    {
      if(this.freeClick == true){
        clicksleft ++;                      //adds a click if it is a free click bubble
      }
      score++;                    //adds to the score
      this.broken = BROKEN;
      this.growrate = 2; // start it expanding
    }
  }

  void collide() {
    Bubble b;
    // check collisions with all bubbles
    for (int i = 0; i < numBubbles; i++) {

      b = (Bubble)others.get(i);
      float dx = b.x - x;
      float dy = b.y - y;
      float distance = sqrt(dx*dx + dy*dy);
      float minDist = b.diameter/2 + diameter/2;
      if (distance < minDist) { // collision has happened
        if ((this.broken == BROKEN) || (b.broken == BROKEN))
        {
          // broken bubbles cause others to break also
          if(clicksleft == 0) second = second();
          b.burst();
        }
      }
    }
  }

  void update() {
    if (this.broken == BROKEN)
    {
      if(superBubble == true) this.diameter += this.growrate *2;    //grows faster if it is a super bubble
      else this.diameter += this.growrate;
      if(superBubble == true){
        if (this.diameter > MAXDIAMETER * 1.5) // reached max size , larger for super bubble
        this.growrate = -1; // start shrinking faster for super bubble
      }else{
      if (this.diameter > MAXDIAMETER) // reached max size
        this.growrate = -0.75; // start shrinking
      }
    } else {
      // move via Euler integration
      x += vx;
      y += vy;

      // the rest: reflect off the sides and top and bottom of the screen
      if (x + diameter/2 > width) {
        x = width - diameter/2;
        vx *= -1;
      } else if (x - diameter/2 < 0) {
        x = diameter/2;
        vx *= -1;
      }
      if (y + diameter/2 > height) {
        y = height - diameter/2;
        vy *= -1;
      } else if (y - diameter/2 < 0) {
        y = diameter/2;
        vy *= -1;
      }
    }
  }

  void display() {
    // if it is a super bubble and is broken, give it a white outline
    if(superBubble == true && this.broken == BROKEN) {
      strokeWeight(2);
      stroke(255);
      // if it is a free click bubble and is broken, give it a black outline
    } else if (freeClick == true && this.broken == BROKEN){
      strokeWeight(2);
      stroke(0);
    }
    else noStroke();  
    fill(name[difficulty - 1]);  //fill with the current level color for bubbles
    ellipse(x, y, diameter, diameter);    //draws bubble
  }
}
