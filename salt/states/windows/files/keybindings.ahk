; TODO: automate linking for autostart:
; $shell = New-Object -ComObject WScript.Shell
; $shortcut = $shell.CreateShortcut("C:\Users\william\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\keybindings.lnk")
; $shortcut.TargetPath = "C:\Users\william\Projects\config\salt\states\windows\files\keybindings.ahk"
; $shortcut.Save()
; [System.Runtime.Interopservices.Marshal]::ReleaseComObject($shell)

; setup
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Recommended for catching common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance, Force
#Persistent
#NoTrayIcon

; globals
pipWindows := {}


; keybindings
; - open sublime (super + r)
#o::Run "C:\Program Files\Sublime Text 3\sublime_text.exe"
; - reload script (ctrl + super + r)
^#r::Relo()

Relo() {
    Gui Color, 0xFF0000
    Gui Font, s10

    Gui +E0x20 -Caption +LastFound +ToolWindow +AlwaysOnTop
    Gui, Add, Text, w190 +Wrap +Center, Versuch um ein Shiny zubekommen. drlfgk jdflkgjdfk l g j f d k j, Black Text

    WinSet, Transparent, 100

    Gui Show, NoActivate, w200 h200
    Sleep 500
    Reload
}

; - pip (super + z)
#z::TogglePip()

; - debug (super + g)
#g::Debug()

/**
 * GetMonitorIndexFromWindow retrieves the HWND (unique ID) of a given window.
 * @param {Uint} windowHandle
 * @author shinywong
 * @link http://www.autohotkey.com/board/topic/69464-how-to-determine-a-window-is-in-which-monitor/?p=440355
 */
GetMonitorIndexFromWindow(windowHandle) {
    ; Starts with 1.
    monitorIndex := 1
    VarSetCapacity(monitorInfo, 40)
    NumPut(40, monitorInfo)
    if (monitorHandle := DllCall("MonitorFromWindow", "uint", windowHandle, "uint", 0x2))
        && DllCall("GetMonitorInfo", "uint", monitorHandle, "uint", &monitorInfo) {
        monitorLeft   := NumGet(monitorInfo,  4, "Int")
        monitorTop    := NumGet(monitorInfo,  8, "Int")
        monitorRight  := NumGet(monitorInfo, 12, "Int")
        monitorBottom := NumGet(monitorInfo, 16, "Int")
        workLeft      := NumGet(monitorInfo, 20, "Int")
        workTop       := NumGet(monitorInfo, 24, "Int")
        workRight     := NumGet(monitorInfo, 28, "Int")
        workBottom    := NumGet(monitorInfo, 32, "Int")
        isPrimary     := NumGet(monitorInfo, 36, "Int") & 1
        SysGet, monitorCount, MonitorCount
        Loop, %monitorCount% {
            SysGet, tempMon, Monitor, %A_Index%
            ; Compare location to determine the monitor index.
            if ((monitorLeft = tempMonLeft) and (monitorTop = tempMonTop)
                and (monitorRight = tempMonRight) and (monitorBottom = tempMonBottom)) {
                monitorIndex := A_Index
                break
            }
        }
    }
    return %monitorIndex%
}

TogglePip() {
    global pipWindows

    ; get window id
    WinGet, windowId, ID, A

    if (pipWindows.HasKey(windowId)) {
        ; pop pip state
        originalDetails := pipWindows.Delete(windowId)

        ; undo pip
        WinMove, A, , originalDetails["x"], originalDetails["y"], originalDetails["width"], originalDetails["height"]
        ; Send {F11}
        WinSet, AlwaysOnTop, off, A
    }
    else {
        ; get details
        ; - window
        WinGetPos, x, y, width, height, A
        ; - monitor
        monitorIndex := GetMonitorIndexFromWindow(windowId)
        SysGet, monitor, Monitor, %monitorIndex%
        monitorWidth := (MonitorRight - MonitorLeft) + 7
        monitorHeight := (MonitorBottom - MonitorTop) + 7
        newWidth := monitorWidth / 4
        newHeight := monitorHeight / 3
        ; TODO: make smarter
        newWidth := 800
        newHeight := 550
        newX := monitorWidth - newWidth
        newY := monitorHeight - newHeight

        ; store original details
        pipWindows[windowId] := {x: x, y: y, width: width, height: height}

        ; make pip
        WinSet, AlwaysOnTop, on, A
        ; Send {F11}
        WinMove, A, , newX, newY, newWidth, newHeight
    }
}

Debug() {
    ; get window id
    WinGet, windowId, ID, A
    ; get window title
    WinGetTitle, windowTitle, A
    ; get window class
    WinGetClass, windowClass, A

    ; display info
    MsgBox, 0, Debug, %windowTitle%
}
