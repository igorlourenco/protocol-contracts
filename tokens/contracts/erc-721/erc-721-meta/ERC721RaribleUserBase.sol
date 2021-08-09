// SPDX-License-Identifier: MIT

pragma solidity 0.7.6;
pragma abicoder v2;

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721BurnableUpgradeable.sol";
import "../ERC721Lazy.sol";
import "../../HasContractURI.sol";

abstract contract ERC721RaribleUserBase is OwnableUpgradeable, ERC721BurnableUpgradeable, ERC721Lazy, HasContractURI {

    function __ERC721RaribleUserBase_init(string memory _name, string memory _symbol, string memory baseURI, string memory contractURI, address[] memory operators) internal initializer {
        _setBaseURI(baseURI);
        __ERC721Lazy_init_unchained();
        __Context_init_unchained();
        __ERC165_init_unchained();
        __Ownable_init_unchained();
        __ERC721Burnable_init_unchained();
        __Mint721Validator_init_unchained();
        __HasContractURI_init_unchained(contractURI);
        __RoyaltiesV2Upgradeable_init_unchained();
        __ERC721_init_unchained(_name, _symbol);
        for(uint i = 0; i < operators.length; i++) {
            setApprovalForAll(operators[i], true);
        }
    }

    function mintAndTransfer(LibERC721LazyMint.Mint721Data memory data, address to) public override virtual {
        require(owner() == data.creators[0].account, "minter is not the owner");
        super.mintAndTransfer(data, to);
    }
    uint256[50] private __gap;
}