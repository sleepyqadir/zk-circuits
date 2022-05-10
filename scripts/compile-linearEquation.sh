#!/bin/bash

cd circuits/build

mkdir LinearEquation

if [ -f ./powersOfTau28_hez_final_16.ptau ]; then
  echo "powersOfTau28_hez_final_16.ptau already exists. Skipping."
else
  echo 'Downloading powersOfTau28_hez_final_16.ptau'
  wget https://hermez.s3-eu-west-1.amazonaws.com/powersOfTau28_hez_final_16.ptau
fi

# compile circuit

if [ -f ./LinearEquation/linearEquation.r1cs ]; then
  echo "Skipping the compilation as linearEquation.r1cs already exists"
else
  circom ../linearEquation.circom --r1cs --wasm --sym -o LinearEquation
  snarkjs r1cs info LinearEquation/linearEquation.r1cs
fi

# Start a new zkey and make a contribution

snarkjs plonk setup LinearEquation/linearEquation.r1cs powersOfTau28_hez_final_16.ptau LinearEquation/circuit_final.zkey #circuit_0000.zkey
snarkjs zkey export verificationkey LinearEquation/circuit_final.zkey LinearEquation/verification_key.json

# generate solidity contract
snarkjs zkey export solidityverifier LinearEquation/circuit_final.zkey ../../contracts/verifier.sol
