git clone https://github.com/ISCDtoolbox/Medit.git
cd Medit
mkdir build
cd build
cmake ..
make
make install
echo "the medit were installed under ~/bin directory, please conseider adding the path to your .bashrc file with :"
echo "export PATH=$PATH:~/bin"
