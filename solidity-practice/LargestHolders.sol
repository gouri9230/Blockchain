// SPDX-License-Identifier: MIT
pragma solidity <= 0.8.12;

/* 
contract to process a large list of addresses and their balances in multiple transactions by subcomputations in order to reduce gas usage.
Then, determine the address that holds the largest balance.
*/
contract LargestHolder {
    address[] holders;
    uint256[] balances;
    uint256 start;
    uint256 end;
    bool balanceSubmitted;
    uint256 txRequired;
    uint256 largestBalance;
    address largestHolder;

    // function should be called only once.
    function submitBalances(uint256[] memory _balances, address[] memory _holders) public {
        require(_balances.length == _holders.length);
        // so once balances are submitted, this function should not be allowed to call again.
        require(!balanceSubmitted, "Balances have already been submitted");
        balanceSubmitted = true;
        holders = _holders;
        balances = _balances;
        // number of transactions needed in order to process whole batch of submitted balances.
        // if 25 addresses --> 25/10 = 2 (2 transaction will cover 20 addresses).
        // so we need one more Tx to cover remaining 5 addresses, so increment txRequired by 1 & now total Tx needed is 3.
        txRequired = holders.length/10;
        if (txRequired * 10 < holders.length) {
            txRequired++;
        }
        //processed in batches of 10.
        end = 10;
        if (end > holders.length) {
            end = holders.length;
        }
    }

    // processes all the addresses and balances submitted to determine address of largest balance holder
    // can be called multiple times
    function process() public {
        // cannot be called until balances are submitted
        require(balanceSubmitted, "Balances have not yet been submitted");
        // end processing when txRequired becomes 0
        require(txRequired != 0, "still processing");
        for (uint256 idx=start; idx < end; idx++) {
            if (balances[idx] > largestBalance) {
                largestHolder = holders[idx];
                largestBalance = balances[idx];
            }
        }
        start = end;
        end += 10;
        if (end > holders.length) {
            end = holders.length;
        }
        txRequired--;
    }

    // can be checked only once balances are submitted
    function numberOfTxRequired() public view returns (uint256) {
        require(balanceSubmitted, "balances have not yet been submitted");
        return txRequired;
    }

    // once all addresses are processed, only then we can check largestHolder
    function getLargestHolder() public view returns (address) {
        require(txRequired == 0, "still processing");
        return largestHolder;
    }
}