pragma solidity ^0.4.23;

contract Timed {
  uint256 public deadline;

  modifier onlyWhileOpen {
    require(block.timestamp <= deadline);
    _;
  }

  modifier onlyWhileClosed {
    require(block.timestamp > deadline);
    _;
  }
}
