// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SlotZeroVulnerability {
    // Important state variables to demonstrate potential corruption
    address public owner;
    uint256 public criticalValue;

    constructor() {
        owner = msg.sender;
        criticalValue = 12345;
    }

    function dangerousAssemblyWrite() public {
        assembly {
            // WARNING: Writing directly to slot 0 - This is EXTREMELY DANGEROUS!
            // Slot 0 in this contract contains the 'owner' address
            sstore(0, 0xDEADBEEFDEADBEEFDEADBEEFDEADBEEFDEADBEEFDEADBEEFDEADBEEFDEADBEEF)
        }
    }

    function checkOwnerAndValue() public view returns (address currentOwner, uint256 currentValue) {
        return (owner, criticalValue);
    }
}

// Explanation of the vulnerability:
// 1. Slot 0 in this contract stores the 'owner' address
// 2. The dangerousAssemblyWrite() function overwrites slot 0 completely
// 3. This will corrupt the 'owner' state variable
// 4. Writing to slot 0 can destroy critical contract state variables
// 5. The overwrite happens without any checks or safeguards

// Potential Consequences:
// - Lose control of contract ownership
// - Corrupt critical state variables
// - Unexpected contract behavior
// - Potential loss of funds or contract functionality depending on the use of "owner"