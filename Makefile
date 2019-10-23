CMD	= sdc
FC	= gfortran
SRCS	= $(CMD).f \
	  trimlen.f freeunit.f \
	  dist.f   redist.f setorg.f		
OBJS	= $(SRCS:%.f=%.o) 

FFLAGS  = -O -ffixed-line-length-none -ffloat-store -W  -fbounds-check -m64 -mcmodel=medium

LDFLAGS        = -O -m64 

all: $(CMD)

$(CMD): $(OBJS)
	$(FC) $(LDFLAGS) $(OBJS) $(LIBS) -o $@

%.o: %.f
	$(FC) $(FFLAGS) -c $(@F:.o=.f) -o $@
clean:
	-rm -f $(CMD) *.o core a.out *.fln junk
