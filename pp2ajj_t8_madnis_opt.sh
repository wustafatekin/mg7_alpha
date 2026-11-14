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
set pdf ${PDF_SET}
set output_format lhe
set gridpack.save_gridpack false #disable gridpack export for a standalone sinlge run
set FT8 ${clv}

#Madnis Setting (CPU-Tunned)

#neutral network architecture 
set madnis.flow_hidden_dim 64 #Reduced from auto=260 -> 64 (~8x fewer MLP flops per forward/backwardk pass on CPU)
set madnis.flow_layers 3 #reduced from auto=4 -> 3 rational quadratic spline coupling layers
set madnis.flow_spline_bins 8 #Reduced from 10->8 per phase-space dimension (faster spline inversion)
set madnis.discrede_hidden_dim 64 #Reduced from auto=260 -> 64 for discrete helicity/channel sampling network
set madnis.cwnet_hidden_dim 64 #Reducem from auto=260-> 64 for channel weight network (CWNet)
set madnis.cwnet_layers 2 #reduced from 3->2 layers in cwnet

#training schedule and batch sizing
set madnis.loss stratified_variance #minimizes stratified variance across integration channels
set madnis.train_batches 250 #reduced from 1000-> 250 stepss (channels already prutne to 1-2 dominant channels by step 200)
set madnis.log_interval 25 #record training telemetry in info.json evry 25 batches
set madnis.batch_size_offset 26 #reduced from 512 -> 256 base phase-space points per batch
set madnis.batch_size_per_channel #reduced from auto=512->128 points per active channel (4x fewer matrix-element element calls per step)
set madnis.lr 0.0015 #slighty higher peak learning rate (1.5e-3 vs 1e-3) for faster convergence in 250 batches
set madnis.lr_scheduler cosine #cosine learning-rate decay schedule

#buffer
set madnis.buffer_capacity 30000 #replay buffer memory capacity (30,000 phase-space points)
set madnis.minimum_buffer_size 4000 #start replay sampling as son ass 4,000 points are collected (default was 10,000)
set madnis.buffered_steps_fraction 0.8 #perform 80% of training steps from memory bbuffer (avoids recomputing expensive cpu matrix elements)
set madnis.buffer_skip_batchers 50 #actiave repelay buffer atc batch 50

#pruning
set madnis.channel_dropping_interval 50 #prune dead diagrams every 50 batches instead of 100
set madnis.channel_dropping_threshold 0.01 #drop any chanenl whose relative weight falls below 1% of total cross section
set madnis.fixed_cwnet_fraction 0.4 #freeze CWnet during the final 40% of training so normalizing flows stability
done
