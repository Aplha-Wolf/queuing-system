-- Theme Management Tables
-- Migration: 001_create_theme_tables.sql

-- Theme table: stores theme configurations
CREATE TABLE theme (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,
    display_name VARCHAR(100) NOT NULL,
    description TEXT,
    is_active BOOLEAN DEFAULT false,
    is_dark BOOLEAN DEFAULT false,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Theme color table: stores color tokens for each theme
CREATE TABLE theme_color (
    id SERIAL PRIMARY KEY,
    theme_id INTEGER REFERENCES theme(id) ON DELETE CASCADE,
    token VARCHAR(50) NOT NULL,
    light_value VARCHAR(20) NOT NULL,
    dark_value VARCHAR(20) NOT NULL,
    UNIQUE(theme_id, token)
);

-- Create index for faster lookups
CREATE INDEX idx_theme_color_theme_id ON theme_color(theme_id);

-- Seed data: Default themes
INSERT INTO theme (name, display_name, description, is_active, is_dark) VALUES
('default', 'Default Dark', 'Classic dark theme for queuing system', true, true),
('corporate', 'Corporate Light', 'Professional light theme for business environments', false, false),
('playful', 'Playful', 'Colorful and fun theme with vibrant colors', false, false);

-- Color tokens for Default theme (id=1)
INSERT INTO theme_color (theme_id, token, light_value, dark_value) VALUES
(1, 'primary', '#2563eb', '#3b82f6'),
(1, 'secondary', '#4b5563', '#6b7280'),
(1, 'surface', '#ffffff', '#1f2937'),
(1, 'surface_alt', '#f3f4f6', '#374151'),
(1, 'text_primary', '#111827', '#f9fafb'),
(1, 'text_secondary', '#6b7280', '#9ca3af'),
(1, 'border', '#e5e7eb', '#374151'),
(1, 'success', '#16a34a', '#22c55e'),
(1, 'danger', '#dc2626', '#ef4444'),
(1, 'warning', '#ca8a04', '#eab308');

-- Color tokens for Corporate theme (id=2)
INSERT INTO theme_color (theme_id, token, light_value, dark_value) VALUES
(2, 'primary', '#1e40af', '#2563eb'),
(2, 'secondary', '#374151', '#4b5563'),
(2, 'surface', '#ffffff', '#f9fafb'),
(2, 'surface_alt', '#f3f4f6', '#f9fafb'),
(2, 'text_primary', '#111827', '#111827'),
(2, 'text_secondary', '#6b7280', '#6b7280'),
(2, 'border', '#d1d5db', '#e5e7eb'),
(2, 'success', '#15803d', '#16a34a'),
(2, 'danger', '#b91c1c', '#dc2626'),
(2, 'warning', '#a16207', '#ca8a04');

-- Color tokens for Playful theme (id=3)
INSERT INTO theme_color (theme_id, token, light_value, dark_value) VALUES
(3, 'primary', '#7c3aed', '#8b5cf6'),
(3, 'secondary', '#ec4899', '#f472b6'),
(3, 'surface', '#fefce8', '#1e1b4b'),
(3, 'surface_alt', '#fef9c3', '#312e81'),
(3, 'text_primary', '#1e1b4b', '#fefce8'),
(3, 'text_secondary', '#6b7280', '#c4b5fd'),
(3, 'border', '#fbbf24', '#6366f1'),
(3, 'success', '#059669', '#10b981'),
(3, 'danger', '#e11d48', '#f43f5e'),
(3, 'warning', '#f59e0b', '#fbbf24');
