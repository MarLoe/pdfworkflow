
on send_pdf(subjectText, filePath)
    tell application id "com.microsoft.Outlook"
        set fileName to filePath as POSIX file -- convert to posix file
        
        with timeout of 60 seconds
            set theMessage to make new outgoing message with properties {subject:subjectText}
            
            tell theMessage -- tell theMessage (not theContent) to add the attachment
                make new attachment with properties {file:fileName}
            end tell
            
            open theMessage -- for further editing
            activate
        end timeout
    end tell
end send_pdf

on run argv
    if class of argv is list and (count of argv) ≥ 2 then
        set {subject, filePath} to items 1 thru 2 of argv
    else
        -- defaults for testing in Script Editor
        set subject to "Test subject"
        set filePath to "/Users/ml/Projects/pdfworkflow/README.md"
    end if
    
    send_pdf(subject, filePath)
end run
