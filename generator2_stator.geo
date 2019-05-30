//Janeiro, 2019 - Autor: Cássio T. Kruger
//UFPel - Eng. de Controle e Automação
//pdd2 - v1

Geometry.AutoCoherence = 0;

//Stator
R_gs = R_sin-AG;


phase_a_plus[] = {0,3};		
phase_a_minus[] = {2,5};		

phase_b_plus[] = {1,4};		
phase_b_minus[] = {0,3};		

phase_c_plus[] = {2,5};		
phase_c_minus[] = {1,4};	

//build stator slots
For i In {0:N_ss-1}
	 //build two halfs
	 For half In {0:1}

	 //Points definitions-----------------------------------------------------------------//
	 //pontos de uma metade(direita) do slot (ranhura)
	 dP=newp;
	 Point(dP+0) = {0,0,0,1};
	 
	 //parte inferior do slot
	 Point(dP+1) = {0,R_sin,0,pslo};
	 Point(dP+2) = {Cos(Pi/2 - 30*deg2rad)*R_sin,Sin(Pi/2 - 30*deg2rad)*R_sin,0,pslo};

	 //abertura no slot, abaixo dos enrolamentos
	 Point(dP+3) = {0, R_sin+0.002,0,pslo};
	 Point(dP+4) = {Cos(Pi/2 - 3*deg2rad)*(R_sin+0.002), Sin(Pi/2 - 3*deg2rad)*(R_sin+0.002),0,pslo};
	 Point(dP+5) = {Cos(Pi/2 - 3*deg2rad)*(R_sin+0.002), Sin(Pi/2 - 3*deg2rad)*(R_sin+0.002 + 0.003),0,pslo};
	 Point(dP+6) = {0, R_sin+0.002+0.003,0,pslo};

	 //parte dos enrolamentos
	 Point(dP+7) = {Cos(Pi/2 - 24*deg2rad)*(R_sin+0.002+ 0.003) , Sin(Pi/2 - 24*deg2rad)*(R_sin+0.002+ 0.003) ,0,pslo*2.6};
	 Point(dP+8) = {0, R_sin+0.002+0.003+0.03,0,pout};
	 Point(dP+9) = {Cos(Pi/2 - 24*deg2rad)*(R_sin+0.002+0.003+0.03), Sin(Pi/2 - 24*deg2rad)*(R_sin+0.002+0.003+0.03),0,pout};

	 //parte superior do slot
	 Point(dP+10) = {0,R_sin+0.002+0.003+0.03+0.015,0,pout*1.5};
	 Point(dP+11) = {Cos(Pi/2 - 30*deg2rad)*(R_sin+0.002+0.003+0.03+0.015),Sin(Pi/2 - 30*deg2rad)*(R_sin+0.002+0.003+0.03+0.015),0,pout*1.5};

	 //sliding e airgap
	 Point(dP+12) = {0,R_gs,0,pMB};
	 Point(dP+13) = {Cos(Pi/2 - 30*deg2rad)*R_gs,Sin(Pi/2 - 30*deg2rad)*R_gs,0,pMB};

	 //Points definitions-----------------------------------------------------------------//
	
	 // rotate the built points to the i-th slot position
	 For t In {dP+0:dP+13}
	 	Rotate {{0,0,1},{0,0,0}, 2*Pi*i/Qs+2*Pi/Qs/2} {Point{t};}
	 EndFor

	 If (half==1) //second half
		 For t In {dP+0:dP+13}
		 	Symmetry {Cos(2*Pi*i/Qs+2*Pi/Qs/2),Sin(2*Pi*i/Qs+2*Pi/Qs/2),0,0} {Point{t};}
		 EndFor
	 EndIf

	 //Lines definitions-----------------------------------------------------------------//
	dR=newl-1;
	 //linha ventical da entrada do slot
	 Circle(dR+1) = {dP+1,dP+0,dP+2};	//parte inferior do slot
	 Line(dR+2) = {dP+1,dP+3};			//slot center
	 Circle(dR+3) = {dP+3,dP+0,dP+4};
	 Line(dR+4) = {dP+3,dP+6};			//slot center
	 Line(dR+5) = {dP+4,dP+5};
	 Circle(dR+6) = {dP+6,dP+0,dP+5};
	 Circle(dR+7) = {dP+5,dP+0,dP+7};
	 Line(dR+8) = {dP+6,dP+8};
	 Line(dR+9) = {dP+7,dP+9};
	 Circle(dR+10) = {dP+8,dP+0,dP+9};
	 Line(dR+11) = {dP+8,dP+10};
	 Line(dR+12) = {dP+2,dP+11};
	 Circle(dR+13) = {dP+10,dP+0,dP+11};

	 Line(dR+14) = {dP+12,dP+1};
	 Line(dR+15) = {dP+13,dP+2};
	 Circle(dR+16) = {dP+12,dP+0,dP+13}; 


	 //filling the lists for boundaries
	 InnerStator_[] += {dR+1}; //slot fechado
	 OuterStator_[] += {dR+13};	 
	 StatorSliding_[] += {dR+16};
	 //Periodic boundary
	 If (Qs != N_ss)
		 //right boundary
		 If (i==0 && half==0)
		 	StatorPeriod_Right_[] = {dR+12,dR+15};
		 EndIf
		 //left boundary
		 If (i==(N_ss-1) && half==1)
		 	StatorPeriod_Left_[] = {dR+12,dR+16};
		 EndIf
	 EndIf
	 
			 	//if mirrorred, then the lines order is reversed
				//direction is important defining the Line Loops
	 rev = (half ? -1 : 1);

	//TESTE PARA AS FASES 
		//A PLUS
	For aux In {0:1:1}
		 If(i == phase_a_plus[aux] && half == 0)
			 Line Loop(newll) = {dR+7, dR+9, -(dR+10), -(dR+8), dR+6};
			 dH = news; Plane Surface(news) = -rev*{newll-1};
			 PhaseA_Plus_[] += dH;
		 EndIf
	EndFor
		//A MINUS
	For aux In {0:1:1}
		 If(i == phase_a_minus[aux] && half == 1)
			 Line Loop(newll) = {dR+7, dR+9, -(dR+10), -(dR+8), dR+6};
			 dH = news; Plane Surface(news) = -rev*{newll-1};
			 PhaseA_Minus_[] += dH;
		 EndIf
	EndFor

		//B PLUS
	For aux In {0:1:1}
		 If(i == phase_b_plus[aux] && half == 0)
			 Line Loop(newll) = {dR+7, dR+9, -(dR+10), -(dR+8), dR+6};
			 dH = news; Plane Surface(news) = -rev*{newll-1};
			 PhaseB_Plus_[] += dH;
		 EndIf
	EndFor
		//B MINUS
	For aux In {0:1:1}
		 If(i == phase_b_minus[aux] && half == 1)
			 Line Loop(newll) = {dR+7, dR+9, -(dR+10), -(dR+8), dR+6};
			 dH = news; Plane Surface(news) = -rev*{newll-1};
			 PhaseB_Minus_[] += dH;
		 EndIf
	EndFor

		//C PLUS
	For aux In {0:1:1}
		 If(i == phase_c_plus[aux] && half == 0)
			 Line Loop(newll) = {dR+7, dR+9, -(dR+10), -(dR+8), dR+6};
			 dH = news; Plane Surface(news) = -rev*{newll-1};
			 PhaseC_Plus_[] += dH;
		 EndIf
	EndFor
		//C MINUS
	For aux In {0:1:1}
		 If(i == phase_c_minus[aux] && half == 1)
			 Line Loop(newll) = {dR+7, dR+9, -(dR+10), -(dR+8), dR+6};
			 dH = news; Plane Surface(news) = -rev*{newll-1};
			 PhaseC_Minus_[] += dH;
		 EndIf
	EndFor
	
		//surface of the stator iron
	 Line Loop(newll) = {dR+2, dR+3, dR+5, dR+7, dR+9, -(dR+10), dR+11, dR+13, -(dR+12), -(dR+1)};
	 dH = news; Plane Surface(news) = -rev*{newll-1};
	 StatorIron_[] += dH;

	 	//airgap stator
	 Line Loop(newll) = {dR+3, dR+5, -(dR+6), -(dR+4)};
	 dH = news; Plane Surface(news) = rev*{newll-1};
	 StatorAir_[] += dH;

	 Line Loop(newll) = {dR+16, dR+15, -(dR+1), -(dR+14)};
	 dH = news; Plane Surface(news) = rev*{newll-1};
	 StatorAirgapLayer_[] += dH;
	
	 EndFor
EndFor

// Completing moving band
NN = #StatorSliding_[] ;
k1 = (NbrPolesInModel==1)?NbrPolesInModel:NbrPolesInModel+1;
For k In {k1:NbrPolesTot-1}
  StatorSliding_[] += Rotate {{0, 0, 1}, {0, 0, 0}, k*NbrSect*2*(Pi/NbrSectTot)} { Duplicata{ Line{StatorSliding_[{0:NN-1}]};} };
EndFor

//---------------------------------stator-----------------------------------------//
Physical Surface("StatorAirgap", STATOR_AIRGAP) = {StatorAirgapLayer_[]};

Color SteelBlue {Surface{StatorIron_[]};}
Color SkyBlue {Surface{StatorAirgapLayer_[]};}
Color SkyBlue {Surface{StatorAir_[]};}


Physical Surface(STATOR_FE) = {StatorIron_[]};
Physical Surface(STATOR_AIR) = {StatorAir_[]};


If (Qs != N_ss)
	StatorBoundary_[] = {InnerStator_[],OuterStator_[],StatorPeriod_Right_[],StatorPeriod_Left_[]};
	Physical Line(STATOR_BND_A0) = {StatorPeriod_Right_[]};
	Physical Line(STATOR_BND_A1) = {StatorPeriod_Left_[]};
EndIf

If (Qs == N_ss)
	StatorBoundary_[] = {InnerStator_[],OuterStator_[]};
EndIf

Physical Line(SURF_EXT) = {OuterStator_[]};
Physical Line(STATOR_BND_MOVING_BAND) = {StatorSliding_[]};

//---------------- Superficies para as fases (A,B,C) dos enrolamentos 

Physical Surface("stator phase A (-)", STATOR_IND_AM) = {PhaseA_Minus_[]};
Physical Surface("stator phase C (+)", STATOR_IND_CP) = {PhaseC_Plus_[]};
Physical Surface("stator phase B (-)", STATOR_IND_BM) = {PhaseB_Minus_[]};
If(NbrSectStator>2)
  Physical Surface("stator phase A (+)", STATOR_IND_AP) = {PhaseA_Plus_[]};
  Physical Surface("stator phase C (-)", STATOR_IND_CM) = {PhaseC_Minus_[]};
  Physical Surface("stator phase B (+)", STATOR_IND_BP) = {PhaseB_Plus_[]};
EndIf

//-------PHASE A--------//
Color Red1 {Surface{PhaseA_Plus_[]};}
Color Red4 {Surface{PhaseA_Minus_[]};}

//-------PHASE B--------//
Color Green1 {Surface{PhaseB_Plus_[]};}
Color Green4 {Surface{PhaseB_Minus_[]};}

//-------PHASE C--------//
Color Yellow1 {Surface{PhaseC_Plus_[]};}
Color Goldenrod4 {Surface{PhaseC_Minus_[]};}
Coherence;

nicepos_stator[] = CombinedBoundary{Surface{StatorIron_[]};};
nicepos_stator[] += CombinedBoundary{Surface{StatorAirgapLayer_[], StatorAir_[]};};

