// See makePattern for the pretty image generation.

import org.apache.commons.math3.complex.*;
float x_min = -3;
float y_min = -3;

float x_max = 3;
float y_max = 3;

//int N = 300;
//float dist = 1.5;

float[] pows = {0.3, 0.5, 0.7, 1, 1.5, 2, 2.3, 2.5, 3, 4, 5, 6.1, 7, 8, 9, 9.5, 10};

void setup() {
    size(1000, 1000);
    background(0);
    
    makePattern(3.4, 1, 3, 100);
    
    //iterate(new Complex(1, 1.5), 300, 100);
    /*
    
    
    
    //first general rendering 
    for (int i_pow = 0; i_pow < 17; i_pow ++){
        for(float dist = 0.5; dist < 3; dist += 0.5) {
            for (int levels = 1; levels < 3; levels ++){
                makePattern(pows[i_pow], dist, levels, 300);
                saveFrame("pow " + str(pows[i_pow]) + " dist " + str(dist) + " lvls " + str(levels));
                background(0);
            }
        }
    }
    */
    /*
    //animation
    for (int i = 0; i < 60; i++){
        makePattern(i/20.0, 1.5, 1, 200);
        saveFrame("anim1-" + str(i) + ".png");
        background(0);
    }*/
}

//iterates a smoothed newton-raphson on f(z) = z^(pow), on a collection of N points equally spaced from the origin.
void makePattern(float pow, float dist, int levels, float N) {
    for (int j = 1; j < levels + 1; j ++) {
        for (int i = 0; i < N; i ++){
            iterate(new Complex(j*dist*cos(2*PI*i / N), j*dist*sin(2*PI*i / N)), 40, pow);
        
        }
    }
}

void draw() {

}

void mousePressed() {
    //iterate(getVal(mouseX, mouseY), 40);

}

void iterate(Complex z, int n, float pow) {
    Complex z_new;
    z_new = z;
    
    drawPointAt(z);
    
    for (int i = 0; i < n; i ++){
        drawLine(z, z_new);
        //print(z);
        z = z_new;
        z_new = nextIterate(z, 0.2, pow);
        
    }

}

Complex nextIterate(Complex z, float epsi, float pow){
    Complex deltaZ = f(z, pow).divide(Df(z, pow));
    //print(deltaZ);
    return z.subtract(deltaZ.multiply(epsi));
    
}

//Methods to draw on canvas based on complex values
void drawPointAt(Complex z) {
    float[] coords = getCoords(z);
    
    float x = coords[0];
    float y = coords[1];
    
    stroke(255);
    fill(255);
    noStroke();
    ellipse(round(x), int(y), 5, 5);
    
}


void drawLine(Complex z1, Complex z2) {
    float[] coords1 = getCoords(z1);
    float[] coords2 = getCoords(z2);
    
    float x1 = coords1[0];
    float y1 = coords1[1];

    float x2 = coords2[0];
    float y2 = coords2[1];

    stroke(255);
    line(x1, y1, x2, y2);
}

Complex getVal(float[] coords){
    float x = coords[0];
    float y = coords[1];
    
    float re = map(x, 0, width, x_min, x_max);
    float im = map(height - y, 0, height, y_min, y_max);
    
    return new Complex(re, im);

}

Complex getVal(float x, float y){
    float re = map(x, 0, width, x_min, x_max);
    float im = map(height - y, 0, height, y_min, y_max);
    
    return new Complex(re, im);

}

float[] getCoords(Complex z){
    float re = (float) z.getReal();
    float im = (float) z.getImaginary();
    
    float[] coords = new float[2];
    
    coords[0] = width * (re - x_min)/(x_max - x_min);
    coords[1] = height - height * (im - y_min)/(y_max - y_min);
    
    return coords;
}


//Function to iterate NR on
Complex f(Complex z, float pow){
    //Complex z_new = new Complex(1, 0);
    
    
    //for (int i = 0; i < 4; i ++){
    //    z_new = z_new.multiply(z);    
    //}
    
    return (z.pow(pow)).add(-1);
}

//Derivative of above function (could be done numerically for more complicated functions)
Complex Df(Complex z, float pow){
    //Complex z_new = new Complex(1, 0);
    
    //for (int i = 0; i < 3; i++){
    //    z_new = z_new.multiply(z);
    //}
    
    return (z.pow(pow-1)).multiply(pow);
}
