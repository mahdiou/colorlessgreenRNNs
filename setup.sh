# installs python3.5 with the required libraries

usage(){
    echo "Usage: $0 path/to/create/env"
    exit 1
}

start_dir=`pwd`

envpath=$1
requirements=./requirements.txt

[[ -z "$envpath" ]] && usage

echo "adding apt repository"
add-apt-repository ppa:deadsnakes/ppa

echo "updating"
apt update
# sudo apt upgrade

echo "installing python 3.5"
apt install python3.5

echo "checking that virtualenv is installed"
pip3 freeze | grep virtualenv || {
    echo "virtualenv not installed. installing virtualenv"
    pip3 install virtualenv
}

echo "creating virtual environment"
old_dir=`pwd`
cd $envpath && virtualenv --python=$(which python3.5) env
source env/bin/activate

cd $old_dir

echo "installing required packages"
pip install -r $requirements