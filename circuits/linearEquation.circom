template linearEquation() {
  signal input x;
  signal input y;
  signal input z;
  signal output out;

  signal sqr <== y*y;
  signal quad <==  sqr * z;
  out <== x * x + quad + 3; 
}

component main = linearEquation();