//Janeiro, 2019 - Autor: Cássio T. Kruger
//UFPel - Eng. de Controle e Automação
//pdd2 - v1

// constantes
u = 1e-3;           // unidade = mm
mm = 1e-3;          // milimetros
cm = 1e-2;          // unidade
deg2rad = Pi/180;   // graus para radianos

pp = "Input/Constructive parameters/";

DefineConstant[
  NbrPolesInModel = { 4, Choices{ 1="1",2="2",3="3",4="4"}, Name "Input/20Number of poles in FE model", Highlight "Blue"},
  InitialRotorAngle_deg = { 0, Name "Input/20Initial rotor angle [deg]", Highlight "AliceBlue"}
];

NbrPolesTot = 4; // Numero total de polos na máquina
NbrPolePairs = NbrPolesTot/2 ;

SymmetryFactor = NbrPolesTot/NbrPolesInModel;
Flag_Symmetry = (SymmetryFactor==1)?0:1;

// Rotor
NbrSectTot = 4; // number of rotor teeth
NbrSect = (NbrSectTot*NbrPolesInModel)/NbrPolesTot; // number of rotor teeth in FE model
Qr = NbrSectTot;
N_rs = NbrSect;

//Stator
NbrSectStatorTot = 6; // number of stator teeth

//NbrSectStator = Ceil[NbrSectStatorTot*NbrPolesInModel/NbrPolesTot]; // number of stator teeth in FE model
NbrSectStator = (NbrSectStatorTot*NbrPolesInModel/NbrPolesTot); // number of stator teeth in FE model

Qs = NbrSectStatorTot;
N_ss = NbrSectStator;

//--------------------------------------------------------------------------------

InitialRotorAngle = InitialRotorAngle_deg*deg2rad ; // initial rotor angle, 0 if aligned

RotorAngle_R = InitialRotorAngle + Pi/NbrSectTot-Pi/2; // initial rotor angle (radians)
RotorAngle_S = RotorAngle_R;

DefineConstant
[
  AG = {u*0.47, Name StrCat[pp, "Airgap width [m]"], Closed 1,Highlight "Gold"},
  R_sin = {0.160, Name StrCat[pp, "Raio Interno do Estator [m]"],Highlight "SteelBlue"},
  R_sout = {0.210, Name StrCat[pp,  "Raio Externo do Estator [m]"],Highlight "SteelBlue"},
  R_rin = {0.0495, Name StrCat[pp, "Raio Interno do Rotor [m]"],Highlight "SkyBlue"},
  R_rout = {0.150, Name StrCat[pp, "Raio Externo do Rotor [m]"],Highlight "SkyBlue"},
  h_m = {0.008, Name StrCat[pp, "Altura do Imã [m]"],Highlight "ForestGreen"}
];

//-------------------------------------------------------------------------------------------------//
//-------------------------------------------------------------------------------------------------//
//-------------------------------------------------------------------------------------------------//
DefineConstant[
  lm = {2.352*mm , Name StrCat[pp, "Magnet height [m]"], Closed 0}
];

Th_magnet = 32.67 *deg2rad ;  // angle in degrees 0 < Th_magnet < 45

//--------------------------------------------------------------------------------

//Gap = rS1-rR5;
DefineConstant[
  AxialLength = {35*mm,  Name StrCat[pp, "Axial length [m]"], Closed 1},
  Gap = {(26.02-25.6)*mm, Name StrCat[pp, "Airgap width [m]"], Closed 0}
];


sigma_fe = 0. ; // laminated steel
DefineConstant[
  mur_fe = {1000, Name StrCat[pp, "Relative permeability for linear case"]},
  b_remanent = {1.2, Name StrCat[pp, "Remanent induction [T]"] }
];

rpm_nominal = 1800 ;
Inominal = 10.9 ; // Nominal current
Tnominal = 2.5 ; // Nominal torque

//-------------------------------------------------------------------------------------------------//
//-------------------------------------------------------------------------------------------------//
//-------------------------------------------------------------------------------------------------//


// ----------------------------------------------------
// Numbers for physical regions in .geo and .pro files
// ----------------------------------------------------
// Rotor
ROTOR_FE     = 500 ;
ROTOR_AIRGAP = 2000 ;
ROTOR_MAGNET = 3000 ; // Index for first Magnet (1/8 model->1; full model->8)

ROTOR_BND_MOVING_BAND = 4000 ; // Index for first line (1/8 model->1; full model->8)
ROTOR_BND_A0 = 5000 ;
ROTOR_BND_A1 = 6000 ;
SURF_INT     = 7000 ;

// Stator
STATOR_FE     = 8000 ;
STATOR_AIR    = 9000 ;
STATOR_AIRGAP = 10000 ;
STATOR_SLOTOPENING = 11000 ; // Slot opening

STATOR_BND_MOVING_BAND = 12000 ;// Index for first line (1/8 model->1; full model->8)
STATOR_BND_A0          = 13000 ;
STATOR_BND_A1          = 14000 ;

STATOR_IND = 15000;
STATOR_IND_AP = STATOR_IND + 1 ; STATOR_IND_CM = STATOR_IND + 2 ;STATOR_IND_BP = STATOR_IND + 3 ;
STATOR_IND_AM = STATOR_IND + 4 ; STATOR_IND_CP = STATOR_IND + 5 ;STATOR_IND_BM = STATOR_IND + 6 ;

STATOR_IND = 16000 ; //Index for first Ind (1/8 model->3; full model->24)
STATOR_IND_AP = STATOR_IND + 1 ; STATOR_IND_BM = STATOR_IND + 2 ;STATOR_IND_CP = STATOR_IND + 3 ;
STATOR_IND_AM = STATOR_IND + 4 ; STATOR_IND_BP = STATOR_IND + 5 ;STATOR_IND_CM = STATOR_IND + 6 ;

SURF_EXT = 17000 ; // outer boundary


MOVING_BAND = 18000 ;

NICEPOS = 111111 ;
