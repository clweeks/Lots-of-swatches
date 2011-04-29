    bouncyShape[] shapes = new bouncyShape[round(random(1,3))+round(random(2))];
    //bouncyShape[] shapes = new bouncyShape[1];

    imageEvaluator ie = new imageEvaluator();

     void setup() {
       println(shapes.length);
       background(1);
       //size(4800, 1200);
       size(96,96);
       smooth();
       ellipseMode(CORNERS);
       for(int i=0; i < shapes.length; i++) {shapes[i] = new bouncyShape();}
     } 

     void draw() {
       ffor(int j=0; j < 1000; j++) {
         for(int i=0; i < shapes.length; i++) {shapes[i].act();}
       }
       ie.process();
       save(int(red(ie.compositeColor)) + "_" + int(green(ie.compositeColor)) + "_" + int(blue(ie.compositeColor)) + ".png");
 //      while(keyPressed == false) {}
     }
        
     class imageEvaluator {
       color meanColor;
       color modeColor;
       color compositeColor;
       
       imageEvaluator() {}
    
       color getMeanColor() {
         int r = 0;
         int g = 0;
         int b = 0;
         loadPixels();
         for(int i=0; i < pixels.length; i++) {
           r = r + int(red(pixels[i]));
           g = g + int(green(pixels[i]));
           b = b + int(blue(pixels[i]));
 //if (i+20 > pixels.length) {println("r-" + r + ", g-" + g + ", b-" + g);}
         }
         return color(r/pixels.length, g/pixels.length, b/pixels.length);
       }
      
       color getModeColor() {
         HashMap colors = new HashMap();
         loadPixels();
         String colorComponents = "";
         for (int i=0; i < pixels.length; i++) {
           colorComponents = red(pixels[i]) + "," + green(pixels[i]) + "," + blue(pixels[i]);
           
//if (i < 20) {println(colorComponents);}
           
           if (colors.containsKey(colorComponents)) {
             int cc = (Integer)colors.get(colorComponents);
             colors.put(colorComponents, cc + 1);
           } else {
             colors.put(colorComponents,1);
           }
         }

         String highColor = "";
         int highColorCount = 0;

         Iterator i = colors.entrySet().iterator();
         while (i.hasNext()) {
           Map.Entry me = (Map.Entry)i.next();
//if ((Integer)me.getValue() > 1) {println((String)me.getKey() + " -> " + (Integer)me.getValue());}
           if ((Integer)me.getValue() > highColorCount) {
             highColorCount = (Integer)me.getValue();
             highColor = (String)me.getKey();
           }
         } 
         String[] colorConstituents = split(highColor, ",");
         return color(int(colorConstituents[0]), int(colorConstituents[1]), int(colorConstituents[2]));
       }
      
      color blendColors(color c1, color c2) {
        return color((red(c1)+red(c2))/2,(green(c1)+green(c2))/2,(blue(c1)+blue(c2))/2);
      }
       
       void process() {
         meanColor = getMeanColor();
//println("meanColor = " + red(meanColor) + ", " + green(meanColor) + ", " + blue(meanColor));
         modeColor = getModeColor();
//println("modeColor = " + red(modeColor) + ", " + green(modeColor) + ", " + blue(modeColor));
         compositeColor = blendColors(meanColor, modeColor);
//println("compositeColor = " + red(compositeColor) + ", " + green(compositeColor) + ", " + blue(compositeColor));
       }
     }
         
     class bouncyShape {
       int x1;
       int y1;
       int x2;
       int y2;

       float x1speed;
       float y1speed;
       float x2speed;
       float y2speed;

       color interior;
       color exterior;

       bouncyShape() {
         x1 = int(random(width * .2, width * .8));
         y1 = int(random(height * .2, height * .8));
         x2 = int(random(width * .2, width * .8));
         y2 = int(random(height * .2, height * .8));
         x1speed = conditionSpeed(random(-2,2));
         y1speed = conditionSpeed(random(-2,2));
         x2speed = conditionSpeed(random(-2,2));
         y2speed = conditionSpeed(random(-2,2));
         interior = color(int(random(255)),int(random(255)),int(random(255)),int(random(4)));
         //exterior = color(255 - red(interior),255 - green(interior),255 - blue(interior));
         exterior = color(int(random(255)),int(random(255)),int(random(255)),int(random(20)));
       }
       
       void display() {
         stroke(exterior);
         fill(interior);
         //ellipse(x1,y1,x2,y2);
         line(x1,y1,x2,y2);         
         if (x1 == x2 && y1 == y2 && int(random(12)) == 1) {background(int(random(255)),int(random(255)),int(random(255)));}
       }
       
       void move() {
         x1 = int(x1 + x1speed);
         y1 = int(y1 + y1speed);
         x2 = int(x2 + x2speed);
         y2 = int(y2 + y2speed);
       }
       
       void bounce() {
         //if ((x1 <= (width * .1)) || (x1 >= (width * .9))) {x1speed = conditionSpeed(0 - x1speed + random(0,-.3));y1speed = conditionSpeed(y1speed + random(0,.3));}
         //if ((y1 <= (height * .1)) || (y1 >= (height * .9))) {y1speed = conditionSpeed(0 - y1speed + random(0,-.3));x1speed = conditionSpeed(x1speed + random(0,.3));}
         //if ((x2 <= (width * .1)) || (x2 >= (width * .9))) {x2speed = conditionSpeed(0 - x2speed + random(0,-.3));y2speed = conditionSpeed(y2speed + random(0,.3));}
         //if ((y2 <= (height * .1)) || (y2 >= (height * .9))) {y2speed = conditionSpeed(0 - y2speed + random(0,-.3));x2speed = conditionSpeed(x2speed + random(0,.3));}
       
         if (x1 < min(50,width * .05)) {x1speed = random(.6,3);y1speed++;}
         if (x1 > max(width-50,width * .95)) {x1speed = random(-3,-.6);y1speed++;}
         if (y1 < min(50,height * .05)) {y1speed = random(.6,3);x1speed++;}
         if (y1 > max(height-50,height * .95)) {y1speed = random(-3,-.6);x1speed++;}
         if (x2 < min(50,width * .05)) {x2speed = random(.6,3);y2speed++;}
         if (x2 > max(width-50,width * .95)) {x2speed = random(-3,-.6);y2speed++;}
         if (y2 < min(50,height * .05)) {y2speed = random(.6,3);x2speed++;}
         if (y2 > max(height-50,height * .95)) {y2speed = random(-3,-.6);x2speed++;}
       }
       
       void act() {
         display();
         move();
         bounce();
         if (int(random(1000)) == 1) {exterior = color(int(random(255)),int(random(255)),int(random(255)),int(random(20)));}
         if (int(random(1000)) == 1) {
           interior = color(int(random(255)),int(random(255)),int(random(255)),int(random(4)));
           //exterior = color(255 - red(interior),255 - green(interior),255 - blue(interior));
         }
       }
       
       float conditionSpeed(float speed) {
         boolean positive = true;
         if (speed < 0) {positive = false;}
         if (positive) {return max(.6,speed);} else {return min(-.6,speed);}
       }
     }  
     
   
