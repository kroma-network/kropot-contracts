// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import {IRewardInternal} from "./reward.interfaces.sol";
import {RewardStorage} from "./reward.storage.sol";

import {MessageHashUtils} from "@openzeppelin/contracts/utils/cryptography/MessageHashUtils.sol";

import {Sig} from "../common.sol";

abstract contract RewardInternal is IRewardInternal, RewardStorage {
    function getTicketHash(Ticket memory ticket) public pure returns (bytes32) {
        return MessageHashUtils.toEthSignedMessageHash(keccak256(abi.encode(ticket)));
    }

    function recoverTicketHash(bytes32 ticketHash, Sig memory sig) public pure returns (address signer) {
        return ecrecover(ticketHash, sig.v, sig.r, sig.s);
    }

    function _checkTicketSignerAuth(address signer) internal view {
        if (!hasSelectorRole(this.recoverTicketHash.selector, signer)) {
            revert RewardError(ERewardError.SignatureRecover);
        }
    }

    function _validateTicket(Ticket memory ticket, Sig memory sig, TicketType service) internal {
        RewardState storage $ = _getRewardState();

        if (ticket.chainId != block.chainid) revert RewardError(ERewardError.ChainId);
        if (ticket.serviceCA != address(this)) revert RewardError(ERewardError.ThisAddress);
        if (ticket.expireIn < block.timestamp) revert RewardError(ERewardError.TicketExpired);
        if (ticket.ticketType != service) {
            if (ticket.ticketType == TicketType.PurchaseToken) revert RewardError(ERewardError.TicketTypePurchaseToken);
            if (ticket.ticketType == TicketType.PurchaseCoupon) {
                revert RewardError(ERewardError.TicketTypePurchaseCoupon);
            }
            revert RewardError(ERewardError.TicketTypeNone);
        }

        bytes32 ticketHash = getTicketHash(ticket);
        if ($.ticketFilter[ticket.ticketType][ticket.ticketId] != bytes32(0)) revert RewardError(ERewardError.TicketTypeIdFilter);
        $.ticketFilter[ticket.ticketType][ticket.ticketId] = ticketHash;
        _checkTicketSignerAuth(recoverTicketHash(ticketHash, sig));
    }

    function _usePurchaseTokenTicket(Ticket memory ticket, Sig memory sig) internal {
        RewardState storage $ = _getRewardState();
        _validateTicket(ticket, sig, TicketType.PurchaseToken);

        if (ticket.payAmount < $.config.minPointExchange) revert RewardError(ERewardError.PurchaseTokenAmount);
        uint256 tokenAmount = ticket.payAmount * 1 ether / ticket.price;

        $.totalPointPayment += ticket.payAmount;
        emit TicketConfirmed(ticket.ticketId, ticket.ticketType);

        $.config.token.transfer(ticket.account, tokenAmount);
    }

    function _usePurchaseCouponTicket(Ticket memory ticket, Sig memory sig) internal {
        RewardState storage $ = _getRewardState();
        _validateTicket(ticket, sig, TicketType.PurchaseCoupon);

        if (ticket.payAmount != ticket.price) revert RewardError(ERewardError.PurchaseCouponAmount);

        $.totalTokenPayment += ticket.price;
        emit TicketConfirmed(ticket.ticketId, ticket.ticketType);

        $.config.token.transferFrom(ticket.account, $.config.paymentReceiver, ticket.price);
    }
}
