cd src/

echo "==== Creating test set for English ===="
./create_testset.sh en

echo "==== Creating test set for French ===="
./create_testset.sh fr

en_model="$1"
fr_model="$2"

[[ -z "$en_model" || -z "$fr_model" ]] && { 
    echo "Usage '$0 <en_model_name> <fr_model_name>'"
    exit 1
}

echo "==== evaluating English model ===="

python language_models/evaluate_target_word.py --data ../data/lm/en_parlement/ --checkpoint ../data/models/en_parlement/$en_model --path ../data/agreement/en_parlement/generated --suffix $en_model --cuda

python results.py en_parlement $en_model


echo "==== evaluating French model ===="

python language_models/evaluate_target_word.py --data ../data/lm/fr_parlement/ --checkpoint ../data/models/fr_parlement/$fr_model --path ../data/agreement/fr_parlement/generated --suffix $fr_model --cuda

python results.py fr_parlement $fr_model