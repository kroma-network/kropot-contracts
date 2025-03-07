// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import {SelectorRoleControlUpgradeable} from "../../eco-libs/contracts/access/SelectorRoleControlUpgradeable.sol";
import {IRewardStorage} from "./reward.interfaces.sol";

import {IEcoERC20} from "../../eco-libs/contracts/token/ERC20/IERC20.sol";

abstract contract RewardStorage is
    IRewardStorage,
    SelectorRoleControlUpgradeable
{
    // keccak256(abi.encode(uint256(keccak256("state.kroket.reward")) - 1)) & ~bytes32(uint256(0xff))
    bytes32 private constant RewardStateLocation =
        0xc5cb75db783a21467cbd8642d4aaef5f7b529086bd458e0afa3c48106a713900;

    function _getRewardState() internal pure returns (RewardState storage $) {
        assembly {
            $.slot := RewardStateLocation
        }
    }

    function __init_Reward() internal onlyInitializing {}

    struct RewardConfig {
        IEcoERC20 token;
        address paymentReceiver;
        uint256 minPointExchange;
    }

    struct RewardState {
        RewardConfig config;
        uint256 totalPointPayment;
        uint256 totalTokenPayment;
        mapping(TicketType ticketType => mapping(uint256 ticketId => bytes32 ticketHash)) ticketFilter;
    }

    // TODO: externals
    function getConfig() public view returns (RewardConfig memory) {
        return _getRewardState().config;
    }

    function totalPointPayment() public view returns (uint256) {
        return _getRewardState().totalPointPayment;
    }

    function totalTokenPayment() public view returns (uint256) {
        return _getRewardState().totalTokenPayment;
    }

    function setConfig(RewardConfig memory config) public onlyAdmin {
        _getRewardState().config = config;
    }

    function retrieveToken(uint256 amount) public onlyAdmin {
        _getRewardState().config.token.transfer(_msgSender(), amount);
    }
}
