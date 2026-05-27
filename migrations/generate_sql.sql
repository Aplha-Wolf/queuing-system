-- Core Queuing System Tables

DROP TABLE IF EXISTS priority CASCADE;
CREATE TABLE "public"."priority" (
    "id" INTEGER UNIQUE GENERATED ALWAYS AS IDENTITY NOT NULL,
    "create_at" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "name" CHARACTER VARYING(255) NOT NULL,
    "icon" CHARACTER VARYING(255) NOT NULL DEFAULT '',
    "prefix" CHARACTER(4) NOT NULL,
    "level" SMALLINT NOT NULL,
    "active" BOOLEAN DEFAULT TRUE NOT NULL,
    CONSTRAINT "priority_pkey" PRIMARY KEY ("id")
);

DROP TABLE IF EXISTS que CASCADE;
CREATE TABLE "public"."que" (
    "id" INTEGER UNIQUE GENERATED ALWAYS AS IDENTITY NOT NULL,
    "reset_id" INTEGER NOT NULL,
    "quetype_id" INTEGER NOT NULL,
    "priority_id" INTEGER NOT NULL,
    "create_at" TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "que_no" INTEGER NOT NULL,
    "terminal_id" INTEGER,
    "update_at" TIMESTAMP,
    CONSTRAINT "que_pkey" PRIMARY KEY ("id")
);

DROP TABLE IF EXISTS quetype CASCADE;
CREATE TABLE "public"."quetype" (
    "id" INTEGER UNIQUE GENERATED ALWAYS AS IDENTITY NOT NULL,
    "create_at" TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "name" CHARACTER VARYING(255) NOT NULL,
    "icon" CHARACTER VARYING(255) NOT NULL DEFAULT '',
    "active" BOOLEAN DEFAULT true NOT NULL,
    "color" CHARACTER VARYING(255) NOT NULL,
    "prefix" CHARACTER(4) NOT NULL,
    CONSTRAINT "quetype_name_key" UNIQUE ("name"),
    CONSTRAINT "quetype_pkey" PRIMARY KEY ("id")
);

DROP TABLE IF EXISTS reset CASCADE;
CREATE TABLE "public"."reset" (
    "id" INTEGER UNIQUE GENERATED ALWAYS AS IDENTITY NOT NULL,
    "create_at" TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "date" DATE DEFAULT CURRENT_DATE NOT NULL,
    CONSTRAINT "reset_pkey" PRIMARY KEY ("id")
);

DROP TABLE IF EXISTS terminal CASCADE;
CREATE TABLE "public"."terminal" (
    "id" INTEGER UNIQUE GENERATED ALWAYS AS IDENTITY NOT NULL,
    "name" CHARACTER VARYING(255) NOT NULL,
    "active" BOOLEAN DEFAULT true NOT NULL,
    "code" CHARACTER(4) NOT NULL,
    "create_at" TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT "terminal_name_key" UNIQUE ("name"),
    CONSTRAINT "terminal_pkey" PRIMARY KEY ("id")
);

DROP TABLE IF EXISTS terminal_quetype CASCADE;
CREATE TABLE "public"."terminal_quetype" (
    "id" INTEGER UNIQUE GENERATED ALWAYS AS IDENTITY NOT NULL,
    "terminal_id" INTEGER NOT NULL,
    "quetype_id" INTEGER NOT NULL,
    CONSTRAINT "terminal_quetype_pkey" PRIMARY KEY ("id")
);

DROP TABLE IF EXISTS display CASCADE;
CREATE TABLE display(
    "id" INTEGER UNIQUE GENERATED ALWAYS AS IDENTITY NOT NULL,
    "code" CHARACTER(4) NOT NULL,
    "create_at" TIMESTAMP without time zone DEFAULT CURRENT_TIMESTAMP,
    "name" CHARACTER VARYING(255) NOT NULL,
    "active" BOOLEAN NOT NULL,
    "now_serving_size" INTEGER DEFAULT 7 NOT NULL,
    "media_width" INTEGER DEFAULT 60 NOT NULL,
    "terminal_div_width" INTEGER DEFAULT 40 NOT NULL,
    "cols" INTEGER DEFAULT 2 NOT NULL,
    "rows" INTEGER DEFAULT 3 NOT NULL,
    "name_size" INTEGER DEFAULT 3 NOT NULL,
    "que_label_size" INTEGER DEFAULT 5 NOT NULL,
    "que_no_size" INTEGER DEFAULT 16 NOT NULL,
    "date_time_size" INTEGER DEFAULT 3 NOT NULL,
    CONSTRAINT "display_pkey" PRIMARY KEY ("id")
);

DROP TABLE IF EXISTS display_terminal CASCADE;
CREATE TABLE display_terminal(
    "id" INTEGER UNIQUE GENERATED ALWAYS AS IDENTITY NOT NULL,
    "display_id" INTEGER NOT NULL,
    "terminal_id" INTEGER NOT NULL,
    "order" INTEGER NOT NULL,
    CONSTRAINT "Display_terminal_pkey" PRIMARY KEY ("id")
);

DROP TABLE IF EXISTS media CASCADE;
CREATE TABLE "public"."media" (
    "id" INTEGER UNIQUE GENERATED ALWAYS AS IDENTITY NOT NULL,
    "create_at" TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "name" CHARACTER VARYING(255) NOT NULL,
    "media_type" SMALLINT NOT NULL,
    "is_ads" BOOLEAN DEFAULT TRUE NOT NULL,
    "filename" VARCHAR(255) NOT NULL,
    "active" BOOLEAN DEFAULT TRUE NOT NULL,
    CONSTRAINT "media_name_key" UNIQUE ("name"),
    CONSTRAINT "media_pkey" PRIMARY KEY ("id")
);

DROP TABLE IF EXISTS frontdesk CASCADE;
CREATE TABLE "public"."frontdesk" (
    "id" INTEGER UNIQUE GENERATED ALWAYS AS IDENTITY NOT NULL,
    "create_at" TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "name" CHARACTER VARYING(255) NOT NULL,
    "code" CHARACTER(4) NOT NULL,
    "active" BOOLEAN DEFAULT TRUE NOT NULL,
    "title_fontsize" INTEGER NOT NULL,
    "option_fontsize" INTEGER NOT NULL,
    "icon_height" INTEGER NOT NULL,
    "icon_width" INTEGER NOT NULL,
    "priority_cols" INTEGER NOT NULL,
    "priority_rows" INTEGER NOT NUll,
    "transaction_cols" INTEGER NOT NULL,
    "transaction_rows" INTEGER NOT NULL,
    CONSTRAINT "frontdesk_name_key" UNIQUE ("name"),
    CONSTRAINT "frontdesk_pkey" PRIMARY KEY ("id")
);

-- Settings table (17 color fields, single row)
DROP TABLE IF EXISTS settings CASCADE;
CREATE TABLE settings (
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

-- Theme Management Tables
DROP TABLE IF EXISTS theme_color CASCADE;
DROP TABLE IF EXISTS theme CASCADE;
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

CREATE TABLE theme_color (
    id SERIAL PRIMARY KEY,
    theme_id INTEGER REFERENCES theme(id) ON DELETE CASCADE,
    token VARCHAR(50) NOT NULL,
    light_value VARCHAR(20) NOT NULL,
    dark_value VARCHAR(20) NOT NULL,
    UNIQUE(theme_id, token)
);

CREATE INDEX idx_theme_color_theme_id ON theme_color(theme_id);

-- Foreign Key Constraints
ALTER TABLE ONLY "public"."que" ADD CONSTRAINT "que_priority_id_fkey" FOREIGN KEY (priority_id) REFERENCES priority(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY "public"."que" ADD CONSTRAINT "que_quetype_id_fkey" FOREIGN KEY (quetype_id) REFERENCES quetype(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY "public"."que" ADD CONSTRAINT "que_reset_id_fkey" FOREIGN KEY (reset_id) REFERENCES reset(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY "public"."que" ADD CONSTRAINT "que_terminal_id_fkey" FOREIGN KEY (terminal_id) REFERENCES terminal(id) ON UPDATE RESTRICT ON DELETE RESTRICT;

ALTER TABLE ONLY "public"."terminal_quetype" ADD CONSTRAINT "terminal_quetype_quetype_id_fkey" FOREIGN KEY (quetype_id) REFERENCES quetype(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY "public"."terminal_quetype" ADD CONSTRAINT "terminal_quetype_terminal_id_fkey" FOREIGN KEY (terminal_id) REFERENCES terminal(id) ON UPDATE RESTRICT ON DELETE RESTRICT;

ALTER TABLE ONLY "public"."display_terminal" ADD CONSTRAINT "display_terminal_display_id_fkey" FOREIGN KEY (display_id) REFERENCES display(id) ON UPDATE RESTRICT ON DELETE CASCADE;
ALTER TABLE ONLY "public"."display_terminal" ADD CONSTRAINT "display_terminal_terminal_id_fkey" FOREIGN KEY (terminal_id) REFERENCES terminal(id) ON UPDATE RESTRICT ON DELETE RESTRICT;

-- Seed data: Default settings row
INSERT INTO settings (id) VALUES (1)
ON CONFLICT (id) DO NOTHING;

-- Seed data: Default themes
INSERT INTO theme (name, display_name, description, is_active, is_dark) VALUES
('default', 'Default Dark', 'Classic dark theme for queuing system', true, true),
('corporate', 'Corporate Light', 'Professional light theme for business environments', false, false),
('playful', 'Playful', 'Colorful and fun theme with vibrant colors', false, false);

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
