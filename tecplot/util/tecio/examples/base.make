# Set to appropriate C++ compiler
           CPP=g++
      TECIOLIB=../../../../lib/libtecio.a

# Set to appropriate Fortran compiler
            FC=gfortran
        FFLAGS=-fcray-pointer -lstdc++

   EXTRAINCLUDES=-I../../../../include
#
# (If not needed reset to empty in actual Makefile)
# link libraries
      LINKLIBS=-lpthread

   PATHTOEXECUTABLE=.

all: $(TARGETS)

clean:
	rm -f $(PATHTOEXECUTABLE)/$(EXECUTABLE)

f90build:
	$(FC) $(F90FILES) $(FFLAGS) $(EXTRAINCLUDES) $(TECIOLIB) -o $(PATHTOEXECUTABLE)/$(EXECUTABLE)-f90 $(LINKLIBS)
