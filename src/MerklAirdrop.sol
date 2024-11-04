//SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import {MerkleProof} from "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import {IERC20, SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract MerkleAirdrop {
    using SafeERC20 for IERC20;
    // distribute my token based on the list of addresses i have
    // have proof check of the address using merkle proof
    // transfer token to the address
    error MerkleAirdrop_InvalidRoothash();
    error MerkleAirdrop_alreadyclaimed();

    event calimed(address add_claimer, uint256 amount);

    address[] claimer;
    bytes32 private immutable i_roothash;
    IERC20 private immutable i_airdroptoken;
    mapping(address claimer => bool claimed) private s_hasClaimed;


    //for the constructor we have to pass in the ERC20 token as well as the root hash of the addresses to complete with the merkle proof
    constructor(bytes32 merkleroot, IERC20 airdroptoken) {
        i_airdroptoken = airdroptoken;
        i_roothash = merkleroot;
        //atoring the roo hash and token into the contract state as immutable
    }

    // the claim function
    /*following CEI
    */
   function claim(address add_claimer, uint256 amount, bytes32[] calldata merklehash) external {
    //check for the address to be available in merkle root hash
    // check the amount
    // check for re spending
    // update the transfered variable
    if(s_hasClaimed[add_claimer]){
        revert MerkleAirdrop_alreadyclaimed();
    }

    //computing hash
    bytes32 leaf = keccak256(bytes.concat(keccak256(abi.encode(add_claimer,amount))));

    //verifying and reverting
    if(!MerkleProof.verify(merklehash,i_roothash,leaf)){
        revert MerkleAirdrop_InvalidRoothash();
    }

    //update for has claimed
    s_hasClaimed[add_claimer] = true;


    //emitt as an event
    emit calimed(add_claimer, amount);
    i_airdroptoken.safeTransfer(add_claimer, amount);

   }

   ///////////////////////////
    //// getter Functions /////
    ///////////////////////////

    function getMerkleRoot() external view returns (bytes32) {
        return i_roothash;
    }

    function getAirdropToken() external view returns (IERC20) {
        return i_airdroptoken;
    }

}