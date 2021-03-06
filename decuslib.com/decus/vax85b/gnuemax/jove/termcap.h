Y
/* Termcap definitions */ 
 
extern char 
	*UP,	/* Scroll reverse, or up */ 
	*CS,	/* If on vt100 */ 
	*SO,	/* Start standout */ 
	*SE,	/* End standout */ 
	*CM,	/* The cursor motion string */ 
	*CL,	/* Clear screen */ 
	*CE,	/* Clear to end of line */ 
	*HO,	/* Home cursor */ 
	*AL,	/* Addline (insert line) */ 
	*DL,	/* Delete line */ 
	*IS,	/* Initial start */ 
	*VS,	/* Visual start */ 
	*VE,	/* Visual end */ 
	*IC,	/* Insert char */ 
	*DC,	/* Delete char */ 
	*IM,	/* Insert mode */ 
	*EI,	/* End insert mode */ 
	*LL,	/* Last line, first column */ 
	*SR,	/* Scroll reverse */ 
	*VB;	/* Visible bell */ 
 
extern int 
	LI,		/* Number of lines */ 
	CO,		/* Number of columns */ 
 
	UL,		/* Underscores don't replace chars already on screen */ 
	MI,		/* Okay to move while in insert mode */ 
 
	TABS,		/* Whether we are in tabs mode */ 
	UpLen,		/* Length of the UP string */ 
	HomeLen,	/* Length of Home string */ 
	LowerLen;	/* Length of lower string */ 
 
extern char 
	PC, 
	*BC;	/* Back space */ 
 
extern int ospeed; 
 
