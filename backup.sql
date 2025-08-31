--
-- PostgreSQL database dump
--

\restrict PQzgoYmLAEhsfrJo9ftmJO6Xwbwul7Wj1ujLz0nGVPYJLDs3u21AKDgHgPGjfly

-- Dumped from database version 17.5
-- Dumped by pg_dump version 17.6 (Homebrew)

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: budgets; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.budgets (
    id integer NOT NULL,
    user_id integer,
    category text NOT NULL,
    amount numeric NOT NULL,
    month text NOT NULL,
    created_at timestamp with time zone DEFAULT now()
);


--
-- Name: budgets_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.budgets_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: budgets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.budgets_id_seq OWNED BY public.budgets.id;


--
-- Name: goals; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.goals (
    id integer NOT NULL,
    user_id integer,
    title text NOT NULL,
    target_amount numeric NOT NULL,
    current_amount numeric DEFAULT 0,
    created_at timestamp with time zone DEFAULT now(),
    target_date date
);


--
-- Name: goals_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.goals_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: goals_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.goals_id_seq OWNED BY public.goals.id;


--
-- Name: transactions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.transactions (
    id integer NOT NULL,
    user_id integer,
    amount numeric NOT NULL,
    type text NOT NULL,
    category text NOT NULL,
    description text,
    created_at timestamp with time zone DEFAULT now(),
    CONSTRAINT transactions_type_check CHECK ((type = ANY (ARRAY['income'::text, 'expense'::text])))
);


--
-- Name: transactions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.transactions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: transactions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.transactions_id_seq OWNED BY public.transactions.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    user_id integer NOT NULL,
    email character varying(255) NOT NULL,
    password_hash character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT now()
);


--
-- Name: users_user_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_user_id_seq OWNED BY public.users.user_id;


--
-- Name: budgets id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.budgets ALTER COLUMN id SET DEFAULT nextval('public.budgets_id_seq'::regclass);


--
-- Name: goals id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.goals ALTER COLUMN id SET DEFAULT nextval('public.goals_id_seq'::regclass);


--
-- Name: transactions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.transactions ALTER COLUMN id SET DEFAULT nextval('public.transactions_id_seq'::regclass);


--
-- Name: users user_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN user_id SET DEFAULT nextval('public.users_user_id_seq'::regclass);


--
-- Data for Name: budgets; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.budgets (id, user_id, category, amount, month, created_at) FROM stdin;
1	3	car	500000	08/2025	2025-08-15 11:27:33.981434+05:30
2	3	laptop	200000	08/2025	2025-08-15 11:28:09.982148+05:30
3	3	trip	5000	08/2025	2025-08-15 11:31:07.116589+05:30
\.


--
-- Data for Name: goals; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.goals (id, user_id, title, target_amount, current_amount, created_at, target_date) FROM stdin;
1	1	Buy a Laptop	50000	0	2025-08-01 17:05:28.507009+05:30	2025-12-31
2	3	save every month	200	0	2025-08-15 13:55:31.615093+05:30	2025-12-31
\.


--
-- Data for Name: transactions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.transactions (id, user_id, amount, type, category, description, created_at) FROM stdin;
1	1	1500	income	Salary	Monthly salary	2025-08-01 01:25:08.448007+05:30
2	3	500000	expense	other	car	2025-08-07 15:00:24.109112+05:30
3	3	100000	expense	other	TV	2025-08-07 15:01:05.604499+05:30
4	3	100000	expense	other	fridge	2025-08-07 15:01:28.452295+05:30
5	3	1000000	expense	other	house	2025-08-07 21:44:17.087925+05:30
6	3	2000000	expense	other	laptops	2025-08-07 22:41:12.449712+05:30
7	3	3000	expense	other	book	2025-08-07 23:45:50.944257+05:30
8	3	3000	expense	other	expense	2025-08-07 23:49:16.715142+05:30
9	3	5000	expense	food	food	2025-08-07 23:54:57.987906+05:30
10	3	500000	expense	food	food	2025-08-07 23:55:18.036905+05:30
11	3	3000	income	education	stationary	2025-08-14 19:59:09.82115+05:30
12	3	10000000	income	salary	paisaHipaisa	2025-08-14 20:00:45.445471+05:30
13	3	2000	expense	medication	tablets	2025-08-15 21:50:33.207517+05:30
14	3	5000000	expense	house	plot for house	2025-08-17 18:30:41.884855+05:30
15	3	100000	income	saving	relative loan	2025-08-17 18:33:12.325692+05:30
16	3	500000	expense	food	pav bhaji	2025-08-17 22:42:03.005853+05:30
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.users (user_id, email, password_hash, created_at) FROM stdin;
1	test@example.com	$2b$10$gn6mrMTEnKH.1iLuXVDDDOmwAMI.hrUxc14I.jVRWwlvdUiFZyh5S	2025-07-31 18:21:11.565344+05:30
2	your@email.com	$2b$10$ok8HbGEPVS6eKV0rqBQiEuR6LrOWgFm53i7PIBeimSHHA9jjQsVSy	2025-07-31 21:05:25.270017+05:30
3	sakshibhongle1221@gmail.com	$2b$10$zOVU3ZWDU0vWUSwxAcxvw.XzZXEAKZXVYBJaciEC54T//zWv2CRBu	2025-08-05 20:01:48.816335+05:30
\.


--
-- Name: budgets_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.budgets_id_seq', 3, true);


--
-- Name: goals_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.goals_id_seq', 2, true);


--
-- Name: transactions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.transactions_id_seq', 16, true);


--
-- Name: users_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.users_user_id_seq', 3, true);


--
-- Name: budgets budgets_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.budgets
    ADD CONSTRAINT budgets_pkey PRIMARY KEY (id);


--
-- Name: goals goals_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.goals
    ADD CONSTRAINT goals_pkey PRIMARY KEY (id);


--
-- Name: transactions transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_pkey PRIMARY KEY (id);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);


--
-- Name: budgets budgets_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.budgets
    ADD CONSTRAINT budgets_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id);


--
-- Name: goals goals_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.goals
    ADD CONSTRAINT goals_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id);


--
-- Name: transactions transactions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id);


--
-- PostgreSQL database dump complete
--

\unrestrict PQzgoYmLAEhsfrJo9ftmJO6Xwbwul7Wj1ujLz0nGVPYJLDs3u21AKDgHgPGjfly

