$items = (New-Object -Com Shell.Application).NameSpace('shell:::{4234d49b-0245-4df3-b780-3893943456e1}').Items()
($items | ?{$_.Name}).Verbs() | ?{$_.Name.replace('&','') -imatch 'From "Start" UnPin|Unpin from Start'} | %{$_.DoIt()}

# TODO: this script no longer works?
# Access is denied. (Exception from HRESULT: 0x80070005 (E_ACCESSDENIED))
# At C:\Users\william\Projects\config\salt\states\windows\files\remove-all-pins.ps1:2 char:110
# + ... '&','') -imatch 'From "Start" UnPin|Unpin from Start'} | %{$_.DoIt()}
# +                                                                ~~~~~~~~~
#     + CategoryInfo          : OperationStopped: (:) [], UnauthorizedAccessException
#     + FullyQualifiedErrorId : System.UnauthorizedAccessException
