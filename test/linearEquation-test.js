
const { plonk } = require('snarkjs');
const { expect } = require("chai")
const { ethers } = require("hardhat");
const { unstringifyBigInts } = require('../utils/utils');



describe("LinearEquation test", () => {
  let Verifier;
  let verifier
  beforeEach(async () => {
    Verifier = await ethers.getContractFactory("PlonkVerifier")
    verifier = await Verifier.deploy();
    await verifier.deployed()
  })

  it("should return true for valid answer", async () => {
    const { proof, publicSignals } = await plonk.fullProve({ "x": "5", "y": "3", "z": "3" }, "circuits/build/LinearEquation/linearEquation_js/linearEquation.wasm", "circuits/build/LinearEquation/circuit_final.zkey")

    const editedProof = unstringifyBigInts(proof)

    const editedPublicSignals = unstringifyBigInts(publicSignals)

    const calldata = await plonk.exportSolidityCallData(editedProof, editedPublicSignals)

    const argv = calldata.split(",").map((arg, i) => {
      return i === 1 ? parseInt(JSON.parse(arg)) : arg
    })

    expect(await verifier.verifyProof(argv[0], [argv[1]])).to.be.true

  })

  it("should return false for wrong answer", async () => {


    const argv = '0x00,["0x0000000000000000000000000000000000000000000000000000000000000037"]'.split(",").map((arg, i) => {
      return i === 1 ? parseInt(JSON.parse(arg)) : arg
    })

    expect(await verifier.verifyProof(argv[0], [argv[1]])).to.be.false

  })
})