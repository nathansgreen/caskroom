cask 'zulu' do
  version '1.8.0_66-8.11.0.1'
  sha256 'e92cad336ad5085c4fadcaa86ac231341b264dd0b3e5b7b8ebddcd7ced929e73'

  homepage "http://www.azul.com/downloads/zulu/zulu-mac/"
  url "http://cdn.azulsystems.com/zulu/bin/zulu#{version}-macosx.dmg",
      referer: "#{homepage}"
  name 'Azul Zulu Java Standard Edition Development Kit'
  license :gratis
  conflicts_with cask: 'java'
  pkg "Double-Click to Install Zulu #{version.split('.')[1]}.pkg"

  postflight do
    system '/usr/bin/sudo', '-E', '--',
           '/bin/mv', '-f', '--', "/Library/Java/JavaVirtualMachines/zulu-#{version.split('.')[1]}.jdk", "/Library/Java/JavaVirtualMachines/zulu#{version.split('-')[0]}.jdk"
    system '/usr/bin/sudo', '-E', '--',
           '/bin/ln', '-nsf', '--', "/Library/Java/JavaVirtualMachines/zulu#{version.split('-')[0]}.jdk", "/Library/Java/JavaVirtualMachines/zulu-#{version.split('.')[1]}.jdk"
    system '/usr/bin/sudo', '-E', '--',
           '/bin/ln', '-nsf', '--', "/Library/Java/JavaVirtualMachines/zulu#{version.split('-')[0]}.jdk/Contents/Home", '/Library/Java/Home'
    if MacOS.release <= :mavericks
      system '/usr/bin/sudo', '-E', '--',
             '/bin/rm', '-rf', '--', '/System/Library/Frameworks/JavaVM.framework/Versions/CurrentJDK'
      system '/usr/bin/sudo', '-E', '--',
             '/bin/ln', '-nsf', '--', "/Library/Java/JavaVirtualMachines/zulu#{version.split('-')[0]}.jdk/Contents", '/System/Library/Frameworks/JavaVM.framework/Versions/CurrentJDK'
    end
  end

  uninstall pkgutil:   [
                         "com.azulsystems.zulu.#{version.split('.')[1]}"
                       ],
            delete:    [
                         "/Library/Java/JavaVirtualMachines/zulu#{version.split('-')[0]}.jdk",
                         "/Library/Java/JavaVirtualMachines/zulu-#{version.split('.')[1]}.jdk",
                         '/Library/Java/Home',
                         if MacOS.release <= :mavericks
                           [
                             '/System/Library/Frameworks/JavaVM.framework/Versions/CurrentJDK'
                           ]
                         end,
                       ].keep_if { |v| !v.nil? }

  caveats <<-EOS.undent
    If this cask is upgraded, previous stale versions will be left under
    'Caskroom/zulu/{version}'. Stale versions may also be left under
    '/Library/Java/JavaVirtualMachines/zulu{version}.jdk'. Removing them may
    require manual deletion, e.g.

      rm -rf /opt/homebrew-cask/Caskroom/zulu/
      rm -rf /Library/Java/JavaVirtualMachines/zulu*.jdk
  EOS
end
