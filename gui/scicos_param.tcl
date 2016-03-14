# ----------------------------------------------------------------------
# GENERAL SCICOS GUI INTERFACE
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

global sciFLTSPTable

# --------------------------------------------------------
# UPDATE MEMBER FUNCTION OPTION
# --------------------------------------------------------
proc sciFLTScicosParMfUp { } {
	global sciFLTSPTable
	set w ".sciFLTScicosParam"
	set p [expr [lsearch $sciFLTSPTable(mfopt) "$sciFLTSPTable(mfchoose)" ]+1]
	set sciFLTSPTable(typ) $p
	if { $p==3 | $p==5 | $p==10 | $p==11 } then { 
		set ok1 { a b }
		set sciFLTSPTable(npar) 2
	} elseif { $p==1 | $p==8 } then {
		set ok1 { a b c }
		set sciFLTSPTable(npar) 3
	} elseif { $p==0 } then {
		set ok1 { }
		set sciFLTSPTable(npar) 0
	} else {
		set ok1 { a b c d }
		set sciFLTSPTable(npar) 4
	}	
	
	# CHANGE THE STATE
	foreach x { a b c d } {	catch {$w.center.e$x configure -state disable }	}
	foreach x $ok1 { catch { $w.center.e$x configure -state normal } }

	# CHECK MEMBER FUNCTION PARAMETERS !
	set allok 0
	
	# TRIANGULAR
	if { $p==1 } then {
		catch { set allok [expr $sciFLTSPTable(a)<$sciFLTSPTable(b) & $sciFLTSPTable(b)<$sciFLTSPTable(c)] }
	}
	# TRAPEZOIDAL
	if { $p==2 } then {
		catch { set allok [expr $sciFLTSPTable(a)<$sciFLTSPTable(b) & $sciFLTSPTable(b)<=$sciFLTSPTable(c) & $sciFLTSPTable(c)<$sciFLTSPTable(d)] }
	}
	# GAUSSIAN
	if { $p==3 } then {
		catch { set allok [expr $sciFLTSPTable(b)!=0] }
	}
	# EXTENDEND GAUSSIAN
	if { $p==4 } then {
		catch { set allok [expr $sciFLTSPTable(b)*$sciFLTSPTable(d)!=0] }
	}
	# SIGMOIDAL, PRODUCT OF TWO or DIFFERENCE
	if { $p==5 | $p==6 | $p==7 } then {
		set allok 1
	}
	# GENERALIZED BELL
	if { $p==8 } then {
		catch { set allok [expr $sciFLTSPTable(b)!=0] }
	}
	# Pi S and Z
	if { $p==9 | $p==10 | $p==11 } then {
		set allok 1
	}	

	if { $allok==1 } then {
		catch {$w.bottom.ok configure -state normal}
	} else {
		catch {$w.bottom.ok configure -state disable}
	}
	
	return 1	
}

# --------------------------------------------------------
# UPDATE COMPLEMENT OPTION
# --------------------------------------------------------
proc sciFLTScicosParComUp { } {
	global sciFLTSPTable
	set sciFLTSPTable(typ) 100
	set sciFLTSPTable(npar) 2
	set w ".sciFLTScicosParam"
	set allok 0
	
	if { $sciFLTSPTable(a)==0 } then {
		set allok 1
		catch { $w.center.e3 configure -state disable }
	} elseif { $sciFLTSPTable(a)==1 } then {
		catch { set allok [expr $sciFLTSPTable(b)>0] }
		catch { $w.center.e3 configure -state normal }
	} elseif { $sciFLTSPTable(a)==2 } then {
		catch { set allok [expr $sciFLTSPTable(b)>-1] }
		catch { $w.center.e3 configure -state normal }
	}

	if { $allok==1 } then {
		catch {$w.bottom.ok configure -state normal}
	} else {
		catch {$w.bottom.ok configure -state disable}
	}
	
	return 1
}

# --------------------------------------------------------
# UPDATE S-NORM OR T-NORM OPTION
# --------------------------------------------------------
proc sciFLTScicosParSTUp { lopt } {
	global sciFLTSPTable
	set sciFLTSPTable(typ) $lopt
	set sciFLTSPTable(npar) 2
	set w ".sciFLTScicosParam"
	set allok 0
	if { $sciFLTSPTable(a)==0 } then {
		catch { set allok [expr $sciFLTSPTable(b)>=0 & $sciFLTSPTable(b)<=1] }
		catch { $w.center.e6 configure -state normal }
	} elseif { $sciFLTSPTable(a)==1 } then {
		catch { set allok [expr $sciFLTSPTable(b)>0] }
		catch { $w.center.e6 configure -state normal }
	} else {
		set allok 1
		catch { $w.center.e6 configure -state disable }
	}
	
	if { $allok==1 } then {
		catch {$w.bottom.ok configure -state normal}
	} else {
		catch {$w.bottom.ok configure -state disable}
	}
	
	return 1
}
	
# --------------------------------------------------------
# UPDATE FLS OPTION
# --------------------------------------------------------
proc sciFLTScicosParFLSUp { } {
	global sciFLTSPTable
	set w ".sciFLTScicosParam"
	if { $sciFLTSPTable(f)=="1" } then {
		catch {$w.bottom.ok configure -state normal}
	} else {
		catch {$w.bottom.ok configure -state disable}
	}
}
	
# --------------------------------------------------------
# MAIN WINDOW
# --------------------------------------------------------
# lopt=1 -> trimf
# lopt=2 -> trapmf
proc sciFLTScicosPar { lopt {pa ""} {pb ""} {pc ""} {pd ""} {pe ""} {pf ""} } {
	global sciFLTSPTable
	global sciFLTpath
	set sciFLTSPTable(ok) 0
	# INITIALIZE ICONS
	if {![info exists sciFLTSPTable(is_init)]} {
		set sciFLTSPTable(is_init) 0
		image create photo sciFLTSPTable(logo) -file [file join $sciFLTpath "gui" "data" "logo.gif"]
		image create photo sciFLTSPTable(warning) -file [file join $sciFLTpath "gui" "data" "logo.gif"]
		set sciFLTSPTable(mfopt) "{(1) trimf} {(2) trapmf} {(3) gaussmf} {(4) gauss2mf} {(5) sigmf} {(6) dsigmf} {(7) psigmf} {(8) gbellmf} {(9) pimf} {(10) smf} {(11) zmf}"
	}
	set w ".sciFLTScicosParam"
	catch { destroy $w }
	toplevel $w
	wm title $w "sciFLT Scicos"
	#wm resizable $w 0 0
	frame $w.top -bd 3 -background white -relief groove
	label $w.top.mes01 -text "Scicos Block" -bg white -font {-*-helvetica-bold-r-*-*-24}
	label $w.top.logo -image sciFLTSPTable(logo) -bg white
	pack $w.top.logo -expand 1 -fill x -side left
	pack $w.top.mes01 -expand 1 -fill x -side right

	labelframe $w.center 
	if { $lopt<100 } then {
		# MEMBER FUNCTION
		$w.center configure -text "Choose member function and parameters:" -fg blue
		label   $w.center.lmftype -text "Member function:"
		set sciFLTSPTable(mfchoose) [lindex $sciFLTSPTable(mfopt) [expr $lopt-1]]
		spinbox $w.center.mftype -width 15 -state readonly -values $sciFLTSPTable(mfopt) -textvariable sciFLTSPTable(mfchoose) 
		grid config $w.center.lmftype -column 0 -row 0 -columnspan 1 -rowspan 1 -sticky "e" -pady 3
		grid config $w.center.mftype -column 1 -row 0 -columnspan 1 -rowspan 1 -sticky "w"
		set i 1
		foreach x { a b c d } {
			label $w.center.l$x -text "$x ="
			eval "set sciFLTSPTable($x) \$p$x"
			entry $w.center.e$x -width 20 -textvariable sciFLTSPTable($x) 
			grid config  $w.center.l$x -column 0 -row $i -columnspan 1 -rowspan 1 -sticky "e" -pady 3
			grid config  $w.center.e$x -column 1 -row $i -columnspan 1 -rowspan 1 -sticky "w"
			incr i
		}
		set sciFLTSPTable(mfchoose) [lindex $sciFLTSPTable(mfopt) [expr $lopt-1]]		
		$w.center.mftype configure -validate all -vcm "set sciFLTSPTable(mfchoose) %P;sciFLTScicosParMfUp"
		foreach x { a b c d } {
			$w.center.e$x configure -validate all -vcmd "set sciFLTSPTable($x) %P;sciFLTScicosParMfUp"
		}
		
	} elseif { $lopt==100 } then {
		# COMPLEMENT
		set sciFLTSPTable(a) $pa
		set sciFLTSPTable(b) $pb
		$w.center configure -text "Choose complement class and parameter:" -fg blue
		radiobutton $w.center.e0 -text "One" -variable sciFLTSPTable(a) -value 0 -relief flat
		radiobutton $w.center.e1 -text "Yager" -variable sciFLTSPTable(a) -value 1 -relief flat
		radiobutton $w.center.e2 -text "Sugeno" -variable sciFLTSPTable(a) -value 2 -relief flat
		label $w.center.l1 -text "parameter = "
		entry $w.center.e3 -textvariable sciFLTSPTable(b)
		grid config $w.center.e0 -column 1 -row 0 -columnspan 1 -rowspan 1 -sticky "w" -pady 3
		grid config $w.center.e1 -column 1 -row 1 -columnspan 1 -rowspan 1 -sticky "w" -pady 3
		grid config $w.center.e2 -column 1 -row 2 -columnspan 1 -rowspan 1 -sticky "w" -pady 3
		grid config $w.center.l1 -column 0 -row 3 -columnspan 1 -rowspan 1 -sticky "w" -pady 3
		grid config $w.center.e3 -column 1 -row 3 -columnspan 1 -rowspan 1 -sticky "w" -pady 3
		$w.center.e3 configure -validate all -vcm "set sciFLTSPTable(b) %P;sciFLTScicosParComUp"
	} elseif { $lopt==101 | $lopt==102 } then {
		# SNORM or TNORM
		set sciFLTSPTable(a) $pa
		set sciFLTSPTable(b) $pb
		if { $lopt==101 } then {
			set o "S"
			set sn { "Dubois" "Yager" "Drastic Sum" "Einstein Sum" "Algebraic Sum" "Maximum" }
		} else {
			set o "T"
			set sn { "Dubois" "Yager" "Drastic Product" "Einstein Product" "Algebraic Product" "Minimum" }
		}
		$w.center configure -text "Choose $o-Norm class and parameter:" -fg blue
		for { set x 0 } { $x<6 } { incr x } {
			radiobutton $w.center.e$x -text [lindex $sn $x] -variable sciFLTSPTable(a) -value $x -relief flat
			grid config $w.center.e$x -column 1 -row $x -columnspan 1 -rowspan 1 -sticky "w" -pady 3
		}
		label $w.center.l1 -text "parameter = "
		entry $w.center.e6 -textvariable sciFLTSPTable(b)
		grid config $w.center.l1 -column 0 -row 7 -columnspan 1 -rowspan 1 -sticky "w" -pady 3
		grid config $w.center.e6 -column 1 -row 7 -columnspan 1 -rowspan 1 -sticky "w" -pady 3
		$w.center.e6 configure -validate all -vcm "set sciFLTSPTable(b) %P;sciFLTScicosParSTUp $lopt"			
	} else {
		# FLS STRUCTURE	- THIS IS A LITTLE MORE COMPLICATED
		foreach x { a b c d e f } {	
			eval "set sciFLTSPTable($x) \$p$x"
		}
		$w.center configure -text "fls structure:" -fg blue
		label $w.center.l0 -text "name:"
		label $w.center.l1 -text "type:"
		label $w.center.l2 -text "number of inputs :" 
		label $w.center.l3 -text "number of outputs :" 
		label $w.center.l4 -text "number of rules :" 
		label $w.center.e0 -textvariable sciFLTSPTable(a) -relief groove -width 15
		label $w.center.e1 -textvariable sciFLTSPTable(b) -relief groove -width 15
		label $w.center.e2 -textvariable sciFLTSPTable(c) -relief groove -width 15
		label $w.center.e3 -textvariable sciFLTSPTable(d) -relief groove -width 15
		label $w.center.e4 -textvariable sciFLTSPTable(e) -relief groove -width 15
		for { set x 0 } { $x<5 } { incr x } {
			grid config $w.center.l$x -column 0 -row $x -columnspan 1 -rowspan 1 -sticky "e" -pady 3
			grid config $w.center.e$x -column 1 -row $x -columnspan 1 -rowspan 1 -sticky "w" -pady 3
		}		
	}	

	frame $w.bottom
	button $w.bottom.ok -text "ok" -width 15 -state disable -command "set sciFLTSPTable(ok) 1; destroy $w"
	button $w.bottom.cancel -text "cancel" -width 15 -command "destroy $w"
	button $w.bottom.import -text "import from file" -width 15 -command "set sciFLTSPTable(ok) -1"
	if { $lopt==200 } then {
		pack $w.bottom.ok $w.bottom.cancel $w.bottom.import -side left -fill both -expand 0 -padx 3 -pady 3
	} else {
		pack $w.bottom.ok $w.bottom.cancel -side left -fill both -expand 0 -padx 3 -pady 3
	}
	
	pack $w.top -side top -fill both -expand 0
	pack $w.center -side top -fill both -expand 1
	pack $w.bottom -side top -fill both -expand 0
	if { $lopt<100 } then {
		bind all <Any-Enter> "sciFLTScicosParMfUp"
		bind all <Any-Leave> "sciFLTScicosParMfUp"
		sciFLTScicosParMfUp
	}
	if { $lopt==100 } then {
		bind all <Any-Enter> "sciFLTScicosParComUp"
		bind all <Any-Leave> "sciFLTScicosParComUp"
		sciFLTScicosParComUp
	}
	if { $lopt==101 | $lopt==102 } then {
		bind all <Any-Enter> "sciFLTScicosParSTUp $lopt"
		bind all <Any-Leave> "sciFLTScicosParSTUp $lopt"
		sciFLTScicosParSTUp $lopt
	}
	if { $lopt==200 } then {
		sciFLTScicosParFLSUp
	}
}


# FOR TEST USE ONLY
if { 0 } then {
	set sciFLTpath "~/svn/software/scb/sciFLT/"
	sciFLTScicosPar 200 "in" "takagi-sugeno" 10 15
	
}
