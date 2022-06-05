// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity >=0.8.0;

contract TokenMock {
    mapping (address => uint)                      public balanceOf;
    mapping (address => mapping (address => uint)) public allowance;
    uint8                                          public decimals = 6;

    function add(uint256 x, uint256 y) internal pure returns (uint256 z) {
        unchecked {
            require((z = x + y) >= x, "overflow");
        }
    }
    function sub(uint256 x, uint256 y) internal pure returns (uint256 z) {
        unchecked {
            require((z = x - y) <= x, "underflow");
        }
    }
    function mul(uint256 x, uint256 y) internal pure returns (uint256 z) {
        unchecked {
            require(y == 0 || (z = x * y) / y == x, "overflow");
        }
    }

    function transfer(address dst, uint256 wad) external returns (bool) {
        return transferFrom(msg.sender, dst, wad);
    }
    function transferFrom(address src, address dst, uint256 wad)
        public returns (bool)
    {
        require(balanceOf[src] >= wad, "Gem/insufficient-balance");
        if (src != msg.sender && allowance[src][msg.sender] != type(uint256).max) {
            require(allowance[src][msg.sender] >= wad, "Gem/insufficient-allowance");
            allowance[src][msg.sender] = sub(allowance[src][msg.sender], wad);
        }
        balanceOf[src] = sub(balanceOf[src], wad);
        balanceOf[dst] = add(balanceOf[dst], wad);
        return true;
    }
    function mint(address usr, uint256 wad) external  {
        balanceOf[usr] = add(balanceOf[usr], wad);
    }
    function burn(address usr, uint256 wad) external {
        require(balanceOf[usr] >= wad, "Gem/insufficient-balance");
        if (usr != msg.sender && allowance[usr][msg.sender] != type(uint256).max) {
            require(allowance[usr][msg.sender] >= wad, "Gem/insufficient-allowance");
            allowance[usr][msg.sender] = sub(allowance[usr][msg.sender], wad);
        }
        balanceOf[usr] = sub(balanceOf[usr], wad);
    }
    function approve(address usr, uint256 wad) external returns (bool) {
        allowance[msg.sender][usr] = wad;
        return true;
    }
}
