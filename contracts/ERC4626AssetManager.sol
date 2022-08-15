// SPDX-License-Identifier: MIT

pragma solidity 0.8.4;

import "./openzeppelin/SafeERC20.sol";
import "./openzeppelin/Math.sol";
import "./third_party/balancer/IBVault.sol";
import "./interfaces/IERC4626.sol";
import "./interfaces/IGauge.sol";
import "./AssetManagerBase.sol";

/// @title ERC4626AssetManager
/// @dev ERC4626AssetManager can invest funds to ERC4626 vault and collect the rewards from gauge.
///      Currently configured to work with TetuVaultV2.
contract ERC4626AssetManager is AssetManagerBase {
  using SafeERC20 for IERC20;

  // ***************************************************
  //                VARIABLES
  // ***************************************************

  address public immutable erc4626Vault;

  /// @notice rewards from gauge are transferred to this address
  address public immutable rewardCollector;
  IGauge public immutable gauge;

  // ***************************************************
  //                  EVENTS
  // ***************************************************

  event Invested(uint256 amount);
  event Devested(uint256 amount);
  event RewardClaimed(address token, uint256 amount);

  // ***************************************************
  //                CONSTRUCTOR
  // ***************************************************

  constructor(
    IBVault balancerVault_,
    address erc4626Vault_,
    address underlying_,
    address rewardCollector_,
    address gauge_
  ) AssetManagerBase(balancerVault_, IERC20(underlying_)) {
    require(erc4626Vault_ != address(0), "zero ERC4626 vault");
    require(rewardCollector_ != address(0), "zero rewardCollector");
    erc4626Vault = erc4626Vault_;
    rewardCollector = rewardCollector_;
    gauge = IGauge(gauge_);

    IERC20(underlying_).safeIncreaseAllowance(erc4626Vault_, type(uint256).max);
  }

  // ***************************************************
  //                VIEWS
  // ***************************************************

  /**
   * @dev Checks balance of managed assets
   */
  function _getAUM() internal view override returns (uint256) {
    return IERC4626(erc4626Vault).convertToAssets(IERC20(erc4626Vault).balanceOf(address(this)));
  }

  // ***************************************************
  //                MAIN LOGIC
  // ***************************************************

  /**
   * @dev Deposits capital into ERC4626 Vault
   * @param amount - the amount of tokens being deposited
   * @return the amount deposited
   */
  function _invest(uint256 amount, uint256) internal override returns (uint256) {
    uint256 balance = underlying.balanceOf(address(this));
    /// GERG: this block here will sweep tokens sent directly to the AM, but will make a deposit
    ///       that overshoots the target if there are extra tokens. Are we fine with this? Should
    ///       there be a check?
    if (amount < balance) {
      balance = amount;
    }

    // invest to ERC4626 Vault
    IERC4626(erc4626Vault).deposit(balance, address(this));
    uint256 shares = IERC20(erc4626Vault).balanceOf(address(this));
    /// GERG: isn't the below check only doing what it says if it's the first deposit? 
    ///       If you're issuing deposit #2 and it fails, wouldn't this require still 
    ///       succeed since it has some shares from deposit #1?
    ///       --> Looks like this delta check is properly done in _divest()
    require(shares > 0, "AM should receive shares after the deposit");
    emit Invested(balance);
    return balance;
  }

  /**
   * @dev Withdraws capital out of ERC4626 Vault
   * @param amountUnderlying - the amount to withdraw
   * @return the number of tokens to return to the balancerVault
   */
   ///GERG: why drop the 2nd argument? 
  function _divest(uint256 amountUnderlying, uint256) internal override returns (uint256) {
    amountUnderlying = Math.min(amountUnderlying, IERC4626(erc4626Vault).maxWithdraw(address(this)));
    uint256 existingBalance = underlying.balanceOf(address(this));
    if (amountUnderlying > 0) {
      IERC4626(erc4626Vault).withdraw(amountUnderlying, address(this), address(this));
      uint256 newBalance = underlying.balanceOf(address(this));
      uint256 divested = newBalance - existingBalance;
      // todo adjust msg or revert if not enough
      require(divested > 0, "AM should receive requested tokens after the withdraw");
      emit Devested(divested);
      return divested;
    }
    return 0;
  }

  /// @dev Claim all rewards from given gague and send to rewardCollector
  function _claim() internal override {
    if (address(gauge) != address(0) && rewardCollector != address(0)) {
      gauge.getAllRewards(address(erc4626Vault), address(this));
      for (uint256 i = 0; i < gauge.rewardTokensLength(address(erc4626Vault)); i++) {
        IERC20 rt = IERC20(gauge.rewardTokens(address(erc4626Vault), i));
        uint256 bal = IERC20(rt).balanceOf(address(this));
        if (bal > 0) {
          rt.safeTransfer(rewardCollector, bal);
          emit RewardClaimed(address(rt), bal);
        }
      }
    }
  }
}
