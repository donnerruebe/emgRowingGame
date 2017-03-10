import hypermedia.net.*;

int PORT_RX=8239;
String HOST_IP = "127.0.0.1";//IP Address of the PC in which this App is running

UDP udp;

Boat b1, b2;
int sizeX;
int sizeY;
int xtarget=130, wtarget=40;
boolean running;
float damping = 0.94;
int countDownFrames = 100;

/********* SETUP BLOCK *********/

void setup() {
  sizeX = 600;
  sizeY = 700;
  size(600, 700);
  udp= new UDP(this, PORT_RX, HOST_IP);
  udp.log(true);
  udp.listen(true);
   initGame();
}

void initGame(){
  textSize(32);
  
  running = true;
  
  
  b1 = new Boat(0.0, 0.0, 200.0, 650.0, color(222,184,135));
  b2 = new Boat(0.0, 0.0, 400.0, 650.0, color(160,82,45));
  
  

  
  //bg = loadImage("sea.jpg");
}



void draw() {
  
  if(running){
    
    //background(bg);
    background(color(50,50,180));
    
    
    // Start und Ziel
    fill(color(255,255,100));
    rect(0, sizeY - 80, sizeX, 80);
    
 
    fill(color(255,0,0));
    rect(0, 30, sizeX, 5);
    
    fill(color(0,255,0));
    
    rect(xtarget, 25, wtarget, 15);
    rect(sizeX/2+xtarget, 25, wtarget, 15);
    

    
    // Border
    fill(color(0,0,0));
    rect(295, 0, 10, sizeY);
    
    
    
    // Collisions
    if(b1.xpos >= 295-22){
       b1.vx = -0.7; 
    }
    
    if(b1.xpos <= 0){
       b1.vx =0.7; 
    }
    
    // Collisions
    if( b2.xpos >= sizeX-20){
       b2.vx = -0.7; 
    }
    
    if(b2.xpos <= 305){
       b2.vx = 0.7; 
    }
    
    b1.draw();
    b2.draw();
    
    if(countDownFrames > 0){
      fill(255, 255, 255);
      text("READY", 260, sizeY - 90 - countDownFrames*3); 
      countDownFrames -= 1;
    }
    
    else{
      b1.animationsschritt();
    b2.animationsschritt();
    }
  }
    
  else{
    fill(255, 255, 255);
    text("FINISH", 260, sizeY - 350);
    if(b1.win){
      
      text("Winner", sizeX/2-200, 100);
    }
    if(b2.win){
      
      text("Winner", sizeX/2+100, 100);
    }
  }

}



class Boat{
 float vx, vy, xpos, ypos;
 color c;
 boolean win;
 float breite=20;
 float laenge=50;
 Boat(float vx, float vy, float xpos, float ypos, color c){
   this.vx = vx;
   this.vy = vy;
   this.ypos = ypos;
   this.xpos = xpos; 
   this.c = c;
   this.win=false;
  }
 void animationsschritt(){
   // Daempfung etc.
   vx *= damping;
   vy *= damping;
   
   
   xpos += vx*2;
   ypos += vy;
   //fill(c);
   //noStroke();
   //rect(xpos, ypos, 20, 40);
   
   if(vy > -0.05 && ypos < sizeY - 100 && vy < 0.8){
   vy+=0.05;
   }
   
   // Check if reached goal
   if(ypos <= 30){
     vy=0.1;
     println("Ziellinie");
     float x2target = xpos;
     if(xpos>sizeX/2){
       x2target = xpos - sizeX/2;
     }
     if(x2target+breite > xtarget && x2target < xtarget + wtarget){ 
       println(x2target);
       running = false;
       this.win=true;
     }
   }
   
 }
 
 void draw(){
   fill(c);
   noStroke();
   rect(xpos, ypos, breite, laenge); 
   triangle(xpos, ypos, xpos+breite/2, ypos-10, xpos+breite, ypos);
 }
 
}



void keyPressed() {
  if (keyCode == LEFT){
      b2.vx += 0.5;
      b2.vy -= 0.5;
  }
  if (keyCode == RIGHT){
      b2.vx -= 0.5;
      b2.vy -= 0.5;
  }
  
  if (key == 'a'){
      b1.vx += 0.5;
      b1.vy -= 0.5;
  }
  if (key == 'd'){
      b1.vx -= 0.5;
      b1.vy -= 0.5;
  }
  if (key == 'r'){
     initGame();
    countDownFrames = 100;
  }
  
}

void receive(byte[] data, String HOST_IP, int PORT_RX){
 
  String value=new String(data);
  println(value);
  
  if (value.equals("PlayerA")){
      println("Test");
      b2.vx += 0.5;
      b2.vy -= 0.5;
  }
  if (value.equals("PlayerB")){
      b2.vx -= 0.5;
      b2.vy -= 0.5;
  }
  
  if (value.equals("PlayerC")){
      b1.vx += 0.5;
      b1.vy -= 0.5;
  }
  if (value.equals("PlayerD")){
      b1.vx -= 0.5;
      b1.vy -= 0.5;
  }
    
}