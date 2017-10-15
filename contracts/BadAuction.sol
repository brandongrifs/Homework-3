pragma solidity ^0.4.15;

import "./AuctionInterface.sol";

/** @title BadAuction */
contract BadAuction is AuctionInterface {
	/* Bid function, vulnerable to attack
	 * Must return true on successful send and/or bid,
	 * bidder reassignment
	 * Must return false on failure and send people
	 * their funds back
	 */
	 uint256 bigBid;
	 address winning;
	function bid() payable external returns (bool) {
		if(msg.value < bigBid) throw;
		if(winning!=0){
		    if(!winning.send(bigBid)) throw;
		}
		winning = msg.sender();
		bigBid = msg.value();
	}

	/* Give people their funds back */
	function () payable {
    	revert();
	}
}
