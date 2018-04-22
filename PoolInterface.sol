pragma solidity ^0.4.23;

interface PoolInterface {
  function() external payable;
  function withdraw() external returns (bool);
}
