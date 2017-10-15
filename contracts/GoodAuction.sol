pragma solidity ^0.4.15;

import "./AuctionInterface.sol";

/** @title GoodAuction */
contract GoodAuction is AuctionInterface {
	/* New data structure, keeps track of refunds owed to ex-highest bidders */
	mapping(address => uint) refunds;
    uint256 bigBid;
	address winning;
	/* Bid function, shifts to push paradigm
	 * Must return true on successful send and/or bid, bidder
	 * reassignment
	 * Must return false on failure and allow people to
	 * retrieve their funds
	 */
	function bid() payable external returns(bool) {
		if (msg.value < highestBid) throw;

        if (highestBidder != 0) {refunds[winning] += bigBid;}

        winning = msg.sender;
        bigBid = msg.value;
        return true;
    }

	/* New withdraw function, shifts to push paradigm */
	function withdrawRefund() external returns(bool) {
		uint refund = refunds[msg.sender];
		refunds[msg.sender] = 0;
		if(!msg.sender.send(refund)){
		    refunds[msg.sender] = refund;
		}
	}

	/* Allow users to check the amount they can withdraw */
	function getMyBalance() constant external returns(uint) {
		return refunds[msg.sender];
	}

	/* Give people their funds back */
	function () payable {
		revert();
	}
}
