// SPDX-License-Identifier: MIT

pragma solidity 0.8.4;

interface ISmartVault {
  event AddedRewardToken(address indexed token);
  event Approval(
    address indexed owner,
    address indexed spender,
    uint256 value
  );
  event ContractInitialized(address controller, uint256 ts, uint256 block);
  event Deposit(address indexed beneficiary, uint256 amount);
  event Invest(uint256 amount);
  event RemovedRewardToken(address indexed token);
  event RewardAdded(address rewardToken, uint256 reward);
  event RewardDenied(
    address indexed user,
    address rewardToken,
    uint256 reward
  );
  event RewardMovedToController(address rewardToken, uint256 amount);
  event RewardPaid(address indexed user, address rewardToken, uint256 reward);
  event RewardRecirculated(address indexed token, uint256 amount);
  event RewardSentToController(address indexed token, uint256 amount);
  event Staked(address indexed user, uint256 amount);
  event StrategyAnnounced(address newStrategy, uint256 time);
  event StrategyChanged(address newStrategy, address oldStrategy);
  event Transfer(address indexed from, address indexed to, uint256 value);
  event UpdatedAddressSlot(
    string indexed name,
    address oldValue,
    address newValue
  );
  event UpdatedBoolSlot(string indexed name, bool oldValue, bool newValue);
  event UpdatedUint256Slot(
    string indexed name,
    uint256 oldValue,
    uint256 newValue
  );
  event Withdraw(address indexed beneficiary, uint256 amount);
  event Withdrawn(address indexed user, uint256 amount);

  function DEPOSIT_FEE_DENOMINATOR() external view returns (uint256);

  function LOCK_PENALTY_DENOMINATOR() external view returns (uint256);

  function TO_INVEST_DENOMINATOR() external view returns (uint256);

  function VERSION() external view returns (string memory);

  function active() external view returns (bool);

  function addRewardToken(address rt) external;

  function allowance(address owner, address spender)
  external
  view
  returns (uint256);

  function alwaysInvest() external view returns (bool);

  function approve(address spender, uint256 amount) external returns (bool);

  function availableToInvestOut() external view returns (uint256);

  function balanceOf(address account) external view returns (uint256);

  function changeActivityStatus(bool _active) external;

  function changeAlwaysInvest(bool _active) external;

  function changeDoHardWorkOnInvest(bool _active) external;

  function changePpfsDecreaseAllowed(bool _value) external;

  function changeProtectionMode(bool _active) external;

  function controller() external view returns (address);

  function created() external view returns (uint256 ts);

  function createdBlock() external view returns (uint256 ts);

  function decimals() external view returns (uint8);

  function decreaseAllowance(address spender, uint256 subtractedValue)
  external
  returns (bool);

  function deposit(uint256 amount) external;

  function depositAndInvest(uint256 amount) external;

  function depositFeeNumerator() external view returns (uint256);

  function depositFor(uint256 amount, address holder) external;

  function disableLock() external;

  function doHardWork() external;

  function doHardWorkOnInvest() external view returns (bool);

  function duration() external view returns (uint256);

  function earned(address rt, address account)
  external
  view
  returns (uint256);

  function earnedWithBoost(address rt, address account)
  external
  view
  returns (uint256);

  function exit() external;

  function getAllRewards() external;

  function getPricePerFullShare() external view returns (uint256);

  function getReward(address rt) external;

  function getRewardTokenIndex(address rt) external view returns (uint256);

  function increaseAllowance(address spender, uint256 addedValue)
  external
  returns (bool);

  function initializeControllable(address __controller) external;

  function initializeSmartVault(
    string memory _name,
    string memory _symbol,
    address _controller,
    address __underlying,
    uint256 _duration,
    bool _lockAllowed,
    address _rewardToken,
    uint256 _depositFee
  ) external;

  function initializeVaultStorage(
    address _underlyingToken,
    uint256 _durationValue,
    bool __lockAllowed
  ) external;

  function isController(address _value) external view returns (bool);

  function isGovernance(address _value) external view returns (bool);

  function lastTimeRewardApplicable(address rt)
  external
  view
  returns (uint256);

  function lastUpdateTimeForToken(address) external view returns (uint256);

  function lockAllowed() external view returns (bool);

  function lockPenalty() external view returns (uint256);

  function lockPeriod() external view returns (uint256);

  function name() external view returns (string memory);

  function notifyRewardWithoutPeriodChange(
    address _rewardToken,
    uint256 _amount
  ) external;

  function notifyTargetRewardAmount(address _rewardToken, uint256 amount)
  external;

  function overrideName(string memory value) external;

  function overrideSymbol(string memory value) external;

  function periodFinishForToken(address) external view returns (uint256);

  function ppfsDecreaseAllowed() external view returns (bool);

  function protectionMode() external view returns (bool);

  function rebalance() external;

  function removeRewardToken(address rt) external;

  function rewardPerToken(address rt) external view returns (uint256);

  function rewardPerTokenStoredForToken(address)
  external
  view
  returns (uint256);

  function rewardRateForToken(address) external view returns (uint256);

  function rewardTokens() external view returns (address[] memory);

  function rewardTokensLength() external view returns (uint256);

  function rewardsForToken(address, address) external view returns (uint256);

  function setLockPenalty(uint256 _value) external;

  function setLockPeriod(uint256 _value) external;

  function setStrategy(address newStrategy) external;

  function setToInvest(uint256 _value) external;

  function stop() external;

  function strategy() external view returns (address);

  function symbol() external view returns (string memory);

  function toInvest() external view returns (uint256);

  function totalSupply() external view returns (uint256);

  function transfer(address recipient, uint256 amount)
  external
  returns (bool);

  function transferFrom(
    address sender,
    address recipient,
    uint256 amount
  ) external returns (bool);

  function underlying() external view returns (address);

  function underlyingBalanceInVault() external view returns (uint256);

  function underlyingBalanceWithInvestment() external view returns (uint256);

  function underlyingBalanceWithInvestmentForHolder(address holder)
  external
  view
  returns (uint256);

  function underlyingUnit() external view returns (uint256);

  function userBoostTs(address) external view returns (uint256);

  function userLastDepositTs(address) external view returns (uint256);

  function userLastWithdrawTs(address) external view returns (uint256);

  function userLockTs(address) external view returns (uint256);

  function userRewardPerTokenPaidForToken(address, address)
  external
  view
  returns (uint256);

  function withdraw(uint256 numberOfShares) external;

  function withdrawAllToVault() external;
}
