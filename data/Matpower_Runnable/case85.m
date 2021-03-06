function mpc = case85
%CASE85  Power flow data for 85 bus distribution system from Das, et al
%   Please see CASEFORMAT for details on the case file format.
%
%   Data from ...
%       D. Das, D.P. Kothari, A. Kalam, Simple and efficient method for
%       load flow solution of radial distribution networks, International
%       Journal of Electrical Power & Energy Systems, Volume 17, Issue 5,
%       1995, Pages 335-346. doi: 10.1016/0142-0615(95)00050-0
%       URL: https://doi.org/10.1016/0142-0615(95)00050-0
%
%   Modifications:
%     v2 - 2020-09-30 (RDZ)
%         - Removed load at bus 60. There appears to be a typo in the paper,
%           with the load for bus 61 repeated. The original case85.m assumed
%           a typo in the bus number, and put the first instance at bus 60.
%           This version assumes it was a simple erroneous duplicate entry,
%           since it results in a power flow solution that matches the one in
%           the paper more closely.
%         - Added code for explicit conversion of loads from kW to MW and
%           branch parameters from Ohms to p.u.
%         - Bus 1 Vmin = Vmax = 1.0
%         - Gen Qmin, Qmax, Pmax magnitudes set to 10 (instead of 999)
%         - Branch flow limits disabled, i.e. set to 0 (instead of 999)
%         - Add gen cost.
%         - Change baseMVA to 1 MVA.

%% MATPOWER Case Format : Version 2
mpc.version = '2';

%%-----  Power Flow Data  -----%%
%% system MVA base
mpc.baseMVA = 1;

%% bus data
%	bus_i	type	Pd	Qd	Gs	Bs	area	Vm	Va	baseKV	zone	Vmax	Vmin
mpc.bus = [ %% (Pd and Qd are specified in kW & kVAr here, converted to MW & MVAr below)
	1	3	0	0	0	0	1	1	0	11	1	1	1;
	2	1	0	0	0	0	1	1	0	11	1	1.1	0.9;
	3	1	0	0	0	0	1	1	0	11	1	1.1	0.9;
	4	1	56	57.1314	0	0	1	1	0	11	1	1.1	0.9;
	5	1	0	0	0	0	1	1	0	11	1	1.1	0.9;
	6	1	35.28	35.9928	0	0	1	1	0	11	1	1.1	0.9;
	7	1	0	0	0	0	1	1	0	11	1	1.1	0.9;
	8	1	35.28	35.9928	0	0	1	1	0	11	1	1.1	0.9;
	9	1	0	0	0	0	1	1	0	11	1	1.1	0.9;
	10	1	0	0	0	0	1	1	0	11	1	1.1	0.9;
	11	1	56	57.1314	0	0	1	1	0	11	1	1.1	0.9;
	12	1	0	0	0	0	1	1	0	11	1	1.1	0.9;
	13	1	0	0	0	0	1	1	0	11	1	1.1	0.9;
	14	1	35.28	35.9928	0	0	1	1	0	11	1	1.1	0.9;
	15	1	35.28	35.9928	0	0	1	1	0	11	1	1.1	0.9;
	16	1	35.28	35.9928	0	0	1	1	0	11	1	1.1	0.9;
	17	1	112	114.2629	0	0	1	1	0	11	1	1.1	0.9;
	18	1	56	57.1314	0	0	1	1	0	11	1	1.1	0.9;
	19	1	56	57.1314	0	0	1	1	0	11	1	1.1	0.9;
	20	1	35.28	35.9928	0	0	1	1	0	11	1	1.1	0.9;
	21	1	35.28	35.9928	0	0	1	1	0	11	1	1.1	0.9;
	22	1	35.28	35.9928	0	0	1	1	0	11	1	1.1	0.9;
	23	1	56	57.1314	0	0	1	1	0	11	1	1.1	0.9;
	24	1	35.28	35.9928	0	0	1	1	0	11	1	1.1	0.9;
	25	1	35.28	35.9928	0	0	1	1	0	11	1	1.1	0.9;
	26	1	56	57.1314	0	0	1	1	0	11	1	1.1	0.9;
	27	1	0	0	0	0	1	1	0	11	1	1.1	0.9;
	28	1	56	57.1314	0	0	1	1	0	11	1	1.1	0.9;
	29	1	0	0	0	0	1	1	0	11	1	1.1	0.9;
	30	1	35.28	35.9928	0	0	1	1	0	11	1	1.1	0.9;
	31	1	35.28	35.9928	0	0	1	1	0	11	1	1.1	0.9;
	32	1	0	0	0	0	1	1	0	11	1	1.1	0.9;
	33	1	14	14.2829	0	0	1	1	0	11	1	1.1	0.9;
	34	1	0	0	0	0	1	1	0	11	1	1.1	0.9;
	35	1	0	0	0	0	1	1	0	11	1	1.1	0.9;
	36	1	35.28	35.9928	0	0	1	1	0	11	1	1.1	0.9;
	37	1	56	57.1314	0	0	1	1	0	11	1	1.1	0.9;
	38	1	56	57.1314	0	0	1	1	0	11	1	1.1	0.9;
	39	1	56	57.1314	0	0	1	1	0	11	1	1.1	0.9;
	40	1	35.28	35.9928	0	0	1	1	0	11	1	1.1	0.9;
	41	1	0	0	0	0	1	1	0	11	1	1.1	0.9;
	42	1	35.28	35.9928	0	0	1	1	0	11	1	1.1	0.9;
	43	1	35.28	35.9928	0	0	1	1	0	11	1	1.1	0.9;
	44	1	35.28	35.9928	0	0	1	1	0	11	1	1.1	0.9;
	45	1	35.28	35.9928	0	0	1	1	0	11	1	1.1	0.9;
	46	1	35.28	35.9928	0	0	1	1	0	11	1	1.1	0.9;
	47	1	14	14.2829	0	0	1	1	0	11	1	1.1	0.9;
	48	1	0	0	0	0	1	1	0	11	1	1.1	0.9;
	49	1	0	0	0	0	1	1	0	11	1	1.1	0.9;
	50	1	36.28	37.013	0	0	1	1	0	11	1	1.1	0.9;
	51	1	56	57.1314	0	0	1	1	0	11	1	1.1	0.9;
	52	1	0	0	0	0	1	1	0	11	1	1.1	0.9;
	53	1	35.28	35.9928	0	0	1	1	0	11	1	1.1	0.9;
	54	1	56	57.1314	0	0	1	1	0	11	1	1.1	0.9;
	55	1	56	57.1314	0	0	1	1	0	11	1	1.1	0.9;
	56	1	14	14.2829	0	0	1	1	0	11	1	1.1	0.9;
	57	1	56	57.1314	0	0	1	1	0	11	1	1.1	0.9;
	58	1	0	0	0	0	1	1	0	11	1	1.1	0.9;
	59	1	56	57.1314	0	0	1	1	0	11	1	1.1	0.9;
	60	1	0	0	0	0	1	1	0	11	1	1.1	0.9;
	61	1	56	57.1314	0	0	1	1	0	11	1	1.1	0.9;
	62	1	56	57.1314	0	0	1	1	0	11	1	1.1	0.9;
	63	1	14	14.2829	0	0	1	1	0	11	1	1.1	0.9;
	64	1	0	0	0	0	1	1	0	11	1	1.1	0.9;
	65	1	0	0	0	0	1	1	0	11	1	1.1	0.9;
	66	1	56	57.1314	0	0	1	1	0	11	1	1.1	0.9;
	67	1	0	0	0	0	1	1	0	11	1	1.1	0.9;
	68	1	0	0	0	0	1	1	0	11	1	1.1	0.9;
	69	1	56	57.1314	0	0	1	1	0	11	1	1.1	0.9;
	70	1	0	0	0	0	1	1	0	11	1	1.1	0.9;
	71	1	35.28	35.9928	0	0	1	1	0	11	1	1.1	0.9;
	72	1	56	57.1314	0	0	1	1	0	11	1	1.1	0.9;
	73	1	0	0	0	0	1	1	0	11	1	1.1	0.9;
	74	1	56	57.1314	0	0	1	1	0	11	1	1.1	0.9;
	75	1	35.28	35.9928	0	0	1	1	0	11	1	1.1	0.9;
	76	1	56	57.1314	0	0	1	1	0	11	1	1.1	0.9;
	77	1	14	14.2829	0	0	1	1	0	11	1	1.1	0.9;
	78	1	56	57.1314	0	0	1	1	0	11	1	1.1	0.9;
	79	1	35.28	35.9928	0	0	1	1	0	11	1	1.1	0.9;
	80	1	56	57.1314	0	0	1	1	0	11	1	1.1	0.9;
	81	1	0	0	0	0	1	1	0	11	1	1.1	0.9;
	82	1	56	57.1314	0	0	1	1	0	11	1	1.1	0.9;
	83	1	35.28	35.9928	0	0	1	1	0	11	1	1.1	0.9;
	84	1	14	14.2829	0	0	1	1	0	11	1	1.1	0.9;
	85	1	35.28	35.9928	0	0	1	1	0	11	1	1.1	0.9;
];

%% generator data
%	bus	Pg	Qg	Qmax	Qmin	Vg	mBase	status	Pmax	Pmin	Pc1	Pc2	Qc1min	Qc1max	Qc2min	Qc2max	ramp_agc	ramp_10	ramp_30	ramp_q	apf
mpc.gen = [
	1	0	0	10	-10	1	100	1	10	0	0	0	0	0	0	0	0	0	0	0	0;
];

%% branch data
%	fbus	tbus	r	x	b	rateA	rateB	rateC	ratio	angle	status	angmin	angmax
mpc.branch = [  %% (r and x specified in ohms here, converted to p.u. below)
	1	2	0.108	0.075	0	0	0	0	0	0	1	-360	360;
	2	3	0.163	0.112	0	0	0	0	0	0	1	-360	360;
	3	4	0.217	0.149	0	0	0	0	0	0	1	-360	360;
	4	5	0.108	0.074	0	0	0	0	0	0	1	-360	360;
	5	6	0.435	0.298	0	0	0	0	0	0	1	-360	360;
	6	7	0.272	0.186	0	0	0	0	0	0	1	-360	360;
	7	8	1.197	0.82	0	0	0	0	0	0	1	-360	360;
	8	9	0.108	0.074	0	0	0	0	0	0	1	-360	360;
	9	10	0.598	0.41	0	0	0	0	0	0	1	-360	360;
	10	11	0.544	0.373	0	0	0	0	0	0	1	-360	360;
	11	12	0.544	0.373	0	0	0	0	0	0	1	-360	360;
	12	13	0.598	0.41	0	0	0	0	0	0	1	-360	360;
	13	14	0.272	0.186	0	0	0	0	0	0	1	-360	360;
	14	15	0.326	0.223	0	0	0	0	0	0	1	-360	360;
	2	16	0.728	0.302	0	0	0	0	0	0	1	-360	360;
	3	17	0.455	0.189	0	0	0	0	0	0	1	-360	360;
	5	18	0.82	0.34	0	0	0	0	0	0	1	-360	360;
	18	19	0.637	0.264	0	0	0	0	0	0	1	-360	360;
	19	20	0.455	0.189	0	0	0	0	0	0	1	-360	360;
	20	21	0.819	0.34	0	0	0	0	0	0	1	-360	360;
	21	22	1.548	0.642	0	0	0	0	0	0	1	-360	360;
	19	23	0.182	0.075	0	0	0	0	0	0	1	-360	360;
	7	24	0.91	0.378	0	0	0	0	0	0	1	-360	360;
	8	25	0.455	0.189	0	0	0	0	0	0	1	-360	360;
	25	26	0.364	0.151	0	0	0	0	0	0	1	-360	360;
	26	27	0.546	0.226	0	0	0	0	0	0	1	-360	360;
	27	28	0.273	0.113	0	0	0	0	0	0	1	-360	360;
	28	29	0.546	0.226	0	0	0	0	0	0	1	-360	360;
	29	30	0.546	0.226	0	0	0	0	0	0	1	-360	360;
	30	31	0.273	0.113	0	0	0	0	0	0	1	-360	360;
	31	32	0.182	0.075	0	0	0	0	0	0	1	-360	360;
	32	33	0.182	0.075	0	0	0	0	0	0	1	-360	360;
	33	34	0.819	0.34	0	0	0	0	0	0	1	-360	360;
	34	35	0.637	0.264	0	0	0	0	0	0	1	-360	360;
	35	36	0.182	0.075	0	0	0	0	0	0	1	-360	360;
	26	37	0.364	0.151	0	0	0	0	0	0	1	-360	360;
	27	38	1.002	0.416	0	0	0	0	0	0	1	-360	360;
	29	39	0.546	0.226	0	0	0	0	0	0	1	-360	360;
	32	40	0.455	0.189	0	0	0	0	0	0	1	-360	360;
	40	41	1.002	0.416	0	0	0	0	0	0	1	-360	360;
	41	42	0.273	0.113	0	0	0	0	0	0	1	-360	360;
	41	43	0.455	0.189	0	0	0	0	0	0	1	-360	360;
	34	44	1.002	0.416	0	0	0	0	0	0	1	-360	360;
	44	45	0.911	0.378	0	0	0	0	0	0	1	-360	360;
	45	46	0.911	0.378	0	0	0	0	0	0	1	-360	360;
	46	47	0.546	0.226	0	0	0	0	0	0	1	-360	360;
	35	48	0.637	0.264	0	0	0	0	0	0	1	-360	360;
	48	49	0.182	0.075	0	0	0	0	0	0	1	-360	360;
	49	50	0.364	0.151	0	0	0	0	0	0	1	-360	360;
	50	51	0.455	0.189	0	0	0	0	0	0	1	-360	360;
	48	52	1.366	0.567	0	0	0	0	0	0	1	-360	360;
	52	53	0.455	0.189	0	0	0	0	0	0	1	-360	360;
	53	54	0.546	0.226	0	0	0	0	0	0	1	-360	360;
	52	55	0.546	0.226	0	0	0	0	0	0	1	-360	360;
	49	56	0.546	0.226	0	0	0	0	0	0	1	-360	360;
	9	57	0.273	0.113	0	0	0	0	0	0	1	-360	360;
	57	58	0.819	0.34	0	0	0	0	0	0	1	-360	360;
	58	59	0.182	0.075	0	0	0	0	0	0	1	-360	360;
	58	60	0.546	0.226	0	0	0	0	0	0	1	-360	360;
	60	61	0.728	0.302	0	0	0	0	0	0	1	-360	360;
	61	62	1.002	0.415	0	0	0	0	0	0	1	-360	360;
	60	63	0.182	0.075	0	0	0	0	0	0	1	-360	360;
	63	64	0.728	0.302	0	0	0	0	0	0	1	-360	360;
	64	65	0.182	0.075	0	0	0	0	0	0	1	-360	360;
	65	66	0.182	0.075	0	0	0	0	0	0	1	-360	360;
	64	67	0.455	0.189	0	0	0	0	0	0	1	-360	360;
	67	68	0.91	0.378	0	0	0	0	0	0	1	-360	360;
	68	69	1.092	0.453	0	0	0	0	0	0	1	-360	360;
	69	70	0.455	0.189	0	0	0	0	0	0	1	-360	360;
	70	71	0.546	0.226	0	0	0	0	0	0	1	-360	360;
	67	72	0.182	0.075	0	0	0	0	0	0	1	-360	360;
	68	73	1.184	0.491	0	0	0	0	0	0	1	-360	360;
	73	74	0.273	0.113	0	0	0	0	0	0	1	-360	360;
	73	75	1.002	0.416	0	0	0	0	0	0	1	-360	360;
	70	76	0.546	0.226	0	0	0	0	0	0	1	-360	360;
	65	77	0.091	0.037	0	0	0	0	0	0	1	-360	360;
	10	78	0.637	0.264	0	0	0	0	0	0	1	-360	360;
	67	79	0.546	0.226	0	0	0	0	0	0	1	-360	360;
	12	80	0.728	0.302	0	0	0	0	0	0	1	-360	360;
	80	81	0.364	0.151	0	0	0	0	0	0	1	-360	360;
	81	82	0.091	0.037	0	0	0	0	0	0	1	-360	360;
	81	83	1.092	0.453	0	0	0	0	0	0	1	-360	360;
	83	84	1.002	0.416	0	0	0	0	0	0	1	-360	360;
	13	85	0.819	0.34	0	0	0	0	0	0	1	-360	360;
];

%%-----  OPF Data  -----%%
%% generator cost data
%	1	startup	shutdown	n	x1	y1	...	xn	yn
%	2	startup	shutdown	n	c(n-1)	...	c0
mpc.gencost = [
	2	0	0	3	0	20	0;
];
