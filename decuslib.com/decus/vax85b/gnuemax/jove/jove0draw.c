Y
/* 
   Jonathan Payne at Lincoln-Sudbury Regional High School 4-19-83 
   
   jove_draw.c 
 
   This contains, among other things, the modeline formatting, and the 
   message routines (for prompting).  */ 
 
#include "jove.h" 
 
#include "termcap.h" 
 
char	mesgbuf[MAXWIDTH]; 
 
/* find_pos() returns the position on the line, that c_char represents 
   in line. */ 
 
find_pos(line, c_char) 
Line	*line; 
{ 
	register char	*lp; 
	char	buf[LBSIZE]; 
 
	if (line == curline) 
		lp = linebuf; 
	else 
		lp = getcptr(line, buf); 
	return calc_pos(lp, c_char); 
} 
 
calc_pos(lp, c_char) 
register char	*lp; 
register int	c_char; 
{ 
	register int	pos = 0; 
 
	while ((--c_char >= 0) && *lp != 0) { 
		if (*lp >= ' ') { 
			pos++; 
			if (*lp == '\177') 
				pos++; 
		} else if (*lp == '\t') 
			pos += (tabstop - (pos % tabstop)); 
		else { 
			pos++; 
			pos++; 
		} 
		lp++; 
 	} 
	return pos; 
} 
 
/* Message prints the null terminated string onto the bottom line of the 
   terminal. */ 
 
extern int	InJoverc; 
 
message(str) 
char	*str; 
{ 
	if (InJoverc) 
		return; 
	UpdMesg++; 
	errormsg = 0; 
	if (str != mesgbuf) 
		strncpy(mesgbuf, str, sizeof mesgbuf); 
} 
 
static 
strcop(cp, str) 
register char	**cp, 
		*str; 
{ 
	register char	*rcp = *cp;	/* Real Char Pointer */ 
 
	while (*rcp++ = *str++) 
		; 
	*cp = --rcp; 
} 
 
RedrawDisplay() 
{ 
	Line	*newtop = prev_line((curwind->w_line = curline), exp_p ? 
				exp : HALF(curwind)); 
 
	if (newtop == curwind->w_top) 
		v_clear(FLine(curwind), FLine(curwind) + SIZE(curwind)); 
	else 
		SetTop(curwind, newtop); 
} 
 
v_clear(line1, line2) 
register int	line1, 
		line2; 
{ 
	while (line1 <= line2) { 
		i_set(line1, 0); 
		cl_eol(); 
		oimage[line1].Line = nimage[line1].Line = 0; 
		line1++; 
	} 
} 
 
ClAndRedraw() 
{ 
	cl_scr(); 
} 
 
NextPage() 
{ 
	Line	*newline; 
 
	if (exp_p) 
		UpScroll(); 
	else { 
		newline = next_line(curwind->w_top, max(1, SIZE(curwind) - 1)); 
		DotTo(newline, 0); 
		if (in_window(curwind, curwind->w_bufp->b_last) == -1) 
			SetTop(curwind, newline); 
		curwind->w_line = newline; 
	} 
} 
 
PrevPage() 
{ 
	Line	*newline; 
 
	if (exp_p) 
		DownScroll(); 
	else { 
		newline = prev_line(curwind->w_top, max(1, SIZE(curwind) - 1)); 
		DotTo(newline, 0); 
		SetTop(curwind, curline); 
		curwind->w_line = curwind->w_top; 
	} 
} 
 
int	VisBell = 1, 
	RingBell = 0;	/* So if we have a lot of errors ... 
			   ring the bell only ONCE */ 
 
rbell() 
{ 
	RingBell++; 
} 
 
/* VARARGS2 */ 
 
format(buf, fmt, args) 
char	*buf, 
	*fmt; 
int	*args; 
{ 
	IOBUF	strbuf, 
		*sp = &strbuf; 
 
 	sp->io_ptr = sp->io_base = buf; 
	sp->io_fd = -1;		/* Not legit for files */ 
	sp->io_cnt = 32767; 
 
	doformat(sp, fmt, (char *) args); 
	Putc('\0', sp); 
} 
 
static char	padc = ' '; 
static IOBUF	*curiop = 0; 
 
putld(leftadj, width, d, base) 
long	d; 
{ 
	int	length = 1; 
	long	tmpd = d; 
 
	while (tmpd = (tmpd / base)) 
		length++; 
	if (d < 0) 
		length++; 
	if (!leftadj) 
		pad(padc, width - length); 
	if (d < 0) { 
		Putc('-', curiop); 
		d = -d; 
	} 
	outld(d, base); 
	if (leftadj) 
		pad(padc, width - length); 
} 
 
outld(d, base) 
long	d; 
{ 
	long	n; 
 
	if (n = (d / base)) 
		outld(n, base); 
	Putc((int) ('0' + (int) (d % base)), curiop); 
} 
 
puts(leftadj, width, str) 
char	*str; 
{ 
	int	length; 
	register char	*cp, 
			c; 
 
	if (str == 0) 
		str = "(Gack! Null str (bug!))"; 
	length = strlen(str); 
	cp = str; 
	if (!leftadj) 
		pad(' ', width - length); 
	while (c = *cp++) 
		Putc(c, curiop); 
	if (leftadj) 
		pad(' ', width - length); 
} 
 
pad(c, amount) 
register int	c, 
		amount; 
{ 
	while (--amount >= 0) 
		Putc(c, curiop); 
} 
 
doformat(sp, fmt, ap) 
register IOBUF	*sp; 
register char	*fmt; 
char	*ap;		/* Points to the stack where the args are. */ 
{ 
	register char	c; 
	int	leftadj, 
		width; 
 
	curiop = sp; 
 
	while (c = *fmt++) { 
		if (c != '%') { 
			Putc(c, sp); 
			continue; 
		} 
 
		padc = ' '; 
		leftadj = width = 0; 
		c = *fmt++; 
		if (c == '-') { 
			leftadj++; 
			c = *fmt++; 
		} 
		if (c == '0') { 
			padc = '0'; 
			c = *fmt++; 
		} 
		while (c >= '0' && c <= '9') { 
			width = width * 10 + (c - '0'); 
			c = *fmt++; 
		} 
		if (c == '*') { 
			width = *(int *) ap; 
			ap += sizeof (int); 
			c = *fmt++; 
		} 
	reswitch: 
		/* At this point, fmt points at one past the format letter. */ 
		switch (c) { 
		case 'l': 
			c = Upper(*++fmt); 
			goto reswitch; 
	 
		case '%': 
			Putc(c, curiop); 
			break; 
	 
		case 'o': 
			putld(leftadj, width, (long) *(int *) ap, 8); 
			ap += sizeof (int); 
			break; 
	 
		case 'd': 
			putld(leftadj, width, (long) *(int *) ap, 10); 
			ap += sizeof (int); 
			break; 
	 
		case 'D': 
			putld(leftadj, width, *(long *) ap, 10); 
			ap += sizeof (long); 
			break; 
	 
		case 's': 
			puts(leftadj, width, *(char **) ap); 
			ap += sizeof (char *); 
			break; 
		 
		case 'c': 
			Putc(*(int *) ap, curiop); 
			ap += sizeof (int); 
			break; 
	 
		default: 
			complain("You forgot to implement %c in format!", c); 
		} 
	} 
} 
 
/* VARARGS1 */ 
 
char * 
sprint(fmt, args) 
char	*fmt; 
{ 
	static char line[MAXWIDTH]; 
 
	format(line, fmt, &args); 
	return line; 
} 
 
/* VARARGS1 */ 
 
char * 
printf(fmt, args) 
char	*fmt; 
{ 
	doformat(&termout, fmt, (char *) &args); 
} 
 
/* VARARGS2 */ 
 
char * 
sprintf(str, fmt, args) 
char	*str, 
	*fmt; 
{ 
	format(str, fmt, &args); 
	return str; 
} 
 
/* VARARGS1 */ 
 
s_mess(fmt, args) 
char	*fmt; 
{ 
	if (InJoverc) 
		return; 
	format(mesgbuf, fmt, &args); 
	message(mesgbuf); 
} 
 
/* VARARGS1 */ 
 
f_mess(fmt, args) 
char	*fmt; 
{ 
	format(mesgbuf, fmt, &args); 
	message(mesgbuf); 
	UpdateMesg(); 
	UpdMesg++;	/* Still needs updating (for convenience) */ 
} 
 
/* VARARGS1 */ 
 
add_mess(fmt, args) 
char	*fmt; 
{ 
	if (InJoverc) 
		return; 
	format(&mesgbuf[strlen(mesgbuf)], fmt, &args); 
	message(mesgbuf); 
} 
 
/* Jonathan Payne at Lincoln-Sudbury Regional High School 5-25-83 
 
   interface.c 
 
   contains the procedures to HELP the user by creating buffers with 
   information in them, or temporarily writing over the user's text. */ 
 
 
#include "termcap.h" 
 
static char	*BufToUse;	/* Buffer to pop to if we are using buffers */ 
static Window	*LastW;		/* Save old window here so we can return */ 
static Buffer	*LastB;		/* Buffer that used to be in LastW (in case it 
				   isn't when we're done. */ 
 
static int	Gobble, 
		Wrapped, 
		StartNo, 
		LineNo;		/* Line number we have reached (if we are NOT 
				   using buffers.  This way is MUCH easier since 
				   all we have to do is zero out the oimage line 
				   pointer and let redisplay() notice the change 
				   and fix it. */ 
 
static int	WhichKind;	/* Buffers or screen? */ 
 
int	UseBuffers = 0;		/* Don't create buffers by default. It may 
				   be useful sometimes to making listings */ 
 
#define WITHSCREEN	1 
#define WITHbuffer	2 
#define WITHbufedt	3 
 
/* Tell With Buffers sets everything up so that we can clean up after 
   ourselves when we are told to. */ 
 
TellWBuffers(bname, clobber) 
char	*bname; 
{ 
	/* So we know how to clean up */ 
	if (clobber&0x2) 
		WhichKind = WITHbuffer; 
	else	WhichKind = WITHbufedt; 
	BufToUse = bname; 
	LastW = curwind; 
	LastB = curbuf; 
 
	pop_wind(bname, clobber, SCRATCH);	/* This creates the window and 
					   	   makes it the current window. */ 
} 
 
/* Tell With Screen.  If gobble is non-zero we DON'T ungetc characters as 
   they are typed  e.g. --more-- or at the end of the list. */ 
 
TellWScreen(gobble) 
{ 
	WhichKind = WITHSCREEN; 
	StartNo = LineNo = FLine(curwind);	/* Much easier, see what I mean! */ 
	Wrapped = 0; 
	Gobble = gobble; 
} 
 
/* DoTell ... don't keep the user in suspense! 
    
   Takes a string as an argument and displays it correctly, i.e. if we are 
   using buffers simply insert the string into the buffer adding a newline. 
   Otherwise we swrite the line and change oimage */ 
 
/* VARARGS1 */ 
 
DoTell(fmt, args) 
char	*fmt; 
{ 
	char	string[132]; 
 
	format(string, fmt, &args); 
 
	if (WhichKind == WITHbuffer || WhichKind == WITHbufedt) { 
		exp = 1; 
		ins_str(string); 
		LineInsert(); 
		return OKAY; 
	} 
 
	if (LineNo == StartNo + curwind->w_height - 1) { 
		int	c; 
 
		Wrapped++;		/* We wrapped ... see StopTelling */ 
		LineNo = StartNo; 
		f_mess("--more--"); 
		switch (c = getchar()) { 
		case ' ': 
			break; 
 
		case CTL(G): 
		case '\177': 
			if (!Gobble) 
				ignore(Ungetc(c)); 
			return ABORT; 
 
		default: 
			if (Gobble == 0) 
				ignore(Ungetc(c)); 
			return STOP; 
		} 
		f_mess(NullStr); 
	} 
	i_set(LineNo, 0); 
	ignore(swrite(string)); 
	cl_eol(); 
	oimage[LineNo].Line = (Line *) -1; 
	LineNo++; 
	flusho(); 
	return OKAY; 
} 
 
StopTelling() 
{ 
	if (WhichKind == WITHbuffer || WhichKind == WITHbufedt) { 
		NotModified(); 
		SetWind(LastW); 
		LastW = 0; 
	} else { 
		int	c; 
 
		ignore(DoTell("----------")); 
		c = getchar(); 
		if (c != ' ' && Gobble == 0) 
			ignore(Ungetc(c)); 
	} 
} 
 
 
/* 
   This prints all the information about the current mode, and the 
   current filename.  */ 
 
ModeLine(w) 
Window	*w; 
{ 
	int	lineno = FLine(w) + SIZE(w); 
	char	line[132]; 
	Buffer	*thisbuf = w->w_bufp; 
	char	*lp = line, 
		*pp; 
	extern int	outc(); 
	extern char	*get_major_string(); 
 
	i_set(lineno, 0); 
 
	strcop(&lp, "[[[[[[[[[[" + 10 - RecDepth); 
	if (w->w_next != fwind) 
		strcop(&lp, "===="); 
	else 
		strcop(&lp, "JOVE"); 
 
	strcop(&lp, " ("); 
	strcop(&lp, get_major_string(thisbuf->b_major)); 
	if (BufMinorMode(thisbuf, Fill)) 
		strcop(&lp, "Fill "); 
	if (BufMinorMode(thisbuf, Save)) 
		strcop(&lp, "Save "); 
	if (BufMinorMode(thisbuf, OverWrite)) 
		strcop(&lp, "OvrWt "); 
	if (!OKXonXoff) 
		strcop(&lp, "XO "); 
	if (BufMinorMode(thisbuf, Indent)) 
		strcop(&lp, "AI "); 
	if (BufMinorMode(thisbuf, ShowMatch)) 
		strcop(&lp, "SM "); 
 
	lp--;	/* Back over the ' ' */ 
	strcop(&lp, ") "); 
 
	strcop(&lp, thisbuf->b_name); 
	if (IsModified(w->w_bufp))		/* fhsu - buffer name */ 
		strcop(&lp, "*: "); 
	else 
		strcop(&lp, ": "); 
 
	if (thisbuf->b_fname == 0) 
		strcop(&lp, "[No File] "); 
	else { 
		pp = PathRelative(thisbuf->b_fname); 
		pp = sprint("%s ", pp); 
		strcop(&lp, pp); 
	} 
 
	if ((w->w_next != fwind && SO == 0) || *SO == 0) 
		while (lp < &line[CO - 13]) 
			*lp++ = '='; 
	strcop(&lp, "]]]]]]]]]]" + 10 - RecDepth); 
 
	*lp = 0; 
	tputs(SO, 1, outc); 
	swrite(line); 
	tputs(SE, 1, outc); 
	do_cl_eol(lineno); 
} 
 
