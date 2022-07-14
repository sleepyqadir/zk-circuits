package main

import (
	"fmt"
	"io/ioutil"
	"github.com/iden3/go-circom-prover-verifier/tree/master/parsers"
	"github.com/iden3/go-circom-prover-verifier/tree/master/verifier"
)



func main() {

	fmt.Println("zkSNARK Groth16 verify")

	proofJson, _ := ioutil.ReadFile( "proof.json")

	vkJson, _ := ioutil.ReadFile("verification_key.json")

	publicJson,_ := ioutil.ReadFile("public.json")

	public, _ := parsers.ParsePublicSignals(publicJson)
	proof, _ := parsers.ParseProof(proofJson)
	vk, _ := parsers.ParseVk(vkJson)

	v := verifier.Verify(vk, proof, public)
	fmt.Printf("%v",v)	

}