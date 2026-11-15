import model SM_LT8_LT9_UFO
define pp = b b~
generate pp pp > a a j j NP=1 QCD=0
output ${PROC_DIR}
launch ${PROC_DIR} -n ${RUN_NAME}
shower=OFF
detector=OFF
analysis=OFF

set seed ${SEED}
set events ${NEVENTS}
set leptonic false #false = proton-proton (hadronic) true=leptonic. in MG5 set lpp1/lpp2 1

set e_cm ${ECM} #different from the MG5 e_c = ebeam1+ebeam2 in units of GeV
set output_format lhe #different from the MG5, the default is *.npy. If pythia8 or delphes used it automatically creates lhe
set FT8 ${cvl}

#madnis
set madnis.enablue auto #if a process 2--> 4 (or 2--> 2>3) it automatically enable the MADNIS
done

