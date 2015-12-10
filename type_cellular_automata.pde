/*
Composer
Project 3
December 6th, 2015
Laurel O'Brien
lobrien14692@ecuad.ca

Does not save PDFs by default. You need to turn on the wantPDF variable
below. 

Left click to generate new offpsring, right click to exit.
*/



/* change these to turn colour indicators on/off and alter layout. 
   final output will be monochrome but colour makes it faster to identify 
   patterns when de-bugging and writing rules
----------------------------------------------------------*/
boolean wantColour = true; //toggle for black vs pastels
boolean wantPDF = false; //toggle boolean output: 
                         //true = export pdf every click
int fontSize = 26; //change number of letters in each row/column
                   //via the font size that fits inside


import processing.pdf.*; //import PDF library


/* declare and initialize global variables
----------------------------------------------------------*/
TypoAutomata reliefGrid; //instantiate 2D cellular automaton object

//array of WoodBlocks for every lowercase letter in the English alphabet
//plus a full-stop (".")
WoodBlock[] allBlocks = new WoodBlock[27];

//array of rules; prescribed offspring for arrangements of letters
boolean[] xRuleSet; //x axis rules, descender based
boolean[] yRuleSet; //y axis rules, ascender based

//values for laying out type in a grid via reliefGrid.render(),
//and transforming that rendering to be mirrored


int spacing = int(fontSize * 1.5); //textbox dimensions
int generation = 0; //generation count
PFont mono; //generation marker font



//initial settings and values
void setup() {
  size(1000, 800); //canvas size, 8.5"x11" format
  background(255); //white
  instantiateWoodBlocks(); //initialize allBlocks[] with new WoodBlocks
  
/* declare & initialize rule sets for evaluating
   generations of TypoAutomata objects on their x and y axes
---------------------------------------------------------*/
  //x axis: referenced in reliefGrid.applyRules()
  boolean[] xRuleSet = { true, false,
                         true, false,
                         false, true,
                         false, false } ;
  //y axis
  boolean[] yRuleSet = { true, false, 
                         true, false, 
                         true, true, 
                         false, true};
                         
  mono = createFont("ApercuProMono.ttf", fontSize); //font for generation marker
  
  //instantiate TypoAutomata object with 2 rule sets, fontSize for rendering
  reliefGrid = new TypoAutomata(xRuleSet, yRuleSet, fontSize);

  reliefGrid.render(); //render the first generation on canvas
}


void draw() {
  //nada: all drawing happens on mouse click
}



/* LEFT CLICK creates a new generation of reliefGrid and renders 
   it on the canvas, erasing the previous one. there is a transform
   on the generation and rendering, translating the rendered object 
   into the center of the canvas with even margins and, when writing
   a PDF, horizontally.
   transformation of scale(-1, 1) flips it horizontally for PDF
   output, before being overwritten by the unscaled version on
   the canvas.
   RIGHT CLICK exits the program to ensure any written PDFs are 
   saved properly.
---------------------------------------------------------*/
void mouseClicked() {
  //on left click
  if (mouseButton == LEFT) {
    
    //if user wants PDF written
    if (wantPDF) beginRecord(PDF, "gen"+generation+".pdf"); //begin recording PDF;
    background(255); //white, erase last frame
    reliefGrid.generate(); //create new generation 
    
    //draw small generation marker above reliefGrid
    //and outside transforms so it's still useful when
    //template is reversed horizontally
    fill(#FFB090); //peachy red
    textAlign(LEFT); //left-align text
    textFont(mono); //use PFont apercu mono
    textSize(fontSize / 1.4); //smaller than reliefGrid's type
    text("generation " + generation, spacing*1.3, spacing/1.1); //draw
    
    //render reliefGrid on the canvas and perform transformations
    //to mirror it horizontally
    pushMatrix(); //isolate memory for transformations
      translate(((spacing * (width/spacing))/2), ((spacing * (height/spacing))/2)); //translate back to final position
      scale(-1, 1); //negative scaling on horizontal axis: mirroring
      translate(-((spacing * (width/spacing))/2),-((spacing * (height/spacing))/2)); //translate center of reliefGrid's to canvas origin (0, 0)
      reliefGrid.render(); //render new generation on canvas
    popMatrix(); //done isolating memory
    
    if (wantPDF) {
      endRecord(); //finish recording pdf
      println("Recorded PDF into sketch folder."); //confirm endRecord() was reached
    }
  
    //re-render same generation on canvas, without mirror transform
    //to preview the actual orientation for the user
    background(255); //erase mirrored version
    reliefGrid.render(); //un-mirrored version
    
    //generation marker again; previous one was erased
    fill(0);
    textAlign(LEFT);
    textFont(mono);
    textSize(fontSize / 1.4);
    text("generation " + generation, spacing*1.3, spacing/1.1);
    
    generation ++; //increment generation count
  } 
  //on right mouse button press
  if (mouseButton == RIGHT) {
    exit(); //exit program properly to ensure PDFs are saved
  }
}