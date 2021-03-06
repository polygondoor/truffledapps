pragma solidity ^0.4.0;

/* 
 * A game of chance, and timing.
 * Each participator must deposit 60 Finney.
 * Depending on where they fall in the order of depositers,
 * they are rewarded with a share in other depositer's deposits.
 *
 * This contract does have issues. The first is that the amount of gas
 * required changes depending on the state of the contract. In other words, 
 * each depositor will pay different amounts of gas.
 *
 */

contract BouncingWishingWell {

    address owner;              // Owner of the contract 
    address[5] depositors;      // The list of users using this system
    uint256 depositorCount;     // How many people have deposited
    uint256 amountDeposited;    // a running count of how much Ether has been deposited

    // First, check that the amount deposited is right.
    // The fixed amount we would like to ensure is 60 Finney
    // Note that 60 is divisible by 2, 3, 4, and 5,
    // thus making any division of the amount of Ether always
    // result in a whole number (Ethereum has no concept of floats)
    uint _amount = 60000000000000000;

    function BouncingWishingWell() public {
      owner = msg.sender;   // owner of contract is whoever deployed it
      depositorCount = 0;
      amountDeposited = 0;     
    }

    // Publicise that we are up to a new round!
    // The amount displayed shows how much Ether was won in the last round
    event LogRoundOver(
        uint256 amntdep,
        uint256 depositorCount,
        address depositorLatest);

    function deposit() if_right_amount() payable public returns (uint256){

        // Increment how much money has been deposited
        amountDeposited += msg.value;

        // Do we need to set counter back to 0?
        if (depositorCount > 4 ) {
            depositorCount = 0;
        }

        // Save the current depositer's address so that we can effectuate
        // future payments
        depositors[ depositorCount ] = msg.sender;

        // The rules!
        if ( depositorCount == 0 ){

            // user gets everything back
            depositors[ 0 ].transfer(_amount);

        } else if ( depositorCount == 1 ){

            // each user gets 1/2 of the money
            depositors[ 0 ].transfer(_amount/2);
            depositors[ 1 ].transfer(_amount/2);

        } else if ( depositorCount == 2 ){

            // each user gets 1/3 of the money
            depositors[ 0 ].transfer(_amount/3);
            depositors[ 1 ].transfer(_amount/3);
            depositors[ 2 ].transfer(_amount/3);

        } else if ( depositorCount == 3 ){

            // each user gets 1/4 of the money
            depositors[ 0 ].transfer(_amount/4);
            depositors[ 1 ].transfer(_amount/4);
            depositors[ 2 ].transfer(_amount/4);
            depositors[ 3 ].transfer(_amount/4);

        } else if ( depositorCount == 4 ){

          // each user gets 1/5 of the money
            depositors[ 0 ].transfer(_amount/5);
            depositors[ 1 ].transfer(_amount/5);
            depositors[ 2 ].transfer(_amount/5);
            depositors[ 3 ].transfer(_amount/5);
            depositors[ 4 ].transfer(_amount/5);

        //LogRoundOver(amountDeposited,depositorCount,depositors[depositorCount-1]); // logic of total won to be worked out
        //  LogStuff();

        }

        // Increment the callerCount
        depositorCount ++;

        LogRoundOver(amountDeposited,depositorCount,depositors[depositorCount-1]); // logic of total won to be worked out

        return amountDeposited;

        
    }

 function amountDep() constant returns (uint256) {
        return amountDeposited;
    }

    

    // This modifier allows us to keep at least one conditional out of the transaction logic
    modifier if_right_amount() {
        require( msg.value == _amount);
        _;
    }
}
