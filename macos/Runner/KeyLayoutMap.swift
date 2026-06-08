import Cocoa
import Carbon

/// Maps macOS virtual key codes (kVK_*) to normalized horizontal positions (0.0~1.0).
/// Based on standard ANSI QWERTY layout with 15 columns.
///
/// Key codes reference: <Carbon/HIToolbox/Events.h>
let qwertyLayout: [Int: Double] = [
    // Row 1: ` 1 2 3 4 5 6 7 8 9 0 - = delete
    kVK_ANSI_Grave: 0.00,
    kVK_ANSI_1: 0.07,
    kVK_ANSI_2: 0.14,
    kVK_ANSI_3: 0.21,
    kVK_ANSI_4: 0.28,
    kVK_ANSI_5: 0.36,
    kVK_ANSI_6: 0.43,
    kVK_ANSI_7: 0.50,
    kVK_ANSI_8: 0.57,
    kVK_ANSI_9: 0.64,
    kVK_ANSI_0: 0.71,
    kVK_ANSI_Minus: 0.78,
    kVK_ANSI_Equal: 0.85,
    kVK_Delete: 0.93,

    // Row 2: tab Q W E R T Y U I O P [ ] \
    kVK_Tab: 0.00,
    kVK_ANSI_Q: 0.10,
    kVK_ANSI_W: 0.17,
    kVK_ANSI_E: 0.24,
    kVK_ANSI_R: 0.31,
    kVK_ANSI_T: 0.38,
    kVK_ANSI_Y: 0.45,
    kVK_ANSI_U: 0.52,
    kVK_ANSI_I: 0.59,
    kVK_ANSI_O: 0.66,
    kVK_ANSI_P: 0.73,
    kVK_ANSI_LeftBracket: 0.80,
    kVK_ANSI_RightBracket: 0.87,
    kVK_ANSI_Backslash: 0.93,

    // Row 3: caps A S D F G H J K L ; ' return
    kVK_CapsLock: 0.00,
    kVK_ANSI_A: 0.10,
    kVK_ANSI_S: 0.17,
    kVK_ANSI_D: 0.24,
    kVK_ANSI_F: 0.31,
    kVK_ANSI_G: 0.38,
    kVK_ANSI_H: 0.45,
    kVK_ANSI_J: 0.52,
    kVK_ANSI_K: 0.59,
    kVK_ANSI_L: 0.66,
    kVK_ANSI_Semicolon: 0.73,
    kVK_ANSI_Quote: 0.80,
    kVK_Return: 0.93,

    // Row 4: shift Z X C V B N M , . / shift
    kVK_Shift: 0.00,
    kVK_RightShift: 0.93,
    kVK_ANSI_Z: 0.12,
    kVK_ANSI_X: 0.19,
    kVK_ANSI_C: 0.26,
    kVK_ANSI_V: 0.33,
    kVK_ANSI_B: 0.40,
    kVK_ANSI_N: 0.47,
    kVK_ANSI_M: 0.54,
    kVK_ANSI_Comma: 0.61,
    kVK_ANSI_Period: 0.68,
    kVK_ANSI_Slash: 0.75,

    // Row 5: fn ctrl opt cmd space cmd opt left right down up
    kVK_Control: 0.03,
    kVK_RightControl: 0.93,
    kVK_Option: 0.10,
    kVK_RightOption: 0.87,
    kVK_Command: 0.17,
    kVK_RightCommand: 0.80,
    kVK_Space: 0.50,
    kVK_LeftArrow: 0.73,
    kVK_RightArrow: 0.87,
    kVK_DownArrow: 0.80,
    kVK_UpArrow: 0.80,

    // Function keys row
    kVK_F1: 0.07,
    kVK_F2: 0.14,
    kVK_F3: 0.21,
    kVK_F4: 0.28,
    kVK_F5: 0.36,
    kVK_F6: 0.43,
    kVK_F7: 0.50,
    kVK_F8: 0.57,
    kVK_F9: 0.64,
    kVK_F10: 0.71,
    kVK_F11: 0.78,
    kVK_F12: 0.85,

    // Escape
    kVK_Escape: 0.00,
    kVK_ForwardDelete: 0.93,
    kVK_Home: 0.07,
    kVK_End: 0.14,
    kVK_PageUp: 0.21,
    kVK_PageDown: 0.28,
    kVK_Help: 0.43,
]

/// Returns the normalized X position (0.0~1.0) for a given macOS keyCode.
/// Falls back to 0.5 (center) for unmapped keys.
func keyLayoutNormalizedX(_ keyCode: Int) -> Double {
    return qwertyLayout[keyCode] ?? 0.5
}

/// Returns the display character for a given macOS keyCode.
func keyDisplayCharacter(_ keyCode: Int) -> String {
    switch keyCode {
    case kVK_ANSI_A: return "A"
    case kVK_ANSI_B: return "B"
    case kVK_ANSI_C: return "C"
    case kVK_ANSI_D: return "D"
    case kVK_ANSI_E: return "E"
    case kVK_ANSI_F: return "F"
    case kVK_ANSI_G: return "G"
    case kVK_ANSI_H: return "H"
    case kVK_ANSI_I: return "I"
    case kVK_ANSI_J: return "J"
    case kVK_ANSI_K: return "K"
    case kVK_ANSI_L: return "L"
    case kVK_ANSI_M: return "M"
    case kVK_ANSI_N: return "N"
    case kVK_ANSI_O: return "O"
    case kVK_ANSI_P: return "P"
    case kVK_ANSI_Q: return "Q"
    case kVK_ANSI_R: return "R"
    case kVK_ANSI_S: return "S"
    case kVK_ANSI_T: return "T"
    case kVK_ANSI_U: return "U"
    case kVK_ANSI_V: return "V"
    case kVK_ANSI_W: return "W"
    case kVK_ANSI_X: return "X"
    case kVK_ANSI_Y: return "Y"
    case kVK_ANSI_Z: return "Z"
    case kVK_ANSI_0: return "0"
    case kVK_ANSI_1: return "1"
    case kVK_ANSI_2: return "2"
    case kVK_ANSI_3: return "3"
    case kVK_ANSI_4: return "4"
    case kVK_ANSI_5: return "5"
    case kVK_ANSI_6: return "6"
    case kVK_ANSI_7: return "7"
    case kVK_ANSI_8: return "8"
    case kVK_ANSI_9: return "9"
    case kVK_ANSI_Grave: return "`"
    case kVK_ANSI_Minus: return "-"
    case kVK_ANSI_Equal: return "="
    case kVK_ANSI_LeftBracket: return "["
    case kVK_ANSI_RightBracket: return "]"
    case kVK_ANSI_Backslash: return "\\"
    case kVK_ANSI_Semicolon: return ";"
    case kVK_ANSI_Quote: return "'"
    case kVK_ANSI_Comma: return ","
    case kVK_ANSI_Period: return "."
    case kVK_ANSI_Slash: return "/"
    case kVK_Delete: return "⌫"
    case kVK_Return: return "↩"
    case kVK_Tab: return "⇥"
    case kVK_Space: return "␣"
    case kVK_Escape: return "⎋"
    case kVK_LeftArrow: return "←"
    case kVK_RightArrow: return "→"
    case kVK_UpArrow: return "↑"
    case kVK_DownArrow: return "↓"
    default:
        return "?"
    }
}
