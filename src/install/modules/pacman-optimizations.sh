sudo awk '/^\[options\]$/ { found=1; print }
          /^CleanMethod/ { next }
          found && !/^\[/ { if (!cleaned) { print "CleanMethod = Packages"; cleaned=1 } }
          !found || /^\[/ { print }' /etc/pacman.conf >/etc/pacman.conf.new && sudo mv /etc/pacman.conf.new /etc/pacman.conf
