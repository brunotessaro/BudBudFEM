FFLAGS= -g -O0  -fbacktrace  -fbounds-check -ffpe-trap=zero -fcray-pointer
TARGET = NavierStokes_Liad2019
MODULES = bin/MODULES.o
TECIOLIB= tecplot/lib/libtecio.a
OBJECTS =   $(MODULES) \
			bin/IOMNGR.o  \
			bin/CONTRL.o  \
			bin/ALLOCATIONS.o \
			bin/MEMORY.o \
			bin/INELEM.o \
			bin/INMESH.o \
			bin/JOINTS.o \
			bin/MATSET.o \
			bin/profil.o \
			bin/aponta.o \
			bin/grafos.o \
			bin/sort.o \
			bin/genrcm.o \
			bin/splot.o \
			bin/matrixtrans2.o \
			bin/fnroot.o \
			bin/rcm.o \
			bin/rootls.o \
			bin/degree.o \
			bin/LOADS.o \
			bin/RHSV_READ.o \
			bin/RHSV_MAKE.o \
			bin/RHSV_LOAD.o \
			bin/NavierStokes3D_Solver.o \
			bin/OCTA8_NAVIER_STOKES_3D_CONVEC.o \
			bin/OCTA8_NAVIER_STOKES_3D_DIFUS.o \
			bin/OCTA8_NAVIER_STOKES_3D_MASSA.o \
			bin/OCTA8_PRESSURE.o \
			bin/CFLcalc.o \
			bin/SOLVER.o \
			bin/getNALHS.o \
			bin/CROUTFACT.o \
			bin/oneStepLinearImplicit.o \
			bin/matvec.o \
			bin/local.o \
			bin/ddot.o \
			bin/addmatvec.o \
			bin/FUNC.o \
			bin/OUTENSIGHT.o \
			bin/OUTTECPLT.o \
			tecplot/include/TECIO.h
			
EXTRAINCLUDES=-I tecplot/include
LINKLIBS=-lpthread

makefile:
all: bin/$(TARGET)

clean:
	-rm bin/*.o bin/*.mod bin/$(TARGET)  #$(OBJECTS)
	
#NavierStokes_Liad2019 : 
#	gfortran src/NavierStokes_Liad2019.f90 -o NavierStokes_Liad2019.exe
	
bin/$(TARGET) : $(OBJECTS)
	gfortran $(FFLAGS) src/$(TARGET).f90 $(OBJECTS) -I bin $(EXTRAINCLUDES) $(TECIOLIB) -o bin/$(TARGET)  $(LINKLIBS)  -lstdc++ 

bin/ALLOCATIONS.o : $(MODULES) bin/MEMORY.o
	gfortran $(FFLAGS) -c src/ALLOCATIONS/ALLOCATIONS.f90 -I bin -o bin/ALLOCATIONS.o
	
bin/CONTRL.o : $(MODULES)
	gfortran $(FFLAGS) -c src/CONTRL/CONTRL.f90 -I bin -o bin/CONTRL.o
	
bin/IOMNGR.o : $(MODULES)
	gfortran $(FFLAGS) -c src/IOMNGR/IOMNGR.f90 -I bin -o bin/IOMNGR.o
			
bin/INMESH.o : $(MODULES)
	gfortran $(FFLAGS) -c src/INPUTMESH/INMESH.f90 -I bin -o bin/INMESH.o
	
bin/INELEM.o : $(MODULES)
	gfortran $(FFLAGS) -c src/INPUTMESH/INELEM.f90 -I bin -o bin/INELEM.o
	
bin/JOINTS.o : $(MODULES)
	gfortran $(FFLAGS) -c src/INPUTMESH/JOINTS.f90 -I bin -o bin/JOINTS.o
	
bin/MATSET.o : $(MODULES)
	gfortran $(FFLAGS) -c src/INPUTMESH/MATSET.f90 -I bin -o bin/MATSET.o
	
bin/LOADS.o : $(MODULES)
	gfortran $(FFLAGS) -c src/LOADS/LOADS.f90 -I bin -o bin/LOADS.o
	
bin/oneStepLinearImplicit.o : $(MODULES)
	gfortran $(FFLAGS) -c src/SOLVER/oneStepLinearImplicit.f90 -I bin -o bin/oneStepLinearImplicit.o
bin/getNALHS.o :
	gfortran $(FFLAGS) -c src/CROUTFACT/getNALHS.f90 -I bin -o bin/getNALHS.o
bin/CROUTFACT.o :
	gfortran $(FFLAGS) -c src/CROUTFACT/CROUTFACT.f90 -I bin -o bin/CROUTFACT.o
	
bin/CFLcalc.o  :
	gfortran $(FFLAGS) -c src/SOLVER/CFLcalc.f90 -I bin -o bin/CFLcalc.o
	
	
bin/matvec.o : bin/local.o
	gfortran $(FFLAGS) -c src/UTILITIES/matvec.f90 -I bin -o bin/matvec.o
bin/local.o :
	gfortran $(FFLAGS) -c src/UTILITIES/local.f90 -I bin -o bin/local.o
bin/ddot.o :
	gfortran $(FFLAGS) -c src/UTILITIES/ddot.f90 -I bin -o bin/ddot.o
bin/addmatvec.o :
	gfortran $(FFLAGS) -c src/UTILITIES/addmatvec.f90 -I bin -o bin/addmatvec.o
bin/FUNC.o :
	gfortran $(FFLAGS) -c src/UTILITIES/FUNC.f90 -I bin -o bin/FUNC.o
bin/OUTENSIGHT.o :
	gfortran $(FFLAGS) -c src/OUTPUT/OUTENSIGHT.f90 -I bin -o bin/OUTENSIGHT.o
bin/OUTTECPLT.o :
	gfortran $(FFLAGS) -c src/OUTPUT/OUTTECPLT.f90  $(FFLAGS) -I bin $(EXTRAINCLUDES) $(TECIOLIB) -o bin/OUTTECPLT.o $(LINKLIBS)  -lstdc++ 
	
bin/MODULES.o :
	gfortran $(FFLAGS) -c src/MODULES/MODULES.f90 -J bin -o bin/MODULES.o
	
bin/MEMORY.o :
	gfortran $(FFLAGS) -c src/UTILITIES/MEMORY.f90 -I bin -o bin/MEMORY.o
	
bin/SOLVER.o : $(MODULES) bin/NavierStokes3D_Solver.o
	gfortran $(FFLAGS) -c src/SOLVER/SOLVER.f90 -I bin -o bin/SOLVER.o

bin/NavierStokes3D_Solver.o : $(MODULES) bin/getNALHS.o
	gfortran $(FFLAGS) -c src/SOLVER/NavierStokes3D_Solver.f90 -I bin -o bin/NavierStokes3D_Solver.o

bin/OCTA8_NAVIER_STOKES_3D_CONVEC.o :
	gfortran $(FFLAGS) -c src/SOLVER/OCTA8/OCTA8_NAVIER_STOKES_3D_CONVEC.f90 -I bin -o bin/OCTA8_NAVIER_STOKES_3D_CONVEC.o
bin/OCTA8_NAVIER_STOKES_3D_DIFUS.o : 
	gfortran $(FFLAGS) -c src/SOLVER/OCTA8/OCTA8_NAVIER_STOKES_3D_DIFUS.f90 -I bin -o bin/OCTA8_NAVIER_STOKES_3D_DIFUS.o
bin/OCTA8_NAVIER_STOKES_3D_MASSA.o :
	gfortran $(FFLAGS) -c src/SOLVER/OCTA8/OCTA8_NAVIER_STOKES_3D_MASSA.f90 -I bin -o bin/OCTA8_NAVIER_STOKES_3D_MASSA.o
bin/OCTA8_PRESSURE.o : $(MODULES)
	gfortran $(FFLAGS) -c src/SOLVER/OCTA8/OCTA8_PRESSURE.f90 -I bin -o bin/OCTA8_PRESSURE.o
	
bin/matrixtrans2.o : 
	gfortran $(FFLAGS) -c src/INPUTMESH/CuthillMckee/matrixtrans2.f90 -I bin -o bin/matrixtrans2.o
bin/profil.o : 
	gfortran $(FFLAGS) -c src/INPUTMESH/CuthillMckee/profil.f90 -I bin -o bin/profil.o
bin/aponta.o : 
	gfortran $(FFLAGS) -c src/INPUTMESH/CuthillMckee/aponta.f90 -I bin -o bin/aponta.o
bin/grafos.o : 
	gfortran $(FFLAGS) -c src/INPUTMESH/CuthillMckee/grafos.f90 -I bin -o bin/grafos.o
bin/sort.o : 
	gfortran $(FFLAGS) -c src/INPUTMESH/CuthillMckee/sort.f90 -I bin -o bin/sort.o
bin/genrcm.o : bin/rcm.o bin/fnroot.o
	gfortran $(FFLAGS) -c src/INPUTMESH/CuthillMckee/genrcm.f90 -I bin -o bin/genrcm.o	
bin/splot.o : 
	gfortran $(FFLAGS) -c src/INPUTMESH/CuthillMckee/splot.f90 -I bin -o bin/splot.o
bin/fnroot.o : bin/rootls.o
	gfortran $(FFLAGS) -c src/INPUTMESH/CuthillMckee/fnroot.f90 -I bin -o bin/fnroot.o
bin/rcm.o : bin/degree.o
	gfortran $(FFLAGS) -c src/INPUTMESH/CuthillMckee/rcm.f90 -I bin -o bin/rcm.o
bin/rootls.o : 
	gfortran $(FFLAGS) -c src/INPUTMESH/CuthillMckee/rootls.f90 -I bin -o bin/rootls.o
bin/degree.o : 
	gfortran $(FFLAGS) -c src/INPUTMESH/CuthillMckee/degree.f90 -I bin -o bin/degree.o
	
bin/RHSV_READ.o : 
	gfortran $(FFLAGS) -c src/LOADS/RHSV_READ.f90 -I bin -o bin/RHSV_READ.o
bin/RHSV_MAKE.o : 
	gfortran $(FFLAGS) -c src/LOADS/RHSV_MAKE.f90 -I bin -o bin/RHSV_MAKE.o
bin/RHSV_LOAD.o : 
	gfortran $(FFLAGS) -c src/LOADS/RHSV_LOAD.f90 -I bin -o bin/RHSV_LOAD.o