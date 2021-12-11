const { assert } = require("chai");

describe("Escrow1", function() {
  let contract;
  let sender;
  let receiver;
  let agent;

  it("should be funded initially", async function() {
    let balance = await ethers.provider.getBalance(contract.address);
    assert.equal(balance.toString(), deposit.toString());
  });

  describe("after approval from address other than the agent", () => {
    it("should revert", async () => {
        let ex;
        try {
            await contract.connect(receiver).approve();
        }
        catch (_ex) {
            ex = _ex;
        }
        assert(ex, "Attempted to approve the Escrow from the receiver address. Expected transaction to revert!");
    });
  });

  describe("after approval from the agent", () => {
    it("should transfer balance to receiver", async () => {
        const before = await ethers.provider.getBalance(receiver.getAddress());
        const approve = await contract.connect(agent).approve();
        const after = await ethers.provider.getBalance(receiver.getAddress());
        assert.equal(after.sub(before).toString(), deposit.toString());
    });
  });
});