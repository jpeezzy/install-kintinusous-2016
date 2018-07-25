#!/bin/bash
#This script will help build kintinuous on 16.04
#First, install cuda 8.0
wget http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/cuda-repo-ubuntu1604_8.0.61-1_amd64.deb
sudo dpkg -i cuda-repo-ubuntu1604_8.0.61-1_amd64.deb
rm cuda-repo-ubuntu1604_8.0.61-1_amd64.deb
sudo apt-get update
sudo apt-get install cuda-8-0

#dependencies 
sudo apt-get install -y cmake-qt-gui git build-essential libusb-1.0-0-dev libudev-dev freeglut3-dev python-vtk libvtk-java libglew-dev  libsuitesparse-dev openexr

#installing openjdk-7-jdk
sudo add-apt-repository ppa:openjdk-r/ppa  
sudo apt-get update   
sudo apt-get install openjdk-7-jdk  

#pcl
sudo apt-get install g++ cmake cmake-gui doxygen mpi-default-dev openmpi-bin openmpi-common libflann-dev libeigen3-dev libboost-all-dev libvtk5-qt4-dev libvtk6.2 libvtk5-dev libqhull* libusb-dev libgtest-dev git-core freeglut3-dev pkg-config build-essential libxmu-dev libxi-dev libusb-1.0-0-dev graphviz mono-complete qt-sdk openjdk-7-jdk openjdk-7-jre
git clone https://github.com/PointCloudLibrary/pcl.git
cd pcl
mkdir build
cd build
cmake -DCMAKE_BUILD_TYPE=Release -DBUILD_GPU=OFF -DBUILD_apps=OFF -DBUILD_examples=OFF ..
make -j
sudo make install
sudo ldconfig
cd ../../
#install openni2
sudo apt install libopenni2-dev

#install kinnect
git clone https://github.com/OpenKinect/libfreenect
cd libfreenect
mkdir build
cd build
cmake .. # -L lists all the project options
make
sudo make install
#copy lib files and link them to openni2
sudo ln -s lib/OpenNI2-FreenectDriver/libFreenectDriver.so /usr/local/lib/OpenNI2-FreenectDriver/libFreenectDriver.so
cd ../../

#install ffmpeg
git clone git://source.ffmpeg.org/ffmpeg.git
cd ffmpeg/
git reset --hard cee7acfcfc1bc806044ff35ff7ec7b64528f99b1
./configure --enable-shared
make -j
sudo make install
sudo ldconfig
cd ../

#Installing opencv
wget http://sourceforge.net/projects/opencvlibrary/files/opencv-unix/2.4.9/opencv-2.4.9.zip
unzip opencv-2.4.9.zip
rm opencv-2.4.9.zip
cd opencv-2.4.9
mkdir build
cd build
cmake -D BUILD_NEW_PYTHON_SUPPORT=OFF -D WITH_OPENCL=OFF -D WITH_OPENMP=ON -D INSTALL_C_EXAMPLES=OFF -D BUILD_DOCS=OFF -D BUILD_EXAMPLES=OFF -D WITH_QT=OFF -D WITH_OPENGL=OFF -D WITH_VTK=OFF -D BUILD_PERF_TESTS=OFF -D BUILD_TESTS=OFF -D WITH_CUDA=OFF -D BUILD_opencv_gpu=OFF ..
make -j
sudo make install
echo "/usr/local/lib" | sudo tee -a /etc/ld.so.conf.d/opencv.conf
sudo ldconfig
echo "PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/usr/local/lib/pkgconfig" | sudo tee -a /etc/bash.bashrc
echo "export PKG_CONFIG_PATH" | sudo tee -a /etc/bash.bashrc
source /etc/bash.bashrc
cd ../../

#DLIB
git clone https://github.com/dorian3d/DLib.git
cd DLib
git reset --hard 330bdc10576f6bcb55e0bd85cd5296f39ba8811a
mkdir build
cd build
cmake ../
make -j
sudo make install
cd ../..

#DBoW2 for place recognition
git clone https://github.com/dorian3d/DBoW2.git
cd DBoW2
git reset --hard 4a6eed2b3ae35ed6837c8ba226b55b30faaf419d
mkdir build
cd build
cmake ../
make -j
sudo make install
cd ../..

#DLoopDetector for place recognition
git clone https://github.com/dorian3d/DLoopDetector.git
cd DLoopDetector
git reset --hard 84bfc56320371bed97cab8aad3aa9561ca931d3f
mkdir build
cd build
cmake ../
make -j
sudo make install
cd ../..


#iSAM for pose graph optimisation
wget http://people.csail.mit.edu/kaess/isam/isam_v1_7.tgz
tar -xvf isam_v1_7.tgz
rm isam_v1_7.tgz
cd isam_v1_7
mkdir build
cd build
cmake ..
make -j
sudo make install
cd ../..

git clone https://github.com/mp3guy/Kintinuous.git
cd Kintinuous
cd src
mkdir build
cd build
cmake ..
make

