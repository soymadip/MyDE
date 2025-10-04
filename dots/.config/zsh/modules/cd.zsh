
cd_ls ()
{
  cdz $1; sleep 0.1; echo ""; eza -a --sort=name --group-directories-first --icons=always --hyperlink;  sleep 0.3 
}
