pragma circom 2.0.0;

// arthimatic circuit

/**

    A ---->
             X ----> 
    A ---->               
                       +  ---->  D 
    B ------------->


**/

template Mult() {
  signal input a;
  signal input b;

  signal output d;
  var c=0;

  c = a*a;
  d <== c+b;

}

component main = Mult();

