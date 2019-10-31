#installing FLEX PART
#install openpnglibrary:

#we save the installation start point in a variable so we can change directory to it later:

installation_home=$PWD

echo "-> creating Directories ..."

sudo mkdir /home/lib
sudo mkdir /home/lib/FLEXPART
sudo mkdir /home/lib/JASPER
sudo mkdir /home/lib/GRIB

sudo chmod 777 -R /home/lib

echo "-> creating subdirectories ..."

mkdir /home/lib/JASPER/setup
mkdir /home/lib/JASPER/build
mkdir /home/lib/JASPER/INSTALL_DIR

mkdir /home/lib/GRIB/setup
mkdir /home/lib/GRIB/build
mkdir /home/lib/GRIB/INSTALL_DIR

mkdir /home/lib/FLEXPART/setup
mkdir /home/lib/FLEXPART/build
mkdir /home/lib/FLEXPART/INSTALL_DIR

echo "-> installing dependencies ..."

echo
echo "-> installing python-pip..."

sudo apt-get install python-pip -y

echo "-> installing building essentials : cmake ..."
echo

sudo apt-get install cmake -y

echo "-> installing libpng-dev (openpng library) ..."
echo

sudo apt-get install libpng-dev -y

echo "-> installing gfortran compiler ..."
echo

sudo apt-get install gfortran -y

echo "-> Installing jasper ..."
cp jasper-1.900.1.zip /home/lib/JASPER/setup/
cd /home/lib/JASPER/setup
unzip jasper-1.900.1.zip 
cd jasper-1.900.1/

export CFLAGS="-fPIC"

./configure --prefix=/home/lib/JASPER/INSTALL_DIR/ 

make
make check
make install

unset CFLAGS

# "back to installation root"

cd $installation_home

echo
echo "-> installing GRIB Dependencies : netcdf 4 & 5"

mkdir /home/lib/GRIB/DEPENDENCY
mkdir /home/lib/GRIB/DEPENDENCY/netcdf
cp ./install_netcdf4.sh /home/lib/GRIB/DEPENDENCY/netcdf
cd /home/lib/GRIB/DEPENDENCY/netcdf

sudo chmod u+x install_netcdf4.sh
bash ./install_netcdf4.sh

#rm ./install_netcdf4.sh

# "back to installation root"

cd $installation_home

echo
echo "-> installing open jpeg library ..."

mkdir /home/lib/GRIB/DEPENDENCY/openjpg

cp openjpeg-master.zip /home/lib/GRIB/DEPENDENCY/openjpg/
cd /home/lib/GRIB/DEPENDENCY/openjpg/

unzip openjpeg-master.zip

cd openjpeg-master/


mkdir build
cd build
cmake .. -DCMAKE_BUILD_TYPE=Release
make
sudo make install
make clean



# "back to installation root"
cd $installation_home 

echo
echo "-> installing GRIB ..."

cp grib_api-1.9.18.tar /home/lib/GRIB/setup/
cd /home/lib/GRIB/setup
tar -xvf grib_api-1.9.18.tar
cd grib_api-1.9.18/

./configure --prefix=/home/lib/GRIB/INSTALL_DIR/ --with-jasper=/home/lib/JASPER/INSTALL_DIR


#uncomment this line if you get an bad value error with make.
#./configure --prefix=/home/lib/GRIB/INSTALL_DIR/ --with-jasper=/home/lib/JASPER/INSTALL_DIR --disable-shared

make
make check
make install

sudo apt-get install libgrib-api-dev

echo "> done!"
# "back to installation root"
cd $installation_home

echo "-> setting up PATH's in ~/.bashrc... "
echo "export GRIB_API_BIN=\"/home/lib/GRIB/INSTALL_DIR/bin\"" >> ~/.bashrc
echo "export GRIB_API_LIB=\"/home/lib/GRIB/INSTALL_DIR/lib\"" >> ~/.bashrc
echo "export GRIB_API_INCLUDE=\"/home/lib/GRIB/INSTALL_DIR/include\"" >> ~/.bashrc
echo "export PATH=$GRIB_API_BIN:$GRIB_API_LIB:$GRIB_API_INCLUDE:$PATH"

#then source it with:
source ~/.bashrc

echo "-> done!"

echo
echo "-> installing emos library ..."

cd $installation_home
mkdir /home/lib/emos
cp emos_000392.tar.gz /home/lib/emos
cd /home/lib/emos
tar -xvf emos_000392.tar.gz
cd emos_000392/

./build_library
./install

cd $installation_home
echo "-> done!"

echo
echo "->installing FLEXPART..."

cp FLEXPART_90.02.tar.gz /home/lib/FLEXPART/
cd /home/lib/FLEXPART/
tar -xvf FLEXPART_90.02.tar.gz

#cp makefile.gfs_gfortran_64 makefile #or other makefiles as you need

#edit makefile now and edit these lines (7-9) as follows
#INCPATH  = /home/lib/GRIB/INSTALL_DIR/include
#LIBPATH1 = /home/lib/GRIB/INSTALL_DIR/lib
#LIBPATH2 = /home/lib/JASPER/INSTALL_DIR/lib

#cp $installation_home/makefile.gfs_gfortran ./makefile
cp $installation_home/makefile ./makefile
#now Adjust file includepar in the FLEXPART directory to your local computing capacities and your needs (if the values of the following parameters are choosen too high, compiling via make will fail)



 #parameter(nxmax=721,nymax=361,nuvzmax=92,nwzmax=92,nzmax=92) (input: ECMWF windfields with resolution 0.5°)
 #parameter(nxmax=361,nymax=181,nuvzmax=92,nwzmax=92,nzmax=92) (input: ECMWF windfields with resolution 1.0°)
 #parameter(maxpart=22000000) (Change to: 1000000 (or 500000 / according to your computer specifications))
 #parameter(maxspec=60) (Number of species. Change to 1 oder 2 (according to your computer specifications and your scientific problem)))

make -f makefile
#if you had this error when compiling erf.f90:
#Return type mismatch of function ‘gammln’ at (1) (REAL(4)/REAL(8))
#go to this page : https://www.flexpart.eu/ticket/49
make clean
make

#to run the fucking shit type:

#./FLEXPART_GFORTRAN

#or better add this line at the end of you bashrc file and then source it
echo
echo "-> adding shortcut to ~/.bashrc"
echo "-> alias flexpart='/home/lib/FLEXPART/FLEXPART_GFORTRAN'" >> ~/.bashrc
echo
echo
echo "--> congradulations!"
echo "--> installation compeleted!"
echo
echo
echo "--> to run this program you can say : flexpart <inputs>"
echo 
echo
echo "--> written by sajed zarrin pour, samim56b@gmail.com"























