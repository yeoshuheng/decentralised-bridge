// SPDX-License-Identifier: MIT 
import '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import './Itoken.sol';

contract BridgeBase {
    address public admin;
    IToken public token;
    // Nonce is used to ensure that transfer only done once.
    mapping(address => mapping(uint => bool)) processedNonces;
    enum Step {mint, burn}
    event Transfer(
        address from,
        address to,
        uint amt,
        uint date,
        uint nonce, 
        bytes sig,
        Step indexed step
    );

    constructor(address _token) {
        admin = msg.sender;
        token = IToken(_token);
    }

    function burn(address to, uint amt, uint nonce, bytes calldata signature) external {
        require(!processedNonces[msg.sender][nonce], "Transfer Processed.");
        processedNonces[msg.sender][nonce] = true;
        token.burn(msg.sender, amt);
        // Burn token & create a transfer event.
        emit Transfer(from = msg.sender, 
            to = to, amt = amt, 
            date = block.timestamp, nonce = nonce, 
            sig = signature, step = Step.burn);
    }

    function mint(address from, address to, uint amt, uint nonce, bytes calldata signature) external {
        // Take in and hash message.
        bytes32 msg = prefixed(keccak256(abi.encodePacked(from, to, amt, nonce)));

        // Signature created from hashed message and the private key, authetication process.
        require(recoverSigner(msg, signature) == from, "Problem in setting up signature.");
        require(!processedNonces[from][nonce], "Transfer Processed.");
        processedNonces[from][nonce] = true;
        token.mint(to, amt);

        // Mints token and creates a transfer event.
        emit Transfer(from = from, to = to, amt = amt, 
            date = block.timestamp, nonce = nonce, 
            sig = signature, step = Step.mint);
    }

    function prefixed(bytes32 hash) internal pure returns (byte32) {
        // We hash the signature.
        return keccak256(abi.encodePacked('\x19Ethereum Signed Message:\n32', hash));
    } 

    function recoverSigner(bytes32 msg, bytes memory signature) internal pure returns (address) {
        uint8 v; bytes32 r; bytes32 s;
        (v, r, s) = splitSignature(signature);
        // Takes in the hash to recover the signer from signature.
        return ecrecover(msg, v, r, s);
    }

    function splitSignature(bytes memory signature) internal pure returns (uint8, bytes32, bytes32) {
        requires(signature.length == 65);
        uint v; bytes32 r; bytes32 s;
        // Using assembly to extract v, r, s.
        assembly { 
            r := mload(add(signature, 32))
            s := mload(add(signature, 64))
            v := byte(0, mload(add(signature, 96)))   
        }
        return (v, r, s);
    }
}
