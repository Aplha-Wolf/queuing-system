DROP TABLE IF EXISTS priority;
CREATE TABLE "public"."priority" (
    "id" INTEGER UNIQUE GENERATED ALWAYS AS IDENTITY NOT NULL,
    "create_at" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "name" CHARACTER VARYING(255) NOT NULL,
    "icon" CHARACTER VARYING(255) NOT NULL,
    "prefix" CHARACTER(4) NOT NULL,
    "level" SMALLINT NOT NULL,
    "active" BOOLEAN DEFAULT TRUE NOT NULL,
    CONSTRAINT "priority_pkey" PRIMARY KEY ("id")
);

DROP TABLE IF EXISTS que;
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

DROP TABLE IF EXISTS quetype;
CREATE TABLE "public"."quetype" (
    "id" INTEGER UNIQUE GENERATED ALWAYS AS IDENTITY NOT NULL,
    "create_at" TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "name" CHARACTER VARYING(255) NOT NULL,
    "icon" CHARACTER VARYING(255) NOT NULL,
    "active" BOOLEAN DEFAULT true NOT NULL,
    "color" CHARACTER VARYING(255) NOT NULL,
    "prefix" CHARACTER(4) NOT NULL,
    CONSTRAINT "quetype_name_key" UNIQUE ("name"),
    CONSTRAINT "quetype_pkey" PRIMARY KEY ("id")
);

DROP TABLE IF EXISTS reset;
CREATE TABLE "public"."reset" (
    "id" INTEGER UNIQUE GENERATED ALWAYS AS IDENTITY NOT NULL,
    "create_at" TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "date" DATE DEFAULT CURRENT_DATE NOT NULL,
    CONSTRAINT "reset_pkey" PRIMARY KEY ("id")
);

DROP TABLE IF EXISTS terminal;
CREATE TABLE "public"."terminal" (
    "id" INTEGER UNIQUE GENERATED ALWAYS AS IDENTITY NOT NULL,
    "name" CHARACTER VARYING(255) NOT NULL,
    "active" BOOLEAN DEFAULT true NOT NULL,
    "code" CHARACTER(4) NOT NULL,
    "create_at" TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT "terminal_name_key" UNIQUE ("name"),
    CONSTRAINT "terminal_pkey" PRIMARY KEY ("id")
);

DROP TABLE IF EXISTS terminal_quetype;
CREATE TABLE "public"."terminal_quetype" (
    "id" INTEGER UNIQUE GENERATED ALWAYS AS IDENTITY NOT NULL,
    "terminal_id" INTEGER NOT NULL,
    "quetype_id" INTEGER NOT NULL,
    CONSTRAINT "terminal_quetype_pkey" PRIMARY KEY ("id")
);

DROP TABLE IF EXISTS display_terminal;
DROP TABLE IF EXISTS display;
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

DROP TABLE IF EXISTS display_terminal;
CREATE TABLE display_terminal(
    "id" INTEGER UNIQUE GENERATED ALWAYS AS IDENTITY NOT NULL,
    "display_id" INTEGER NOT NULL,
    "terminal_id" INTEGER NOT NULL,
    "order" INTEGER NOT NULL,
    CONSTRAINT "Display_terminal_pkey" PRIMARY KEY ("id")
);

DROP TABLE IF EXISTS media;
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

DROP TABLE IF EXISTS frontdesk;
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


ALTER TABLE ONLY "public"."que" ADD CONSTRAINT "que_priority_id_fkey" FOREIGN KEY (priority_id) REFERENCES priority(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY "public"."que" ADD CONSTRAINT "que_quetype_id_fkey" FOREIGN KEY (quetype_id) REFERENCES quetype(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY "public"."que" ADD CONSTRAINT "que_reset_id_fkey" FOREIGN KEY (reset_id) REFERENCES reset(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY "public"."que" ADD CONSTRAINT "que_terminal_id_fkey" FOREIGN KEY (terminal_id) REFERENCES terminal(id) ON UPDATE RESTRICT ON DELETE RESTRICT;

ALTER TABLE ONLY "public"."terminal_quetype" ADD CONSTRAINT "terminal_quetype_quetype_id_fkey" FOREIGN KEY (quetype_id) REFERENCES quetype(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY "public"."terminal_quetype" ADD CONSTRAINT "terminal_quetype_terminal_id_fkey" FOREIGN KEY (terminal_id) REFERENCES terminal(id) ON UPDATE RESTRICT ON DELETE RESTRICT;

ALTER TABLE ONLY "public"."display_terminal" ADD CONSTRAINT "display_terminal_display_id_fkey" FOREIGN KEY (display_id) REFERENCES display(id) ON UPDATE RESTRICT ON DELETE CASCADE;
ALTER TABLE ONLY "public"."display_terminal" ADD CONSTRAINT "display_terminal_terminal_id_fkey" FOREIGN KEY (terminal_id) REFERENCES terminal(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
