on run argv

    set alertText to item 1 of argv
    set alertMessage to item 2 of argv
    display alert alertText message alertMessage as critical buttons {"OK"} default button "OK" -- cancel button "Cancel"',

end run
