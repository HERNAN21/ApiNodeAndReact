--
-- PostgreSQL database dump
--

-- Dumped from database version 11.5
-- Dumped by pg_dump version 11.5

-- Started on 2019-11-15 16:57:35

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 196 (class 1259 OID 18095)
-- Name: users; Type: TABLE; Schema: public; Owner: pool_recursos_qa
--

CREATE TABLE public.users (
    id integer NOT NULL,
    user_name character varying(100) NOT NULL,
    pasword_1 character varying(100) NOT NULL,
    pasword_2 character varying(100) NOT NULL,
    estado boolean NOT NULL
);


ALTER TABLE public.users OWNER TO pool_recursos_qa;

--
-- TOC entry 2806 (class 0 OID 18095)
-- Dependencies: 196
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: pool_recursos_qa
--

INSERT INTO public.users VALUES (1, 'hrojas', '123', '123', true);


--
-- TOC entry 2684 (class 2606 OID 18099)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: pool_recursos_qa
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


-- Completed on 2019-11-15 16:57:36

--
-- PostgreSQL database dump complete
--

