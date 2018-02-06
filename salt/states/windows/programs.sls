
# runtimes
adobeair: chocolatey.installed
silverlight: chocolatey.installed
javaruntime: chocolatey.installed
dotnet4.7.1: chocolatey.installed
adobeshockwaveplayer: chocolatey.installed
k-litecodecpackmega: chocolatey.installed
vcredist-all: chocolatey.installed

# programs
firefox: chocolatey.installed
googlechrome: chocolatey.installed
windirstat: chocolatey.installed
7zip: chocolatey.installed
sumatrapdf: chocolatey.installed
adobereader: chocolatey.installed
spotify: chocolatey.installed
keepass: chocolatey.installed
f.lux: chocolatey.installed
hwmonitor: chocolatey.installed
mpc-hc: chocolatey.installed

# pre-programs
dropbox:
  chocolatey.installed:
    - pre_versions: true
