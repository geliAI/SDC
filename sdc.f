c Convert coordinates of a geographical point by short distance conversion (SDC)

c	subroutine sdc2(x, y, xlat, xlon, i)     ! 22.Okt. 1990

        implicit none

c	Parameters:

        logical ex
        character       fn_inp*80
	character	fn_out*80
	integer		fu_out
        integer		fu_inp
        integer         i               !  1: (x, y) -> (xlat, xlon)
                                        ! -1: (xlat, xlon) -> (x, y)
        integer io_stat,index
        integer 	l
        real lat_Orig,lon_Orig,dep_Orig
        character 	line*80
        integer		narguments
        real		rota
        integer		trimlen
        real		x(5000), y(5000)
        doubleprecision xlat(5000), xlon(5000)

        include "geocoord.inc"

c--- get input parameter file name:
        narguments = iargc()
        if(narguments.lt.1) then
           write(*,*)'SHORT DISTANCE CONVERSION FROM TOMODD!'
           write(*,'(/,a)') 'INPUT FILE [sdc.inp <ret>]:'
           read(5,'(a)') fn_inp
           if(trimlen(fn_inp).le.1) then
              fn_inp= 'sdc.inp' !default input file name
           else
              fn_inp= fn_inp(1:trimlen(fn_inp))
           endif
        else
           call getarg(1,fn_inp)
        endif
        inquire(FILE= fn_inp,exist=ex)
        if(.not. ex) stop' >>> ERROR OPENING INPUT PARAMETER FILE.'

c--  get input file data:
        call freeunit(fu_inp)
        open(unit=fu_inp,status='old',file=fn_inp,err=997,iostat=io_stat)

        l = 1

c--  Loop to read input file:
210     read (fu_inp,'(a)',end=303) line
        if (line(1:1).eq.'*' .or. line(2:2).eq.'*') goto 210
        if (l.eq.1) then
        read (line,*,err=999) lat_Orig,lon_Orig,dep_Orig,i,rota
        end if

        if (l.gt.1) then
          if (i.eq.-1) then
           read (line,*,err=999) xlat(l-1), xlon(l-1)
          end if
          if (i.eq.1) then
          read (line,*,err=999) x(l-1), y(l-1)
          end if
        end if

        l = l + 1
        goto 210

303     close(fu_inp)

      	call setorg(lat_Orig,lon_Orig,rota,0)
      	if(.not.(i.eq.-1.or.i.eq.1)) stop'SDC>>> specify conversion !!!'

c----  Converting!
      	if(i.eq.1) then
         do 400, index = 1,l-2
400           call redist(x(index),y(index),xlat(index),xlon(index))
        end if

      	if(i.eq.-1) then
        do  410, index = 1,l-2
410            call dist(xlat(index),xlon(index),x(index),y(index))
        end if

c---    Writing output file
        call freeunit(fu_out)
        open(unit=fu_out,status='replace',file='sdc.out',err=998,iostat=io_stat)
        do 500, index =1 , l-2
500         write(fu_out,*)xlat(index),xlon(index),x(index),y(index)

        goto 1001
997    	write(*,*)'>>> ERROR OPENING INPUT FILE'
       	goto 1000
998    	write(*,*)'>>> ERROR WRITING OUTPUT FILE'
        goto 1000
999     write (*,*)'>>> ERROR READING DATA IN LINE ',l
        write (*,*) line
1000   	stop 'Program run aborted!'
1001    write(*,*)'Done! Please check "sdc.out" !'
	    end  ! end of routine
