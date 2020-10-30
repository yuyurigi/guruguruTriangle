import java.util.Calendar;

PImage source;

float radius = 10;     // 最初の三角の大きさ（外接円の半径）
float addRadius = 5.0; //線と線の間隔（数字が小さいと狭い）
int vc = 0;
float SCALE = 2.0; 
boolean b = true;
float thickness = 2;  // 線の太さの最小値
float thickMax = 7;   // 線の太さの最大値
PVector[] vertex = {};
PVector Pos, Ac;
float tr;

void setup() {
  frameRate(240);
  size(800, 800);
  background(241, 240, 238); //背景色
  fill(0, 0, 0, 100); //線の色
  
  noStroke();

  source = loadImage("image.png"); // 画像をロード
  source.resize(width, height);
  source.loadPixels();

  PVector center = new PVector(width/2, height/2);
  float lastRadius = dist(center.x, center.y, 50, 50); // 最後の三角の大きさ（外接円の半径）
  float rot = ((lastRadius) / addRadius ) * 90;
  
  Ac = new PVector();

  //三角形の頂点を配列に代入
  float lastx = -999;
    for (float ang = 30; ang <= 30+rot; ang += 120) {
    radius += addRadius;
    float rad = radians(ang);
    float x0 =  center.x + (radius*cos(rad));
    float y0 = center.y + (radius* sin(rad));
    if ( lastx > -999) {
      vertex = (PVector[]) append(vertex, new PVector(x0, y0));
    }
    lastx = x0;
  }
  
  //三角形の辺の中点を計算する
  PVector mp = calcMidPoint(vertex[vertex.length-1], vertex[vertex.length-2]);
  //内接円の半径
  float r = dist(center.x, center.y, mp.x, mp.y);
  //三角形の中心を計算する
  PVector tcenter = calcMidPoint(vertex[vertex.length-3], mp);
  //三角形の中心が画面の真ん中に来るよう移動するための数値
  tr = dist(center.x, center.y, tcenter.x, tcenter.y);
}

//辺の中点を計算する
PVector calcMidPoint(PVector end1, PVector end2){
  float mx, my;
  if (end1.x > end2.x){
    mx = end2.x + ((end1.x - end2.x)/2);
  } else {
    mx = end1.x + ((end2.x - end1.x)/2);
  }
  if (end1.y > end2.y) {
    my = end2.y + ((end1.y - end2.y)/2);
  } else {
    my = end1.y + ((end2.y - end1.y)/2);
  }
  PVector cMP = new PVector(mx, my);
  return cMP;
}

void draw() {
  if (b) {
    Pos = vertex[vc];
  }
  
  b = false;
  
  //Posと次の頂点との距離
  float dist = PVector.dist(Pos, vertex[vc+1]);
  Ac = PVector.sub(vertex[vc+1], Pos); //次の頂点に向かうベクトルを計算
  Ac.normalize(); //単位ベクトル化
  
  int cpos = (int(Pos.y+tr) * source.width) + int(Pos.x); // 画像の色を取得
  color c = source.pixels[cpos]; // 暗い色を太い線に、明るい色を細い線にする
  float dim = map(brightness(c), 0, 255, thickMax, thickness);
  ellipse(Pos.x, Pos.y+tr, dim, dim); //線を描く
  
  if (dist>1) {
    Pos.add(Ac.x*SCALE, Ac.y*SCALE);
    } else {
      PVector m = new PVector();
      m = PVector.sub(vertex[vc+1], Pos);
      Pos.add(m.x, m.y);
    }
  
  if (dist<=0) { //線が角まで来たら
  if (vc == vertex.length-2){
    noLoop();
  }
    b = true;
    vc += 1;
  }
}

void keyPressed() {
  if (key == 's' || key == 'S')saveFrame(timestamp()+"_####.png");
}


String timestamp() {
  Calendar now = Calendar.getInstance();
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", now);
}
