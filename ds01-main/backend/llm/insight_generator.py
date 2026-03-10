def generate_insight(coin: str):
    coin_name = {
        "btc": "Bitcoin (BTC)",
        "eth": "Ethereum (ETH)",
        "sol": "Solana (SOL)"
    }.get(coin.lower(), coin.upper())
    
    return {
        "market_regime": "Trending",
        "momentum": "Strong Bullish",
        "volatility_state": "High",
        "risk_outlook": "Moderate",
        "key_insight": f"{coin_name} is showing strong institutional accumulation with rising on-chain activity.",
        "caution": "Global macro headwinds might cause short-term pullbacks."
    }
