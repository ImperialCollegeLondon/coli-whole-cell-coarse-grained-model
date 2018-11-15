
clang++ -pipe -stdlib=libc++ -O2 -std=gnu++11 -Wall -W -fPIC -o build/simparams.o -c source/simparams.cpp
clang++ -pipe -stdlib=libc++ -O2 -std=gnu++11 -Wall -W -fPIC -o build/CellState.o -c source/CellState.cpp
clang++ -pipe -stdlib=libc++ -O2 -std=gnu++11 -Wall -W -fPIC -o build/StochSimulator.o -c source/StochSimulator.cpp
clang++ -pipe -stdlib=libc++ -O2 -std=gnu++11 -Wall -W -fPIC -o build/ModelParameters.o -c source/ModelParameters.cpp
clang++ -pipe -stdlib=libc++ -O2 -std=gnu++11 -Wall -W -fPIC -o build/main.o -c source/main.cpp
clang++ -pipe -stdlib=libc++ -O2 -std=gnu++11 -Wall -W -fPIC -o build/common.o -c source/libs/common.cpp
clang++ -pipe -stdlib=libc++ -O2 -std=gnu++11 -Wall -W -fPIC -o build/ludcmp.o -c source/libs/ludcmp.cpp
clang++ -pipe -stdlib=libc++ -O2 -std=gnu++11 -Wall -W -fPIC -o build/sparse.o -c source/libs/sparse.cpp
clang++ -pipe -stdlib=libc++ -O2 -std=gnu++11 -Wall -W -fPIC -o build/stepperdopr853.o -c source/libs/stepperdopr853.cpp

clang++ -pipe -stdlib=libc++ -O2 -std=gnu++11 -Wall -W -fPIC -o build/simulator build/main.o build/simparams.o build/CellState.o  build/StochSimulator.o build/ModelParameters.o build/common.o build/ludcmp.o build/sparse.o build/stepperdopr853.o
