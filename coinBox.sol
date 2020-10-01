pragma solidity 0.4.26;

contract coinBox {
    address owner;
    uint256 fundLimit;
    uint256 initialTime;

    constructor() public {
        owner = msg.sender;
        fundLimit = 60 * 1e18;
        initialTime = block.timestamp;
    }

    modifier ownerOnly() {
        require(owner == msg.sender);
        _;
    }

    function insertFunds() external payable returns (bool) {
        require(msg.value > 0);
        require(address(this).balance <= fundLimit);
        return true;
    }

    function withdrawFunds(uint256 _amount) external payable ownerOnly() returns (bool) {
        require(_amount > 0);
        require(_amount <= maxWithAllowed());
        owner.transfer(_amount);
        return true;
    }

    function maxWithAllowed() public view returns (uint256) {
        uint256 maxMonthCoins = fundLimit / 10; /* 10% */
        uint256 monthsEclipsed = (block.timestamp - initialTime) / (30 days);
        uint256 max = 0;
        if (maxMonthCoins * monthsEclipsed > fundLimit - address(this).balance) {
            max = maxMonthCoins * monthsEclipsed - (fundLimit - address(this).balance);
        }
        return max;
    }

    function showBalance() public view returns (uint256) {
        return address(this).balance;
    }

    function showInitialTime() public view returns (uint256) {
        return initialTime;
    }

    function breakBox(address _addr) external payable ownerOnly() {
        selfdestruct(_addr);
    }
}
