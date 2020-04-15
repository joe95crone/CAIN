HEADER 'CBETA 42MeV Compton';
! CBETA 42MeV CAIN Spectrum Sim
! Here a lot of values are hardcoded in so it isnt the clearest.
! NOT MANY EVENTS HAPPEN AS IS BASED ON RECIRCULATION NOT BRUTE FORCE
ALLOCATE MP=5000000;
! Setting code for particles
SET photon=1, electron=2, positron=3;
SET reprate=1D6;
SET MsgLevel=1; ! set flag for echo
! Setting Beam Parameters
BEAM RIGHT, KIND=electron, NP=900000, AN=2D8, E0=53.2D6,
   TXYS=(0,0,0,0), GCUTT=3.0, BETA=(1D-2,1D-2), EMIT=(1.02D-9,1.02D-9), 
   SIGT=1D-3, SPIN=(0,0,0);
LASER LEFT, WAVEL=1064D-9, POWERD=6.30D14*reprate, TXYS=(0,0,0,0),
     E3=(0,0,-1), E1=(1,0,0), RAYLEIGH=(7.38D-3,7.38D-3),
     SIGT=3D-3, GCUTT=3, STOKES=(0,1,0);
LASERQED  COMPTON, NPH=0, XIMAX=2.82D-3, LAMBDAMAX=1086D-9,
       ENHANCE=1, PMAX=0.5 ; 
SET MsgLevel=0;  FLAG OFF ECHO;
SET Smesh=1D-3;
SET  it=0;
PRINT CPUTIME;
SET totlen=12D-3;
PUSH  Time=(-totlen,totlen,100000);
      IF Mod(it,50)=0;
        PRINT it, FORMAT=(F6.0,'-th time step'); PRINT STAT, SHORT;
      ENDIF;
     SET it=it+1;
ENDPUSH;
PRINT CPUTIME;
!  Pull all particles to the back to the focal point
DRIFT S=0;
WRITE BEAM, KIND=(electron,photon), FILE='TempCBETAData.dat';
PRINT STAT;
PLOT  HIST, RIGHT, KIND=electron, H=En/1D6, HSCALE=(41,43,100000),
        TITLE='Right-Going Electron Energy Spectrum;',
        HTITLE='E0e1 (MeV); X X      ;';
PLOT  HIST, RIGHT, KIND=photon, H=En/1D3, HSCALE=(0,35,100000),
        TITLE='All Photon Energy Spectrum;',
        HTITLE='E0G1 (keV); XGX      ;'  ;
PLOT  HIST, LEFT, KIND=photon, H=En, HSCALE=(1.1,1.5,100000),
        TITLE='All Photon Energy Spectrum;',
        HTITLE='E0G1 (eV); XGX      ;'  ;
STOP;
END;