pragma solidity ^0.4.23;

import "./FishTokenInterface.sol";
import "./Ownable.sol";
import "./Timed.sol";
import "./SafeMath.sol";

contract FishToken is FishTokenInterface, Ownable, Timed {
  using SafeMath for uint256;

  uint8 public decimals;
  address public currentShark;
  uint256 public totalSupply;

  mapping(address => uint256) public balances;
  mapping(address => bool) public participantsMap;

  address[] public participantsArray;

  constructor(uint256 _deadline) public {
    deadline = _deadline;
    totalSupply = 0;
    currentShark = msg.sender;
    owner = msg.sender;
  }

  function determineNewShark() internal {
    address shark = participantsArray[0];
    uint arrayLength = participantsArray.length;

    for (uint i = 1; i < arrayLength; i++) {
      if (balances[shark] < balances[participantsArray[i]]) {
        shark = participantsArray[i];
      }
    }

    if (currentShark != shark) {
      currentShark = shark;
      emit LogNewShark(shark, balances[shark]);
    }
  }

  function addToParticipants(address _address) internal returns (bool) {
    if (participantsMap[_address]) {
      return false;
    }

    participantsMap[_address] = true;
    participantsArray.push(_address);

    return true;
  }

  function transfer(address _to, uint256 _value) public onlyWhileOpen returns (bool) {
    if (balances[msg.sender] < _value || (balances[_to] + _value) <= balances[_to]) {
      return false;
    }

    addToParticipants(_to);
    balances[msg.sender] = balances[msg.sender].sub(_value);
    balances[_to] = balances[_to].add(_value);
    emit LogTransfer(msg.sender, _to, _value);
    determineNewShark();

    return true;
  }

  function balanceOf(address _owner) public view returns (uint256) {
    return balances[_owner];
  }

  function issueTokens(address _beneficiary, uint256 _amount)
    public
    onlyOwner
    onlyWhileOpen
    returns (bool)
  {
    if (balances[_beneficiary] + _amount <= balances[_beneficiary]) {
      return false;
    }

    addToParticipants(_beneficiary);
    balances[_beneficiary] = balances[_beneficiary].add(_amount);
    totalSupply = totalSupply.add(_amount);

    emit LogIssue(_beneficiary, _amount);

    determineNewShark();

    return true;
  }
}
