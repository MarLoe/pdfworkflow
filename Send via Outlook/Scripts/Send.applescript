on run argv

    tell application "Microsoft Outlook"
        activate

        set subjectText to item 1 of argv
        set fileName to item 2 of argv as POSIX file --convert to posix file

        set theMessage to make new outgoing message with properties {subject:subjectText}
        tell theMessage -- tell theMessage (not theContent) to add the attachment
            make new attachment with properties {file:fileName}
        end tell

        open theMessage -- for further editing

    end tell
	
end run
