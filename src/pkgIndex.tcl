# Tcl package index file, version 1.1
# This file is generated by the "pkg_mkIndex" command
# and sourced either when an application starts up or
# by a "package unknown" script.  It invokes the
# "package ifneeded" command to set up package-related
# information so that packages will be loaded automatically
# in response to "package require" commands.  When this
# script is sourced, the variable $dir must contain the
# full path name of this file's directory.

package ifneeded ::tclhdl 1.0 [list source [file join $dir tclhdl.tcl]]
package ifneeded ::tclhdl::definitions 1.0 [list source [file join $dir tclhdl-definitions.tcl]]
package ifneeded ::tclhdl::quartus 1.0 [list source [file join $dir tclhdl-quartus.tcl]]
package ifneeded ::tclhdl::vivado 1.0 [list source [file join $dir tclhdl-vivado.tcl]]
package ifneeded ::tclhdl::ise 1.0 [list source [file join $dir tclhdl-ise.tcl]]
