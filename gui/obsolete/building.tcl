# ----------------------------------------------------------------------
# SHOW INFORMATION DURING BUILD PROCESS
# ----------------------------------------------------------------------
# This file is part of sciFLT ( Scilab Fuzzy Logic Toolbox )
# Copyright (C) @YEARS@ Jaime Urzua Grez
# mailto:jaime_urzua@yahoo.com
# 
# 2011 Holger Nahrstaedt
# ----------------------------------------------------------------------
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
# ----------------------------------------------------------------------

proc sciFLTbuild { dir1 } {
	image create photo logo_flt -file [file join $dir1 "logo01_sciFLT_small.gif"]
	set w ".sciFLTReadme"
	catch { destroy $w }
	toplevel $w
	#wm geometry $w 400x300
	wm resizable $w 0 0
	wm title $w "sciFLT toolbox"
	frame $w.top -bd 2 -background white -relief groove
	label $w.top.logo -image logo_flt -bg white
	pack $w.top.logo

	labelframe $w.center -text "Information:"
	text $w.center.txt -wrap word -width 1 -height 20 -yscrollcommand "$w.center.sby set" -bg white
	$w.center.txt tag configure t0 -foreground black 
	$w.center.txt tag configure t1 -foreground blue -font {-*-helvetica-bold-r-*-*-16} -justify center
	$w.center.txt tag configure t2 -foreground navy
	$w.center.txt tag configure t3 -foreground darkgreen
	
	set tc t0
	scrollbar $w.center.sby -orient vertical -command "$w.center.txt yview"
	pack $w.center.txt -side left -fill both -expand 1
	pack $w.center.sby -side left -fill y -expand 0
	set fid [open [file join $dir1 "../readme.txt" ] r]
	while { [eof $fid]==0 } {
		gets $fid lineRead
		if { [string range $lineRead 0 0]=="*" } then {
			$w.center.txt insert end "[string range $lineRead 1 end]\n" t1
			if { [string range $lineRead 0 15]=="* REVISION NOTES" } then {
				set tc t3
			}
		} elseif  { [string range $lineRead 0 8]=="Copyright" } then {
			set tc t2
			$w.center.txt insert end "$lineRead\n" $tc
		} else {		
			$w.center.txt insert end "$lineRead\n" $tc
		}
	}
	close $fid

	labelframe $w.center2 -relief groove -text "Installation"
	label $w.center2.t1 -text "Building scilab objects"
	label $w.center2.t2 -text "Building library"
	label $w.center2.t3 -text "Building loader.sce"
	label $w.center2.t4 -text "Building documentation"
	pack $w.center2.t1 $w.center2.t2 $w.center2.t3 $w.center2.t4
	
	frame $w.bottom -relief groove
	button $w.bottom.demo -text "Run demos & examples" -command "destroy $w;catch {ScilabEval sciFLTdemo};"
	pack $w.bottom.demo -fill x
	
	pack $w.top
	pack $w.center -side top -expand 1 -fill both -padx 3
        #pack $w.center2 -side top -expand 1 -fill both
	#pack $w.bottom -side top -expand 1 -fill both -padx 3
}

sciFLTbuild "[file dirname [info script]]"
