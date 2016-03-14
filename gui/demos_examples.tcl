# ----------------------------------------------------------------------
# GENERAL DEMOS AND EXAMPLES
# ----------------------------------------------------------------------
# This file is part of sciFLT ( Scilab Fuzzy Logic Toolbox )
# Copyright (C) 2004 Jaime Urzua Grez
# mailto:jaime_urzua@yahoo.com
# Toolbox Revision @REV@ -- @DATE@

# ----------------------------------------------------------------------
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
# ----------------------------------------------------------------------

global sciFLTDemoTable

# --------------------------------------------------------------------------
# Run Demo
# --------------------------------------------------------------------------
proc sciFLTDemoGet { } {
	global sciFLTDemoTable
	global sciFLTpath
	set sciFLTDemoTable(nit) 0
	set fid [open [file join $sciFLTpath "demos" "demos.txt"] r]
	while { [eof $fid]==0 } {
		gets $fid lineRead
		set lineRead [string trimleft "$lineRead"]
		if { [regexp "^<it>*" "$lineRead"] } {
			incr sciFLTDemoTable(nit)
			set sciFLTDemoTable($sciFLTDemoTable(nit),1) [string range "$lineRead" 4 end]
		}
		
		if { [regexp "^<de>*" "$lineRead"] } {
			set sciFLTDemoTable($sciFLTDemoTable(nit),2) [string range "$lineRead" 4 end]
		}

		if { [regexp "^<cm>*" "$lineRead"] } {
			set sciFLTDemoTable($sciFLTDemoTable(nit),3) [string range "$lineRead" 4 end]
		}

		if { [regexp "^<im>*" "$lineRead"] } {
			set sciFLTDemoTable($sciFLTDemoTable(nit),4) [string range "$lineRead" 4 end]
		}
	}
	close $fid
}



# --------------------------------------------------------------------------
# Run Demo
# --------------------------------------------------------------------------
proc sciFLTDemoRun { } {
	global sciFLTDemoTable
	if { $sciFLTDemoTable(curitem)!=0 } then {
		set filetmp $sciFLTDemoTable($sciFLTDemoTable(curitem),3)
		ScilabEval "exec(flt_path()+'demos/$filetmp',-1);"
	}
}


# --------------------------------------------------------------------------
# Main Routine
# --------------------------------------------------------------------------
proc sciFLTDemo { } {
	global sciFLTDemoTable
	global sciFLTpath
	sciFLTDemoGet
	if {![info exists sciFLTDemoTable(is_init)]} {
		set sciFLTDemoTable(is_init) 0
		#image create photo sciFLTDemoTable(icon_logo) -file [file join $sciFLTpath "gui" "data" "logo.gif"]
		image create photo sciFLTDemoTable(icon_logo) -file [file join $sciFLTpath "gui" "logo01_sciFLT_small.gif"]
		image create photo sciFLTDemoTable(icon_demo) -file [file join $sciFLTpath "demos" "flt_tiptest.gif" ] 
	}	
	set w ".sciFLTDemo"
	catch { destroy $w }
	toplevel $w
	wm title $w "sciFLT Demos & Example"
	wm resizable $w 0 0
	#wm protocol $w WM_DELETE_WINDOW "set sciFLTScicosTable(goout) 1; destroy $w"
	set sciFLTDemoTable(widget) $w
	set sciFLTDemoTable(curitem) 0

	frame $w.top1 -bd 2 -background white -relief groove
	label $w.top1.mes01 -text "Demos & Examples" -bg white -font {-*-helvetica-bold-r-*-*-24}
	label $w.top1.logo -image sciFLTDemoTable(icon_logo) -bg white
	pack $w.top1.logo -expand 1 -fill x -side left
	pack $w.top1.mes01 -expand 1 -fill x -side right
	
	frame $w.center -bd 2 -relief groove
	frame $w.center.l
	listbox $w.center.l.list -yscroll "$w.center.l.sb set" -setgrid 1 -height 12 -width 30
	for {set x 1} { $x <= $sciFLTDemoTable(nit) } { incr x } {
		$w.center.l.list insert end "$sciFLTDemoTable($x,1)"
	}
	scrollbar $w.center.l.sb -command "$w.center.l.list yview"
	bind $w.center.l.list <<ListboxSelect>> {
		global sciFLTDemoTable
		set it0 [selection get]
		set txt ""
		for {set x 1} {$x<=$sciFLTDemoTable(nit) } { incr x } {
			if { $sciFLTDemoTable($x,1)==$it0 } then {
				set txt $sciFLTDemoTable($x,2)
				set imgn $sciFLTDemoTable($x,4)
				set sciFLTDemoTable(curitem) $x
				$sciFLTDemoTable(widget).bot.runme configure -text "run $it0" -state normal
				# ADD IMAGEN!
				if { $imgn!="" } {
				       	image create photo sciFLTDemoTable(icon_demo) -file [file join $sciFLTpath "demos" $imgn ]
				}
			}
		}
		$sciFLTDemoTable(widget).center.r.entry delete 1.0 end
		$sciFLTDemoTable(widget).center.r.entry insert 0.0 $txt
	}
	
	pack $w.center.l.list -side left -expand 1 -fill both
	pack $w.center.l.sb -side right -fill y
		
	frame $w.center.r
	text $w.center.r.entry -width 40 -height 15 -wrap word -yscrollcommand "$w.center.r.sb set" 
	scrollbar $w.center.r.sb -command "$w.center.r.entry yview"
	pack $w.center.r.entry -side left -expand 1 -fill both
	pack $w.center.r.sb -side right -fill y

	frame $w.center.rr
	label $w.center.rr.img -image sciFLTDemoTable(icon_demo) -bg white
	pack $w.center.rr.img
	
	pack $w.center.l $w.center.r $w.center.rr -fill y -expand 1 -side left -padx 2 -pady 5
	
	frame $w.bot
	button $w.bot.cancel -text "cancel" -width 15 -command "destroy $w"
	button $w.bot.runme -text "run demo" -width 35 -state disabled -command "sciFLTDemoRun"
	pack $w.bot.cancel -side left -expand 0
	pack $w.bot.runme -side right -expand 0

	pack $w.top1 -side top -fill x -expand 0 -pady 2 -padx 10
	pack $w.center -side top -fill both -expand 1 -pady 2 -padx 2
	pack $w.bot -side bottom -fill x -expand 0 -pady 2 -padx 10 
}


# ONLY FOR TEST POURPOSE
if { 0 } then {
	set sciFLTpath "c:/sciFLT/source"
	sciFLTDemo
}
