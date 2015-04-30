--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: hstore; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS hstore WITH SCHEMA public;


--
-- Name: EXTENSION hstore; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION hstore IS 'data type for storing sets of (key, value) pairs';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: blocks; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE blocks (
    id integer NOT NULL,
    page_id integer,
    type character varying(255),
    section_id integer,
    "column" integer,
    "position" integer,
    options hstore,
    mongo_id character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    file character varying(255)
);


--
-- Name: blocks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE blocks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: blocks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE blocks_id_seq OWNED BY blocks.id;


--
-- Name: clubs; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE clubs (
    id integer NOT NULL,
    name character varying(255),
    short_name character varying(255),
    tenant_id integer,
    mongo_id character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: clubs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE clubs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: clubs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE clubs_id_seq OWNED BY clubs.id;


--
-- Name: events; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE events (
    id integer NOT NULL,
    tenant_id integer,
    league_id integer,
    season_id integer,
    location_id integer,
    type character varying(255),
    starts_on timestamp without time zone,
    ends_on timestamp without time zone,
    duration integer,
    all_day boolean,
    summary character varying(255),
    description text,
    mongo_id character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    home_team_id integer,
    away_team_id integer,
    statsheet_id integer,
    statsheet_type character varying(255),
    home_team_score integer DEFAULT 0,
    away_team_score integer DEFAULT 0,
    home_team_name character varying(255),
    away_team_name character varying(255),
    home_team_custom_name boolean,
    away_team_custom_name boolean,
    text_before character varying(255),
    text_after character varying(255),
    result character varying(255),
    completion character varying(255)
);


--
-- Name: events_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE events_id_seq OWNED BY events.id;


--
-- Name: hockey_goals; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE hockey_goals (
    id integer NOT NULL,
    tenant_id integer,
    statsheet_id integer,
    period integer,
    minute integer,
    second integer,
    team_id integer,
    scored_by_id integer,
    scored_on_id integer,
    assisted_by_id integer,
    also_assisted_by_id integer,
    strength character varying(255),
    mongo_id character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: hockey_goals_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE hockey_goals_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: hockey_goals_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE hockey_goals_id_seq OWNED BY hockey_goals.id;


--
-- Name: hockey_goaltenders; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE hockey_goaltenders (
    id integer NOT NULL,
    type character varying(255),
    tenant_id integer,
    team_id integer,
    player_id integer,
    statsheet_id integer,
    games_played integer,
    minutes_played integer,
    shots_against integer,
    goals_against integer,
    saves integer,
    save_percentage double precision,
    goals_against_average double precision,
    shutouts integer,
    shootout_attempts integer,
    shootout_goals integer,
    shootout_save_percentage double precision,
    regulation_wins integer,
    regulation_losses integer,
    overtime_wins integer,
    overtime_losses integer,
    shootout_wins integer,
    shootout_losses integer,
    total_wins integer,
    total_losses integer,
    mongo_id character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: hockey_goaltenders_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE hockey_goaltenders_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: hockey_goaltenders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE hockey_goaltenders_id_seq OWNED BY hockey_goaltenders.id;


--
-- Name: hockey_penalties; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE hockey_penalties (
    id integer NOT NULL,
    tenant_id integer,
    statsheet_id integer,
    period integer,
    minute integer,
    second integer,
    team_id integer,
    committed_by_id integer,
    infraction character varying(255),
    duration integer,
    severity character varying(255),
    start_period character varying(255),
    start_minute integer,
    start_second integer,
    end_period character varying(255),
    end_minute integer,
    end_second integer,
    mongo_id character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: hockey_penalties_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE hockey_penalties_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: hockey_penalties_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE hockey_penalties_id_seq OWNED BY hockey_penalties.id;


--
-- Name: hockey_skaters; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE hockey_skaters (
    id integer NOT NULL,
    type character varying(255),
    tenant_id integer,
    team_id integer,
    player_id integer,
    statsheet_id integer,
    jersey_number character varying(255),
    games_played integer,
    goals integer,
    assists integer,
    points integer,
    penalties integer,
    penalty_minutes integer,
    minor_penalties integer,
    major_penalties integer,
    misconduct_penalties integer,
    game_misconduct_penalties integer,
    hat_tricks integer,
    playmakers integer,
    gordie_howes integer,
    ejections integer,
    mongo_id character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: hockey_skaters_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE hockey_skaters_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: hockey_skaters_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE hockey_skaters_id_seq OWNED BY hockey_skaters.id;


--
-- Name: hockey_statsheets; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE hockey_statsheets (
    id integer NOT NULL,
    tenant_id integer,
    posted boolean,
    away_score integer,
    home_score integer,
    latest_period character varying(255),
    latest_minute integer,
    latest_second integer,
    min_1 integer,
    min_2 integer,
    min_3 integer,
    min_ot integer,
    away_shots_1 integer,
    away_shots_2 integer,
    away_shots_3 integer,
    away_shots_ot integer,
    home_shots_1 integer,
    home_shots_2 integer,
    home_shots_3 integer,
    home_shots_ot integer,
    mongo_id character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: hockey_statsheets_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE hockey_statsheets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: hockey_statsheets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE hockey_statsheets_id_seq OWNED BY hockey_statsheets.id;


--
-- Name: leagues; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE leagues (
    id integer NOT NULL,
    name character varying(255),
    slug character varying(255),
    show_standings boolean,
    show_players boolean,
    show_statistics boolean,
    standings_array text[] DEFAULT '{}'::text[],
    tenant_id integer,
    mongo_id character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    standings_schema_id character varying(255)
);


--
-- Name: leagues_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE leagues_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: leagues_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE leagues_id_seq OWNED BY leagues.id;


--
-- Name: leagues_seasons; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE leagues_seasons (
    id integer NOT NULL,
    league_id integer,
    season_id integer
);


--
-- Name: leagues_seasons_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE leagues_seasons_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: leagues_seasons_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE leagues_seasons_id_seq OWNED BY leagues_seasons.id;


--
-- Name: locations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE locations (
    id integer NOT NULL,
    tenant_id integer,
    name character varying(255),
    short_name character varying(255),
    mongo_id character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: locations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE locations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: locations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE locations_id_seq OWNED BY locations.id;


--
-- Name: pages; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE pages (
    id integer NOT NULL,
    tenant_id integer,
    title character varying(255),
    slug character varying(255),
    url_path character varying(255),
    meta_keywords text,
    meta_description text,
    link_url character varying(255),
    show_in_menu boolean,
    title_in_menu character varying(255),
    skip_to_first_child boolean,
    draft boolean,
    ancestry character varying(255),
    ancestry_depth integer,
    "position" integer,
    mongo_id character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: pages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE pages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE pages_id_seq OWNED BY pages.id;


--
-- Name: players; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE players (
    id integer NOT NULL,
    tenant_id integer,
    team_id integer,
    first_name character varying(255),
    last_name character varying(255),
    jersey_number character varying(255),
    birthdate date,
    email character varying(255),
    slug character varying(255),
    mongo_id character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: players_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE players_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: players_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE players_id_seq OWNED BY players.id;


--
-- Name: posts; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE posts (
    id integer NOT NULL,
    tenant_id integer,
    title character varying(255),
    summary text,
    body text,
    link_url character varying(255),
    image character varying(255),
    mongo_id character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: posts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE posts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: posts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE posts_id_seq OWNED BY posts.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: seasons; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE seasons (
    id integer NOT NULL,
    name character varying(255),
    slug character varying(255),
    starts_on date,
    tenant_id integer,
    mongo_id character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: seasons_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE seasons_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: seasons_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE seasons_id_seq OWNED BY seasons.id;


--
-- Name: sections; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sections (
    id integer NOT NULL,
    page_id integer,
    pattern character varying(255),
    "position" integer,
    mongo_id character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: sections_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sections_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sections_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE sections_id_seq OWNED BY sections.id;


--
-- Name: taggings; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE taggings (
    id integer NOT NULL,
    tag_id integer,
    taggable_id integer,
    taggable_type character varying(255),
    tagger_id integer,
    tagger_type character varying(255),
    context character varying(128),
    created_at timestamp without time zone
);


--
-- Name: taggings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE taggings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: taggings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE taggings_id_seq OWNED BY taggings.id;


--
-- Name: tags; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE tags (
    id integer NOT NULL,
    name character varying(255)
);


--
-- Name: tags_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE tags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE tags_id_seq OWNED BY tags.id;


--
-- Name: teams; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE teams (
    id integer NOT NULL,
    name character varying(255),
    short_name character varying(255),
    slug character varying(255),
    show_in_standings boolean,
    pool character varying(255),
    seed integer,
    tenant_id integer,
    league_id integer,
    season_id integer,
    club_id integer,
    logo character varying(255),
    primary_color character varying(255),
    secondary_color character varying(255),
    accent_color character varying(255),
    main_colors text[] DEFAULT '{}'::text[],
    custom_colors boolean,
    crop_x integer DEFAULT 0,
    crop_y integer DEFAULT 0,
    crop_h integer DEFAULT 0,
    crop_w integer DEFAULT 0,
    mongo_id character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    games_played integer,
    wins integer,
    losses integer,
    ties integer,
    overtime_wins integer,
    overtime_losses integer,
    shootout_wins integer,
    shootout_losses integer,
    forfeit_wins integer,
    forfeit_losses integer,
    points integer,
    percent double precision,
    scored integer,
    allowed integer,
    margin integer,
    last_result character varying(255),
    current_run integer,
    longest_win_streak integer,
    longest_loss_streak integer
);


--
-- Name: teams_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE teams_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: teams_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE teams_id_seq OWNED BY teams.id;


--
-- Name: tenants; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE tenants (
    id integer NOT NULL,
    name character varying(255),
    slug character varying(255),
    host character varying(255),
    description text,
    analytics_id character varying(255),
    theme character varying(255),
    twitter_id character varying(255),
    facebook_id character varying(255),
    instagram_id character varying(255),
    foursquare_id character varying(255),
    google_plus_id character varying(255),
    mongo_id character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: tenants_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE tenants_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tenants_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE tenants_id_seq OWNED BY tenants.id;


--
-- Name: tenants_users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE tenants_users (
    tenant_id integer,
    user_id integer
);


--
-- Name: user_roles; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE user_roles (
    id integer NOT NULL,
    user_id integer,
    name character varying(255),
    title character varying(255),
    tenant_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    mongo_id character varying(255)
);


--
-- Name: user_roles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE user_roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE user_roles_id_seq OWNED BY user_roles.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    email character varying(255) DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying(255) DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying(255),
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip character varying(255),
    last_sign_in_ip character varying(255),
    name character varying(255),
    mongo_id character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY blocks ALTER COLUMN id SET DEFAULT nextval('blocks_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY clubs ALTER COLUMN id SET DEFAULT nextval('clubs_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY events ALTER COLUMN id SET DEFAULT nextval('events_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY hockey_goals ALTER COLUMN id SET DEFAULT nextval('hockey_goals_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY hockey_goaltenders ALTER COLUMN id SET DEFAULT nextval('hockey_goaltenders_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY hockey_penalties ALTER COLUMN id SET DEFAULT nextval('hockey_penalties_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY hockey_skaters ALTER COLUMN id SET DEFAULT nextval('hockey_skaters_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY hockey_statsheets ALTER COLUMN id SET DEFAULT nextval('hockey_statsheets_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY leagues ALTER COLUMN id SET DEFAULT nextval('leagues_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY leagues_seasons ALTER COLUMN id SET DEFAULT nextval('leagues_seasons_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY locations ALTER COLUMN id SET DEFAULT nextval('locations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY pages ALTER COLUMN id SET DEFAULT nextval('pages_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY players ALTER COLUMN id SET DEFAULT nextval('players_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY posts ALTER COLUMN id SET DEFAULT nextval('posts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY seasons ALTER COLUMN id SET DEFAULT nextval('seasons_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY sections ALTER COLUMN id SET DEFAULT nextval('sections_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY taggings ALTER COLUMN id SET DEFAULT nextval('taggings_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY tags ALTER COLUMN id SET DEFAULT nextval('tags_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY teams ALTER COLUMN id SET DEFAULT nextval('teams_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY tenants ALTER COLUMN id SET DEFAULT nextval('tenants_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY user_roles ALTER COLUMN id SET DEFAULT nextval('user_roles_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: blocks_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY blocks
    ADD CONSTRAINT blocks_pkey PRIMARY KEY (id);


--
-- Name: clubs_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY clubs
    ADD CONSTRAINT clubs_pkey PRIMARY KEY (id);


--
-- Name: events_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY events
    ADD CONSTRAINT events_pkey PRIMARY KEY (id);


--
-- Name: hockey_goals_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY hockey_goals
    ADD CONSTRAINT hockey_goals_pkey PRIMARY KEY (id);


--
-- Name: hockey_goaltenders_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY hockey_goaltenders
    ADD CONSTRAINT hockey_goaltenders_pkey PRIMARY KEY (id);


--
-- Name: hockey_penalties_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY hockey_penalties
    ADD CONSTRAINT hockey_penalties_pkey PRIMARY KEY (id);


--
-- Name: hockey_skaters_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY hockey_skaters
    ADD CONSTRAINT hockey_skaters_pkey PRIMARY KEY (id);


--
-- Name: hockey_statsheets_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY hockey_statsheets
    ADD CONSTRAINT hockey_statsheets_pkey PRIMARY KEY (id);


--
-- Name: leagues_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY leagues
    ADD CONSTRAINT leagues_pkey PRIMARY KEY (id);


--
-- Name: leagues_seasons_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY leagues_seasons
    ADD CONSTRAINT leagues_seasons_pkey PRIMARY KEY (id);


--
-- Name: locations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY locations
    ADD CONSTRAINT locations_pkey PRIMARY KEY (id);


--
-- Name: pages_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY pages
    ADD CONSTRAINT pages_pkey PRIMARY KEY (id);


--
-- Name: players_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY players
    ADD CONSTRAINT players_pkey PRIMARY KEY (id);


--
-- Name: posts_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY posts
    ADD CONSTRAINT posts_pkey PRIMARY KEY (id);


--
-- Name: seasons_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY seasons
    ADD CONSTRAINT seasons_pkey PRIMARY KEY (id);


--
-- Name: sections_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sections
    ADD CONSTRAINT sections_pkey PRIMARY KEY (id);


--
-- Name: taggings_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY taggings
    ADD CONSTRAINT taggings_pkey PRIMARY KEY (id);


--
-- Name: tags_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (id);


--
-- Name: teams_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY teams
    ADD CONSTRAINT teams_pkey PRIMARY KEY (id);


--
-- Name: tenants_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY tenants
    ADD CONSTRAINT tenants_pkey PRIMARY KEY (id);


--
-- Name: user_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY user_roles
    ADD CONSTRAINT user_roles_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_clubs_on_tenant_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_clubs_on_tenant_id ON clubs USING btree (tenant_id);


--
-- Name: index_events_on_away_team_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_events_on_away_team_id ON events USING btree (away_team_id);


--
-- Name: index_events_on_home_team_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_events_on_home_team_id ON events USING btree (home_team_id);


--
-- Name: index_events_on_league_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_events_on_league_id ON events USING btree (league_id);


--
-- Name: index_events_on_location_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_events_on_location_id ON events USING btree (location_id);


--
-- Name: index_events_on_season_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_events_on_season_id ON events USING btree (season_id);


--
-- Name: index_events_on_tenant_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_events_on_tenant_id ON events USING btree (tenant_id);


--
-- Name: index_hockey_goals_on_statsheet_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_hockey_goals_on_statsheet_id ON hockey_goals USING btree (statsheet_id);


--
-- Name: index_hockey_goals_on_tenant_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_hockey_goals_on_tenant_id ON hockey_goals USING btree (tenant_id);


--
-- Name: index_hockey_goaltenders_on_player_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_hockey_goaltenders_on_player_id ON hockey_goaltenders USING btree (player_id);


--
-- Name: index_hockey_goaltenders_on_statsheet_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_hockey_goaltenders_on_statsheet_id ON hockey_goaltenders USING btree (statsheet_id);


--
-- Name: index_hockey_goaltenders_on_team_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_hockey_goaltenders_on_team_id ON hockey_goaltenders USING btree (team_id);


--
-- Name: index_hockey_goaltenders_on_tenant_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_hockey_goaltenders_on_tenant_id ON hockey_goaltenders USING btree (tenant_id);


--
-- Name: index_hockey_penalties_on_statsheet_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_hockey_penalties_on_statsheet_id ON hockey_penalties USING btree (statsheet_id);


--
-- Name: index_hockey_penalties_on_tenant_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_hockey_penalties_on_tenant_id ON hockey_penalties USING btree (tenant_id);


--
-- Name: index_hockey_skaters_on_player_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_hockey_skaters_on_player_id ON hockey_skaters USING btree (player_id);


--
-- Name: index_hockey_skaters_on_statsheet_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_hockey_skaters_on_statsheet_id ON hockey_skaters USING btree (statsheet_id);


--
-- Name: index_hockey_skaters_on_team_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_hockey_skaters_on_team_id ON hockey_skaters USING btree (team_id);


--
-- Name: index_hockey_skaters_on_tenant_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_hockey_skaters_on_tenant_id ON hockey_skaters USING btree (tenant_id);


--
-- Name: index_hockey_statsheets_on_tenant_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_hockey_statsheets_on_tenant_id ON hockey_statsheets USING btree (tenant_id);


--
-- Name: index_leagues_seasons_on_league_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_leagues_seasons_on_league_id ON leagues_seasons USING btree (league_id);


--
-- Name: index_leagues_seasons_on_season_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_leagues_seasons_on_season_id ON leagues_seasons USING btree (season_id);


--
-- Name: index_locations_on_tenant_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_locations_on_tenant_id ON locations USING btree (tenant_id);


--
-- Name: index_pages_on_ancestry; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_pages_on_ancestry ON pages USING btree (ancestry);


--
-- Name: index_pages_on_tenant_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_pages_on_tenant_id ON pages USING btree (tenant_id);


--
-- Name: index_players_on_team_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_players_on_team_id ON players USING btree (team_id);


--
-- Name: index_players_on_tenant_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_players_on_tenant_id ON players USING btree (tenant_id);


--
-- Name: index_posts_on_tenant_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_posts_on_tenant_id ON posts USING btree (tenant_id);


--
-- Name: index_sections_on_page_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_sections_on_page_id ON sections USING btree (page_id);


--
-- Name: index_tags_on_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_tags_on_name ON tags USING btree (name);


--
-- Name: index_teams_on_club_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_teams_on_club_id ON teams USING btree (club_id);


--
-- Name: index_teams_on_league_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_teams_on_league_id ON teams USING btree (league_id);


--
-- Name: index_teams_on_season_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_teams_on_season_id ON teams USING btree (season_id);


--
-- Name: index_teams_on_tenant_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_teams_on_tenant_id ON teams USING btree (tenant_id);


--
-- Name: index_tenants_users_on_tenant_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_tenants_users_on_tenant_id ON tenants_users USING btree (tenant_id);


--
-- Name: index_tenants_users_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_tenants_users_on_user_id ON tenants_users USING btree (user_id);


--
-- Name: index_user_roles_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_user_roles_on_user_id ON user_roles USING btree (user_id);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_email ON users USING btree (email);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON users USING btree (reset_password_token);


--
-- Name: taggings_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX taggings_idx ON taggings USING btree (tag_id, taggable_id, taggable_type, context, tagger_id, tagger_type);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user",public;

INSERT INTO schema_migrations (version) VALUES ('20150128040418');

INSERT INTO schema_migrations (version) VALUES ('20150128045109');

INSERT INTO schema_migrations (version) VALUES ('20150128045758');

INSERT INTO schema_migrations (version) VALUES ('20150128052915');

INSERT INTO schema_migrations (version) VALUES ('20150129040945');

INSERT INTO schema_migrations (version) VALUES ('20150129052703');

INSERT INTO schema_migrations (version) VALUES ('20150203225000');

INSERT INTO schema_migrations (version) VALUES ('20150203225028');

INSERT INTO schema_migrations (version) VALUES ('20150204222311');

INSERT INTO schema_migrations (version) VALUES ('20150204222312');

INSERT INTO schema_migrations (version) VALUES ('20150204222452');

INSERT INTO schema_migrations (version) VALUES ('20150205055953');

INSERT INTO schema_migrations (version) VALUES ('20150210010603');

INSERT INTO schema_migrations (version) VALUES ('20150210011439');

INSERT INTO schema_migrations (version) VALUES ('20150210012116');

INSERT INTO schema_migrations (version) VALUES ('20150210204838');

INSERT INTO schema_migrations (version) VALUES ('20150210205852');

INSERT INTO schema_migrations (version) VALUES ('20150210221248');

INSERT INTO schema_migrations (version) VALUES ('20150211174045');

INSERT INTO schema_migrations (version) VALUES ('20150211180006');

INSERT INTO schema_migrations (version) VALUES ('20150211180336');

INSERT INTO schema_migrations (version) VALUES ('20150302180214');

INSERT INTO schema_migrations (version) VALUES ('20150302234608');

INSERT INTO schema_migrations (version) VALUES ('20150302235459');

INSERT INTO schema_migrations (version) VALUES ('20150303183516');

INSERT INTO schema_migrations (version) VALUES ('20150303184334');

INSERT INTO schema_migrations (version) VALUES ('20150424155941');

INSERT INTO schema_migrations (version) VALUES ('20150430214331');

