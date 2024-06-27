// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract AllanCoin {
    /** ERC-20 **/
    string public name = "AllanCoin";
    string public symbol = "ALC";
    uint8 public decimals = 18;
    uint256 public totalSupply = 1000 * 10 ** decimals;    
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;
    
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    function balanceOf(address owner) public view returns (uint256 balance) {
        return _balances[owner];
    }

    function transfer(address to, uint256 value) public returns (bool success) {
        require(balanceOf(msg.sender) >= value, "Insufficient balance");

        uint256 donation = (value * donationPercentage) / 100;
        uint256 transferAmount = value - donation;

        _balances[msg.sender] -= value;
        _balances[to] += transferAmount;
        _balances[currentCharity] += donation;

        emit Transfer(msg.sender, to, transferAmount);
        emit Donation(msg.sender, currentCharity, donation);

        return true;
    }

    function approve(address spender, uint256 value) public returns (bool success) {
        _allowances[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }

    function allowance(address owner, address spender) public view returns (uint256 remaining) {
        return _allowances[owner][spender];
    }

    function transferFrom(address from, address to, uint256 value) public returns (bool success) {
        require(balanceOf(from) >= value, "Insufficient balance");
        require(allowance(from, msg.sender) >= value, "Insufficient allowance");

        uint256 donation = (value * donationPercentage) / 100;
        uint256 transferAmount = value - donation;

        _balances[from] -= value;
        _allowances[from][msg.sender] -= value;
        _balances[to] += transferAmount;
        _balances[currentCharity] += donation;

        emit Transfer(from, to, transferAmount);
        emit Donation(from, currentCharity, donation);

        return true;
    }

    /** Custom **/
    uint256 public donationPercentage = 1;
    address public currentCharity;
    uint256 public votingEndTime;
    uint256 public votingDuration = 1 weeks; 

    struct Charity {
        address charityAddress;
        uint256 votes;
    }

    Charity[] public charities;
    mapping(address => bool) public hasVoted;
    event Donation(address indexed from, address indexed charity, uint256 value);
    event CharityAdded(address indexed charity);
    event CharityVoted(address indexed voter, address indexed charity);
    event CharitySelected(address indexed charity);

    /**
     * @dev Constructor function that initializes the AllanCoin contract.
     * It sets the initial balance of the contract deployer (msg.sender) to the total supply of tokens.
     * It also sets the end time for voting by adding the voting duration to the current block timestamp.
     */
    constructor() {
        _balances[msg.sender] = totalSupply;
        votingEndTime = block.timestamp + votingDuration;
    }

    /**
     * @dev Adds a new charity to the list of available charities.
     * @param charityAddress The address of the new charity.
     */
    function addCharity(address charityAddress) public {
        charities.push(Charity({
            charityAddress: charityAddress,
            votes: 0
        }));
        emit CharityAdded(charityAddress);
    }


    /**
     * @dev Allows a user to vote for a specific charity by providing the index of the charity.
     * Users can only vote during the voting period and can only vote once per period.
     * The number of votes a user has is determined by the balance of tokens they hold.
     * Emits a `CharityVoted` event with the address of the voter and the address of the charity.
     * @param charityIndex The index of the charity to vote for.
     * @notice This function should only be called when the voting period is active and the user has not voted before.
     * @notice The number of votes a user has is determined by their token balance.
     * @notice Emits a `CharityVoted` event upon successful voting.
     * @notice Throws an error if the voting period has ended or if the user has already voted.
     */
    function voteForCharity(uint256 charityIndex) public {
        require(block.timestamp < votingEndTime, "Voting period has ended");
        require(!hasVoted[msg.sender], "Already voted in this period");

        Charity storage charity = charities[charityIndex];
        charity.votes += _balances[msg.sender]; // Votos ponderados pela quantidade de tokens
        hasVoted[msg.sender] = true;

        emit CharityVoted(msg.sender, charity.charityAddress);
    }

    /**
     * @dev Selects the leading charity based on the votes received during the voting period.
     * Emits a `CharitySelected` event with the address of the selected charity.
     * Resets the voting period for the next round and clears the votes and voting status for all charities.
     */
    function selectCharity() public {
        require(block.timestamp >= votingEndTime, "Voting period has not ended");

        Charity memory leadingCharity;
        uint256 highestVotes;

        for (uint256 i = 0; i < charities.length; i++) {
            if (charities[i].votes > highestVotes) {
                highestVotes = charities[i].votes;
                leadingCharity = charities[i];
            }
        }

        currentCharity = leadingCharity.charityAddress;
        emit CharitySelected(currentCharity);

        // Resetar para a próxima votação
        votingEndTime = block.timestamp + votingDuration;
        for (uint256 i = 0; i < charities.length; i++) {
            charities[i].votes = 0;
        }
        
        // Resetar hasVoted para todos os endereços que votaram
        for (uint256 i = 0; i < charities.length; i++) {
            address charityAddress = charities[i].charityAddress;
            hasVoted[charityAddress] = false;
        }
    }

    /**
     * @dev Sets the donation percentage for the AllanCoin contract.
     * @param percentage The new donation percentage to be set.
     */
    function setDonationPercentage(uint256 percentage) public {
        donationPercentage = percentage;
    }
}
