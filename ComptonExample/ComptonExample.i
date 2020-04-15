HEADER 'Compton Scattering';
!!  Very high energy Compton scattering including nonlinear scattering.
ALLOCATE MP=500000;
SET   photon=1, electron=2, positron=3,
   mm=1e-3, micron=1e-6, nm=1e-9, mu0=4*Pi*1e-7, psec=1e-12*Cvel,
   nsec=1e-9*Cvel;
! define variables for electron beam
SET ee=250D9,  gamma=ee/Emass,  an=0.65D10,  sigz=0.1*mm, 
   betax=0.5*mm, betay=0.5*mm, emitx=5D-6/gamma, emity=8D-8/gamma,
   sigx=Sqrt(emitx*betax), sigy=Sqrt(emity*betay),
   ntcut=3.0;
! define variables for laser
SET  laserwl=1.053*micron, lambar=laserwl/(2*Pi), omegal=Hbarc/lambar, 
   rlx=0.1*mm, rly=0.1*mm, sigt=0.23*mm,   !! Rayleigh length and pulse length
   pulseE=1,        !!  pulse energy in Joule
   powerd=pulseE*Cvel/[Pi*lambar*sigt*Sqrt(2*Pi*rlx*rly)],
   xisq=powerd*mu0*Cvel*(lambar/Emass)^2,   xi=Sqrt(xisq),
   eta=omegal*ee/Emass^2, lambda=4*eta,
   angle=0.0 ;
SET MsgLevel=1;
BEAM  RIGHT, KIND=electron, NP=50000, AN=an, E0=ee,
   TXYS=(0,0,0,0),  GCUTT=ntcut,
   BETA=(betax,betay), EMIT=(emitx,emity), SIGT=sigz, SPIN=(0,0,-1);
LASER LEFT, WAVEL=laserwl, POWERD=powerd,
      TXYS=(0,0,0,0),
      E3=(0,-Sin(angle),-Cos(angle)), E1=(1,0,0), 
      RAYLEIGH=(rlx,rly), SIGT=sigt, GCUTT=ntcut, STOKES=(0,1,0) ;
LASERQED  COMPTON, NPH=5, XIMAX=1.1*xi, LAMBDAMAX=1.1*lambda ,
       ENHANCE=1, PMAX=0.5 ;
SET MsgLevel=0;  FLAG OFF ECHO;
SET Smesh=sigt/3;
SET emax=1.001*ee, wmax=emax;
SET  it=0;
PRINT CPUTIME;
PUSH  Time=(-ntcut*(sigt+sigz),ntcut*(sigt+sigz),500);
      IF Mod(it,50)=0;
        PRINT it, FORMAT=(F6.0,'-th time step'); PRINT STAT, SHORT;
      ENDIF;
     SET it=it+1;
ENDPUSH;
PRINT CPUTIME;
!  Pull all particles to the back to the focal point
DRIFT S=0;
WRITE BEAM, KIND=(electron,photon), FILE='TempData.dat';
PRINT STAT;
PLOT  HIST, RIGHT, KIND=electron, H=En/1D9, HSCALE=(0,emax/1e9,50),
        TITLE='Right-Going Electron Energy Spectrum;',
        HTITLE='E0e1 (GeV); X X      ;';
PLOT  HIST, KIND=photon, H=En/1D9, HSCALE=(0,emax/1e9,50),
        TITLE='All Photon Energy Spectrum;',
        HTITLE='E0G1 (GeV); XGX      ;'  ;
PLOT  SCAT, KIND=photon, RIGHT,
        H=En/1D9, V=Xi2,
        HSCALE=(0,emax/1e9), VSCALE=(-1,1),
        TITLE='Photon Energy vs. Helicity;',
        HTITLE='E0G1 (GeV); XGX      ;',
        VTITLE='X021; X X;',;
STOP;
END;
