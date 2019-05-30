//Janeiro, 2019 - Autor: Cássio T. Kruger
//UFPel - Eng. de Controle e Automação
//pdd2 - v1.0

Solver.AutoShowLastStep = 1;
Mesh.Algorithm = 1;

// constantes
u = 1e-3;           // unidade = mm
mm = 1e-3;          // milimetros
cm = 1e-2;          // unidade
deg2rad = Pi/180;   // graus para radianos

// some characteristic lengths...
pslo = mm * 3*2/2/1.5;  // slot opening
psl  = mm * 2.2;        // upper part slot
pout = mm * 12;         // outer radius
pMB  = mm * 1 * 2/2;    // MB
p  = mm*12*0.05*1.3;    //rotor


Include "generator2_data.geo" ;
Include "generator2_stator.geo" ;
Include "generator2_rotor.geo" ;

Mesh.CharacteristicLengthFactor = 1;


//Mesh 2;

// For nice visualisation...
Mesh.Light = 0 ;

Hide { Line{ Line '*' }; }
Hide { Point{ Point '*' }; }

Physical Line(NICEPOS) = { nicepos_rotor[], nicepos_stator[] };
Show { Line{ nicepos_rotor[], nicepos_stator[] }; }

//For post-processing...
View[PostProcessing.NbViews-1].Light = 0;
View[PostProcessing.NbViews-1].NbIso = 50; // Number of intervals
View[PostProcessing.NbViews-1].IntervalsType = 1;
