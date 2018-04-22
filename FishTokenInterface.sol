pragma solidity ^0.4.23;

interface FishTokenInterface {
  event LogTransfer(address indexed _from, address indexed _to, uint256 _value);
  event LogIssue(address indexed _member, uint256 _value);
  event LogNewShark(address indexed _shark, uint256 _value);

  function balanceOf(address _owner) external view returns (uint256);
  function transfer(address _to, uint256 _amount) external returns (bool);
  function issueTokens(address _beneficiary, uint256 _amount) external returns (bool);
  function getShark() external view returns (address sharkAddress, uint256 sharkBalance);
  function isShark(address _address) external view returns (bool);
}
