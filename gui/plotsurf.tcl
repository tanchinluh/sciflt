# ----------------------------------------------------------------------
# GUI USED WITH PLOTSURF
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

global sciFLTPlotSurfTable

# ------------------------------------------------------------------------------------------------------------------
# INITIALIZATION
# ------------------------------------------------------------------------------------------------------------------
proc sciFLTPlotSurfIni { } {
	global sciFLTPlotSurfTable
	global sciFLTpath
	if {![info exists sciFLTPlotSurfTable(is_init)]} {
		set sciFLTPlotSurfTable(is_init) 0
	}
	if { $sciFLTPlotSurfTable(is_init)==0 } then {
		image create photo sciFLTPlotSurfTable(icon_logo) -file [file join $sciFLTpath "gui" "data" "logo.gif"]
		set sciFLTPlotSurfTable(is_init) 1
	}
}


# ------------------------------------------------------------------------------------------------------------------
# GET BASIC STRUCTURE
# ------------------------------------------------------------------------------------------------------------------
proc sciFLTPlotSurfGetFile { filename } {
	global sciFLTPlotSurfTable
	set embed $sciFLTPlotSurfTable(embed)
	set sciFLTPlotSurfTable($embed,input,ninput) 0
	set sciFLTPlotSurfTable($embed,output,noutput) 0
	set sciFLTPlotSurfTable($embed,f) ""
	set sciFLTPlotSurfTable($embed,input,tch) {"(0) ----"}
	set sciFLTPlotSurfTable($embed,output,tch) {"(0) ----"}
	set fid [open $filename r] 
	while { [eof $fid]==0 } {
		gets $fid lineRead
		set lineRead [string trimleft "$lineRead"]
		if { [regexp "^<i>" $lineRead ] } then {
			incr sciFLTPlotSurfTable($embed,input,ninput)
			set ni $sciFLTPlotSurfTable($embed,input,ninput)
			set sciFLTPlotSurfTable($embed,input,$ni) [string range $lineRead 3 end]
			lappend sciFLTPlotSurfTable($embed,input,tch) "($ni) [string range $lineRead 3 end]"
		}
		if { [regexp "^<o>" $lineRead ] } then {
			incr sciFLTPlotSurfTable($embed,output,noutput)
			set no $sciFLTPlotSurfTable($embed,output,noutput)
			set sciFLTPlotSurfTable($embed,output,$no) [string range $lineRead 3 end]
			lappend sciFLTPlotSurfTable($embed,output,tch) "($no) [string range $lineRead 3 end]"
		}
		if { [regexp "^<f>" $lineRead ] } then {
			set sciFLTPlotSurfTable($embed,f) [string range $lineRead 3 end]
		}
		if { [regexp "^<s>" $lineRead ] } then {
			set sciFLTPlotSurfTable($embed,s) [string range $lineRead 3 end]
		}		
	}
	close $fid
	# DELETE THE FILE
	catch { file delete $filename }
	
}

# ------------------------------------------------------------------------------------------------------------------
# UPDATE SCREEN
# ------------------------------------------------------------------------------------------------------------------
proc sciFLTPlotSurfUpdate { embed } {
	global sciFLTPlotSurfTable
	set w $sciFLTPlotSurfTable(winname)
	set li [string first ")" $sciFLTPlotSurfTable($embed,xaxe)]
	set idx [string range $sciFLTPlotSurfTable($embed,xaxe) 1 [expr $li-1]]
	set li [string first ")" $sciFLTPlotSurfTable($embed,yaxe)]
	set idy [string range $sciFLTPlotSurfTable($embed,yaxe) 1 [expr $li-1]]
	set li [string first ")" $sciFLTPlotSurfTable($embed,yaxe)]
	set idz [string range $sciFLTPlotSurfTable($embed,zaxe) 1 [expr $li-1]]
	# BOTH AXES CAN'T BE THE SAME!
	
	for { set n 1 } { $n<=$sciFLTPlotSurfTable($embed,input,ninput) } { incr n} {
		if { $n==$idx | $n==$idy } then {
			set nst disabled
		} else {
			set nst normal
		}
		$w.center.bottom.cnv.e$n configure -state $nst
	}

	if { [expr ($idx+$idy)*$idz]==0 } then {
		$w.bottom.plot configure -state disabled
	} else {
		$w.bottom.plot configure -state normal
	}

	if { [expr $idx*$idy]==0 } then {
		$w.bottom.modes configure -state disabled
	} else {
		$w.bottom.modes configure -state normal
	}	
		
}


# ------------------------------------------------------------------------------------------------------------------
# CALL SCILAB TO PLOT
# ------------------------------------------------------------------------------------------------------------------
proc sciFLTPlotSurfDo { embed } {
	global sciFLTEditorTable
	global sciFLTPlotSurfTable
	set li [string first ")" $sciFLTPlotSurfTable($embed,xaxe)]
	set idx [string range $sciFLTPlotSurfTable($embed,xaxe) 1 [expr $li-1]]
	set li [string first ")" $sciFLTPlotSurfTable($embed,yaxe)]
	set idy [string range $sciFLTPlotSurfTable($embed,yaxe) 1 [expr $li-1]]
	set li [string first ")" $sciFLTPlotSurfTable($embed,yaxe)]
	set idz [string range $sciFLTPlotSurfTable($embed,zaxe) 1 [expr $li-1]]
	# NOW I PREPARE THE COMMAND
	set fls $sciFLTPlotSurfTable($embed,s)
	if { $embed=="yes" } then {
		set sciFLTEditorTable(scilabname) $fls
		sciFLTEditorExportToScilabDo
	}
	
	if { [expr $idx*$idy]==0 } then {
		set ivar [expr $idx+$idy]
		if { $idx==0 } then {
			set npart "$sciFLTPlotSurfTable($embed,nyaxe)"
		} else {
			set npart "$sciFLTPlotSurfTable($embed,nxaxe)"
		}
	} else {
		set ivar "$idx $idy"
		set npart "$sciFLTPlotSurfTable($embed,nxaxe) $sciFLTPlotSurfTable($embed,nyaxe)"
	}
	set ovar $idz
	set vivar ""
	for { set n 1 } { $n<=$sciFLTPlotSurfTable($embed,input,ninput) } { incr n} {
		lappend vivar $sciFLTPlotSurfTable($embed,input,$n,v)
	}
	set li [string first ")" $sciFLTPlotSurfTable($embed,mod)]
	set mod [string range $sciFLTPlotSurfTable($embed,mod) 1 [expr $li-1]]

	
	set cmd "plotsurf($fls,\[$ivar\],\[$ovar\],\[$vivar\],\[$npart\],$mod);"
	if { $sciFLTPlotSurfTable($embed,nw) } then {
		set cmd "scf();$cmd"
	}
	catch { ScilabEval $cmd }
	if $embed=="no" then {
		catch { destroy $sciFLTPlotSurfTable(winname) }
	}
}


# ------------------------------------------------------------------------------------------------------------------
# MAIN ROUTINE
# ------------------------------------------------------------------------------------------------------------------
proc sciFLTPlotSurf { filename { embed "no"} {winname ".sciFLTPlotSurf"} } {
	global sciFLTEditorTable
	global sciFLTPlotSurfTable
	global sciFLTpath
	sciFLTPlotSurfIni
	set w $winname
	set sciFLTPlotSurfTable(winname) $w		
	
	set sciFLTPlotSurfTable(embed) "yes"
	if { $embed=="no" } then {
		catch { $destroy $w }
		toplevel $w
		wm title $w "Plot fls Surface"	
		frame $w.top -bd 3 -background white -relief groove
		label $w.top.mes01 -text "surfplot" -bg white -font {-*-helvetica-bold-r-*-*-24}
		label $w.top.logo -image sciFLTPlotSurfTable(icon_logo) -bg white
		pack $w.top.logo -expand 1 -fill x -side left
		pack $w.top.mes01 -expand 1 -fill x -side right
		set sciFLTPlotSurfTable(embed) "no"
		sciFLTPlotSurfGetFile $filename
	}
	
	set isemb $sciFLTPlotSurfTable(embed)
	
	set sciFLTPlotSurfTable($isemb,nxaxe) 21
	
	set sciFLTPlotSurfTable($isemb,nyaxe) 21
	
	labelframe $w.center -text "Plot the sourface of : $sciFLTPlotSurfTable($isemb,f)"
	frame $w.center.top
	label   $w.center.top.l_vp   -text "Var to plot"
	label   $w.center.top.l_np   -text "Nr. Points"
	
	label   $w.center.top.l_xaxe -text "X axe :"
	spinbox $w.center.top.xaxe   -width 15 -values $sciFLTPlotSurfTable($isemb,input,tch) -textvariable sciFLTPlotSurfTable($isemb,xaxe) -state readonly
	set sciFLTPlotSurfTable($isemb,xaxe) "(0) ----"	
	entry   $w.center.top.nxaxe  -width 10 -textvariable sciFLTPlotSurfTable($isemb,nxaxe)
	
	label   $w.center.top.l_yaxe -text "Y axe :"
	spinbox $w.center.top.yaxe   -width 15 -values $sciFLTPlotSurfTable($isemb,input,tch) -textvariable sciFLTPlotSurfTable($isemb,yaxe) -state readonly
	set sciFLTPlotSurfTable($isemb,yaxe) "(0) ----"	
	entry   $w.center.top.nyaxe  -width 10 -textvariable sciFLTPlotSurfTable($isemb,nyaxe)
	
	label   $w.center.top.l_zaxe -text "Z axe :"
	spinbox $w.center.top.zaxe   -width 15 -values $sciFLTPlotSurfTable($isemb,output,tch) -textvariable sciFLTPlotSurfTable($isemb,zaxe) -state readonly
	set sciFLTPlotSurfTable($isemb,zaxe) "(0) ----"


	grid config $w.center.top.l_vp   -column 1 -row 0 -columnspan 1 -rowspan 1 -sticky "w"
	grid config $w.center.top.l_np   -column 2 -row 0 -columnspan 1 -rowspan 1 -sticky "w"
	grid config $w.center.top.l_xaxe -column 0 -row 1 -columnspan 1 -rowspan 1 -sticky "e"
	grid config $w.center.top.xaxe   -column 1 -row 1 -columnspan 1 -rowspan 1 -sticky "w"
	grid config $w.center.top.nxaxe  -column 2 -row 1 -columnspan 1 -rowspan 1 -sticky "w"
	grid config $w.center.top.l_yaxe -column 0 -row 2 -columnspan 1 -rowspan 1 -sticky "e"
	grid config $w.center.top.yaxe   -column 1 -row 2 -columnspan 1 -rowspan 1 -sticky "w"
	grid config $w.center.top.nyaxe  -column 2 -row 2 -columnspan 1 -rowspan 1 -sticky "w"
	grid config $w.center.top.l_zaxe -column 0 -row 3 -columnspan 1 -rowspan 1 -sticky "e"
	grid config $w.center.top.zaxe   -column 1 -row 3 -columnspan 1 -rowspan 1 -sticky "w"

	frame     $w.center.bottom
	canvas    $w.center.bottom.mes -width 1 -height 20 -bg lightyellow
	canvas    $w.center.bottom.cnv -width 1 -height 1 -yscrollcommand "$w.center.bottom.sby set"
	scrollbar $w.center.bottom.sby -orient vertical -command "$w.center.bottom.cnv yview"
	grid config $w.center.bottom.mes -column 0 -row 0 -columnspan 1 -rowspan 1 -sticky "ew"
	grid config $w.center.bottom.cnv -column 0 -row 1 -columnspan 1 -rowspan 1 -sticky "nsew"
	grid config $w.center.bottom.sby -column 1 -row 1 -columnspan 1 -rowspan 1 -sticky "ns"
	grid columnconfigure $w.center.bottom 0 -weight 50
	grid rowconfigure    $w.center.bottom 1 -weight 50

	# NOW I PUT ALL INPUT VARS
	$w.center.bottom.mes create text 5 7 -text "Variable:" -anchor nw
	$w.center.bottom.mes create text 150 7 -text "Value:" -anchor nw
	for { set n 1 } { $n<=$sciFLTPlotSurfTable($isemb,input,ninput) } { incr n} {
		# MMM... WORK?
		set bb [$w.center.bottom.cnv bbox all]
		set y [expr [lindex $bb 3]+15]
		label $w.center.bottom.cnv.l$n -text $sciFLTPlotSurfTable($isemb,input,$n) -width 15 -anchor w
		$w.center.bottom.cnv create window 0 $y -window $w.center.bottom.cnv.l$n -anchor w
		entry $w.center.bottom.cnv.e$n -width 15 -textvariable sciFLTPlotSurfTable($isemb,input,$n,v)
		set sciFLTPlotSurfTable($isemb,input,$n,v) 0
		$w.center.bottom.cnv create window 150 $y -window $w.center.bottom.cnv.e$n -anchor w		
	}

	$w.center.bottom.cnv configure -scrollregion [$w.center.bottom.cnv bbox all]

	pack $w.center.top    -side top    -expand 0 -fill both
	pack $w.center.bottom -side bottom -expand 1 -fill both -pady 5
	
	frame $w.bottom
	button $w.bottom.plot   -text "Plot" -width 10 -command "sciFLTPlotSurfDo $isemb"
	button $w.bottom.cancel -text "Cancel" -width 10 -command "destroy $w"	
	checkbutton $w.bottom.innew -text "In New window" -variable sciFLTPlotSurfTable($isemb,nw)
	set sciFLTPlotSurfTable($isemb,nw) 0
	set modes { "(1) Gray Color" "(2) Jet Color" "(3) Hot Color" "(4) Internal Color" "(11) 2D Gray color surface" "(12) 2D Jet Color Surface" "(13) 2D Hot Color Surface" "(14) 2D Internal Color Surface"}
	spinbox $w.bottom.modes -values $modes -width 15 -state readonly -textvariable sciFLTPlotSurfTable($isemb,mod)
	pack $w.bottom.plot $w.bottom.innew $w.bottom.modes -side left -padx 5 -pady 2 -expand 0
	if { $embed=="no" } then {
		pack $w.bottom.cancel -side left -padx 5 -pady 2 -expand 0
	}
	if { $embed=="no" } then {
		pack $w.top -side top -fill both -expand 0
	}
	pack $w.center -side top -fill both -expand 1
	pack $w.bottom -side top -fill both -expand 0
	# MMM I NEED MORE BINDING OR EVENT DETECTOR!
	bind all <Any-Enter> "catch {sciFLTPlotSurfUpdate $isemb}"
	bind all <Any-Leave> "catch {sciFLTPlotSurfUpdate $isemb}"
	bind all <1> "catch {sciFLTPlotSurfUpdate $isemb}"
	bind all <Enter> "catch {sciFLTPlotSurfUpdate $isemb}"
	

}

# ------------------------------------------------------------------------------------------------------------------
# FOR TEST ONLY
# ------------------------------------------------------------------------------------------------------------------
if { 0 } then {
	set sciFLTpath "d:/sciFLT/source"
	sciFLTPlotSurf "m1.txt"
}

