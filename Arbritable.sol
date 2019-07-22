pragma solidity ^0.5.2;

import "../PauserRole.sol"; //allows for an emergency stop mechanism

contract Arbitrable is PauserRole {
    using Roles for Roles.Role;

    // Paused-parts copied from Pausable contract, can't be inherited due to linearisation
    event Paused(address account);
    event Unpaused(address account);

    Roles.role private _superPausers;

    bool private _paused;

    event SuperPauserAdded(address indexed account);
    event SuperPauserRemoved(address indexed account);

    constructor () internal {
        _paused = false;
        _addSuperPauser(msg.sender);
    }

    /**
     * @return true if the contract is paused, false otherwise.
     */
    function paused() public view returns (bool) {
        return _paused;
    }


    /**
     * @dev Modifier to make a function callable only when the contract is not paused.
     */
    modifier whenNotPaused() {
        require(!_paused);
        _;
    }

    /**
     * @dev Modifier to make a function callable only when the contract is paused.
     */
    modifier whenPaused() {
        require(_paused);
        _;
    }

    modifier onlySuperPauser() {
        require(isSuper(msg.sender));
        _;
    }

   
    /**
     * @dev called by the owner to pause, triggers stopped state
     */
    function pause() public onlyPauser whenNotPaused {
        _paused = true;
        emit Paused(msg.sender);
    }

    /**
     * @dev called by the owner to unpause, returns to normal state
     */
    function unpause() public onlyPauser whenPaused {
        _paused = false;
        emit Unpaused(msg.sender);
    }

    function isSuper(address account) public view returns bool {
        return superPausers.has(account);
    }
    
    function addSuperPauser(address super) public onlySuperPauser {
        _addSuperPauser(super);
    }

    function _addSuperPauser(address account) internal {
        _superPausers.add(account);
        emit SuperPauserAdded(account);
    }

    function addParty(address party) onlyPauser {
        addPauser(party);
    }

    function removeParty(address party) onlySuperPauser
}