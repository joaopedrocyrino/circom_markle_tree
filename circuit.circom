pragma circom 2.0.0;

include "./node_modules/circomlib/circuits/mimcsponge.circom";

template DoubleHashedLeaf() {
    signal input left;
    signal input right;
    signal output out;

    component hash = MiMCSponge(2, 220, 1);

    hash.ins[0] <== left;
    hash.ins[1] <== right;
    hash.k <== 0;

    out <== hash.outs[0]; 
}
 
template MerkleTreeRoot (n) {
   signal input leaves[n];
   signal output root;
   component H[n - 1];

   var index = 0;

   for (var i = 0; i < n - 1; i++) {
      H[i] = DoubleHashedLeaf();

      if (index < n - 1) {
         H[i].left <== leaves[index];
         H[i].right <== leaves[index + 1];
      } else {
         H[i].left <== H[index - n].out;
         H[i].right <== H[index - n + 1].out;
      }

      index += 2;
   }

   root <== H[n - 2].out;
}

 component main {public [leaves]} = MerkleTreeRoot(8);