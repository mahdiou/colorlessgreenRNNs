cd src/


echo "==== Generating train/test/valid sets and vocabulary for english ===="
python data/data_vocab_prep.py --input ../data/corpora/english.txt --output_dir ../data/lm/en_parlement --vocab 10000

echo "==== Generating train/test/valid sets and vocabulary for french ===="
python data/data_vocab_prep.py --input ../data/corpora/francais.txt --output_dir ../data/lm/fr_parlement --vocab 10000


params_dir='../data/model_params'
en_models_dir='../data/models/en_parlement'
fr_models_dir='../data/models/fr_parlement'
logs_dir='../data/logs'

echo "=================================================="
echo "==== Training LSTM on English data ===="
echo "=================================================="

exec < $params_dir/lstm_params.csv || exit 1
read header
while IFS=, read model nhid batch_size dropout lr epochs ; do
    model_name="${model}_hidden${nhid}_batch${batch_size}_dropout${dropout}_lr${lr}"
    echo $model_name
    echo "----------------------------------------------------------"

    python language_models/main.py --data ../data/lm/en_parlement \
     --model $model --emsize $nhid --nhid $nhid --dropout $dropout \
     --lr $lr --epochs $epochs \
     --model $en_models_dir/${model_name}.pt \
     --log $logs_dir/${model_name}.txt \
     --cuda
done


echo "=================================================="
echo "==== Training LSTM on French data ===="
echo "=================================================="

exec < $params_dir/lstm_params.csv || exit 1
read header
while IFS=, read model nhid batch_size dropout lr epochs ; do
    model_name="${model}_hidden${nhid}_batch${batch_size}_dropout${dropout}_lr${lr}"
    echo $model_name
    echo "----------------------------------------------------------"
    
    python language_models/main.py --data ../data/lm/fr_parlement \
     --model $model --emsize $nhid --nhid $nhid --dropout $dropout \
     --lr $lr --epochs $epochs \
     --model $fr_models_dir/${model_name}.pt \
     --log $logs_dir/${model_name}.txt \
     --cuda
done




echo "=================================================="
echo "==== Training sequential RNNs on English data ===="
echo "=================================================="

exec < $params_dir/sRNN_params.csv || exit 1
read header
while IFS=, read model nhid batch_size dropout lr epochs ; do
    model_name="${model}_hidden${nhid}_batch${batch_size}_dropout${dropout}_lr${lr}"
    echo $model_name
    echo "----------------------------------------------------------"
    
    python language_models/main.py --data ../data/lm/en_parlement \
     --model $model --emsize $nhid --nhid $nhid --dropout $dropout \
     --lr $lr --epochs $epochs \
     --model $en_models_dir/${model_name}.pt \
     --log $logs_dir/${model_name}.txt \
     --cuda
done


echo "=================================================="
echo "==== Training sequential RNNs on French data ===="
echo "=================================================="

exec < $params_dir/sRNN_params.csv || exit 1
read header
while IFS=, read model nhid batch_size dropout lr epochs ; do
    model_name="${model}_hidden${nhid}_batch${batch_size}_dropout${dropout}_lr${lr}"
    echo $model_name
    echo "----------------------------------------------------------"
    
    python language_models/main.py --data ../data/lm/fr_parlement \
     --model $model --emsize $nhid --nhid $nhid --dropout $dropout \
     --lr $lr --epochs $epochs \
     --model $fr_models_dir/${model_name}.pt \
     --log $logs_dir/${model_name}.txt \
     --cuda
done




echo "=================================================="
echo "==== Training 5-gram LSTMs on English data ===="
echo "=================================================="

exec < $params_dir/ngram_lstm_params.csv || exit 1
read header
while IFS=, read model nhid batch_size dropout lr epochs ; do
    model_name="${model}_hidden${nhid}_batch${batch_size}_dropout${dropout}_lr${lr}"
    echo $model_name
    echo "----------------------------------------------------------"
    
    python language_models/ngram_lstm.py --data ../data/lm/en_parlement \
     --model $model --emsize $nhid --nhid $nhid --dropout $dropout \
     --lr $lr --epochs $epochs \
     --model $en_models_dir/${model_name}.pt \
     --log $logs_dir/${model_name}.txt \
     --cuda
     --train
done


echo "=================================================="
echo "==== Training 5-gram LSTMs on French data ===="
echo "=================================================="

exec < $params_dir/ngram_lstm_params.csv || exit 1
read header
while IFS=, read model nhid batch_size dropout lr epochs ; do
    model_name="${model}_hidden${nhid}_batch${batch_size}_dropout${dropout}_lr${lr}"
    echo $model_name
    echo "----------------------------------------------------------"
    
    python language_models/ngram_lstm.py --data ../data/lm/fr_parlement \
     --model $model --emsize $nhid --nhid $nhid --dropout $dropout \
     --lr $lr --epochs $epochs \
     --model $fr_models_dir/${model_name}.pt \
     --log $logs_dir/${model_name}.txt \
     --cuda
done