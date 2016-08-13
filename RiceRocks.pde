int width = 800;
int height = 600;
int score = 0;
int lives = 3;
boolean started = false;
float time = 0.5;

Ship my_ship;
ArrayList<Sprite> missiles;
ArrayList<Sprite> rocks;
ArrayList<Sprite> explosions;

// Images
ImageInfo debris_info = new ImageInfo(new int[]{320, 240}, new int[]{640, 480});
PImage debris_image;

ImageInfo nebula_info = new ImageInfo(new int[]{400, 300}, new int[]{800, 600});
PImage nebula_image;

ImageInfo splash_info = new ImageInfo(new int[]{200, 150}, new int[]{400, 300});
PImage splash_image;

ImageInfo ship_info = new ImageInfo(new int[]{45, 45}, new int[]{90, 90}, 35);
//PImage ship_image;

ImageInfo missile_info = new ImageInfo(new int[]{5, 5}, new int[]{10, 10}, 3, 20);
//PImage missile_image;

ImageInfo asteroid_info = new ImageInfo(new int[]{45, 45}, new int[]{90, 90}, 40, 200);
//PImage asteroid_image;

ImageInfo explosion_info = new ImageInfo(new int[]{64, 64}, new int[]{128, 128}, 17, 24, true);
PImage[] explosion_image;


//////// HELPER FUNCTIONS

void process_sprite_group(ArrayList<Sprite> sprite_set){
  
  for (int i = sprite_set.size()-1; i >= 0; i--) {
    Sprite sprite = sprite_set.get(i);
    if (sprite.update() == true) {
      // Items can be deleted with remove().
      sprite_set.remove(i);
    }
    else
      sprite.display();
  }
}

float[] angle_to_vector(float angle){
  return new float[]{cos(angle), sin(angle)};
}

float dist(float[] p, float[] q){
  return sqrt( (p[0] - q[0])*(p[0] - q[0]) + (p[1] - q[1])*(p[1] - q[1]));
}

int ship_collide(ArrayList<Sprite> sprite_set, Ship other_object){
  int collitions = 0;
  for (int i = sprite_set.size()-1; i >= 0; i--) {
    Sprite sprite = sprite_set.get(i);
    if (sprite.collide(other_object) == true) {
      // Items can be deleted with remove().
      sprite_set.remove(i);
      explosions.add(new Sprite(sprite.get_position(), new float[]{0,0}, 0, 0, "explosion_", 24, explosion_info));
      collitions += 1;
    }
  }
  return collitions;
}

int group_collide(ArrayList<Sprite> sprite_set, Sprite other_object){
  int collitions = 0;
  for (int i = sprite_set.size()-1; i >= 0; i--) {
    Sprite sprite = sprite_set.get(i);
    if (sprite.collide(other_object) == true) {
      // Items can be deleted with remove().
      sprite_set.remove(i);
      explosions.add(new Sprite(sprite.get_position(), new float[]{0,0}, 0, 0, "explosion_", 24, explosion_info));
      collitions += 1;
    }
  }
  return collitions;
}

int group_group_collide(ArrayList<Sprite> sprite_set1, ArrayList<Sprite> sprite_set2){
  int collitions = 0;
  for (int i = sprite_set1.size()-1; i >= 0; i--) {
    Sprite sprite = sprite_set1.get(i);
    if (group_collide(sprite_set2, sprite) > 0) {
      // Items can be deleted with remove().
      sprite_set1.remove(i);
      collitions += 1;
    }
  }
  return collitions;
}

////////

void setup(){  
  //size(width, height);
  size(800, 600);
  debris_image = loadImage("debris.png");
  nebula_image = loadImage("planeta.png");
  //splash_image = loadImage("splash.png");
  my_ship = new Ship(new float[]{width / 2, height / 2}, new float[]{0,0}, 0, "ship_", 2, ship_info );
  missiles = new ArrayList<Sprite>();
  rocks = new ArrayList<Sprite>();
  explosions = new ArrayList<Sprite>();
  background(nebula_image);
  imageMode(CENTER);
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      my_ship.set_thrust(true);
    } else if (keyCode == LEFT) {
      my_ship.decrement_angle_vel();
    } else if (keyCode == RIGHT) {
      my_ship.increment_angle_vel();
    } else if (keyCode == CONTROL) {
      my_ship.shoot();
    } 
  }
}

void keyReleased() {
  if (key == CODED) {
    if (keyCode == UP) {
      my_ship.set_thrust(false);
    } 
  }
}

void rock_spawner(){
  
  if ( rocks.size() < 10 ){
    
    float[] rock_pos = {random(width), random(height)};
    float[] rock_vel = {random(90)/30.0 - 1.5, random(90)/30.0 - 1.5};
    float rock_avel = random(20)/100.0 - 0.1;
    if ( dist(rock_pos, my_ship.get_position()) > (1.5)*(my_ship.get_radius() + asteroid_info.get_radius()) ){
      println(rocks.size());
      rocks.add(new Sprite(rock_pos, rock_vel, 0, rock_avel, "asteroid_", 1, asteroid_info));
    }
  }
}

void draw(){
  time += 1;
  
  my_ship.update();
  rock_spawner();
  
  ship_collide(rocks, my_ship);
  group_group_collide(rocks, missiles);
  
  background(nebula_image);
  image(debris_image, ( debris_info.get_center()[0] + time) % (debris_info.get_size()[0] + width)  - .5*debris_info.get_size()[0], debris_info.get_center()[1]);
  image(debris_image, ( debris_info.get_center()[0] + time + .9 * width) % (debris_info.get_size()[0] + width)  - .5*debris_info.get_size()[0], debris_info.get_center()[1]);
  
  process_sprite_group(missiles);
  process_sprite_group(rocks);
  process_sprite_group(explosions);
  my_ship.display();
  
}
class ImageInfo {
  
  int[] center;
  int[] size;
  int radius = 0;
  int lifespan;
  boolean animated = false;
  
  ImageInfo(int [] Centro, int[] Tamano){
    center = new int[2];
    center = Centro;
    size = new int[2];
    size = Tamano;
  }
  
  ImageInfo(int [] Centro, int[] Tamano, int radio){
    center = new int[2];
    center = Centro;
    size = new int[2];
    size = Tamano;
    radius = radio;
  }
  
  ImageInfo(int [] Centro, int[] Tamano, int radio, int tiempodevida){
    center = new int[2];
    center = Centro;
    size = new int[2];
    size = Tamano;
    radius = radio;
    lifespan = tiempodevida;
  }
  
  ImageInfo(int [] Centro, int[] Tamano, int radio, int tiempodevida, boolean animado){
    center = new int[2];
    center = Centro;
    size = new int[2];
    size = Tamano;
    radius = radio;
    lifespan = tiempodevida;
    animated = animado;
  }
  
  int[] get_center(){
    return center;
  }
  
  int[] get_size(){
    return size;
  }
  
  int get_radius(){
    return radius;
  }
  
  int get_lifespan(){
    return lifespan;
  }
  
  boolean get_animated(){
    return animated;
  }
  
}
class Ship{
  float[] pos;
  float[] vel;
  boolean thrust = false;
  float angle;
  float angle_vel = 0;
  PImage[] image;
  int imageCount;
  int[] image_center;
  int[] image_size;
  int radius;
  int time = 0;
  
  Ship(float[] posicion, float[] velocidad, float angulo, String imagen, int count, ImageInfo info){
    pos = posicion;
    vel = velocidad;
    angle = angulo;
    imageCount = count;
    image = new PImage[imageCount];
    for(int i = 0; i < imageCount; i++){
      String filename = imagen + nf(i, 1) + ".png"; 
       image[i] = loadImage(filename);
    }
    image_center = info.get_center();
    image_size = info.get_size();
    radius = info.get_radius();
  }
  
  void display(){
    pushMatrix();  
    translate(pos[0], pos[1]);
    rotate(angle);
    if (thrust)
      image(image[1], 0, 0, image_size[0], image_size[1]);  
    else  
      image(image[0], 0, 0, image_size[0], image_size[1]);
    popMatrix();
  }
  
  void update(){
    // update angle
    angle += angle_vel;
    //update position
    pos[0] = (pos[0] + vel[0]) % width;
    if ( pos[0] < 0)
      pos[0] += width;
    pos[1] = (pos[1] + vel[1]) % height;
    if (pos[1] < 0 )
      pos[1] += height;
    
    // update velocity
    if(thrust){
      float[] acc = angle_to_vector(angle);
      vel[0] += acc[0] * .1;
      vel[1] += acc[1] * .1;
    }
    angle_vel *= 0.99;
    vel[0] *= 1;
    vel[1] *= 1;
  }
  
  void set_thrust(boolean on){
    thrust = on;
  }
      
  void increment_angle_vel(){
    angle_vel += .1;
  }

  void decrement_angle_vel(){
    angle_vel -= .1;
  }

  float[] get_position(){
    return pos;
  }

  int get_radius(){
    return radius;
  }  
  
  void shoot(){
    float[] forward = angle_to_vector(angle);
    missiles.add( new Sprite( new float[]{pos[0] + radius*forward[0], pos[1] + radius*forward[1]}, new float[]{vel[0] + 6*forward[0], vel[1] + 6*forward[1]}, angle, 0, "missile_", 1, missile_info ) );
  }
  
}
class Sprite {
  float[] pos;
  float[] vel;
  float angle;
  float angle_vel = 0;
  PImage[] image;
  int imageCount;
  int[] image_center;
  int[] image_size;
  boolean animated = false;
  int lifespan;
  int age = 0;
  int radius;
  int time = 0;
  
  Sprite(float[] posicion, float[] velocidad, float angulo, float velocidadAngular, String imagen, int count, ImageInfo info){
    pos = posicion;
    vel = velocidad;
    angle = angulo;
    angle_vel = velocidadAngular;
    imageCount = count;
    image = new PImage[imageCount];
    for(int i = 0; i < imageCount; i++){
      String filename = imagen + nf(i, 2) + ".png"; 
       image[i] = loadImage(filename);
    }
    image_center = info.get_center();
    image_size = info.get_size();
    radius = info.get_radius();
    lifespan = info.get_lifespan();
    animated = info.get_animated();
  }
  
  void display(){
    pushMatrix();  
    translate(pos[0], pos[1]);
    rotate(angle);
    if(animated == false)
      image(image[0], 0, 0, image_size[0], image_size[1]);  
    else
      image(image[age], 0, 0, image_size[0], image_size[1]);
    popMatrix();
  }
  
  boolean update(){
    age += 1;
    // update angle
    angle += angle_vel;
    //update position
    pos[0] = (pos[0] + vel[0]) % width;
    if ( pos[0] < 0)
      pos[0] += width;
    pos[1] = (pos[1] + vel[1]) % height;
    if (pos[1] < 0 )
      pos[1] += height;
    if ( age < lifespan )
      return false;
    else
      return true;
  }
  
  float[] get_position(){
    return pos;
  }

  int get_radius(){
    return radius;
  }
  
  boolean collide(Sprite OtherObject){
    if (dist(pos, OtherObject.get_position()) < radius + OtherObject.get_radius())
      return true;
    else
      return false; 
  }
  
  boolean collide(Ship OtherObject){
    if (dist(pos, OtherObject.get_position()) < radius + OtherObject.get_radius())
      return true;
    else
      return false; 
  }
}