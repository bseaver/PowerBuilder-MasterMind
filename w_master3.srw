$PBExportHeader$w_master3.srw
forward
global type w_master3 from Window
end type
type st_6 from statictext within w_master3
end type
type st_5 from statictext within w_master3
end type
type st_4 from statictext within w_master3
end type
type st_3 from statictext within w_master3
end type
type st_2 from statictext within w_master3
end type
type st_1 from statictext within w_master3
end type
type cb_test from commandbutton within w_master3
end type
type cb_start_stop from commandbutton within w_master3
end type
type dw_board from datawindow within w_master3
end type
end forward

global type w_master3 from Window
int X=677
int Y=93
int Width=1541
int Height=1617
boolean TitleBar=true
string Title="MasterMind"
long BackColor=12632256
boolean ControlMenu=true
boolean MinBox=true
boolean MaxBox=true
string Icon="f:\apps\pb\tools\MM_WIN.ICO"
st_6 st_6
st_5 st_5
st_4 st_4
st_3 st_3
st_2 st_2
st_1 st_1
cb_test cb_test
cb_start_stop cb_start_stop
dw_board dw_board
end type
global w_master3 w_master3

type variables
Integer ii_currow, ii_ncolors = 6

// 0=Stop, 1=Play
Integer ii_game_mode

// Color being dragged
String is_dragcolor

// Play peg being dragged
String is_dragpeg
Integer ii_dragrow

// Track if peg dragged off of dw_board
Boolean ib_inboard
end variables

forward prototypes
public subroutine f_start ()
public subroutine f_stop ()
public subroutine f_quickcopy (statictext p_st_color)
end prototypes

public subroutine f_start ();// Start Game of master mind
SetRedraw(False)

Integer lastrow, i, j
String status
lastrow = dw_board.RowCount()

// Put status in instance
ii_game_mode = 1

// Clear out the board
FOR i = 1 to lastrow
	CHOOSE CASE i
	CASE 1
		status = "1"
	CASE lastrow
		status = "p"
	CASE ELSE
		status = " "
	END CHOOSE
	dw_board.SetItem( i, "status", status )


	FOR j = 1 to 8
		dw_board.SetItem( i, j, " " )
	NEXT
NEXT

// Init the buttons
cb_start_stop.Text = "Stop"
cb_test.Enabled = True

// Initialize the code for each peg in top row
Integer ncolor
String scolor
FOR i = 1 to 4
	ncolor = Rand( ii_ncolors )
	scolor = " "
	FOR j = 1 to ncolor
		scolor = gf_next_peg_color( scolor )
	NEXT

	dw_board.SetItem( 1, i, scolor )
NEXT

SetRedraw(True)
end subroutine

public subroutine f_stop ();// Stop the game

SetRedraw(False)

// Set the mode
ii_game_mode = 0

// Set the board
dw_board.SetItem( 1, "status", "0" )

// The buttons
cb_start_stop.Text = "Start"
cb_start_stop.SetFocus()
cb_test.Enabled = False

SetRedraw(True)
end subroutine

public subroutine f_quickcopy (statictext p_st_color);// Game stopped?
IF ii_game_mode = 0 THEN RETURN

// Find the play row
Integer row, peg

row = dw_board.Find( "status='p'", 1, dw_board.RowCount() )

// Scan the pegs on the play row
String pegcol
FOR peg = 1 to 4
	pegcol = "peg" + String(peg)
	// IF peg column is empty fill it
	IF dw_board.GetItemString( row, pegcol ) = " " THEN
		dw_board.SetItem( row, pegcol, p_st_color.Tag )
		EXIT
	END IF
NEXT

RETURN

end subroutine

on open;// Random sequences desired
Randomize(0)

// Set Window Icon
This.Icon = "mm_win.ico"

// Set Board Drag Icon
dw_board.DragIcon = "mm_peg.ico"

// Playing board gets 11 rows
dw_board.Reset()

Integer i
FOR i = 1 TO 11
	dw_board.InsertRow(0)
NEXT

// Initialize the drag colors
String color
StaticText dragpeg

FOR i = 1 TO ii_ncolors
	CHOOSE CASE i
		CASE 1
			dragpeg = st_1
		CASE 2
			dragpeg = st_2
		CASE 3
			dragpeg = st_3
		CASE 4
			dragpeg = st_4
		CASE 5
			dragpeg = st_5
		CASE 6
			dragpeg = st_6
		CASE ELSE
			EXIT
	END CHOOSE
	color = gf_next_peg_color( color )
	dragpeg.Tag = color
	dragpeg.DragIcon = "mm_peg.ico"
	dragpeg.TextColor = gf_peg_color( color )
NEXT


// Start the game
f_start()

IF False THEN
	// This just makes sure function is included in .EXE
	// Since it is used only in the datawindow
	gf_peg_color("")
END IF
end on

on resize;//String max
//IF WindowState <> Maximized! THEN max = "Not "
//MessageBox("Resize", max + "Maximized")
end on

on w_master3.create
this.st_6=create st_6
this.st_5=create st_5
this.st_4=create st_4
this.st_3=create st_3
this.st_2=create st_2
this.st_1=create st_1
this.cb_test=create cb_test
this.cb_start_stop=create cb_start_stop
this.dw_board=create dw_board
this.Control[]={ this.st_6,&
this.st_5,&
this.st_4,&
this.st_3,&
this.st_2,&
this.st_1,&
this.cb_test,&
this.cb_start_stop,&
this.dw_board}
end on

on w_master3.destroy
destroy(this.st_6)
destroy(this.st_5)
destroy(this.st_4)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.cb_test)
destroy(this.cb_start_stop)
destroy(this.dw_board)
end on

type st_6 from statictext within w_master3
event ue_down pbm_lbuttondown
int X=1372
int Y=789
int Width=119
int Height=141
string DragIcon="f:\apps\pb\tools\MM_PEG.ICO"
string Text="l"
Alignment Alignment=Center!
boolean FocusRectangle=false
long BackColor=12632256
int TextSize=-24
int Weight=400
string FaceName="Wingdings"
FontCharSet FontCharSet=Symbol!
FontPitch FontPitch=Variable!
end type

on ue_down;IF ii_game_mode = 0 THEN RETURN
is_dragcolor = This.Tag
This.Drag( Begin! )

end on

on doubleclicked;f_quickcopy( This )
end on

type st_5 from statictext within w_master3
event ue_down pbm_lbuttondown
int X=1217
int Y=789
int Width=119
int Height=141
string DragIcon="f:\apps\pb\tools\MM_PEG.ICO"
string Text="l"
Alignment Alignment=Center!
boolean FocusRectangle=false
long BackColor=12632256
int TextSize=-24
int Weight=400
string FaceName="Wingdings"
FontCharSet FontCharSet=Symbol!
FontPitch FontPitch=Variable!
end type

on ue_down;IF ii_game_mode = 0 THEN RETURN
is_dragcolor = This.Tag
This.Drag( Begin! )

end on

on doubleclicked;f_quickcopy( This )
end on

type st_4 from statictext within w_master3
event ue_down pbm_lbuttondown
int X=1061
int Y=789
int Width=119
int Height=141
string DragIcon="f:\apps\pb\tools\MM_PEG.ICO"
string Text="l"
Alignment Alignment=Center!
boolean FocusRectangle=false
long BackColor=12632256
int TextSize=-24
int Weight=400
string FaceName="Wingdings"
FontCharSet FontCharSet=Symbol!
FontPitch FontPitch=Variable!
end type

on ue_down;IF ii_game_mode = 0 THEN RETURN
is_dragcolor = This.Tag
This.Drag( Begin! )

end on

on doubleclicked;f_quickcopy( This )
end on

type st_3 from statictext within w_master3
event ue_down pbm_lbuttondown
int X=1372
int Y=589
int Width=119
int Height=141
string DragIcon="f:\apps\pb\tools\MM_PEG.ICO"
string Text="l"
Alignment Alignment=Center!
boolean FocusRectangle=false
long BackColor=12632256
int TextSize=-24
int Weight=400
string FaceName="Wingdings"
FontCharSet FontCharSet=Symbol!
FontPitch FontPitch=Variable!
end type

on ue_down;IF ii_game_mode = 0 THEN RETURN
is_dragcolor = This.Tag
This.Drag( Begin! )

end on

on doubleclicked;f_quickcopy( This )
end on

type st_2 from statictext within w_master3
event ue_down pbm_lbuttondown
int X=1217
int Y=589
int Width=119
int Height=141
string DragIcon="f:\apps\pb\tools\MM_PEG.ICO"
string Text="l"
Alignment Alignment=Center!
boolean FocusRectangle=false
long BackColor=12632256
int TextSize=-24
int Weight=400
string FaceName="Wingdings"
FontCharSet FontCharSet=Symbol!
FontPitch FontPitch=Variable!
end type

on ue_down;IF ii_game_mode = 0 THEN RETURN
is_dragcolor = This.Tag
This.Drag( Begin! )

end on

on doubleclicked;f_quickcopy( This )
end on

type st_1 from statictext within w_master3
event ue_down pbm_lbuttondown
int X=1061
int Y=589
int Width=119
int Height=141
string DragIcon="f:\apps\pb\tools\MM_PEG.ICO"
string Text="l"
Alignment Alignment=Center!
boolean FocusRectangle=false
long BackColor=12632256
int TextSize=-24
int Weight=400
string FaceName="Wingdings"
FontCharSet FontCharSet=Symbol!
FontPitch FontPitch=Variable!
end type

on ue_down;IF ii_game_mode = 0 THEN RETURN
is_dragcolor = This.Tag
This.Drag( Begin! )

end on

on doubleclicked;f_quickcopy( This )
end on

type cb_test from commandbutton within w_master3
int X=1061
int Y=1369
int Width=435
int Height=137
int TabOrder=20
boolean Enabled=false
string Text="Test"
int TextSize=-12
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on clicked;// Find the play row
Integer row

row = dw_board.Find( "status='p'", 1, dw_board.RowCount() )

// Load colors
String test[], code[]
Integer i, j

FOR i = 1 to 4
	test[i] = dw_board.GetItemString( row, i )
	IF test[i] = " " THEN
		MessageBox( Parent.Title, "Please select your colors.  (Dark Gray means no color picked)." )
		RETURN
	END IF
	code[i] = dw_board.GetItemString( 1, i )
NEXT


// So how many exact matches?
Integer exact

FOR i = 1 to 4
	IF test[i] = code[i] THEN
		exact = exact + 1
		test[i] = "x"
		code[i] = "x"
	END IF
NEXT

// And how many right colors, but in the wrong place?
Integer right

FOR i = 1 to 4
	IF test[i] <> "x" THEN
		FOR j = 1 to 4
			IF i <> j AND test[i] = code[j] THEN
				right = right + 1
				code[j] = "x"
				EXIT
			END IF
		NEXT
	END IF
NEXT

// Now update the score
j = 4 + exact + right
FOR i = 5 TO j
	IF i - exact < 5 THEN
		dw_board.SetItem( row, i, "n" )
	ELSE
		dw_board.SetItem( row, i, "w" )
	END IF
NEXT 

// Winner?
IF exact = 4 THEN
	f_stop()
	MessageBox( Parent.Title, "You win!" )
	RETURN
END IF

// This row has been "scored"
dw_board.SetItem( row, "status", "s" )

// Is there another row to play?
IF row > 2 THEN
	dw_board.SetItem( row - 1, "status", "p" )
ELSE
	f_stop()
END IF
end on

type cb_start_stop from commandbutton within w_master3
int X=1061
int Y=13
int Width=435
int Height=137
int TabOrder=10
string Text="Stop"
int TextSize=-12
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on clicked;CHOOSE CASE ii_game_mode
CASE 0 // stopped
	f_start()
CASE 1 // started
	f_stop()
END CHOOSE

end on

type dw_board from datawindow within w_master3
event ue_rbuttondblclk pbm_rbuttondblclk
event ue_up pbm_lbuttonup
event ue_mouseover pbm_mousemove
int Width=988
int Height=1537
boolean DragAuto=true
string DragIcon="f:\apps\pb\tools\MM_PEG.ICO"
string DataObject="d_master2"
boolean Border=false
boolean LiveScroll=true
end type

on ue_rbuttondblclk;TriggerEvent( RButtonDown! )
end on

on ue_up;IF NOT ib_inboard AND ii_dragrow > 0 THEN
	SetItem( ii_dragrow, is_dragpeg, " " )
END IF

ii_dragrow = 0
end on

on ue_mouseover;// Game stopped?
IF ii_game_mode = 0 THEN GOTO no

// Over a peg?
String peg
peg = GetObjectAtPointer()
IF Left( peg, 3 ) <> "peg" THEN
	GOTO no
END IF

// Row of peg is?
Integer row
row = Integer( Mid( peg, 6 ) )
peg = Left( peg, 4 )

// Does peg have a color
String color
color = GetItemString( row, peg )
IF color = " " THEN
	GOTO no
END IF

// Start dragging the color
// Is this the play row?
IF GetItemString( row, "status" ) = "p" THEN
	is_dragpeg = peg
	ii_dragrow = row
ELSE
	ii_dragrow = 0
END IF

// Set current color
is_dragcolor = color

DragAuto = True
RETURN

no:
	ii_dragrow = 0
	DragAuto = False
	RETURN


end on

on rbuttondown;// Rotate color selection if game is on and
// if clicked over the play row

// Do nothing if game is stopped
IF ii_game_mode = 0 THEN
	RETURN
END IF

// Clicked Where? (Quit if not a peg).
String clicked_what

clicked_what = GetObjectAtPointer()
IF Left( clicked_what, 3 ) <> "peg" THEN
	RETURN
END IF

// What peg, row?
Integer row
String peg

peg = Left( clicked_what, 4 )
row = Integer( Mid( clicked_what, 6 ) )

// Can't click except on the "Play" row
String status
status = GetItemString( row, "status" )
IF status <> "p" THEN
	RETURN
END IF

// Rotate the color
String color
color = GetItemString( row, peg )
color = gf_next_peg_color(color)
SetItem( row, peg, color )
end on

on dragdrop;String dropped
Integer droprow
Boolean success
dropped = This.GetObjectAtPointer()
IF Left( dropped, 3 ) = "peg" THEN
	droprow = Integer( Mid( dropped, 6 ) )
	dropped = Left( dropped, 4 )

	IF GetItemString( droprow, "status" ) = "p" THEN
		IF ii_dragrow = droprow THEN
			SetItem( droprow, is_dragpeg, GetItemString( droprow, dropped ) )
		END IF
		SetItem( droprow, dropped, is_dragcolor )
		success = True
	END IF
END IF

ii_dragrow = 0

 
end on

on dragenter;ib_inboard = True
end on

on dragleave;ib_inboard = False
end on

