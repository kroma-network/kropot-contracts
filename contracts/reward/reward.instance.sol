// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import {IReward} from "./reward.interfaces.sol";
import {RewardExternal} from "./reward.external.sol";

contract Reward is IReward, RewardExternal {}
