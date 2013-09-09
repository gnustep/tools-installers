; Miscellaneous functions we use

;
; Page to select the Cairo Backend
;
Var Dialog
Var Label
Var Checkbox
Function CairoBackendPage
	nsDialogs::Create 1018
	Pop $Dialog
	${If} $Dialog == error
		Abort
	${EndIf}
	StrCpy $CAIRO_BACKEND ${BST_CHECKED}

  	${NSD_CreateLabel} 5% 45% 80% 56u "To activate the cairo backend make sure the box above is checked.  You can always activate the cairo backend later by typing a shell window 'defaults write NSGlobalDomain GSBackend cairo' or you can go back to the original backend by typing 'defaults remove NSGlobalDomain GSBackend' after installation."
	Pop $Label
	${NSD_CreateCheckbox} 10% 35% 100% 12u "Activate Cairo Backend"
	Pop $Checkbox
	${If} $CAIRO_BACKEND == ${BST_CHECKED}
		${NSD_Check} $Checkbox
	${EndIf}

	nsDialogs::Show
FunctionEnd

Function CairoBackendLeave
	 ${NSD_GetState} $Checkbox $CAIRO_BACKEND
FunctionEnd

