# The compiler
FC = gfortran
# flags for debugging or for maximum performance, comment as necessary
FCFLAGS = -g -fbounds-check
# flags forall (e.g. look for system .mod files, required in gfortran)
FCFLAGS += -I/usr/include
DIR = 

PROGRAMS = cfd

cfd: diff.o parameters.o utils.o save.o actuator.o boundary.o
diff.o: parameters.o
save.o: parameters.o
actuator.o: parameters.o
boundary.o: parameters.o

# ======================================================================
# And now the general rules, these should not require modification
# ======================================================================

# General rule for building prog from prog.o; $^ (GNU extension) is
# used in order to list additional object files on which the
# executable depends
%: %.o
	$(FC) $(FCFLAGS) -o $@ $(DIR)$^ $(LDFLAGS)

# General rules for building prog.o from prog.f90 or prog.F90; $< is
# used in order to list only the first prerequisite (the source file)
# and not the additional prerequisites such as module or include files
%.o: %.f90
	$(FC) $(FCFLAGS) -c $(DIR)$<

%.o: %.F90
	$(FC) $(FCFLAGS) -c $(DIR)$<
%.o: %.F
	$(FC) $(FCFLAGS) -c $(DIR)$<

# Utility targets
.PHONY: clean veryclean

clean:
	rm -f *.o *.mod *.MOD main test output*.txt

testall: test
	mpirun -np 3 test
