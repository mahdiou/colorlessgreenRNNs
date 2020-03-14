cd src/
data_dir="../data"
echo "==== Generating train/test/valid sets and vocabulary for english ===="
python data/data_vocab_prep.py --input $data_dir/corpora/anglais.txt --output_dir $data_dir/lm/en_parlement --vocab 50000

echo "==== Generating train/test/valid sets and vocabulary for french ===="
python data/data_vocab_prep.py --input $data_dir/corpora/francais.txt --output_dir $data_dir/lm/fr_parlement --vocab 50000


params_dir="$data_dir/model_params"
en_models_dir="$data_dir/models/en_parlement"
fr_models_dir="$data_dir/models/fr_parlement"
logs_dir="$data_dir/logs"

echo "=================================================="
echo "==== Training LSTM on English data ===="
echo "=================================================="

exec < $params_dir/lstm_params.csv || exit 1
read header
while IFS=, read model nhid batch_size dropout lr epochs ; do
    model_name="${model}_hidden${nhid}_batch${batch_size}_dropout${dropout}_lr${lr}"
    echo $model_name
    echo "----------------------------------------------------------"

    python language_models/main.py --data $data_dir/lm/en_parlement \
     --model $model --emsize $nhid --nhid $nhid --dropout $dropout \
     --lr $lr --epochs $epochs \
     --model $en_models_dir/${model_name}.pt \
     --log $logs_dir/${model_name}.txt \
     --cuda

     exit 1
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
    
    python language_models/main.py --data $data_dir/lm/fr_parlement \
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
    
    python language_models/main.py --data $data_dir/lm/en_parlement \
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
    
    python language_models/main.py --data $data_dir/lm/fr_parlement \
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
    
    python language_models/ngram_lstm.py --data $data_dir/lm/en_parlement \
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
    
    python language_models/ngram_lstm.py --data $data_dir/lm/fr_parlement \
     --model $model --emsize $nhid --nhid $nhid --dropout $dropout \
     --lr $lr --epochs $epochs \
     --model $fr_models_dir/${model_name}.pt \
     --log $logs_dir/${model_name}.txt \
     --cuda
done