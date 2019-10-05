#!/usr/bin/sh
echo "INTALLING FENICS ON MANJARO 18-GNOME BY : SA.ZARRINPOUR@IASBS.AC.IR"
#Creating and Entering to the installation root
mkdir fenics_build
cd fenics_build
_INSTALLATION_ROOT_=$(pwd)
echo "--> Installing fenics Under ${_INSTALLATION_ROOT}"
#begin of instruction from : https://fenics.readthedocs.io/en/latest/installation.html

#I had made little changes to get things work on my manjaro 18, Gnome


PYBIND11_VERSION=2.2.3
echo "-> PYBIND11 version is set to 2.2.3..."
echo "-> Downloading pybind11..."
wget -nc --quiet https://github.com/pybind/pybind11/archive/v${PYBIND11_VERSION}.tar.gz
echo "-> Installing pybind11..."
tar -xf v${PYBIND11_VERSION}.tar.gz && cd pybind11-${PYBIND11_VERSION}

mkdir build && cd build && cmake -DPYBIND11_TEST=off .. && sudo make install
echo "-> Installing fenics-ffc..."
python3 -m pip install fenics-ffc --upgrade
FENICS_VERSION=$(python3 -c"import ffc; print(ffc.__version__)")
echo "-> Cloning the branch  ${FENICS_VERSION} of dolfin..."
git clone --branch=$FENICS_VERSION https://bitbucket.org/fenics-project/dolfin
echo "-> Cloning mshr..."
git clone  https://bitbucket.org/fenics-project/mshr
echo "-> Installing dolphin..."
mkdir dolfin/build && cd dolfin/build && cmake .. && sudo make install && cd ../..
echo "-> Setting up environement..."
#sourcing the dolphin configuration :
source /usr/local/share/dolfin/dolfin.conf
echo "*** it is worth to note that I had already added library path to the LD variable",
echo "*** so I donno wether it will be auto matically added for you or not,"
echo "*** to make sure, you can add this line at the end of your ~/.bashrc file :"

#things to add in ~/.bashrc
#I prefered to leave it upon you to add it manually ;)

echo "##setting shared library path"
echo "export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib"
echo "##setting dolfin configurations"
echo "source /usr/local/share/dolfin/dolfin.conf"
echo "-> Installing mshr..."
mkdir mshr/build   && cd mshr/build   && cmake .. && sudo make install && cd ../..
echo "-> Installing python-dolphin..."
cd dolfin/python && sudo python3 -m pip install . && cd ../..
echo "->Installing python-mshr..."
cd mshr/python   && sudo python3 -m pip install . && cd ../..
echo "---> all works had been finished."
