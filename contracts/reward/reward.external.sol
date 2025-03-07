// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import {IRewardExternal} from "./reward.interfaces.sol";
import {RewardInternal} from "./reward.internal.sol";

import {Sig} from "../common.sol";

import {IEcoERC20} from "../../eco-libs/contracts/token/ERC20/IERC20.sol";

abstract contract RewardExternal is IRewardExternal, RewardInternal {
    function usePurchaseTokenTicket(Ticket memory ticket, Sig memory sig) external {
        return _usePurchaseTokenTicket(ticket, sig);
    }

    function usePurchaseCouponTicket(Ticket memory ticket, Sig memory sig) external {
        return _usePurchaseCouponTicket(ticket, sig);
    }
}
