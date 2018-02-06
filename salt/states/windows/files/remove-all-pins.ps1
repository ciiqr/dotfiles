
$items = (New-Object -Com Shell.Application).NameSpace('shell:::{4234d49b-0245-4df3-b780-3893943456e1}').Items()
($items | ?{$_.Name}).Verbs() | ?{$_.Name.replace('&','') -imatch 'From "Start" UnPin|Unpin from Start'} | %{$_.DoIt()}
