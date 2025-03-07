// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface IRewardStorage {
    error RewardError(ERewardError e);

    enum ERewardError {
        None,
        ChainId,
        ThisAddress,
        TicketExpired,
        TicketTypeIdFilter,
        SignatureRecover,
        TicketTypePurchaseToken,
        TicketTypePurchaseCoupon,
        TicketTypeNone,
        PurchaseTokenAmount,
        PurchaseCouponAmount
    }

    enum TicketType {
        None,
        PurchaseToken,
        PurchaseCoupon
    }

    struct Ticket {
        uint256 chainId;
        address serviceCA;
        TicketType ticketType;
        uint256 ticketId;
        uint256 expireIn;
        address account;
        uint256 price;
        uint256 payAmount;
    }
}

interface IRewardInternal is IRewardStorage {
    event TicketConfirmed(uint256 indexed ticketId, TicketType indexed ticketType);
}

interface IRewardExternal is IRewardInternal {}

interface IReward is IRewardExternal {}
