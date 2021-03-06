$PBExportHeader$w_master3.srw
forward
global type w_master3 from window
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

global type w_master3 from window
integer x = 677
integer y = 92
integer width = 1568
integer height = 1676
boolean titlebar = true
string title = "MasterMind"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 12632256
string icon = "MM_WIN.ICO"
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
// Number of different colors that may be used on the board
Constant Integer ii_ncolors = 6
Constant String is_empty_color = " "

// 0=Stop, 1=Play
Integer ii_game_mode

// 2018-03-13 Benjamin  Seaver 
// Refactor using structure
st_peg_info ist_dragged_peg

// Track if peg dragged off of dw_board
Boolean ib_inboard

// 2018-03-08 Benjamin Seaver
// Dragging and Dropping masks double click event
// Workaround: Track drops (mouse ups) to detect when two clicks occur within a typical double click interval
Long il_dragdrop_cpu
Constant Long il_double_click_interval = 500


end variables

forward prototypes
public subroutine f_start ()
public subroutine f_stop ()
public subroutine f_quickcopy (statictext p_st_color)
public subroutine f_start_drag (readonly statictext astatictext)
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
		dw_board.SetItem( i, j, is_empty_color )
	NEXT
NEXT

// Init the buttons
cb_start_stop.Text = "&Stop"
cb_test.Enabled = True

// Initialize the code for each peg in top row
Integer ncolor
String scolor
FOR i = 1 to 4
	ncolor = Rand( ii_ncolors )
	scolor = is_empty_color
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
cb_start_stop.Text = "&Start"
cb_start_stop.SetFocus()
cb_test.Enabled = False

SetRedraw(True)
end subroutine

public subroutine f_quickcopy (statictext p_st_color);// Benjamin Seaver 2018-03-14
// Refactor copying double clicked color on to the next empty playable peg
st_peg_info lst_peg_info

IF ii_game_mode = 1 THEN
	lst_peg_info = gf_peg_info(dw_board)
	IF lst_peg_info.ss_next_empty_peg_column <> "" THEN
		dw_board.SetItem( lst_peg_info.si_play_row, lst_peg_info.ss_next_empty_peg_column , p_st_color.Tag )
	END IF
END IF

end subroutine

public subroutine f_start_drag (readonly statictext astatictext);// Benjamin Seaver 2018-03-15
// Refactor dragging static text colors using new structure
st_peg_info lst_peg_info

// If game is in progress
IF ii_game_mode = 1 THEN
	// Initialize dragged peg color to what is stored in the Tag of the static text
	lst_peg_info.ss_peg_color = astatictext.Tag
	ist_dragged_peg = lst_peg_info
	
	// Start dragging
	astatictext.Drag( Begin! )
END IF
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
this.Control[]={this.st_6,&
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

event key;// 2018-03-15 Benjamin Seaver
// Refactor using st_peg_info structure

// Pressing a key is like double clicking the 
// static text that has that color.
// Pressing back space removes rightmost color.

String ls_color
Boolean lb_backspace
st_peg_info lst_peg_info

// Game stopped?
IF ii_game_mode = 0 THEN RETURN 1

CHOOSE CASE key
	CASE KeyR!
		ls_color = "r" // red
	CASE KeyN!, KeyL!, KeyA!, KeyC!, KeyK!
		ls_color = "n" // black (noir)
	CASE KeyG!
		ls_color = "g" // green
	CASE KeyB!
		ls_color = "b" // blue
	CASE KeyW!
		ls_color = "w" // white
	CASE KeyY!
		ls_color = "y" // yellow
	CASE KeyBack!
		lb_backspace = True
END CHOOSE

// Get information about playing boad
lst_peg_info = gf_peg_info(dw_board)

// Did we get a backspace? If so erase one color
IF lb_backspace AND lst_peg_info.ss_last_filled_peg_column <> "" THEN
	dw_board.SetItem( lst_peg_info.si_play_row, lst_peg_info.ss_last_filled_peg_column , is_empty_color )
END IF

// Did we get a key signifying a color?  If so, fill in next empty peg column with it.
IF ls_color <> "" AND lst_peg_info.ss_next_empty_peg_column <> "" THEN
	dw_board.SetItem( lst_peg_info.si_play_row, lst_peg_info.ss_next_empty_peg_column , ls_color )
	// Set focus on the test button for convenience of keyboard user
	cb_test.setfocus( )
END IF

// Continue processing all keys normally
RETURN 1

end event

type st_6 from statictext within w_master3
event ue_down pbm_lbuttondown
integer x = 1371
integer y = 788
integer width = 119
integer height = 140
string dragicon = "f:\apps\pb\tools\MM_PEG.ICO"
integer textsize = -24
integer weight = 400
fontcharset fontcharset = symbol!
fontpitch fontpitch = variable!
string facename = "Wingdings"
long backcolor = 12632256
string text = "l"
alignment alignment = center!
boolean focusrectangle = false
end type

event ue_down;// Benjamin Seaver 2018-03-15
// Refactor dragging static text colors using new structure and function
f_start_drag( This )

end event

on doubleclicked;f_quickcopy( This )
end on

type st_5 from statictext within w_master3
event ue_down pbm_lbuttondown
integer x = 1216
integer y = 788
integer width = 119
integer height = 140
string dragicon = "f:\apps\pb\tools\MM_PEG.ICO"
integer textsize = -24
integer weight = 400
fontcharset fontcharset = symbol!
fontpitch fontpitch = variable!
string facename = "Wingdings"
long backcolor = 12632256
string text = "l"
alignment alignment = center!
boolean focusrectangle = false
end type

event ue_down;// Benjamin Seaver 2018-03-15
// Refactor dragging static text colors using new structure and function
f_start_drag( This )

end event

on doubleclicked;f_quickcopy( This )
end on

type st_4 from statictext within w_master3
event ue_down pbm_lbuttondown
integer x = 1061
integer y = 788
integer width = 119
integer height = 140
string dragicon = "f:\apps\pb\tools\MM_PEG.ICO"
integer textsize = -24
integer weight = 400
fontcharset fontcharset = symbol!
fontpitch fontpitch = variable!
string facename = "Wingdings"
long backcolor = 12632256
string text = "l"
alignment alignment = center!
boolean focusrectangle = false
end type

event ue_down;// Benjamin Seaver 2018-03-15
// Refactor dragging static text colors using new structure and function
f_start_drag( This )

end event

on doubleclicked;f_quickcopy( This )
end on

type st_3 from statictext within w_master3
event ue_down pbm_lbuttondown
integer x = 1371
integer y = 588
integer width = 119
integer height = 140
string dragicon = "f:\apps\pb\tools\MM_PEG.ICO"
integer textsize = -24
integer weight = 400
fontcharset fontcharset = symbol!
fontpitch fontpitch = variable!
string facename = "Wingdings"
long backcolor = 12632256
string text = "l"
alignment alignment = center!
boolean focusrectangle = false
end type

event ue_down;// Benjamin Seaver 2018-03-15
// Refactor dragging static text colors using new structure and function
f_start_drag( This )

end event

on doubleclicked;f_quickcopy( This )
end on

type st_2 from statictext within w_master3
event ue_down pbm_lbuttondown
integer x = 1216
integer y = 588
integer width = 119
integer height = 140
string dragicon = "f:\apps\pb\tools\MM_PEG.ICO"
integer textsize = -24
integer weight = 400
fontcharset fontcharset = symbol!
fontpitch fontpitch = variable!
string facename = "Wingdings"
long backcolor = 12632256
string text = "l"
alignment alignment = center!
boolean focusrectangle = false
end type

event ue_down;// Benjamin Seaver 2018-03-15
// Refactor dragging static text colors using new structure and function
f_start_drag( This )

end event

on doubleclicked;f_quickcopy( This )
end on

type st_1 from statictext within w_master3
event ue_down pbm_lbuttondown
integer x = 1061
integer y = 588
integer width = 119
integer height = 140
string dragicon = "f:\apps\pb\tools\MM_PEG.ICO"
integer textsize = -24
integer weight = 400
fontcharset fontcharset = symbol!
fontpitch fontpitch = variable!
string facename = "Wingdings"
long backcolor = 12632256
string text = "l"
alignment alignment = center!
boolean focusrectangle = false
end type

event ue_down;// Benjamin Seaver 2018-03-15
// Refactor dragging static text colors using new structure and function
f_start_drag( This )

end event

on doubleclicked;f_quickcopy( This )
end on

type cb_test from commandbutton within w_master3
integer x = 1061
integer y = 1368
integer width = 434
integer height = 136
integer taborder = 20
integer textsize = -12
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "&Test"
end type

on clicked;// Find the play row
Integer row

row = dw_board.Find( "status='p'", 1, dw_board.RowCount() )

// Load colors
String test[], code[]
Integer i, j

FOR i = 1 to 4
	test[i] = dw_board.GetItemString( row, i )
	IF test[i] = is_empty_color THEN
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
integer x = 1061
integer y = 12
integer width = 434
integer height = 136
integer taborder = 10
integer textsize = -12
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Stop/Stop"
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
integer width = 987
integer height = 1536
string dragicon = "MM_PEG.ICO"
boolean dragauto = true
string dataobject = "d_master2"
boolean border = false
boolean livescroll = true
end type

event ue_rbuttondblclk;// Benjamin Seaver 2018-03-15
// For people who click right mouse quickly,
// let right double click also rotate the color of the peg
Triggerevent(rbuttondown!)
end event

event ue_up;// 2018-03-14 Benjamin Seaver
// Refactor dragging a peg in play off the board so that its column becomes empty
IF NOT ib_inboard AND ist_dragged_peg.sb_is_play_peg  THEN
	SetItem( ist_dragged_peg.si_peg_row, ist_dragged_peg.ss_peg_column, is_empty_color )
END IF

// Is this two clicks within a doubleclick interval?
Long ll_new_dragdrop_cpu
Boolean lb_treat_as_dbl_click
ll_new_dragdrop_cpu = Cpu()
lb_treat_as_dbl_click = ll_new_dragdrop_cpu <= (il_dragdrop_cpu + il_double_click_interval)

// Update dragdrop milliseconds
il_dragdrop_cpu = ll_new_dragdrop_cpu

// Trigger doubleclicked
IF lb_treat_as_dbl_click THEN
	this.TriggerEvent(doubleclicked!)
	
	// Reset doubleclick
	il_dragdrop_cpu = 0
END IF

end event

event ue_mouseover;// Benjamin Seaver 2018-03-13
// Refactor using gf_peg_info

boolean lb_start_dragging
st_peg_info lst_peg

// Game in progress?
IF ii_game_mode = 1 THEN
	lst_peg = gf_peg_info(this)
	
	// Drag if a colored peg column with a color in it
	lb_start_dragging  = lst_peg.sb_is_colored_peg AND lst_peg.ss_peg_color <> is_empty_color
END IF

IF lb_start_dragging THEN
	DragAuto = True
	ist_dragged_peg = lst_peg
ELSE
	DragAuto = False
END IF

end event

event dragdrop;// 2018-03-13 Benjamin Seaver
// Refactor to use gf_peg_info

// Get details on dropped peg
st_peg_info lst_drop_peg
lst_drop_peg = gf_peg_info(this)

// Drop supported only on play row
IF lst_drop_peg.sb_is_play_peg THEN
	// If drag row is also play row, then swap peg colors between drag and drop peg
	IF ist_dragged_peg.sb_is_play_peg THEN
		SetItem( ist_dragged_peg.si_peg_row, ist_dragged_peg.ss_peg_column, lst_drop_peg.ss_peg_color )
	END IF
	
	// Set color of peg we dropped on
	SetItem( lst_drop_peg.si_peg_row, lst_drop_peg.ss_peg_column, ist_dragged_peg.ss_peg_color )
END IF

end event

on dragenter;ib_inboard = True
end on

on dragleave;ib_inboard = False
end on

event doubleclicked;// 2018-03-08 First Version Benjamin Seaver
// 2018-03-13 Refactor with gf_peg_info
// On doubleclick, copy scored row color up to active "Play" row 
// on the same column as clicked

// Do nothing if game is stopped
IF ii_game_mode = 0 THEN
	RETURN
END IF

// Get details on double clicked peg
st_peg_info st_peg
st_peg = gf_peg_info(this)

// Double click supported only on scored row
IF st_peg.sb_is_scored_peg THEN
	// On the play row, set the same peg column to the same color as the double clicked scored peg
	SetItem( st_peg.si_play_row, st_peg.ss_peg_column, st_peg.ss_peg_color )
END IF

end event

event rbuttondown;// Benjamn Seaver 2018-03-15
// Refactor using new structure
// Implement function on right button *down* so that color changes immediately when button is pushed

st_peg_info lst_peg_info

lst_peg_info = gf_peg_info( This )

// If game is active and changeable peg
IF ii_game_mode = 1 AND lst_peg_info.sb_is_play_peg THEN
	// Rotate color to next color
	lst_peg_info.ss_peg_color = gf_next_peg_color( lst_peg_info.ss_peg_color )
	SetItem( lst_peg_info.si_peg_row, lst_peg_info.ss_peg_column , lst_peg_info.ss_peg_color )
END IF

end event

