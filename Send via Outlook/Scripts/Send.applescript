
on send_pdf(subjectText, filePath)
    tell application "Microsoft Outlook"
        activate
        
        set fileName to filePath as POSIX file --convert to posix file
        
        set theMessage to make new outgoing message with properties {subject:subjectText}
        tell theMessage -- tell theMessage (not theContent) to add the attachment
            make new attachment with properties {file:fileName}
        end tell
        
        open theMessage -- for further editing
        
    end tell
end send_pdf

on run argv
    send_pdf(item 1 of argv, item 2 of argv)
end run
