tell application "Xcode"
    activate
    
    -- Xcode'un açık olduğundan emin ol
    delay 2
    
    -- Project Navigator'ı aç (⌘+1)
    tell application "System Events"
        keystroke "1" using command down
    end tell
    
    delay 1
    
    -- EvcilHayvanim klasörüne sağ tıkla
    tell application "System Events"
        tell process "Xcode"
            -- EvcilHayvanim klasörünü bul ve sağ tıkla
            click (first button whose description contains "EvcilHayvanim")
            delay 0.5
            
            -- "Add Files to EvcilHayvanim" seçeneğini bul
            click menu item "Add Files to \"EvcilHayvanim\"" of menu 1 of menu bar 1
        end tell
    end tell
    
    delay 2
    
    -- Dosya seçim dialogunu aç
    tell application "System Events"
        tell process "Xcode"
            -- "Add" butonuna tıkla
            click button "Add" of window 1
        end tell
    end tell
end tell 