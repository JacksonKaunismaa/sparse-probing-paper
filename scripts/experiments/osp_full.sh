#!/bin/bash
#SBATCH --mem-per-cpu=4G
#SBATCH -N 1
#SBATCH -c 16
#SBATCH -o log/%j-%a-osp_all.log
#SBATCH -a 1-16


# set environment variables
export PATH=$SPARSE_PROBING_ROOT:$PATH

export HF_DATASETS_OFFLINE=1
export TRANSFORMERS_OFFLINE=1

export RESULTS_DIR=/home/gridsan/groups/maia_mechint/sparse_probing/results
export FEATURE_DATASET_DIR=/home/gridsan/groups/maia_mechint/sparse_probing/feature_datasets
export TRANSFORMERS_CACHE=/home/gridsan/groups/maia_mechint/models
export HF_DATASETS_CACHE=/home/gridsan/groups/maia_mechint/sparse_probing/hf_home
export HF_HOME=/home/gridsan/groups/maia_mechint/sparse_probing/hf_home

sleep 0.1  # wait for paths to update

# activate environment and load modules
source $SPARSE_PROBING_ROOT/sparprob/bin/activate
source /etc/profile
module load gurobi/gurobi-1000

PYTHIA_MODELS=('pythia-70m' 'pythia-160m' 'pythia-410m' 'pythia-1b' 'pythia-1.4b' 'pythia-2.8b' 'pythia-6.9b')


for model in "${PYTHIA_MODELS[@]}"
do
    python -u probing_experiment.py \
        --experiment_name test_full_feature_selection_comparison \
        --experiment_type optimal_sparse_probing \
        --model "$model" \
        --feature_dataset programming_lang_id.pyth.512.-1 \
        --activation_aggregation mean \
        --normalize_activations \
        --seed 42 \
        --save_features_together


    python -u probing_experiment.py \
        --experiment_name test_full_feature_selection_comparison \
        --experiment_type optimal_sparse_probing \
        --model "$model" \
        --feature_dataset distribution_id.pyth.512.-1 \
        --activation_aggregation mean \
        --normalize_activations \
        --seed 42 \
        --save_features_together


    python -u probing_experiment.py \
        --experiment_name test_full_feature_selection_comparison \
        --experiment_type optimal_sparse_probing \
        --model "$model" \
        --feature_dataset natural_lang_id.pyth.512.-1 \
        --activation_aggregation mean \
        --normalize_activations \
        --seed 42 \
        --save_features_together


    python -u probing_experiment.py \
        --experiment_name test_full_feature_selection_comparison \
        --experiment_type optimal_sparse_probing \
        --model "$model" \
        --feature_dataset compound_words.pyth.24.-1 \
        --normalize_activations \
        --seed 42 \
        --save_features_together


    python -u probing_experiment.py \
        --experiment_name test_full_feature_selection_comparison \
        --experiment_type optimal_sparse_probing \
        --model "$model" \
        --feature_dataset text_features.pyth.256.10000 \
        --normalize_activations \
        --seed 42 \
        --save_features_together


    python -u probing_experiment.py \
        --experiment_name test_full_feature_selection_comparison \
        --experiment_type optimal_sparse_probing \
        --model "$model" \
        --feature_dataset ewt.pyth.512.-1 \
        --normalize_activations \
        --feature_subset not-dep \
        --seed 42 \
        --save_features_together


    python -u probing_experiment.py \
        --experiment_name test_full_feature_selection_comparison \
        --experiment_type optimal_sparse_probing \
        --model "$model" \
        --feature_dataset latex.pyth.1024.-1 \
        --normalize_activations \
        --seed 42 \
        --save_features_together
done