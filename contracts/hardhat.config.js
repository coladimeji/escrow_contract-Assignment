/**
 * @type import ('hardhat/config').HardhatUserConfig
 */
 require('@nomiclabs/hardhat-waffle');
 import ('hardhat/config').HardhatUserConfig;
 const INFURA_URL = 'https://rinkeby.infura.io/v3/56a5734a3e6b444cab9c64ab27d6aa5f';
 const PRIVATE_KEY = '838b150089f9e868e394d60e75f8f285b04c58a5667b4678796bafeaa69dcf93';
 
 module.exports = {
     solidity: "0.8.4",
     networks: {
         rinkeby:{
             url: INFURA_URL,
             accounts: [ '0x${PRIVATE_KEY}']
         }
     }
 };