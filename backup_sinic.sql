--
-- PostgreSQL database dump
--

-- Dumped from database version 17.5
-- Dumped by pg_dump version 17.5

-- Started on 2026-06-05 17:07:55

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 2 (class 3079 OID 29130)
-- Name: postgis; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA public;


--
-- TOC entry 5763 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION postgis; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis IS 'PostGIS geometry and geography spatial types and functions';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 232 (class 1259 OID 30262)
-- Name: cartografia_catastral; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cartografia_catastral (
    id_cartografia integer NOT NULL,
    escala character varying(20) NOT NULL,
    fuente character varying(100) NOT NULL,
    geom public.geometry(MultiPolygon,9377)
);


ALTER TABLE public.cartografia_catastral OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 30261)
-- Name: cartografia_catastral_id_cartografia_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cartografia_catastral_id_cartografia_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.cartografia_catastral_id_cartografia_seq OWNER TO postgres;

--
-- TOC entry 5764 (class 0 OID 0)
-- Dependencies: 231
-- Name: cartografia_catastral_id_cartografia_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cartografia_catastral_id_cartografia_seq OWNED BY public.cartografia_catastral.id_cartografia;


--
-- TOC entry 224 (class 1259 OID 30211)
-- Name: interesados; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.interesados (
    id_interesado integer NOT NULL,
    tipo_documento character varying(20) NOT NULL,
    numero_documento character varying(50) NOT NULL,
    nombre_completo character varying(255) NOT NULL,
    tipo_interesado character varying(50)
);


ALTER TABLE public.interesados OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 30210)
-- Name: interesados_id_interesado_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.interesados_id_interesado_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.interesados_id_interesado_seq OWNER TO postgres;

--
-- TOC entry 5765 (class 0 OID 0)
-- Dependencies: 223
-- Name: interesados_id_interesado_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.interesados_id_interesado_seq OWNED BY public.interesados.id_interesado;


--
-- TOC entry 230 (class 1259 OID 30248)
-- Name: topografia_representacion; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.topografia_representacion (
    id_topografia integer NOT NULL,
    id_ue integer,
    metodo_levantamiento character varying(100) NOT NULL,
    fecha_levantamiento date NOT NULL,
    geom public.geometry(Point,9377)
);


ALTER TABLE public.topografia_representacion OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 30247)
-- Name: topografia_representacion_id_topografia_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.topografia_representacion_id_topografia_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.topografia_representacion_id_topografia_seq OWNER TO postgres;

--
-- TOC entry 5766 (class 0 OID 0)
-- Dependencies: 229
-- Name: topografia_representacion_id_topografia_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.topografia_representacion_id_topografia_seq OWNED BY public.topografia_representacion.id_topografia;


--
-- TOC entry 226 (class 1259 OID 30220)
-- Name: unidad_administrativa; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.unidad_administrativa (
    id_ua integer NOT NULL,
    tipo_derecho character varying(100) NOT NULL,
    matricula_inmobiliaria character varying(50) NOT NULL,
    id_interesado integer
);


ALTER TABLE public.unidad_administrativa OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 30219)
-- Name: unidad_administrativa_id_ua_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.unidad_administrativa_id_ua_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.unidad_administrativa_id_ua_seq OWNER TO postgres;

--
-- TOC entry 5767 (class 0 OID 0)
-- Dependencies: 225
-- Name: unidad_administrativa_id_ua_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.unidad_administrativa_id_ua_seq OWNED BY public.unidad_administrativa.id_ua;


--
-- TOC entry 228 (class 1259 OID 30234)
-- Name: unidad_espacial; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.unidad_espacial (
    id_ue integer NOT NULL,
    id_ua integer,
    tipo_unidad character varying(50) NOT NULL,
    area_terreno numeric NOT NULL,
    geom public.geometry(Polygon,9377)
);


ALTER TABLE public.unidad_espacial OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 30233)
-- Name: unidad_espacial_id_ue_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.unidad_espacial_id_ue_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.unidad_espacial_id_ue_seq OWNER TO postgres;

--
-- TOC entry 5768 (class 0 OID 0)
-- Dependencies: 227
-- Name: unidad_espacial_id_ue_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.unidad_espacial_id_ue_seq OWNED BY public.unidad_espacial.id_ue;


--
-- TOC entry 5577 (class 2604 OID 30265)
-- Name: cartografia_catastral id_cartografia; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cartografia_catastral ALTER COLUMN id_cartografia SET DEFAULT nextval('public.cartografia_catastral_id_cartografia_seq'::regclass);


--
-- TOC entry 5573 (class 2604 OID 30214)
-- Name: interesados id_interesado; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.interesados ALTER COLUMN id_interesado SET DEFAULT nextval('public.interesados_id_interesado_seq'::regclass);


--
-- TOC entry 5576 (class 2604 OID 30251)
-- Name: topografia_representacion id_topografia; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.topografia_representacion ALTER COLUMN id_topografia SET DEFAULT nextval('public.topografia_representacion_id_topografia_seq'::regclass);


--
-- TOC entry 5574 (class 2604 OID 30223)
-- Name: unidad_administrativa id_ua; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.unidad_administrativa ALTER COLUMN id_ua SET DEFAULT nextval('public.unidad_administrativa_id_ua_seq'::regclass);


--
-- TOC entry 5575 (class 2604 OID 30237)
-- Name: unidad_espacial id_ue; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.unidad_espacial ALTER COLUMN id_ue SET DEFAULT nextval('public.unidad_espacial_id_ue_seq'::regclass);


--
-- TOC entry 5757 (class 0 OID 30262)
-- Dependencies: 232
-- Data for Name: cartografia_catastral; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cartografia_catastral (id_cartografia, escala, fuente, geom) FROM stdin;
\.


--
-- TOC entry 5749 (class 0 OID 30211)
-- Dependencies: 224
-- Data for Name: interesados; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.interesados (id_interesado, tipo_documento, numero_documento, nombre_completo, tipo_interesado) FROM stdin;
1	cc	1000365306	allison	propietario
\.


--
-- TOC entry 5572 (class 0 OID 29452)
-- Dependencies: 219
-- Data for Name: spatial_ref_sys; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.spatial_ref_sys (srid, auth_name, auth_srid, srtext, proj4text) FROM stdin;
\.


--
-- TOC entry 5755 (class 0 OID 30248)
-- Dependencies: 230
-- Data for Name: topografia_representacion; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.topografia_representacion (id_topografia, id_ue, metodo_levantamiento, fecha_levantamiento, geom) FROM stdin;
\.


--
-- TOC entry 5751 (class 0 OID 30220)
-- Dependencies: 226
-- Data for Name: unidad_administrativa; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.unidad_administrativa (id_ua, tipo_derecho, matricula_inmobiliaria, id_interesado) FROM stdin;
\.


--
-- TOC entry 5753 (class 0 OID 30234)
-- Dependencies: 228
-- Data for Name: unidad_espacial; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.unidad_espacial (id_ue, id_ua, tipo_unidad, area_terreno, geom) FROM stdin;
\.


--
-- TOC entry 5769 (class 0 OID 0)
-- Dependencies: 231
-- Name: cartografia_catastral_id_cartografia_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cartografia_catastral_id_cartografia_seq', 1, false);


--
-- TOC entry 5770 (class 0 OID 0)
-- Dependencies: 223
-- Name: interesados_id_interesado_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.interesados_id_interesado_seq', 1, true);


--
-- TOC entry 5771 (class 0 OID 0)
-- Dependencies: 229
-- Name: topografia_representacion_id_topografia_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.topografia_representacion_id_topografia_seq', 1, false);


--
-- TOC entry 5772 (class 0 OID 0)
-- Dependencies: 225
-- Name: unidad_administrativa_id_ua_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.unidad_administrativa_id_ua_seq', 1, false);


--
-- TOC entry 5773 (class 0 OID 0)
-- Dependencies: 227
-- Name: unidad_espacial_id_ue_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.unidad_espacial_id_ue_seq', 1, false);


--
-- TOC entry 5594 (class 2606 OID 30269)
-- Name: cartografia_catastral cartografia_catastral_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cartografia_catastral
    ADD CONSTRAINT cartografia_catastral_pkey PRIMARY KEY (id_cartografia);


--
-- TOC entry 5582 (class 2606 OID 30218)
-- Name: interesados interesados_numero_documento_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.interesados
    ADD CONSTRAINT interesados_numero_documento_key UNIQUE (numero_documento);


--
-- TOC entry 5584 (class 2606 OID 30216)
-- Name: interesados interesados_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.interesados
    ADD CONSTRAINT interesados_pkey PRIMARY KEY (id_interesado);


--
-- TOC entry 5592 (class 2606 OID 30255)
-- Name: topografia_representacion topografia_representacion_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.topografia_representacion
    ADD CONSTRAINT topografia_representacion_pkey PRIMARY KEY (id_topografia);


--
-- TOC entry 5586 (class 2606 OID 30227)
-- Name: unidad_administrativa unidad_administrativa_matricula_inmobiliaria_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.unidad_administrativa
    ADD CONSTRAINT unidad_administrativa_matricula_inmobiliaria_key UNIQUE (matricula_inmobiliaria);


--
-- TOC entry 5588 (class 2606 OID 30225)
-- Name: unidad_administrativa unidad_administrativa_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.unidad_administrativa
    ADD CONSTRAINT unidad_administrativa_pkey PRIMARY KEY (id_ua);


--
-- TOC entry 5590 (class 2606 OID 30241)
-- Name: unidad_espacial unidad_espacial_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.unidad_espacial
    ADD CONSTRAINT unidad_espacial_pkey PRIMARY KEY (id_ue);


--
-- TOC entry 5597 (class 2606 OID 30256)
-- Name: topografia_representacion topografia_representacion_id_ue_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.topografia_representacion
    ADD CONSTRAINT topografia_representacion_id_ue_fkey FOREIGN KEY (id_ue) REFERENCES public.unidad_espacial(id_ue) ON DELETE CASCADE;


--
-- TOC entry 5595 (class 2606 OID 30228)
-- Name: unidad_administrativa unidad_administrativa_id_interesado_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.unidad_administrativa
    ADD CONSTRAINT unidad_administrativa_id_interesado_fkey FOREIGN KEY (id_interesado) REFERENCES public.interesados(id_interesado) ON DELETE SET NULL;


--
-- TOC entry 5596 (class 2606 OID 30242)
-- Name: unidad_espacial unidad_espacial_id_ua_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.unidad_espacial
    ADD CONSTRAINT unidad_espacial_id_ua_fkey FOREIGN KEY (id_ua) REFERENCES public.unidad_administrativa(id_ua) ON DELETE CASCADE;


-- Completed on 2026-06-05 17:07:56

--
-- PostgreSQL database dump complete
--

