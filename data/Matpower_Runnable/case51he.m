function mpc = case51he
%CASE51HE Power flow data for 51 bus distribution system from Hengsritawat, et al
%   Please see CASEFORMAT for details on the case file format.
%
%   Data from ...
%       Hengsritawat V, Tayjasanant T, Nimpitiwan N (2012) Optimal sizing of
%       photovoltaic distributed generators in a distribution system with
%       consideration of solar radiation and harmonic distortion. Int J Electr
%       Power Energy Syst 39:36-47. doi: 10.1016/j.ijepes.2012.01.002
%       URL: https://doi.org/10.1016/j.ijepes.2012.01.002

%% MATPOWER Case Format : Version 2
mpc.version = '2';

%%-----  Power Flow Data  -----%%
%% system MVA base
mpc.baseMVA = 1;

%% bus data
%	bus_i	type	Pd	Qd	Gs	Bs	area	Vm	Va	baseKV	zone	Vmax	Vmin
mpc.bus = [ %% (Pd and Qd are specified in kW & kVAr here, converted to MW & MVAr below)
	1	3	0	0	0	0	1	1	0	22	1	1	1;
	2	1	14.58	8.07	0	0	1	1	0	22	1	1.1	0.9;
	3	1	0	0	0	0	1	1	0	22	1	1.1	0.9;
	4	1	0	0	0	0	1	1	0	22	1	1.1	0.9;
	5	1	0	0	0	0	1	1	0	22	1	1.1	0.9;
	6	1	14.58	8.07	0	0	1	1	0	22	1	1.1	0.9;
	7	1	0	0	0	0	1	1	0	22	1	1.1	0.9;
	8	1	0	0	0	0	1	1	0	22	1	1.1	0.9;
	9	1	58.33	32.27	0	0	1	1	0	22	1	1.1	0.9;
	10	1	0	0	0	0	1	1	0	22	1	1.1	0.9;
	11	1	0	0	0	0	1	1	0	22	1	1.1	0.9;
	12	1	20	15	0	0	1	1	0	22	1	1.1	0.9;
	13	1	0	0	0	0	1	1	0	22	1	1.1	0.9;
	14	1	0	0	0	0	1	1	0	22	1	1.1	0.9;
	15	1	0	0	0	0	1	1	0	22	1	1.1	0.9;
	16	1	29.17	16.14	0	0	1	1	0	22	1	1.1	0.9;
	17	1	72.92	40.34	0	0	1	1	0	22	1	1.1	0.9;
	18	1	20	15	0	0	1	1	0	22	1	1.1	0.9;
	19	1	145.67	80.69	0	0	1	1	0	22	1	1.1	0.9;
	20	1	62.88	33.33	0	0	1	1	0	22	1	1.1	0.9;
	21	1	14.58	8.07	0	0	1	1	0	22	1	1.1	0.9;
	22	1	94.79	52.45	0	0	1	1	0	22	1	1.1	0.9;
	23	1	14.58	8.07	0	0	1	1	0	22	1	1.1	0.9;
	24	1	0	0	0	0	1	1	0	22	1	1.1	0.9;
	25	1	14.58	8.07	0	0	1	1	0	22	1	1.1	0.9;
	26	1	35	19.36	0	0	1	1	0	22	1	1.1	0.9;
	27	1	29.17	16.14	0	0	1	1	0	22	1	1.1	0.9;
	28	1	29.17	16.14	0	0	1	1	0	22	1	1.1	0.9;
	29	1	91.88	50.83	0	0	1	1	0	22	1	1.1	0.9;
	30	1	85.9	36.83	0	0	1	1	0	22	1	1.1	0.9;
	31	1	29.17	16.14	0	0	1	1	0	22	1	1.1	0.9;
	32	1	14.58	8.07	0	0	1	1	0	22	1	1.1	0.9;
	33	1	43.75	24.21	0	0	1	1	0	22	1	1.1	0.9;
	34	1	43.75	24.21	0	0	1	1	0	22	1	1.1	0.9;
	35	1	0	0	0	0	1	1	0	22	1	1.1	0.9;
	36	1	145.83	80.69	0	0	1	1	0	22	1	1.1	0.9;
	37	1	91.88	50.83	0	0	1	1	0	22	1	1.1	0.9;
	38	1	29.17	16.14	0	0	1	1	0	22	1	1.1	0.9;
	39	1	58.33	32.27	0	0	1	1	0	22	1	1.1	0.9;
	40	1	14.58	8.07	0	0	1	1	0	22	1	1.1	0.9;
	41	1	29.17	16.14	0	0	1	1	0	22	1	1.1	0.9;
	42	1	29.17	16.14	0	0	1	1	0	22	1	1.1	0.9;
	43	1	29.17	16.14	0	0	1	1	0	22	1	1.1	0.9;
	44	1	148.75	82.3	0	0	1	1	0	22	1	1.1	0.9;
	45	1	29.17	16.14	0	0	1	1	0	22	1	1.1	0.9;
	46	1	0	0	0	0	1	1	0	22	1	1.1	0.9;
	47	1	29.17	16.14	0	0	1	1	0	22	1	1.1	0.9;
	48	1	58.33	32.27	0	0	1	1	0	22	1	1.1	0.9;
	49	1	43.75	24.21	0	0	1	1	0	22	1	1.1	0.9;
	50	1	116.67	64.55	0	0	1	1	0	22	1	1.1	0.9;
	51	1	91.88	50.83	0	0	1	1	0	22	1	1.1	0.9;
];

%% generator data
%	bus	Pg	Qg	Qmax	Qmin	Vg	mBase	status	Pmax	Pmin	Pc1	Pc2	Qc1min	Qc1max	Qc2min	Qc2max	ramp_agc	ramp_10	ramp_30	ramp_q	apf
mpc.gen = [
	1	0	0	10	-10	1	100	1	10	0	0	0	0	0	0	0	0	0	0	0	0;
];

%% branch data
%	fbus	tbus	r	x	b	rateA	rateB	rateC	ratio	angle	status	angmin	angmax
mpc.branch = [  %% (r and x specified in ohms here, converted to p.u. below)
	1	2	0.4214	0.7334	0	0	0	0	0	0	1	-360	360;
	2	3	0.4214	0.7334	0	0	0	0	0	0	1	-360	360;
	3	4	0.2107	0.3667	0	0	0	0	0	0	1	-360	360;
	4	5	0.4214	0.7334	0	0	0	0	0	0	1	-360	360;
	5	6	0.2107	0.3667	0	0	0	0	0	0	1	-360	360;
	6	7	0.2107	0.3667	0	0	0	0	0	0	1	-360	360;
	7	8	0.4214	0.7334	0	0	0	0	0	0	1	-360	360;
	8	9	0.4214	0.7334	0	0	0	0	0	0	1	-360	360;
	9	10	0.3996	0.67215	0	0	0	0	0	0	1	-360	360;
	10	11	0.5328	0.8962	0	0	0	0	0	0	1	-360	360;
	11	12	0.2664	0.4481	0	0	0	0	0	0	1	-360	360;
	12	13	0.7992	1.3443	0	0	0	0	0	0	1	-360	360;
	13	14	0.5328	0.8962	0	0	0	0	0	0	1	-360	360;
	14	15	1.66675	1.102	0	0	0	0	0	0	1	-360	360;
	15	16	2.0001	1.3224	0	0	0	0	0	0	1	-360	360;
	16	17	0.6667	0.4408	0	0	0	0	0	0	1	-360	360;
	17	18	1.3334	0.8816	0	0	0	0	0	0	1	-360	360;
	18	19	0.6667	0.4408	0	0	0	0	0	0	1	-360	360;
	3	20	5.3336	3.5264	0	0	0	0	0	0	1	-360	360;
	4	21	1.3334	0.8816	0	0	0	0	0	0	1	-360	360;
	5	22	3.3335	2.204	0	0	0	0	0	0	1	-360	360;
	22	23	2.6668	1.7632	0	0	0	0	0	0	1	-360	360;
	23	24	0.6667	0.4408	0	0	0	0	0	0	1	-360	360;
	24	25	6.667	4.408	0	0	0	0	0	0	1	-360	360;
	25	26	1.3334	0.8816	0	0	0	0	0	0	1	-360	360;
	26	27	2.0001	1.3224	0	0	0	0	0	0	1	-360	360;
	23	28	5.3336	3.5264	0	0	0	0	0	0	1	-360	360;
	24	29	1.3334	0.8816	0	0	0	0	0	0	1	-360	360;
	7	30	5.00025	3.306	0	0	0	0	0	0	1	-360	360;
	30	31	0.6667	0.4408	0	0	0	0	0	0	1	-360	360;
	31	32	1.3334	0.8816	0	0	0	0	0	0	1	-360	360;
	32	33	1.3334	0.8816	0	0	0	0	0	0	1	-360	360;
	33	34	1.00005	0.6612	0	0	0	0	0	0	1	-360	360;
	34	35	1.3334	0.8816	0	0	0	0	0	0	1	-360	360;
	35	36	2.33345	1.5428	0	0	0	0	0	0	1	-360	360;
	36	37	1.3334	0.8816	0	0	0	0	0	0	1	-360	360;
	37	38	1.00005	0.6612	0	0	0	0	0	0	1	-360	360;
	30	39	2.0001	1.3224	0	0	0	0	0	0	1	-360	360;
	35	40	1.3334	0.8816	0	0	0	0	0	0	1	-360	360;
	8	41	1.00005	0.6612	0	0	0	0	0	0	1	-360	360;
	9	42	1.3334	0.8816	0	0	0	0	0	0	1	-360	360;
	10	43	4.0002	2.6448	0	0	0	0	0	0	1	-360	360;
	11	44	1.3334	0.8816	0	0	0	0	0	0	1	-360	360;
	12	45	4.6669	3.0856	0	0	0	0	0	0	1	-360	360;
	14	46	0.6667	0.4408	0	0	0	0	0	0	1	-360	360;
	46	47	2.0001	1.3224	0	0	0	0	0	0	1	-360	360;
	47	48	2.0001	1.3224	0	0	0	0	0	0	1	-360	360;
	46	49	0.13334	0.08816	0	0	0	0	0	0	1	-360	360;
	15	50	4.6669	3.0856	0	0	0	0	0	0	1	-360	360;
	17	51	2.6668	1.7632	0	0	0	0	0	0	1	-360	360;
];

%%-----  OPF Data  -----%%
%% generator cost data
%	1	startup	shutdown	n	x1	y1	...	xn	yn
%	2	startup	shutdown	n	c(n-1)	...	c0
mpc.gencost = [
	2	0	0	3	0	20	0;
];
