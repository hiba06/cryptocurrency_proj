-- Supabase Postgres Schema for Crypto Analytics
-- Run this in your Supabase SQL Editor after creating a project

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Raw tick data from Coinbase API
CREATE TABLE IF NOT EXISTS raw_ticks (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    coin VARCHAR(10) NOT NULL,
    ts TIMESTAMPTZ NOT NULL,
    price DECIMAL(20, 8) NOT NULL,
    bid DECIMAL(20, 8),
    ask DECIMAL(20, 8),
    size DECIMAL(20, 8),
    side VARCHAR(10),
    source VARCHAR(50) DEFAULT 'coinbase',
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Chart points (normalized/derived for visualization)
CREATE TABLE IF NOT EXISTS chart_points (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    coin VARCHAR(10) NOT NULL,
    ts TIMESTAMPTZ NOT NULL,
    normalized_price DECIMAL(20, 8) NOT NULL,
    raw_price DECIMAL(20, 8),
    window_id VARCHAR(50),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(coin, ts)
);

-- Derived metrics (returns, volatility, momentum)
CREATE TABLE IF NOT EXISTS metrics (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    coin VARCHAR(10) NOT NULL,
    ts TIMESTAMPTZ NOT NULL,
    return_1m DECIMAL(20, 8),
    return_5m DECIMAL(20, 8),
    return_15m DECIMAL(20, 8),
    volatility_5m DECIMAL(20, 8),
    volatility_15m DECIMAL(20, 8),
    momentum_5m DECIMAL(20, 8),
    momentum_15m DECIMAL(20, 8),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(coin, ts)
);

-- ML predictions
CREATE TABLE IF NOT EXISTS predictions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    coin VARCHAR(10) NOT NULL,
    ts TIMESTAMPTZ NOT NULL,
    predicted_normalized_price DECIMAL(20, 8) NOT NULL,
    model_version VARCHAR(50) DEFAULT 'v1',
    confidence DECIMAL(5, 4),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(coin, ts)
);

-- LLM insight cache
CREATE TABLE IF NOT EXISTS llm_insight_cache (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    coin VARCHAR(10) NOT NULL,
    ts TIMESTAMPTZ NOT NULL,
    insight_json JSONB NOT NULL,
    expires_at TIMESTAMPTZ NOT NULL,
    input_hash VARCHAR(64),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(coin, input_hash)
);

-- Indexes for performance
CREATE INDEX IF NOT EXISTS idx_raw_ticks_coin_ts ON raw_ticks(coin, ts DESC);
CREATE INDEX IF NOT EXISTS idx_chart_points_coin_ts ON chart_points(coin, ts DESC);
CREATE INDEX IF NOT EXISTS idx_metrics_coin_ts ON metrics(coin, ts DESC);
CREATE INDEX IF NOT EXISTS idx_predictions_coin_ts ON predictions(coin, ts DESC);
CREATE INDEX IF NOT EXISTS idx_llm_cache_coin_expires ON llm_insight_cache(coin, expires_at);

-- Note: Row Level Security (RLS) is disabled by default.
-- Backend connects using service_role key (bypasses RLS).
-- If you enable RLS, ensure backend uses service_role or configure policies.
