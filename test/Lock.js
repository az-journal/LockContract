const { idText } = require("typescript");
const{
    expectRevert,
    time,
    constants
} = require('@openzeppelin/test-helpers');

const Lock = artifacts.require('Lock.sol');
const MockToken = artifacts.require('MockToken.sol');

contract('Lock', async accounts =>{
    let lock, token;
    const [deployer, owner, otherAddress, _] = accounts;

   before(async()=> {
       lock = await Lock.new(owner);
       token = await MockToken.new();
   })

it('should lock&unlock token& ether', async ()=>{
    let contractEtherBalance, contractTokenBalance, ownerTokenBalance;
    const etherAmount = web3.utils.toWei('1');
    const tokenAmount = web3.utils.toWei('1');

    await web3.eth.sendTransaction({
        from: owner,
        to: lock.address,
        value: etherAmount
    });

    await token.approve(lock.address, tokenAmount);
    await lock.deposit(token.address, tokenAmount);
    contractEtherBalance = await web3.eth.getBalance(lock.address);
    contractTokenBalance = await token.balanceOf(lock.address);
    assert (contractEtherBalance.toString() === etherAmount);
    assert(contractTokenBalance.toString() === tokenAmount);

await expectRevert(
    lock.withdraw(token.address,tokenAmount, {from:otherAddress}), 'onlyOwner');

await lock.withdraw(constants.ZERO_ADDRESS, etherAmount, {from: owner});
await lock.withdraw(token.address, tokenAmount, {from:owner})
contractEtherBalance = await web3.eth.getBalance(lock.address);
contractTokenBalance = await token.balanceOf(lock.address);
ownerEtherBalance = await web3.eth.getBalance(owner);
ownerTokenbalance = await token.balanceOf(owner);

assert(contractEtherBalance.toString() === '0');
assert(contractTokenBalance.toString()=== '0');
assert(ownerTokenBalance.toString().length === 20);
assert(ownerEtherBalance.toString().slice(0,2) === '99');
});
});