import processing.serial.*;
import processing.sound.*;
import ddf.minim.*;


int a;
int fruitindex;
boolean kas;
Serial mySerial;  // Create object from Serial class
String myString=null;    // Data received from the serial port
PVector location1;  // Location of shape
PVector velocity;  // Velocity of shape
PVector gravity;   // Gravity acts at the shape's acceleration
PImage imgl1;
PImage imgl2;
PImage img3;
PImage img1,img2,randfruit;
PImage cg1,cg2,cg3,cg4;
String[] playerlist={"Ebasket.png","Leastbas.png","BAS.png","Masterbasket1.1.png"};
String[] fruitlist={"apple.png","mango.png","kiwi.png","poisonous.png"};


//Objects
Player player = new Player();
//Bullet arraylist
ArrayList<Bullet> bullets;


String[] bg_img = {"1538621112_maxresdefault.jpg","a3223947044_10.jpg","good-night-2904747_1920.jpg","maxresdefault.jpg","pis10 (1).jpg","grellow.jpeg","blue.jpeg","grite.jpeg","pink.jpeg","Taiputini-National-Park.jpg"};

PImage background[] = new PImage[bg_img.length];

String[] musiclist = {"pis1.mp3","pis2.mp3","pis3.mp3","pis4.mp3","pis5.mp3","goodf.mp3","badf.mp3"};


//Vars to regulate shooting speed
boolean canShoot = true;
float canShootCounter;
int dist=320*1600/640,targ=0;
int i;
int score=0;

int numSong = 7;

SoundFile file;
//SoundFile musicfiles[];
final  Minim minim = new Minim(this);
AudioPlayer[] musicfiles = new AudioPlayer[numSong];
int currsong=int(random(0,numSong))-1;

long timeToWait = 10000;// in miliseconds
long lastTime;
long firstTime;
int bg = int(random(0,background.length));

void setup() 
{
  fruitindex=0;
  kas=true;
  mySerial=new Serial(this,"COM7",9600);
  //print(fruitlist[3]);

  size(1600,600);
  //location1 for basket
  location1 = new PVector(100,100);
  velocity = new PVector(1.5,2.1);
  gravity = new PVector(0,0.2);
  cg1= loadImage(playerlist[0]);
  cg2= loadImage(playerlist[1]);
  cg3= loadImage(playerlist[2]);
  cg4= loadImage(playerlist[3]);
  imgl1= loadImage("loss.png");
  imgl2= loadImage("congo.png");
  //size(1200,700);
  img3=cg1;

// loading all the images in the array
  for(int i = 0; i < bg_img.length; i++)
  {
    background[i] = loadImage(bg_img[i]);
  }

    //bullets code
    bullets = new ArrayList<Bullet>();
  player = new Player();
  
  file = new SoundFile(this, "explosion-01.mp3");
//  file.play();


// loading all the music files in the array
  for(int i = 0; i < musiclist.length; i++)
  {
    musicfiles[i] = minim.loadFile(musiclist[i]);
  }

lastTime = millis();
firstTime = lastTime;

}


//Instruct sound at event

void mouseClicked()
{
 file.play();
 file.amp(200);
}


void draw() 
{
 if (firstTime == lastTime)
 {
       image(background[0], 0, 0,1600,600);
       lastTime = millis();
 }
 else
   {
     if( millis() - lastTime > timeToWait)
    {
      lastTime = millis();
      bg = bg + 1;
      if (bg > background.length-1)
      {
        bg = 0;
      }
      
    }
    if(score<0 || score>=20){
      if(score<0){image(imgl1, 0, 0,1600,600);}
      else if(score>=20){image(imgl2, 0, 0,1600,600);}
      if(a!=dist)
      {score=0;}
    }
    else{image(background[bg], 0, 0,1600,600);}  
     redraw();
   }   

 //redraw();
 
randfruit=loadImage(fruitlist[fruitindex]);

 if (firstTime == lastTime)
 {
       //image(background[0], 0, 0,1600,600); 
       //background(255,255,255);
       lastTime = millis();
 }
 else
   {
     if( millis() - lastTime > timeToWait)
    {
      lastTime = millis();
      bg = bg + 1;
      if (bg > background.length-1)
      {
        bg = 0;
      }
       //background(0,255,255);
      //image(background[bg], 0, 0,1600,600);  
      //redraw();
    }
   } 
   

   
   if (currsong == -1)
   {
     currsong = 0;  
     musicfiles[currsong].play();
   }
   else
   {
     if (!musicfiles[currsong].isPlaying())
     {
       currsong++;
       if (currsong > numSong - 3)
       {
         currsong = 0;
         // loading all the music files in the array
          for(int i = 0; i < musiclist.length; i++)
          {
            musicfiles[i] = minim.loadFile(musiclist[i]);  
          }
       }
       musicfiles[currsong].play();
     }
   }
//println('a');  
while (mySerial.available()>0)
 {
    myString=mySerial.readStringUntil('\n');
    
    if (myString !=null)
    {
      //background(0);
      
      //print(myString);
       //kas=true;
    
    if(myString.indexOf("Distance: ")>=0)
    {
            dist=int(myString.substring("Distance: ".length(),myString.length()-1))*1600/640;
    }
 }
 }
if(score<20 && score>=0)
{ a=dist;
  player.update(); 
  textSize(32);
  fill(0,0,255);
  text("Fruits :",30,30);
  text(score,90+30+20,30);
 for (i = bullets.size()-1; i >= 0; i--) {
    //you need a seperate var to get the object from the bullets arraylist then use that variable to call the functions
    Bullet bullet = bullets.get(i);
    bullet.update();
  }
  // Add velocity to the location.
  //location1.add(velocity);
  // Add gravity to velocity
  velocity.add(gravity);
  
  // Bounce off edges
  if ((location1.x > width-20) || (location1.x <= 0)) {
    //String[] words = { "a", "bb", "ccc", "dogo" };y
    //int index = int(random(words.length));
    //velocity.x = -(velocity.x/(abs(velocity.x))*index);
    velocity.x=velocity.x*-1;
  }
  location1.x=dist;
  location1.y=height-50-50;
  /*if (location.y > height) {
    // We're reducing velocity ever so slightly 
    // when it hits the bottom of the window
    velocity.y = velocity.y * -0.95; 
    location.y = height;
*/  


  // Display circle at location vector
  stroke(255);
  strokeWeight(2);
  
  fill(127);
  
  //println(img3,location1.x,location1.y,dist);
  println(location1.x-25,location1.y);
  image(img3,location1.x-25-25,location1.y,30*5/2*2,10*5/2*2+20+30);
}
}

class Player {
  PVector location;
  Player() {
    location = new PVector(width/2, height/2);
  } 
  void update() {
    if (kas==true) {
      // this regulates the shooting speed
      //if (canShoot == true) {
        bullets.add( new Bullet());
        kas=false;
        //canShoot = false;
        //canShootCounter = 0; 
      }
    }
    }

class Bullet 
{
  //standard PVector used for the location of the bullet
  PVector location;
  //vars used to check the angle between location and the mouse
  float oldPosX, oldPosY, rotation, speed;
  Bullet() 
  {
    //places the bullet in the middle of the room
    location= new PVector(int(random(3)+1)*160, 0);
    //this checks the angle
    oldPosX = mouseX;
    oldPosY = mouseY;
    //rotation = atan2(oldPosY - location.y, oldPosX - location.x) / PI * 180;
    rotation=-90;
    //bullet speed
    speed = 10;//change this number to change the speed
  }

  void update() 
  {
    //move the bullet/fruit
    
    location.x = location.x - cos(rotation/180*PI)*speed;
    location.y = location.y - sin(rotation/180*PI)*speed;
    //print(location.x,location.y);
    //tint(255,126);
    image(randfruit,location.x*1600/640, location.y, 20*5/2-20, 30*5/2-25);
    kas=false;
    if(!(location.x*1600/640 > 0 && location.x*1600/640 < 1600 && location.y > 0 && location.y < 600 )||(location.x*1600/640==dist && location.y>=location1.y)) 
    {
      bullets.remove(i);
      kas=true;
           if(location.x*1600/640==location1.x && location.y>=location1.y)
      {
        musicfiles[5].play();
        musicfiles[5] = minim.loadFile(musiclist[5]);
        //musicfiles[i] = minim.loadFile(musiclist[6]);
        score++;
        println('a');
        if(fruitindex==3)
        {
         score-=4;
       musicfiles[6].play();
       //musicfiles[i] = minim.loadFile(musiclist[5]);
       musicfiles[6] = minim.loadFile(musiclist[6]);

       //print(fruitlist[fruitindex]);
        }
      }
 
      fruitindex=int(random(1.0)*4);

    if(score==0)
    {
      fruitindex=int(random(1.0)*3);  
    }
      //if((location.x+10>=targ*16-10 && location.x<=targ*16+30  && location.y<=50))
   }
    if(score>5 && score<=10){
      img3=cg2;
    }
    if(score>10 && score<=15){
      img3=cg3;
    }
    if(score>15)
    {
     img3=cg4;
    }
    
  }
}
