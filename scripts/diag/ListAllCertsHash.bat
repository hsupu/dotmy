
certutil -scinfo -silent | findstr /c:"Cert Hash(" | for /f "tokens=1,2,3 delims=: " %a in ('sort /uniq') do @echo '%c'
