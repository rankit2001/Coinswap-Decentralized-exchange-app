// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Exchange is ERC20 {
    address public tokenAddress;

    constructor(address token) ERC20("ETH TOKEN LP TOKEN", "lpETHTOKEN"){
        require(token != address(0), "token address passed is a null address");
        tokenAddress = token;
    }

    //getReserve function returns the balance of 'token' held by this contract
    function getReserve() public view returns(uint256){
        return ERC20(tokenAddress).balanceOf(address(this));
    }

    function addLiquidity(uint256 amountToken) public payable returns (uint256) {
        uint256 lpTokensToMint;
        uint256 ethReserveBalance = address(this).balance;
        uint256 tokenReserveBalance = getReserve();

        ERC20 token = ERC20(tokenAddress);

        //if the reserve is empty, take any user supplied value for initial liquidity
        if(tokenReserveBalance == 0){
            token.transferFrom(msg.sender,address(this),amountToken);
            lpTokensToMint = ethReserveBalance;
            _mint(msg.sender,lpTokensToMint);
            
            return lpTokensToMint;
        }

        //if the reserve is not empty calculate the amount of lp tokens to be minted
        uint256 ethReservePriorToFunctionCall = ethReserveBalance - msg.value;
        uint256 minTokenAmountRequired = (msg.value * tokenReserveBalance) / ethReservePriorToFunctionCall;

        require(amountToken >= minTokenAmountRequired, "Insufficient amount of tokens provided");
        token.transferFrom(msg.sender,address(this),minTokenAmountRequired);

        lpTokensToMint = (totalSupply() * msg.value) / ethReservePriorToFunctionCall;

        _mint(msg.sender,lpTokensToMint);
        return lpTokensToMint;
    }

    function removeLiquidity(uint256 amountOfLPTokens) public returns(uint256,uint256) {
        require(amountOfLPTokens>0,"Amount of tokens to remove must be greater than 0");

        uint256 lpTokenTotalSupply = totalSupply();
        uint256 ethReserveBalance = address(this).balance;

        uint256 ethToReturn = (ethReserveBalance * amountOfLPTokens) / lpTokenTotalSupply;
        uint256 tokenToReturn = (getReserve() * amountOfLPTokens) / lpTokenTotalSupply;

        _burn(msg.sender, amountOfLPTokens);
        payable(msg.sender).transfer(ethToReturn);
        ERC20(tokenAddress).transfer(msg.sender,tokenToReturn);

        return (ethToReturn,tokenToReturn);
    }

    //calculates amount of output to be received based on x*y = (x+dx)*(y-dy)
    function getOutputAmountFromSwap(uint256 inputAmount, uint256 outputReserve, uint256 inputReserve) public pure returns (uint256){
        require(inputReserve>0 && outputReserve>0, "reserves must be greater than zero");

        uint256 inputAmountWithFee = inputAmount * 99;

        uint256 numerator = inputAmountWithFee * outputReserve;
        uint256 denominator = inputAmountWithFee + 100 * inputReserve;

        return numerator / denominator;
    }

    //ethToTokenSwap allows user to swap ETH for tokens
    function ethToTokenSwap(uint256 minTokenToReceive) public payable {
        uint256 tokenReserveBalance = getReserve();
        uint256 tokensToReceive = getOutputAmountFromSwap(msg.value, tokenReserveBalance, address(this).balance-msg.value);

        require(minTokenToReceive<=tokensToReceive,"token received are less than minimum tokens expected");

        ERC20(tokenAddress).transfer(msg.sender,tokensToReceive);
    }

    //tokenToEthSwap allows users to swap token for eth
    function tokenToEthSwap(uint256 tokenToSwap, uint256 minEthToReceive) public {
        uint256 tokenReserveBalance = getReserve();
        uint256 ethToReceive = getOutputAmountFromSwap(tokenToSwap, address(this).balance,tokenReserveBalance);

        require(ethToReceive >= minEthToReceive, "eth received is less than minimum eth received");
        ERC20(tokenAddress).transferFrom(msg.sender,address(this), tokenToSwap);
        payable(msg.sender).transfer(ethToReceive);
    }
}