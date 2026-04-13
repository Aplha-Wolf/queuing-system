-- Settings Table
-- Migration: 002_create_settings_tables.sql

-- Create settings table if it doesn't exist
CREATE TABLE IF NOT EXISTS settings (
    id SERIAL PRIMARY KEY,
    background VARCHAR(20) DEFAULT '#1f2937',
    text_primary VARCHAR(20) DEFAULT '#f9fafb',
    text_secondary VARCHAR(20) DEFAULT '#9ca3af',
    card_background VARCHAR(20) DEFAULT '#374151',
    card_border VARCHAR(20) DEFAULT '#4b5563',
    card_text VARCHAR(20) DEFAULT '#f9fafb',
    button_primary VARCHAR(20) DEFAULT '#2563eb',
    button_secondary VARCHAR(20) DEFAULT '#4b5563',
    input_background VARCHAR(20) DEFAULT '#374151',
    input_border VARCHAR(20) DEFAULT '#4b5563',
    input_text VARCHAR(20) DEFAULT '#f9fafb',
    header_background VARCHAR(20) DEFAULT '#1e3a8a',
    header_text VARCHAR(20) DEFAULT '#f9fafb',
    border VARCHAR(20) DEFAULT '#4b5563',
    success VARCHAR(20) DEFAULT '#22c55e',
    danger VARCHAR(20) DEFAULT '#ef4444',
    warning VARCHAR(20) DEFAULT '#eab308',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Try to copy from existing route_settings if settings is empty
-- This is for backwards compatibility if old migration ran
INSERT INTO settings (id, background, text_primary, text_secondary, card_background, card_border, card_text, button_primary, button_secondary, input_background, input_border, input_text, header_background, header_text, border, success, danger, warning)
SELECT 1, background, text_primary, text_secondary, card_background, card_border, card_text, button_primary, button_secondary, input_background, input_border, input_text, header_background, header_text, border, success, danger, warning
FROM route_settings 
WHERE route_name = 'terminal'
ON CONFLICT (id) DO NOTHING;

-- Seed data with default colors if still empty
INSERT INTO settings (id) VALUES (1)
ON CONFLICT (id) DO NOTHING;