pragma solidity ^0.8.4;


contract ICOEXC {
    address public EXC = payable(0x71c6a1ae78259f9E74cD4FaA3F96CFD06d9E1616);
    address wEXP = payable(0x331631B4bb93b9B8962faE15860BD538a389395A);
    uint256 public EXCGoal;
    uint256 public EXCMinted;
    uint256 public LiquidityPool;
    uint256 public DevelopmentPool;
    uint256 public CharityPool;
    uint256 EXPcurrentPrice;
    uint256 EXCtoMintAndSend;
    uint public OpenClosed;
    address public Owner;
    string removalT;
    //Variable Declarations
    
    //Event Declartions
    event EXCBought(address indexed buyer, uint256 amountWEXP, uint256 amountEXC);
    event EXPremoval(address indexed remover, string RemovalType, uint256 amountEXP);
    
    

    //contructor arguments
    constructor(uint256 _Goal, uint256 _EXPcurrentPrice){
        EXCGoal = _Goal;
        EXPcurrentPrice = _EXPcurrentPrice;
        Owner = msg.sender;
    }
    
    
    function Buy(uint256 _AmountWEXP) public payable returns(bool success){
        //Requirements to Call
        EXCtoMintAndSend = (((_AmountWEXP/100000000) * EXPcurrentPrice) / 25);
        require (OpenClosed == 1);
        require (_AmountWEXP > 100000000);
        require ((EXCMinted + EXCtoMintAndSend) <= EXCGoal);

        //Transfers WEXP to Contract and sets amount variables
        ERC20(wEXP).transferFrom(msg.sender, address(this), _AmountWEXP);
        LiquidityPool = LiquidityPool+((_AmountWEXP / 100) * 85);
        DevelopmentPool = DevelopmentPool+((_AmountWEXP / 100) * 10);
        CharityPool = CharityPool+((_AmountWEXP / 100) * 5);
        
        //Mints and Sends EXC to Buyer
        ERC20(EXC).Mint(msg.sender, EXCtoMintAndSend);
        
        //Function Events and Clearings
        emit EXCBought(msg.sender, _AmountWEXP, EXCtoMintAndSend);
        EXCMinted = EXCMinted + EXCtoMintAndSend;
        EXCtoMintAndSend = 0;
        return success;
        
    }
    
    //View Current Conversion
    
    function ViewConversionAmount(uint256 _amountEXP)public view returns(uint256){
        return (((_amountEXP/100000000) * EXPcurrentPrice) / 25);
        
        
    }
    
    //Owner Functions
    function changePrice(uint256 _NewPrice)public payable returns(bool success){
        require (msg.sender == Owner);
        EXPcurrentPrice = _NewPrice;
        return success;
        
    }
    
    function WithdrawLPpool()public payable returns(bool success){
        require (msg.sender == Owner);
        removalT = "LiquidityPool";
        ERC20(wEXP).transfer(Owner, LiquidityPool);
        emit EXPremoval (Owner, removalT, LiquidityPool);
        LiquidityPool = 0;
        removalT = "";
        return success;
    }
    
     function WithdrawCharity()public payable returns(bool success){
        require (msg.sender == Owner);
        removalT = "CharityPool";
        ERC20(wEXP).transfer(Owner, CharityPool);
        emit EXPremoval (Owner, removalT, CharityPool);
        CharityPool = 0;
        removalT = "";
        return success;
    }
    
    function WithdrawDevPool()public payable returns(bool success){
        require (msg.sender == Owner);
        removalT = "DevelopmentPool";
        ERC20(wEXP).transfer(Owner, DevelopmentPool);
        emit EXPremoval (Owner, removalT, DevelopmentPool);
        DevelopmentPool = 0;
        removalT = "";
        return success;
    }
    
    function ChangeEXCAddress(address payable NewAddy) public returns(bool success){
        require (msg.sender == Owner);
        EXC = NewAddy;
        return success;
        
    }
    
    function OnOff(uint OneOnZeroOff) public returns(bool success){
        require (msg.sender == Owner);
        OpenClosed = OneOnZeroOff;
        return success;
    }
    
    
    
}


interface ERC20 {
  function balanceOf(address owner) external view returns (uint256);
  function allowance(address owner, address spender) external view returns (uint256);
  function approve(address spender, uint value) external returns (bool);
  function Mint(address _MintTo, uint256 _MintAmount) external;
  function transfer(address to, uint value) external returns (bool);
  function transferFrom(address from, address to, uint256 value) external returns (bool); 
  function totalSupply() external view returns (uint);
}    
